#define "{RESHAPE_Q1}" = "{RESHAPE_Q1TOP}{O2}{RESHAPE_Q1A}{O2}{RESHAPE_Q1B}{O2}{RESHAPE_Q1C}"
{PSQ:RESHAPE_Q1TOP}

* {Q1QTITLE}

* We have a dataset of summer Olympic medal wins:

use {DATA_OLYMPICS1}, clear

* Each observation is a list of sports in which a country medaled.
* Observations are identified by country and the year of the Olympics:

isid country year
browse

/* However, the sport variables are a mess.
It is not clear how they are ordered (time? medal class?),
but we want them to be alphabetical. */

{PSQ:RESHAPE_Q1A}

/* {bf:(a)}

Sort across the sport variables,
so that {cmd:sport1} is a country's alphabetically first sport,
{cmd:sport2} the second, and so on.
(The sport variables are numeric,
but the values of the value label are sorted by sport name:
{bf:{stata label list sport}}) */

{PSQ:RESHAPE_Q1B}

/* {bf:(b)}

Create a variable named {cmd:sportchange} that is {cmd:1}
if a country's sports list changed since its last medaling year,
and {cmd:0} if not.
There are multiple approaches to {bf:(b)}! */

{PSQ:RESHAPE_Q1C}

/* {bf:(c)}

Create a variable named {cmd:nochange} that is {cmd:1}
if a country has never seen a change in its sports list from
one medaling year to the next, and {cmd:0} otherwise.
How many countries always win the same medals? */

{PSQ:RESHAPE_Q2}

/* For variables that are lists, such as {cmd:sports},
{cmd:reshape} allows manipulation beyond sorting.

The following is a dataset of one list variable, {cmd:s2_q8},
a question that allowed respondents to choose up to 4 of 12 possible options: */

use {DATA_S2Q8}, clear

browse

/* You can see that {cmd:s2_q8} is already internally sorted.
However, it is still not possible to use the variable for analysis.

Using {cmd:reshape}, create dummy variables for all 12 options.
For each option, if a list contains that option, the option's dummy variable should equal {cmd:1};
otherwise it should equal {cmd:0}. For example: */

list in 1

/* In observation 1, the dummy variable for option {cmd:1} would equal {cmd:0},
since the list does not contain {cmd:1}.
However, the dummy variable for option {cmd:5} would equal {cmd:1}. */

{FOOT}
