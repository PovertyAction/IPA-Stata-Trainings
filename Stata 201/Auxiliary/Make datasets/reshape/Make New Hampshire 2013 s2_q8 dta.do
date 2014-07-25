vers 13

set seed 19370131

clear
set obs 100

gen id = _n
gen n = ceil(4 * runiform())

forv i = 1/`=_N' {
	expand `=n[`i']' in `i'
}

gen response = ceil(12 * runiform())

drop n
duplicates drop

gen s2_q8 = ""
bys id (response): replace s2_q8 = s2_q8[_n - 1] + " " + strofreal(response)
by  id (response): replace s2_q8 = s2_q8[_N]
replace s2_q8 = strtrim(s2_q8)

keep id s2_q8
duplicates drop

lab var id "Unique ID"
lab var s2_q8 "Of the 12 options, choose up to 4."

compress
c adv 13
svold "Raw/New Hampshire 2013 s2_q8", replace 10
