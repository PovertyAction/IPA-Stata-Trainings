/* {HEAD}

{PROPERTIES!}
{PS!}

{PROPERTIES_PSQ1}
{PROPERTIES_PSQ2}
{PROPERTIES_PSQ3}
{PROPERTIES_PSQ4}
{PROPERTIES_PSQ5}
{PROPERTIES_PSQ6}
{PROPERTIES_PSQ7} */


{PSQ:PROPERTIES_Q1}

{USE}

/* Consider the problem of renaming the same variables
multiple times with different prefixes.
First, assign the prefix {cmd:base_} (for "baseline") to all variables.
Then rename variables with the prefix {cmd:mid_} instead.
Finally, rename with the prefix {cmd:end_}.

What variable(s) would you not want to rename in this fashion? */

{PSQ:PROPERTIES_Q2}

{USE}

/* In this dataset, a number of variables end with {cmd:_1} or {cmd:_2}.
But imagine you instead prefer these variables
to begin with {cmd:first_} and {cmd:second_}, respectively.
How would you go about doing this? */

{PSQ:PROPERTIES_Q3}

{USE}

/* Variables {cmd:robberyyn}, {cmd:assaultyn} and {cmd:falsecaseyn}
share the same value label, which has been removed for this problem set.
In one line of code,
label the values of all three variables with the existing value label {cmd:yesno}. */

{PSQ:PROPERTIES_Q4}

{USE}

* For the variable {cmd:educ},
* why are some values labeled while others are apparently not?
* You can see this as follows:

tabulate educ

* {bf:Hint:} begin by determining the value label using {cmd:describe}.

{PSQ:PROPERTIES_Q5TOP}

* {Q5QTITLE}

{USE}

* When you create a new variable,
* you often want to immediately assign it a value label.

{PSQ:PROPERTIES_Q5A}

/* {bf:(a)}

First create a new variable named {cmd:over40}
that equals {cmd:1} if {cmd:age} is greater than {cmd:40},
and {cmd:0} if it is not.

How would you go about checking that you have created the variable correctly? */

{PSQ:PROPERTIES_Q5B}

/* {bf:(b)}

Assign an appropriate value label to {cmd:over40}.

{bf:Hint:} use {cmd:label list} to see
which existing value label would be appropriate
for the new variable you've created. */

{PSQ:PROPERTIES_Q6TOP}

* {Q6QTITLE}

{USE}

/* First, execute the following commands,
which define the value label {cmd:addressunit}
and assign it to the variable {cmd:addressdur_unit}: */

label define addressunit 1 days 2 weeks 3 months 4 years
label values addressdur_unit addressunit

{PSQ:PROPERTIES_Q6A}

/* {bf:(a)}

/* Combining the two variables {cmd:addressdur} and {cmd:addressdur_unit},
create a new variable named {cmd:addressdays} that indicates
the number of days a respondent has lived at his/her current address. */

{PSQ:PROPERTIES_Q6B}

* {bf:(b)}

* Calculate the mean number of days
* that respondents have lived at their current address.

{PSQ:PROPERTIES_Q7}

* Under what circumstances would you want
* to convert a string variable to numeric?
* How about converting a numeric variable to string?

/* {FOOT}

{PROPERTIES_ANS2}
{TOMOD}{PROPERTIES}

{START} */
