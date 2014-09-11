/* {HEAD}

{MACROS!}
{PSANS!}

{MACROS_ANSQ1}
{MACROS_ANSQ2} */

{MACROS_Q1}

generate scheierrev1 = 6 - scheier1

forvalues i = 1/5 {
	local num = 6 - `i'
	local text : label scheier `i'
	label define scheierrev `num' "`text'", modify
}

label values scheierrev1 scheierrev

tabulate scheier1 scheierrev1

* {NEW46}

{MACROS_Q2}

use {DATA_POLICE2}, clear

generate dup = 0
generate dupvars = ""

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

