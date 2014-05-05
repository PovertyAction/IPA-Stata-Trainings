/* {HEAD}

{OTHERCHECKS!}
{PS!}

{OTHERCHECKS_PSQ1}
{OTHERCHECKS_PSQ2}
{OTHERCHECKS_PSQ3}
{OTHERCHECKS_PSQ4} */


{PSQ:OTHERCHECKS_Q1}

{USE}

* We've seen two ways to check that {cmd:cycleownyn} is only {cmd:Yes} or {cmd:No}.
* The first involved {bf:{view `"{OTHERCHECKS-}##levelsof"':levelsof}}:

levelsof cycleownyn
assert "`r(levels)'" == "1 2"

* The second was {bf:{view `"{OTHERCHECKS-}##inrange"':inrange()}}:

assert inrange(cycleownyn, 1, 2)

/* Could it ever occur that the first {cmd:assert} (with {cmd:levelsof})
would fail but the second with {cmd:inrange()} would not?
How about vice versa?
If so, under what circumstances would this occur? */

#define "{OTHERCHECKS_Q2}" = "{OTHERCHECKS_Q2TOP}{O2}{OTHERCHECKS_Q2A}{O2}{OTHERCHECKS_Q2B}"
{PSQ:OTHERCHECKS_Q2TOP}

* {Q2QTITLE}

{USE}

{PSQ:OTHERCHECKS_Q2A}
/* {bf:(a)}

Using {cmd:levelsof}, loop through all distinct values of {cmd:castename}.
For how many values is the {help substr():first character} {cmd:"B"}? */

{PSQ:OTHERCHECKS_Q2B}
/* {bf:(b)}

For each distinct value of {cmd:castename},
display the number of corresponding values of {cmd:castecode}.
For example, {cmd:castename "VISHWAKARMA"} has
exactly one corresponding value of {cmd:castecode}: {cmd:OBC}.

Are there any values of {cmd:castename}
with more than one corresponding value of {cmd:castecode}? */

{PSQ:OTHERCHECKS_Q3}

{USE}

/* Using a loop (not manually using {cmd:codebook}),
find all variables with all missing values.

If there are any, are they all necessarily problematic? */

{PSQ:OTHERCHECKS_Q4}

/* Have you encountered unexpected, problematic, or weird data originating
from a project's survey design, computer-assisted interviewing (CAI) programming,
or field work?
Describe the process through which you identified
the source of the issue and how you resolved it. */

/* {FOOT}

{OTHERCHECKS_ANS2}
{TOMOD}{OTHERCHECKS}

{START} */
