args example

loc trace = c(trace) == "on"
if `trace' set trace off

local mata mata:

if `example' == 1 {
	if `trace' set trace on
	noi {

forvalues i = 1/5 {
    local num = 6 - `i'
    local text : label scheier `i'
    label define scheierrev `num' "`text'", modify
}

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

local vars s1_q2 s1_q2_other s1_q3 s1_q4 s1_q5
local nvars : word count `vars'
forvalues i = 1/`nvars' {
    gettoken var1 vars : vars
    local rest `vars'

    local nrest : word count `rest'
    forvalues j = 1/`nrest' {
        gettoken var2 rest : rest

        foreach var3 of local rest {
            duplicates tag `var1' `var2' `var3', generate(loopdup)
            replace loopdup = 0 if missing(`var1', `var2', `var3')
            replace dup = 1 if loopdup
            replace dupvars = dupvars + cond(dupvars == "", "", "; ") + "`var1' `var2' `var3'" if loopdup
            drop loopdup
        }
    }
}

	}
	if `trace' set trace off
}
