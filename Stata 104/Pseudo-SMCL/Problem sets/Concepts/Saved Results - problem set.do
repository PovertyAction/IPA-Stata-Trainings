/* {HEAD}

{RESULTS!}
{PS!}

{RESULTS_PSQ1}
{RESULTS_PSQ2}
{RESULTS_PSQ3}
{RESULTS_PSQ4}
{RESULTS_PSQ5} */


{PSQ:RESULTS_Q1TOP}

* {Q1QTITLE}

{PSQ:RESULTS_Q1A}

/* {bf:(a)}

What are saved results? */

{PSQ:RESULTS_Q1B}

/* {bf:(b)}

How do you view the current saved results? */

{PSQ:RESULTS_Q2TOP}

* {Q2QTITLE}

{USE}

{PSQ:RESULTS_Q2A}

/* {bf:(a)}

Use {cmd:ds} to list the string variables in the dataset. */

{PSQ:RESULTS_Q2B}

/* {bf:(b)}

When listing variables,
{cmd:ds} by default abbreviates variable names to 12 characters.
Using saved results, display the unabbreviated list. */

{PSQ:RESULTS_Q3}

/* How does using saved results change
based on whether the results are numeric or string? */

#define "{RESULTS_Q4}" = "{RESULTS_Q4TOP}{O2}{RESULTS_Q4A}{O2}{RESULTS_Q4B}"
{PSQ:RESULTS_Q4TOP}

* {Q4QTITLE}

{USE}

{PSQ:RESULTS_Q4A}

/* {bf:(a)}

List all variables with the value label {cmd:yesno}. */

{PSQ:RESULTS_Q4B}

/* {bf:(b)}

Using {cmd:ds} and a for-loop,
get Stata to count the number of variables with the value label {cmd:yesno}. */

#define "{RESULTS_Q5}" = "{RESULTS_Q5TOP}{O2}{RESULTS_Q5A}{O2}{RESULTS_Q5B}{O2}{RESULTS_Q5C}{O2}{RESULTS_Q5C_EXTRA}"
{PSQ:RESULTS_Q5TOP}

* {Q5QTITLE}

{USE}

{PSQ:RESULTS_Q5A}

/* {bf:(a)}

Use {cmd:duplicates tag} and {cmd:count} to determine the number of {cmd:surveyid} duplicates. */

{PSQ:RESULTS_Q5B}

/* {bf:(b)}

First, use {cmd:duplicates drop} to drop the exact copy of {cmd:hhid "1807077"}: */

duplicates drop

/* Now, using {cmd:duplicates tag} and {cmd:count},
find all numeric variables that uniquely identify observations.
If the output is overwhelming, try adding {cmd:quietly} before select commands. */

{PSQ:RESULTS_Q5C}

/* {bf:(c)}

Find all combinations of two numeric variables that uniquely identify observations.
Reminder: {cmd:duplicates tag} takes a variable {it:list}.

Make sure you have used {cmd:duplicates drop}
to drop the exact copy of {cmd:hhid "1807077"}. */

{PSQ:RESULTS_Q5C_EXTRA}

/* A (much faster) alternative to {cmd:duplicates tag} is
the combination of {helpb isid} and
{view `"{LOGICCHECKS-}##capture"':{bf:capture}}.
Extra credit if you try using them,
but only do so if you already know {cmd:capture} and {cmd:_rc}.
If you don't know them, we will discuss them
in the module on {view `"{LOGICCHECKS-}"':logic checks}. */

/* {FOOT}

{RESULTS_ANS2}
{TOMOD}{RESULTS}

{START} */
