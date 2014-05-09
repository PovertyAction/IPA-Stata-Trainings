args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

foreach letter in a b c d {
    display "`letter'"
}

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

foreach var in literateyn own4wheeleryn theftfromcaryn {
    tabulate `var'
}

	}
	if `trace' set trace off
}
