/* {HEAD}

{EGEN!}
{PSANS!}

{EGEN_ANSQ1}
{EGEN_ANSQ2}
{EGEN_ANSQ3} */


{EGEN_Q1}

/* {cmd:generate} creates a new variable observation by observation.
Generally speaking, the value of the new variable in observation {cmd:1} depends only on
other values in observation {cmd:1};
the value in observation {cmd:2} depends only on
other values in observation {cmd:2};
and so on.
(The chief exception to this is {LITTLEN...}.)

On the other hand, {cmd:egen} usually calculates its values across all observations
in the dataset (or all observations within the by-group, if {cmd:by} is used).
For a new variable, all observations' values depend on other observations,
not just their own observations. */

{EGEN_Q2TOP}

{EGEN_Q2A}

generate over40 = age > 40 if !missing(age)

{EGEN_Q2B}

bysort over40: egen meaneduc = mean(educ)
tabulate meaneduc over40

* Verifying with {cmd:summarize}:

by over40: summarize educ

{EGEN_Q3TOP}

{EGEN_Q3A}

egen nmiss = rowmiss(_all)

{EGEN_Q3B}

egen nonmiss = rownonmiss(_all), strok

{EGEN_Q3C}

generate sum = nmiss + nonmiss
tabulate sum

{EGEN_Q3D}

/* Both {cmd:rowmiss()} and {cmd:rownonmiss()},
as well as other {cmd:egen row*()} functions,
calculate their values observation by observation,
as {cmd:generate} does.
Many {cmd:egen} functions calculate their values
across all observations in the dataset,
yet some {cmd:egen} functions, such as these, are
essentially the same as normal functions used
with {cmd:generate} and within expressions. */

/* {FOOT}

{EGEN_PS2}
{TOMOD}{EGEN}

{START} */
