args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

local nvars 0
ds, has(vallabel yesno)
foreach var in `r(varlist)' {
    local nvars = `nvars' + 1
}

display "`nvars' variables have the value label yesno."

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

ds, has(type numeric)
foreach var in `r(varlist)' {
    quietly duplicates tag `var', generate(dup)
    quietly count if dup > 0
    if r(N) == 0 {
        display "`var' uniquely identifies observations."
    }
    drop dup
}

	}
	if `trace' set trace off
}
else if `example' == 3 {
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
else if `example' == 4 {
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
