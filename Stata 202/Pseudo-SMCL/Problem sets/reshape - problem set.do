#define "{RESHAPE_Q1}" = "{RESHAPE_Q1TOP}{O2}{RESHAPE_Q1A}{O2}{RESHAPE_Q1B}{O2}{RESHAPE_Q1C}"
{PSQ:RESHAPE_Q1TOP}

/* {Q1QTITLE}

Suppose we have a subset of a dataset of 2011 IPA expense reports.
(Don't worry, the data is fake.) */

use {DATA_PROJ1}, clear

* The dataset is sorted by employee ({cmd:id}) and the date of the ER ({cmd:date}):

isid id date
browse

/* However, the projects variables are a mess.
They were taken directly from the ER,
so the values are ordered according to how they were entered in the ER. */

{PSQ:RESHAPE_Q1A}

/* {bf:(a)}

Sort across the project variables,
so that {cmd:project1} is an employee's alphabetically first project,
{cmd:project2} the second, and so on.
(The project variables are numeric,
but the values of the value label are sorted by project text:
{bf:{stata label list project}}) */

{PSQ:RESHAPE_Q1B}

/* {bf:(b)}

Create a variable named {cmd:projectchange} that is {cmd:1}
if an employee's list of projects changed since their last ER,
and {cmd:0} otherwise.
There are multiple approaches to {bf:(b)}! */

{PSQ:RESHAPE_Q1C}

/* {bf:(c)}

Create a variable named {cmd:anychange} that is {cmd:1}
if an employee made any project change in 2011,
and {cmd:0} otherwise. How many IPAers changed projects in 2011? */

{PSQ:RESHAPE_Q2}

/* For variables that are lists, such as {cmd:projects},
{cmd:reshape} allows manipulation beyond sorting.

The following is a dataset of one variable, {cmd:s2_q8},
a question that allowed respondents to choose up to 4 of 12 possible options: */

use {DATA_S2Q8}, clear

browse

/* You can see that {cmd:s2_q8} is already internally sorted.
However, it's still not possible to use the variable for analysis.

Using {cmd:reshape}, create dummy variables for all 12 options.
For each value, if a list contains that value, the value's dummy variable should equal {cmd:1};
otherwise it should equal {cmd:0}. For example: */

list in 1

/* In observation 1, the dummy variable for option {cmd:1} would equal {cmd:0},
since the list does not contain {cmd:1}.
However, the dummy variable for option {cmd:5} would equal {cmd:1}. */

{FOOT}
