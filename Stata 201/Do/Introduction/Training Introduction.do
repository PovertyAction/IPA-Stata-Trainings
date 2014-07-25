args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

foreach i of numlist 1/10 {
    display `i'
}

	}
	if `trace' set trace off
}
