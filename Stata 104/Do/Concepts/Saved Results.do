args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

local sum 0
summarize cycleownnum
foreach i of numlist r(min)/r(max) {
    local sum = `sum' + `i'
}
display "The sum is: `sum'"

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

local sum 0
summarize cycleownnum
foreach i of numlist `r(min)'/`r(max)' {
    local sum = `sum' + `i'
}
display "The sum is: `sum'"

	}
	if `trace' set trace off
}
else if `example' == 3 {
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
else if `example' == 4 {
	if `trace' set trace on
	noi {

ds, has(type numeric)
foreach var in `r(varlist)' {
    if `var'[597] != `var'[598] {
        display "The two observations of 1802011 differ on numeric variable `var'."
    }
}

	}
	if `trace' set trace off
}
