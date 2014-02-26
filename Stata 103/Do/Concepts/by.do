args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

foreach i of numlist 1/6 . {
    summarize educ if castecode == `i'
}

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

sort hhid
foreach var of varlist _all {
    if `var'[597] != `var'[598] {
        display "The two observations of 1802011 differ on `var'."
    }
}

	}
	if `trace' set trace off
}
else if `example' == 3 {
	if `trace' set trace on
	noi {

foreach var of varlist _all {
    bysort hhid (`var'): generate unequal = `var'[1] != `var'[_N]
    list hhid `var' if unequal == 1
    drop unequal
}

	}
	if `trace' set trace off
}
