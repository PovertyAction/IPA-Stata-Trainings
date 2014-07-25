args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

ds, not(vallab)
local nolabvars `r(varlist)'

ds, has(type string)
local strvars `r(varlist)'

foreach nolabvar of local nolabvars {
    local isnumvar 1

    foreach strvar of local strvars {
        if "`nolabvar'" == "`strvar'" {
            local isnumvar 0
        }
    }

    if `isnumvar' {
        local numnolabvars `numnolabvars' `nolabvar'
    }
}

display "`numnolabvars'"

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

ds, not(vallab)
local nolabvars `r(varlist)'

ds, has(type string)
local strvars `r(varlist)'

foreach nolabvar of local nolabvars {
    local instrvars : list nolabvar in strvars
    if !`instrvars' {
        local numnolabvars `numnolabvars' `nolabvar'
    }
}

display "`numnolabvars'"

	}
	if `trace' set trace off
}
else if `example' == 3 {
	if `trace' set trace on
	noi {

#delimit ;
* The first list to loop over;
local vars
    s1_q1
    s1_q2
    s1_q2_other
    s1_q3
    s1_q4
    s1_q5
    s1_q6
;
* The second list to loop over;
local newvars
    sex
    occupation
    occupationother
    castename
    castecode
    age
    education
;
#delimit cr

local nvars = wordcount("`vars'")
forvalues i = 1/`nvars' {
    * `var' is the `i'th element of `vars'.
    local var    = word("`vars'",    `i')
    * `newvar' is the `i'th element of `newvars'.
    local newvar = word("`newvars'", `i')
    rename `var' `newvar'
}

	}
	if `trace' set trace off
}
else if `example' == 4 {
	if `trace' set trace on
	noi {

ds
local vars `r(varlist)'

lstrfun newvars, lower("`vars'")

local nvars : word count `vars'
forvalues i = 1/`nvars' {
    local var    : word `i' of `vars'
    local newvar : word `i' of `newvars'
    rename `var' `newvar'
}

	}
	if `trace' set trace off
}
else if `example' == 5 {
	if `trace' set trace on
	noi {

local vars s1_q2 s1_q2_other s1_q3 s1_q4 s1_q5
foreach var1 of local vars {
    foreach var2 of local vars {
        if "`var1'" != "`var2'" {
            duplicates tag `var1' `var2', generate(loopdup)
            replace loopdup = 0 if missing(`var1', `var2')
            replace dup = 1 if loopdup
            replace dupvars = dupvars + cond(dupvars == "", "", "; ") + "`var1' `var2'" if loopdup
            drop loopdup
        }
    }
}

	}
	if `trace' set trace off
}
else if `example' == 6 {
	if `trace' set trace on
	noi {

local vars s1_q2 s1_q2_other s1_q3 s1_q4 s1_q5
local nvars : word count `vars'
forvalues i = 1/`nvars' {
    gettoken var1 vars : vars

    foreach var2 of local vars {
        duplicates tag `var1' `var2', generate(loopdup)
        replace loopdup = 0 if missing(`var1', `var2')
        replace dup = 1 if loopdup
        replace dupvars = dupvars + cond(dupvars == "", "", "; ") + "`var1' `var2'" if loopdup
        drop loopdup
    }
}

	}
	if `trace' set trace off
}
