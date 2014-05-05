args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

local i 0
levelsof castename
foreach level in `r(levels)' {
    if substr("`level'", 1, 1) == "B" {
        local i = `i' + 1
    }
}

display "`i' values of castename start with B."

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

levelsof castename
foreach level in `r(levels)' {
    quietly tabulate castecode if castename == "`level'"
    display "`level' corresponds to `r(r)' values of castecode."
}

	}
	if `trace' set trace off
}
else if `example' == 3 {
	if `trace' set trace on
	noi {

foreach var of varlist _all {
    quietly count if missing(`var')
    if r(N) == _N {
        display "`var' has all missing values."
    }
}

	}
	if `trace' set trace off
}
