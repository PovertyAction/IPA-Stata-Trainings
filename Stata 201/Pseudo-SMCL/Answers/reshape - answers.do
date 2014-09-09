/* {HEAD}

{RESHAPE!}
{PSANS!}

{RESHAPE_ANSQ1}
{RESHAPE_ANSQ2} */

{RESHAPE_Q1TOP}

{RESHAPE_Q1A}

reshape long sport, i(country year)

drop _j
bysort country year (sport): generate j = _n
reshape wide sport, i(country year) j(j)

{RESHAPE_Q1B}

* Here's one approach:

generate sportchange = 0
forvalues i = 1/46 {
	bysort country (year): replace sportchange = 1 ///
		if sport`i' != sport`i'[_n - 1] & _n > 1
}

{RESHAPE_Q1C}

bysort country (sportchange): generate nochange = !sportchange[_N]

* Or in two steps:

bysort country: egen anychange = max(sportchange)
generate nochange = !anychange

tabulate country if nochange

/* {hline}

{NEW46} */

{RESHAPE_Q2}

split s2_q8, generate(response)

browse

reshape long response, i(id)
drop if missing(response)

browse

destring response, replace

xi i.response, noomit
renpfix _Iresponse s2_q8

browse

foreach var of varlist s2_q8_* {
	bysort id (`var'): replace `var' = `var'[_N]
}

browse

forvalues i = 1/12 {
	capture generate s2_q8_`i' = 0
}

browse

drop response _j
duplicates drop

browse

