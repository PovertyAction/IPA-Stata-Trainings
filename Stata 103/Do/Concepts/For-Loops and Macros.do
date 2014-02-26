args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

foreach var in sex age educ {
    display "Checking `var' for missing values..."
    list hhid `var' if `var == .
}

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

foreach var in sex age educ {
    display "Checking `var' for missing values..."
    list hhid `var' if `var == .
}

	}
	if `trace' set trace off
}
else if `example' == 3 {
	if `trace' set trace on
	noi {

foreach var in sex age educ {
    display "Checking `var' for missing values..."
    list hhid `var' if `var' == .
}

	}
	if `trace' set trace off
}
else if `example' == 4 {
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
