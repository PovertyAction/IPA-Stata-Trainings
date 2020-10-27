args example

loc trace = c(trace) == "on"
if `trace' set trace off

local mata mata:

if `example' == 1 {
	if `trace' set trace on
	noi {

generate sportchange = 0
forvalues i = 1/46 {
    bysort country (year): replace sportchange = 1 ///
        if sport`i' != sport`i'[_n - 1] & _n > 1
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
