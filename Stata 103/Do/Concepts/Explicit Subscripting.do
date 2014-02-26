args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

foreach var of varlist _all {
    display "`var'"
    display `var'[597]
    display `var'[598]
    display
}

	}
	if `trace' set trace off
}
