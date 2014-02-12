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
else if `example' == 2 {
	if `trace' set trace on
	noi {

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
    display "The two observations of 1802011 differ on `var'." if `var'[597] != `var'[598]
}

	}
	if `trace' set trace off
}
else if `example' == 4 {
	if `trace' set trace on
	noi {

if sex[1] == 1 {
    summarize age
}

	}
	if `trace' set trace off
}
else if `example' == 5 {
	if `trace' set trace on
	noi {

foreach var of varlist _all {
    if `var'[597] != `var'[598] {
        display "The two observations of 1802011 differ on `var'."
    }
}

	}
	if `trace' set trace off
}
