/* {HEAD}

{RESULTS!}
{PSANS!}

{RESULTS_ANSQ1}
{RESULTS_ANSQ2}
{RESULTS_ANSQ3}
{RESULTS_ANSQ4}
{RESULTS_ANSQ5} */

{RESULTS_Q1TOP}

{RESULTS_Q1A}

* Saved results are values that are stored by commands
* and are available for use after the command is complete.

{RESULTS_Q1B}

/* Saved results come in different {view `"{RESULTS-}##r_and_e"':classes},
of which the most common are {cmd:r()} and {cmd:e()}.
To view the current {cmd:r()} saved results, use {helpb return list}.
To view the current {cmd:e()} saved results, use {helpb ereturn list}. */

{RESULTS_Q2TOP}

{RESULTS_Q2A}

ds, has(type string)

{RESULTS_Q2B}

ds, has(type string)
display "`r(varlist)'"

{RESULTS_Q3}

/* String saved results, such as {cmd:r(varlist)},
should always be enclosed by single quotes,
as otherwise they are truncated at around 244 characters. (Prior to Stata 13)

Numeric saved results, such as {cmd: r(mean)},
typically can be used without being enclosed by single quotes.
However, they need single quotes when used with the for-loop commands
{cmd:foreach} and {cmd:forvalues}.
For details, see the related
{view `"{RESULTS-}##enclosing_saved_results"':Technical Tip box}
in the saved results module. */

{RESULTS_Q4TOP}

{RESULTS_Q4A}

ds, has(vallabel yesno)

{RESULTS_Q4B}

* Using an interative loop to count: 

{BLOCK}local nvars 0
{BLOCK}ds, has(vallabel yesno)
{BLOCK}foreach var in `r(varlist)' {
	{BLOCK}local nvars = `nvars' + 1
{BLOCK}}
{BLOCK}
{BLOCK}display "`nvars' variables have the value label yesno."

{RESULTS_Q5TOP}

{RESULTS_Q5A}

duplicates tag surveyid, generate(dup)
count if dup > 0

drop dup

{RESULTS_Q5B}

ds, has(type numeric)
foreach var in `r(varlist)' {
	quietly duplicates tag `var', generate(dup)
	quietly count if dup > 0
	if r(N) == 0 {
		display "`var' uniquely identifies observations."
	}
	drop dup
}

{RESULTS_Q5C}

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

{RESULTS_Q5C_EXTRA}

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

/* Do you notice a difference between the output
of these two approaches to {bf:(c)}?
What explains it?
(Hint: it has to do with how {helpb isid} responds to missing values.) */

/* {FOOT}

{RESULTS_PS2}
{TOMOD}{RESULTS}

{START} */
