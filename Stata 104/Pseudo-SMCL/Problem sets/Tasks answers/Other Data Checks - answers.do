/* {HEAD}

{OTHERCHECKS!}
{PSANS!}

{OTHERCHECKS_ANSQ1}
{OTHERCHECKS_ANSQ2}
{OTHERCHECKS_ANSQ3}
{OTHERCHECKS_ANSQ4} */


{OTHERCHECKS_Q1}

/* {cmd:assert} with {cmd:levelsof} would fail while {cmd:assert} with {cmd:inrange()} wouldn't
if {cmd:1 < cycleownyn < 2}.

{cmd:assert} with {cmd:inrange()} would fail while {cmd:assert} with {cmd:levelsof} wouldn't
if {cmd:cycleownyn} was missing, since unless its option {cmd:missing} is specified,
{cmd:levelsof} doesn't display or save missing values. */

{OTHERCHECKS_Q2TOP}

{OTHERCHECKS_Q2A}

* Using a for-loop for counting:

{BLOCK}local i 0
{BLOCK}levelsof castename
{BLOCK}foreach level in `r(levels)' {
	{BLOCK}if substr("`level'", 1, 1) == "B" {
		{BLOCK}local i = `i' + 1
	{BLOCK}}
{BLOCK}}
{BLOCK}
{BLOCK}display "`i' values of castename start with B."

{OTHERCHECKS_Q2B}

levelsof castename
foreach level in `r(levels)' {
	quietly tabulate castecode if castename == "`level'"
	display "`level' corresponds to `r(r)' values of castecode."
}

* There are values of {cmd:castename}
* with more than one corresponding value of {cmd:castecode}.

{OTHERCHECKS_Q3}

foreach var of varlist _all {
	quietly count if missing(`var')
	if r(N) == _N {
		display "`var' has all missing values."
	}
}

/* These variables are not all necessarily problematic.
For example, {cmd:own2wheelertheftvictim_2} has all missing values,
but just because there was never a second reported theft victim,
not because the enumerators or data entry operators made a mistake. */

{OTHERCHECKS_Q4}

/* There are many potential problems you can encounter
when collecting survey data.
Here is one example, from an actual project:

A question in the project's computer-assisted interviewing (CAI) program
was supposed to ask how many hours per week
respondents worked at their job,
but was accidentally programmed to ask for hours per {it:day}.
However, from the data collected,
it appeared that many enumerators were still asking for
hours per week, given that many responses were the maximum allowed {cmd:24}.

Fortunately, the error was caught quickly,
and the corrected question was added to a back check survey
while the survey was reprogrammed to fix the question text. */

/* {FOOT}

{OTHERCHECKS_PS2}
{TOMOD}{OTHERCHECKS}

{START} */
