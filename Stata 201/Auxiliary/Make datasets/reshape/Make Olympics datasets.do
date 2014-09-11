vers 13.1

set varabbrev off
set seed 472233340

* This private directory contains two publicly available datasets.
* See below for the links.
c stata_training_develop
cd "Stata 201/Olympics"

* Dataset from
* https://docs.google.com/spreadsheets/d/1cNI7yompmiaC3PY6yg3eyIIxJkY6IonkROapzWSh-Bs/edit?usp=sharing
import excel using "More NOCs", first clear
tempfile more_noc
sa `more_noc'

* Dataset from
* http://www.theguardian.com/sport/datablog/2012/jun/25/olympic-medal-winner-list-data
loc fn Summer Olympic medallists 1896 to 2008.xlsx
import excel using "`fn'", sh("IOC COUNTRY CODES") first case(lower) clear

drop isocode
assert country == d
drop d
varabbrev ren int noc

append using `more_noc', gen(more)

replace country = subinstr(country, "*", "", 1)
replace country = subinstr(country, char(160), " ", .)
replace country = strtrim(itrim(country))
assert regexm(country, "^[-a-zA-Z',() ]+$")

bys noc (more): drop if _N > 1 & _n == _N & more[_N]
drop more
isid noc

tempfile country
sa `country'

import excel using "`fn'", sh("ALL MEDALISTS") all clear
drop in 1/4

foreach var of var _all {
	loc newvar = strlower(`var'[1])
	ren `var' `newvar'
}
drop in 1
destring, replace
compress

drop city event_gender athlete gender medal
ren edition year

merge m:1 noc using `country', keep(1 3)
* Multiple countries; too lazy to fill in.
assert noc == "IOP" if _merge == 1
drop if _merge == 1
drop noc _merge

gen event_full = discipline + " " + event
replace event_full = strtrim(itrim(event_full))
bys sport discipline event (event_full): assert event_full[1] == event_full[_N]
drop sport discipline event
encode event_full, gen(sport)
drop event_full

duplicates drop

gen u = runiform()
sort country u
loc maxN 46
bys country year (u): keep if _n <= `maxN'
by  country year: gen j = _n
drop u

lab var country		Country
lab var year		Year

order country year

preserve

gen sports = ""
bys country year (j): replace sports = sports[_n - 1] + ///
	!mi(sport) * (!mi(sports[_n - 1]) * ", " + strofreal(sport))
by country year: replace sports = sports[_N]
drop sport j
duplicates drop
isid country year
assert "`:type sports'" != "str`c(maxstrvarlen)'"
form sports `=subinstr("`:format sports'", "%", "%-", 1)'

lab var sports Sports

compress

c stata_training
cd "Stata 201"
svold "Raw/Olympics 2", 10 replace

restore

reshape wide sport, i(country year) j(j)

forv i = 1/`maxN' {
	lab var sport`i' "Sport (#`i'/`maxN')"
}

compress
svold "Raw/Olympics 1", 10 replace
