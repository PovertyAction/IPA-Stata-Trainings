/* {HEAD}

{IF!}
{PSANS!}

{IF_ANSQ1}
{IF_ANSQ2}
{IF_ANSQ3}*/


{IF_Q1TOP}

{IF_Q1A}

/* {cmd:if} qualifier: the command has been limited to a subset of the data, respondents younger
than {cmd:30}: */

list sex if age < 30

{IF_Q1B}

/* {cmd:if} command: the command has not been limited to a subset of the data.
Utilizing {helpb return:saved results}, a concept introduced in {bf: Stata 104},
the code for this might look like: */

count if sex < 0
local n = r(N)
if `n' > 0 {
	summarize sex
}

{IF_Q1C}

/* {cmd:if} qualifier: the command has been limited to a subset of the data, namely women: */

tabulate occupation if sex == 2

{IF_Q1D}

/* Both. First the {cmd:if} command is used to test whether there are any values
greater than {cmd:0}, then the {cmd:if} qualifier limits the observations whose values of
{cmd:hhid} are listed to those for which the variable is less than {cmd:0}.
Again utlizing {helpb return:saved results}: */

count if sex < 0
local n = r(N)
if `n' > 0 {
	list hhid if sex < 0
}

{IF_Q2TOP}

{IF_Q2A}

/* A command's help file shows whether it allows the {cmd:if} qualifier.
If it does, [{it:{help if}}] will usually appear
on the first line of the syntax section. */

{IF_Q2B}

/* Many commands with which we are familiar allow the {cmd:if} qualifer,
including {helpb tabulate oneway:tabulate}, {helpb generate}, and {helpb browse}.

Commands that don't allow the {cmd:if} qualifier include
{helpb describe}, {helpb sort}, {helpb label}, and {helpb local}. */

{IF_Q3TOP}

{IF_Q3A}

* {cmd:* Obtain the observation numbers.}
list hhid if hhid == "1813023"

if surveyid[678] != surveyid[679] {
	display "Difference!"
}

{IF_Q3B}

foreach var of varlist _all {
	if `var'[678] != `var'[679] {
		display "Difference on `var'"
	}
}

{IF_Q3C}

* Using the method described in the {view `"{LOOPS-}##counting"':module on for-loops}:

{BLOCK}local diffs 0
{BLOCK}foreach var of varlist _all {
	{BLOCK}if `var'[678] != `var'[679] {
		{BLOCK}local diffs = `diffs' + 1
	{BLOCK}}
{BLOCK}}
{BLOCK}
{BLOCK}display "`diffs' differences"

/* {FOOT}

{IF_PS2}
{TOMOD}{IF}

{START} */
