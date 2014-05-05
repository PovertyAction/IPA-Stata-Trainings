/* {HEAD}

{LOGICCHECKS!}
{PSANS!}

{LOGICCHECKS_ANSQ1}
{LOGICCHECKS_ANSQ2}
{LOGICCHECKS_ANSQ3}
{LOGICCHECKS_ANSQ4}
{LOGICCHECKS_ANSQ5}
{LOGICCHECKS_ANSQ6}
{LOGICCHECKS_ANSQ7}
*/

{LOGICCHECKS_Q1}

/* As a first step, use {cmd:assert} to check key skip patterns.
Combining {cmd:assert} with {cmd:capture} could be especially useful
for more complicated checks, such as those requiring for-loops.

Alternatively, create a
{view `"{LOGICCHECKS-}##dummy"':dummy variable that indicates whether there's a data issue},
then use {cmd:browse} or summary commands like {cmd:summarize} or {cmd:tabulate}.

Here's an example from this dataset.
{cmd:assaultyn} asks whether anyone from the respondent's household
has suffered from an action that caused injury, fear, or annoyance.
{cmd:assaultnum} indicates the number of times this happened.
{cmd:assaultnum} should be nonmissing if and only if
{cmd:assaultyn} equals {cmd:Yes} ({cmd:1}).
Here's how we could check this using {cmd:assert}: */

{USE}

assert assaultnum != . if assaultyn == 1
assert assaultnum == . if assaultyn != 1

{LOGICCHECKS_Q2}

/* For both commands, no output is displayed if the assertion/assumption is true.
(In the case of {cmd:isid}, the assertion is that
the specified variables uniquely identify the observations.)
Moreover, both issue an error message if the assertion is false. */

{LOGICCHECKS_Q3}

/* {cmd:capture} suppresses all output from a command
regardless of whether it results in an error.
If a {cmd:capture}d command issues an error message, it is not shown.
If the command does not result in an error,
its normal output is also not displayed.
The exception to this is the use of {cmd:noisily} with {cmd:capture}. */

{LOGICCHECKS_Q4}

/* One option is to add {cmd:noisily} after {cmd:capture}.
For example: */

{USE}

* {cmd:* No output is shown, but because of the capture, it's unclear what this means.}
capture assert cycleownyn == 1 | cycleownyn == 2
* {cmd:* No output is shown, which means the assertion is true.}
capture noisily assert cycleownyn == 1 | cycleownyn == 2

/* A second possibility is to use {cmd:_rc},
which indicates whether the command resulted in an error: */

capture assert cycleownyn == 1 | cycleownyn == 2
display _rc

* You can also choose simply not to use {cmd:assert} for this purpose,
* opting instead for
* {view `"{LOGICCHECKS-}##dummy"':alternatives like {bf:list} and {bf:tabulate}},
* which don't require {cmd:capture}.

{LOGICCHECKS_Q5TOP}

{LOGICCHECKS_Q5A}

assert sex == 1 | sex == 2

{LOGICCHECKS_Q5B}

assert own2wheelertheftvictim_1 != own2wheelertheftvictim_2 | own2wheelertheftvictim_1 == .

{LOGICCHECKS_Q5C}

foreach var of varlist own2wheelertheftnum own2wheelertheftvictim_1 {
	assert `var' != . if own2wheelertheft == 1
	assert `var' == . if own2wheelertheft != 1
}

assert own2wheelertheftvictim_2 == . ///
	if own2wheelertheftnum < 2 | own2wheelertheftnum == .

{LOGICCHECKS_Q6}

/* It is nonzero ({cmd:111}) after both:

{cmd:capture display "Hello world!" if sex == 1}

After this command, {cmd:_rc == 111}.

{cmd:display "Hello world!"}

This command is not preceded by {cmd:capture},
so {cmd:_rc} is unchanged and remains {cmd:111}. */


{LOGICCHECKS_Q7}

* {cmd:* First, make sure that all yes/no variables have yes == 1 and no == 2.}
ds *yn
local ynvars `r(varlist)'
describe `ynvars'
recode `ynvars' (0=2)
label values `ynvars' yesno

{BLOCK}* Loop over all yes/no variables.
{BLOCK}foreach ynvar of varlist *yn {
	{BLOCK}* Remove "yn" from the end of `ynvar'. This makes it easy to determine the name of
	{BLOCK}* the num variable.
	{BLOCK}local base = substr("`ynvar'", 1, length("`ynvar'") - 2)
	{BLOCK}capture noisily list `ynvar' `base'num ///
		{BLOCK}if (`ynvar' == 1 & `base'num == .) | (`ynvar' == 2 & `base'num != .), ///
		{BLOCK}abbreviate(32)
{BLOCK}}

/* Here, we use {cmd:capture} because there are several variables
that end with {cmd:yn} but don't have a correponding variable that ends with {cmd:num}
(for example, {cmd:backcheckedyn}).
Without the {cmd:capture}, the for-loop would result in an error.

We use {cmd:noisily} so that the output of {cmd:list} is not suppressed by {cmd:capture}.
We don't want the do-file to issue an error message and stop,
but we do want to see what {cmd:list} displays. */

/* {FOOT}

{LOGICCHECKS_PS2}
{TOMOD}{LOGICCHECKS}

{START} */
