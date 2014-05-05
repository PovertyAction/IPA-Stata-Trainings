/* {HEAD}

{LOGICCHECKS!}
{PS!}

{LOGICCHECKS_PSQ1}
{LOGICCHECKS_PSQ2}
{LOGICCHECKS_PSQ3}
{LOGICCHECKS_PSQ4}
{LOGICCHECKS_PSQ5}
{LOGICCHECKS_PSQ6}
{LOGICCHECKS_PSQ7} */

{PSQ:LOGICCHECKS_Q1}

* In your project, what critical skip patterns could you check using Stata?

* What command(s) would you use to check this skip pattern?

{PSQ:LOGICCHECKS_Q2}

* How does the output of {cmd:assert} compare with that of
* {helpb isid}?

{PSQ:LOGICCHECKS_Q3}

/* If you add the prefix {cmd:capture} to a command
and the command results in an error,
what do you expect to see?
How about if the command does not result in an error? */

{PSQ:LOGICCHECKS_Q4}

/* It can be difficult to tell whether your {cmd:assert}ions are true
when you use the {cmd:capture} prefix.
What are two solutions to this problem? */

#define "{LOGICCHECKS_Q5}" = "{LOGICCHECKS_Q5TOP}{O2}{LOGICCHECKS_Q5A}{O2}{LOGICCHECKS_Q5B}{O2}{LOGICCHECKS_Q5C}"
{PSQ:LOGICCHECKS_Q5TOP}

* {Q5QTITLE}

{USE}

{PSQ:LOGICCHECKS_Q5A}
/* {bf:(a)}

Use {cmd:assert} to check that {cmd:sex} is either {cmd:1} or {cmd:2}. */

{PSQ:LOGICCHECKS_Q5B}
/* {bf:(b)}

Checking for logical consistency between questions
entails checking that the responses to the different questions
are logically consistent with each other.

Skip patterns are an example of a logical relationship,
and you check logical consistency in the same way as skip patterns.
With that mind, complete the following logic check using {cmd:assert}:

Victim 1 of a two-wheeler theft ({cmd:own2wheelertheftvictim_1}) is
different from victim 2 ({cmd:own2wheelertheftvictim_2}). */

{PSQ:LOGICCHECKS_Q5C}
/* {bf:(c)}

Use {cmd:assert} to check all logicial relationships between {cmd:own2wheelertheft},
{cmd:own2wheelertheftnum}, {cmd:own2wheelertheftvictim_1}, and {cmd:own2wheelertheftvictim_2}:
{DEF}

{TOP}
{COL}{cmd:own2wheelertheft}{CEND}
{MLINE}
{COL}Have you or other members of your household had any of their mopeds/{CEND}
{COL}scooters/motorcycles stolen?{CEND}
{BLANK}
{COL}{cmd:1}  Yes{CEND}
{COL}{cmd:2}  No (skip remaining questions){CEND}
{COL}{cmd:.d} Don't know (skip remaining questions){CEND}
{COL}{cmd:.r} Refuse to answer (skip remaining questions){CEND}
{BOTTOM}

{TOP}
{COL}{cmd:own2wheelertheftnum}{CEND}
{MLINE}
{COL}How many times did this happen?{CEND}
{BOTTOM}

{TOP}
{COL}{cmd:own2wheelertheftvictim_1}{CEND}
{MLINE}
{COL}Which household members were victims of this type of crime? (Victim 1){CEND}
{BOTTOM}

{AQ}If {cmd:own2wheelertheftnum > 1} and multiple households members were victims,
ask {cmd:own2wheelertheftvictim_2}:
{DEF}

{TOP}
{COL}{cmd:own2wheelertheftvictim_2}{CEND}
{MLINE}
{COL}Which household members were victims of this type of crime? (Victim 2){CEND}
{BOTTOM} */

{PSQ:LOGICCHECKS_Q6}

/* After each command, is {cmd:_rc} zero or nonzero?
Answer without executing the commands in Stata.

{cmd:capture display "Hello world!" if sex == 1}{BR}
{cmd:display "Hello world!"} */

{PSQ:LOGICCHECKS_Q7}

{USE}

/* In this dataset, there are multiple pairs of variables that first ask
whether a given action has taken place,
and second, how many times it has happened.
These variables have the suffixes {cmd:yn} and {cmd:num}, respectively.
For instance, {cmd:attackyn} and {cmd:attacknum} are one such pair. */

describe attackyn attacknum
browse attackyn attacknum

/* Check for logical consistency in all such pairs:
if the yes/no variable is yes,
then the {cmd:num} variable should not be missing;
if the yes/no variable is no,
then the {cmd:num} variable should be missing.

{bf:Hint 1:}
First use {cmd:ds} to identify all variables that end with {cmd:yn}.
Do all these variables have the same value label?
Do they all have a corresponding {cmd:num} variable?

{bf:Hint 2:}
You may need to use a {help string function}, such as {helpb substr()}. */

/* {FOOT}

{LOGICCHECKS_ANS2}
{TOMOD}{LOGICCHECKS}

{START} */
