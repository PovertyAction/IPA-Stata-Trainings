/* {HEAD}

{PROPERTIES!}
{PSANS!}

{PROPERTIES_ANSQ1}
{PROPERTIES_ANSQ2}
{PROPERTIES_ANSQ3}
{PROPERTIES_ANSQ4}
{PROPERTIES_ANSQ5}
{PROPERTIES_ANSQ6}
{PROPERTIES_ANSQ7} */


{PROPERTIES_Q1}

* If you're using Stata 12 or higher,
* the improved {cmd:rename} is one way to add the {cmd:base_} prefix:

rename * base_*

* {cmd:renpfix} is an option for all versions:

renpfix "" base_

* All variables now have the {cmd:base_} prefix.
* As we add the {cmd:mid_} prefix,
* we must remember that the variables do have a prefix, {cmd:base_},
* rather than no prefix at all.

* {cmd:* Stata 12 or higher}
rename base_* mid_*

* {cmd:* Stata 11 or below}
renpfix base_ mid_

* Finaly, changing the prefix from {cmd:mid_} to {cmd:end_}:

* {cmd:* Stata 12 or higher}
rename mid_* end_*

* {cmd:* Stata 11 or below}
renpfix mid_ end_

/* You probably would not want to rename {cmd:hhid} in this way.
{cmd:hhid} should be constant across all rounds of a survey,
so attaching a round prefix to it would be superflous.
Further, renaming it in this way could impede merging. */

{PROPERTIES_Q2}

* First, it would be useful to see all variables whose names contain {cmd:"_"}:

describe *_*, fullnames

* In Stata 12 and higher, you can use {cmd:rename} to rename groups of variables:

rename (*_1 *_2) (first_* second_*)

* If you are using Stata 11 or lower,
* one option is repeated uses of the user-written program {cmd:renvars}:

renvars *_1, prefix(first_)
renvars *_1, postsub(_1)

renvars *_2, prefix(second_)
renvars *_2, postsub(_2)

* Once you're done, check that all variables have been renamed correctly:

describe *_*, fullnames

{PROPERTIES_Q3}

label values robberyyn assaultyn falsecaseyn yesno

{PROPERTIES_Q4}

* This indicates that the value label of {cmd:educ} is {cmd:standard}:

describe educ

* To see the contents of {cmd:standard}:

label list standard

/* Since the survey question for {cmd:educ} asks for the highest standard reached,
values {cmd:1} through {cmd:12} are self-explanatory.
Text is needed to interpret values {cmd:0} and {cmd:13} through {cmd:16},
so the value label {cmd:standard} was defined for only those values. */

{PROPERTIES_Q5TOP}

{PROPERTIES_Q5A}

generate over40 = 0 if age != .
replace  over40 = 1 if age > 40 & age != .

* One way to check our work would be
* to use the {cmd:tabulate} and {cmd:summarize} commands as follows:

tabulate over40
summarize age if age <= 40
summarize age if age > 40

{PROPERTIES_Q5B}

label list

* We can see that the label {cmd:yes1no0} can be used
* for the variable. Thus:

label values over40 yes1no0

{PROPERTIES_Q6TOP}

{PROPERTIES_Q6A}

generate addressdays = .
replace addressdays = addressdur               if addressdur_unit == 1
replace addressdays = addressdur * 7           if addressdur_unit == 2
replace addressdays = addressdur * 365.25 / 12 if addressdur_unit == 3
replace addressdays = addressdur * 365.25      if addressdur_unit == 4

{PROPERTIES_Q6B}

summarize addressdays

{PROPERTIES_Q7}

/* Converting a string variable to numeric greatly aids data analysis.
For instance, one can calculate various statistics regarding the variable,
such as its mean, median, variance, and so on.
A numeric variable, unlike a string,
can also be used in regressions and other types of analysis.

Converting from numeric to string is rarely necessary, but here's one example.
Suppose you have an open-ended free text variable
that could contain numbers or text.
If it contains only numbers, it may be imported from the raw data as numeric.
However, if future values of the variable are likely to contain text,
you may want to convert it to string. */

/* {FOOT}

{PROPERTIES_PS2}
{TOMOD}{PROPERTIES}

{START} */
