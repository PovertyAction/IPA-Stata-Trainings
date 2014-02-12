args module example

loc trace = c(trace) == "on"
if `trace' set trace off

loc module = strlower("`module'")


********************************************************************************
******************************FOR-LOOPS AND MACROS******************************
********************************************************************************

if "`module'" == "for-loops and macros" {
	if `example' == 1 {
		if `trace' set trace on
		noi {

foreach x in "Hello world" "a" "b" "c" {
	display "`x'"
}

		}
		if `trace' set trace off
	}
	else if `example' == 2 {
		if `trace' set trace on
		noi {

local list ""Hello world" "a" "b" "c""
foreach x in `list' {
	display "`x'"
}

		}
		if `trace' set trace off
	}
	else if `example' == 3 {
		if `trace' set trace on
		noi {

local list "Hello world" "a" "b" "c"
foreach x in `list' {
	display "`x'"
}

		}
		if `trace' set trace off
	}
}


********************************************************************************
*********************************SAVED RESULTS**********************************
********************************************************************************

if "`module'" == "saved results" {
	if `example' == 1 {
		if `trace' set trace on
		noi {

foreach i of numlist (1+1)/(2+2) {
	display `i'
}

		}
		if `trace' set trace off
	}
	else if `example' == 2 {
		if `trace' set trace on
		noi {

local start = 1 + 1
local end   = 2 + 2
foreach i of numlist `start'/`end' {
	display `i'
}

		}
		if `trace' set trace off
	}
}


********************************************************************************
**********************************LOGIC CHECKS**********************************
********************************************************************************

if "`module'" == "logic checks" {
	if `example' == 1 {
		if `trace' set trace on
		noi {

ds, has(type numeric)
local numvars `r(varlist)'
foreach var1 in `numvars' {
	foreach var2 in `numvars' {
		if "`var1'" != "`var2'" {
			quietly duplicates tag `var1' `var2', generate(dup)
			quietly count if dup > 0
			if r(N) == 0 {
				display "`var1' `var2' uniquely identify observations."
			}
			drop dup
		}
	}
}

		}
		if `trace' set trace off
	}
	else if `example' == 2 {
		if `trace' set trace on
		noi {

ds, has(type numeric)
local numvars `r(varlist)'
foreach var1 in `numvars' {
	foreach var2 in `numvars' {
		if "`var1'" != "`var2'" {
			capture isid `var1' `var2'
			if _rc == 0 {
				display "`var1' `var2' uniquely identify observations."
			}
		}
	}
}

		}
		if `trace' set trace off
	}
}
