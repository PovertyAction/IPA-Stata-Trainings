/* {HEAD}

{RESHAPE!}
{PSANS!}

{RESHAPE_ANSQ1}
{RESHAPE_ANSQ2} */

{RESHAPE_Q1TOP}

{RESHAPE_Q1A}

reshape long project, i(id date)

drop _j
bysort id date (project): generate j = _n
reshape wide project, i(id date) j(j)

{RESHAPE_Q1B}

* Here's one approach:

generate projectchange = 0
forvalues i = 1/6 {
	bysort id (date): replace projectchange = 1 ///
		if project`i' != project`i'[_n - 1] & _n > 1
}

{RESHAPE_Q1C}

bysort id (projectchange): generate anychange = projectchange[_N]

tabulate id if anychange

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

