/* {HEAD}

{LOOPS!}
{PSANS!}

{LOOPS_ANSQ1}
{LOOPS_ANSQ2}
{LOOPS_ANSQ3} */


{LOOPS_Q1}

foreach caste in hami jain rawat {
	summarize sex age educ if castename == "`caste'"
}

* It may have been tempting to use two loops instead:

foreach caste in hami jain rawat {
	foreach var of varlist sex age educ {
		summarize `var' if castename == "`caste'"
	}
}

/* However, this is unnecessary,
because you can {cmd:summarize} multiple variables at once.
As useful as they are,
you should usually avoid loops when a one-line command is possible.

In the output from the first loop,
it's hard to tell which {cmd:summarize} goes with which caste.
To address this, we can {cmd:display} the caste name before {cmd:summarize}: */

foreach caste in hami jain rawat {
	display "`caste'"
	summarize sex age educ if castename == "`caste'"
}

{LOOPS_Q2TOP}

{LOOPS_Q2A}

* One method with which you are likely familiar: 

generate castecode1 = 1 if castecode == 1 & castecode != .
replace castecode1 = 0 if castecode != 1 & castecode != . 

* A simpler method is to take advantage of logical expressions:
generate castecode1_1 = castecode == 1 if castecode != .

* See the module on view {view `"{DUMMIES-}"':logical expressions} for more on this method of creating dummy variables. 

{LOOPS_Q2B}

foreach i of numlist 1/6 {
	generate castecode`i' = castecode == `i' if castecode != .
}

{LOOPS_Q3TOP}

{LOOPS_Q3A}

* We can use logical expressions to create the variable with a single command:

generate cycletheft1 = cycletheftvictim_1 == 1 | cycletheftvictim_2 == 1

{LOOPS_Q3B}

generate anycrime1 = 0

foreach crime in cycletheft robbery theft molestation eveteasing attack extortion assault falsecase othercrime {
	replace anycrime1 = 1 if `crime'victim_1 == 1 | `crime'victim_2 == 1
}

{LOOPS_Q3C}

foreach crime in cycletheft robbery theft molestation eveteasing attack extortion assault falsecase othercrime {
	display "`crime'"
	tabulate `crime'victim_1
	tabulate `crime'victim_2
}

* The maximum household member number among members who were victims was {cmd:8}.

{LOOPS_Q3D}

foreach i of numlist 1/8 {
	generate anycrime`i' = 0
	foreach crime in cycletheft robbery theft molestation eveteasing attack extortion assault falsecase othercrime {
		replace anycrime`i' = 1 if `crime'victim_1 == `i' | `crime'victim_2 == `i'
	}
}

{LOOPS_Q3E}

generate nvictims = 0
foreach i of numlist 1/8 {
	replace nvictims = nvictims + anycrime`i'
}

/* {FOOT}

{LOOPS_PS2}
{TOMOD}{LOOPS}

{START} */
