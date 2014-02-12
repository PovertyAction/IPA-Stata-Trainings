/* {HEAD}

{BY!}
{PSANS!}

{BY_ANSQ1}
{BY_ANSQ2}
{BY_ANSQ3}
{BY_ANSQ4}
{BY_ANSQ5}
{BY_ANSQ6} */


{BY_Q1}

/* By-groups are subsets of the data used by the {cmd:by} prefix.
Every observation in the dataset belongs to exactly one by-group.
When used with {cmd:by}, a command is executed separately for each by-group.
The by-variables are the list of variables that follow {cmd:by}.
Each combination of values of the by-variables is
associated with an individual by-group.
The by-variables are constant within a given by-group;
all observations of a particular by-group share the same values of the by-variables. */

{BY_Q2}

/* {cmd:bysort} combines the {cmd:by} and {cmd:sort} commands.
It first sorts the dataset by the by-variables
and then executes the {cmd:by} command.
By itself, {cmd:by} requires that the dataset be previously sorted.

{cmd:bysort} should be used
when the dataset hasn't already been sorted by the by-variables.
However, it's always possible to use {cmd:bysort} instead of {cmd:by}:
there's no harm in using {cmd:bysort} over {cmd:by}.

Note you cannot combine {cmd:by} with {cmd:gsort} if you want to 
have by-variables in descending order. Use {cmd:gsort} first and then
execute {cmd:by}. */

{BY_Q3}

/* For {GROUP3...} commands like {cmd:generate} and {cmd:list},
using {cmd:by} changes the meanings
of {cmd:_N} and {cmd:_n}.
For these commands,
{cmd:_N} becomes the total number of observations
in the {it:by-group} (not the dataset),
while {cmd:_n} becomes the observation number
within the by-group (not the dataset as a whole).

With {view `"{BY-}##group4"':group 4} commands,
including {cmd:egen},
the values of {cmd:_N} and {cmd:_n} are unpredictable.
{cmd:_N} and {cmd:_n} should not be used with these commands. */

{BY_Q4}

bysort sex: generate sexn = _N

* {cmd:generate} is {GROUP3...}.

{BY_Q5}

* To create {cmd:treatment}:

bysort sex: generate treatment = _n <= _N / 2

* Note the use of the logical expression
* {cmd:_n <= _N / 2} to create the dummy variable.

{BY_Q6}

* Here is one option, using a logical expression:

bysort castename (age): generate over30 = age[_N] > 30

* Here is another option,
* again using a logical expression, this time to create a dummy variable:

* {cmd:* "respover30" for "respondent over 30"}
generate respover30 = age > 30
bysort castename (respover30): generate over30 = respover30[_N]

tabulate over30
tabulate castename over30

/* {FOOT}

{BY_PS2}
{TOMOD}{BY}

{START} */
