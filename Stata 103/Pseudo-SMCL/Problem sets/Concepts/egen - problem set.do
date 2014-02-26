/* {HEAD}

{EGEN!}
{PS!}

{EGEN_PSQ1}
{EGEN_PSQ2}
{EGEN_PSQ3} */


{PSQ:EGEN_Q1}

* What is the difference between {cmd:generate} and {cmd:egen}?

{PSQ:EGEN_Q2TOP}

* {Q2QTITLE}

{USE}

{PSQ:EGEN_Q2A}

/* {bf:(a)}

Create a dummy variable named {cmd:over40}
that equals {cmd:1} if a respondent is over {cmd:40} years old
and {cmd:0} otherwise. */

{PSQ:EGEN_Q2B}

/* {bf:(b)}

Using {cmd:over40}, {cmd:by}, and {cmd:egen},
calculate the average number of years of education for
those 40 and younger and for those older.

Verify your results using {cmd:summarize}. */

{PSQ:EGEN_Q3TOP}

* {Q3QTITLE}

{USE}

{PSQ:EGEN_Q3A}

/* {bf:(a)}

Using {cmd:egen}, create a variable named {cmd:nmiss} (for "number missing")
that indicates for a given observation
the total number of missing values across all variables.

Use {helpb egen:help egen} to find
the right {cmd:egen} function to use for this task. */

{PSQ:EGEN_Q3B}

/* {bf:(b)}

Using a different {helpb egen} function than you did in {bf:(a)},
create a new variable named {cmd:nonmiss}
that equals the total number of {it:non}missing values for each observation. */

{PSQ:EGEN_Q3C}

/* {bf:(c)}

In each observation,
the sum of {cmd:nmiss} and {cmd:nonmiss} should equal a constant number.
Verify that this is the case. */

{PSQ:EGEN_Q3D}

/* {bf:(d)}

How do the {cmd:egen} functions used above differ
from most other {cmd:egen} functions? */

/* {FOOT}

{EGEN_ANS2}
{TOMOD}{EGEN}

{START} */
