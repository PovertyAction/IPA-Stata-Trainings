args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

generate projectchange = 0
forvalues i = 1/6 {
    bysort id (date): replace projectchange = 1 ///
        if project`i' != project`i'[_n - 1] & _n > 1
}

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

foreach var of varlist s2_q8_* {
    bysort id (`var'): replace `var' = `var'[_N]
}

	}
	if `trace' set trace off
}
else if `example' == 3 {
	if `trace' set trace on
	noi {

forvalues i = 1/12 {
    capture generate s2_q8_`i' = 0
}

	}
	if `trace' set trace off
}
