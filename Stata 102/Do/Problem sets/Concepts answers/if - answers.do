args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

count if sex < 0
local n = r(N)
if `n' > 0 {
    summarize sex
}

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

count if sex < 0
local n = r(N)
if `n' > 0 {
    list hhid if sex < 0
}

	}
	if `trace' set trace off
}
else if `example' == 3 {
	if `trace' set trace on
	noi {

if surveyid[678] != surveyid[679] {
    display "Difference!"
}

	}
	if `trace' set trace off
}
else if `example' == 4 {
	if `trace' set trace on
	noi {

foreach var of varlist _all {
    if `var'[678] != `var'[679] {
        display "Difference on `var'"
    }
}

	}
	if `trace' set trace off
}
else if `example' == 5 {
	if `trace' set trace on
	noi {

local diffs 0
foreach var of varlist _all {
    if `var'[678] != `var'[679] {
        local diffs = `diffs' + 1
    }
}

display "`diffs' differences"

	}
	if `trace' set trace off
}
