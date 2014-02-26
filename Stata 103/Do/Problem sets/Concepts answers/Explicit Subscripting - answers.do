args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

foreach var in age educ castecode {
    display "`var'"
    display `var'[5]
    display `var'[6]
    display
}

	}
	if `trace' set trace off
}
