args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

foreach var of varlist sex scrutinizedyn educ {
    display "Checking `var' for missing values..."
    list hhid `var' if missing(`var')
}

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

foreach var of varlist sex scrutinizedyn educ {
    display "Checking `var' for missing values..."
    assert !missing(`var')
}

	}
	if `trace' set trace off
}
