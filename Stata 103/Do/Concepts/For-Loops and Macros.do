args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

foreach var of varlist _all {
    display "`var'"
}

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

foreach var in _all {
    display "`var'"
}

	}
	if `trace' set trace off
}
else if `example' == 3 {
	if `trace' set trace on
	noi {

foreach i of numlist 10(5)50 {
    display "`i'"
}

	}
	if `trace' set trace off
}
else if `example' == 4 {
	if `trace' set trace on
	noi {

foreach num in 1 2 3 4 5 {
    display "`num'"
}

	}
	if `trace' set trace off
}
else if `example' == 5 {
	if `trace' set trace on
	noi {

foreach num of numlist 1/5 {
    display "`num'"
}

	}
	if `trace' set trace off
}
else if `example' == 6 {
	if `trace' set trace on
	noi {

foreach var in sex age educ {
    display "Checking `var' for missing values..."
    list hhid `var' if `var == .
}

	}
	if `trace' set trace off
}
else if `example' == 7 {
	if `trace' set trace on
	noi {

foreach var in sex age educ {
    display "Checking `var' for missing values..."
    list hhid `var' if `var == .
}

	}
	if `trace' set trace off
}
else if `example' == 8 {
	if `trace' set trace on
	noi {

foreach var in sex age educ {
    display "Checking `var' for missing values..."
    list hhid `var' if `var' == .
}

	}
	if `trace' set trace off
}
else if `example' == 9 {
	if `trace' set trace on
	noi {

local i = 1
while  `i' < 15 {
    display "Round `i'"
    local i = `i' + 1
}

	}
	if `trace' set trace off
}
