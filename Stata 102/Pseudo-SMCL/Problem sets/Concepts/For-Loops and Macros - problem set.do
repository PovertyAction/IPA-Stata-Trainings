/* {HEAD}

{LOOPS!}
{PS!}

{LOOPS_PSQ1}
{LOOPS_PSQ2}
{LOOPS_PSQ3} */


{PSQ:LOOPS_Q1}

{USE}

/* Loop over these values of variable {cmd:castename}:
{cmd:"hami"}, {cmd:"jain"}, and {cmd:"rawat"}.
For each of these castes,
{cmd:summarize} the variables {cmd:sex}, {cmd:age}, and {cmd:educ}. */

{PSQ:LOOPS_Q2TOP}

* {Q2QTITLE}

{USE}

/* Variable {cmd:castecode} is categorical: it can be one of a fixed set of values. */

tabulate castecode

* {cmd:castecode} is {view `"{PROPERTIES-}##labels"':value labeled}:

tabulate castecode, nolabel

{PSQ:LOOPS_Q2A}
/* {bf:(a)}

Create a dummy variable named {cmd:castecode1} for the {cmd:General} caste.
If {cmd:castecode} is {cmd:1} ({cmd:General}), {cmd:castecode1} should equal {cmd:1}.
If {cmd:castecode} is another caste, {cmd:castecode1} should equal {cmd:0}.
If {cmd:castecode} is missing, {cmd:castecode1} should also be missing. */

{PSQ:LOOPS_Q2B}
/* {bf:(b)}

Reload the dataset: */

{USE}

* Use a for-loop to create a dummy variable for each of the six castes.

{PSQ:LOOPS_Q3TOP}

* {Q3QTITLE}

{USE}

/* For many crimes in the dataset,
there is information about which household members were victims.
For example, household members with these IDs
were victims of cycle theft: */

tabulate cycletheftvictim_1
tabulate cycletheftvictim_2

{PSQ:LOOPS_Q3A}
/* {bf:(a)}

Create a dummy variable named {cmd:cycletheft1} for whether household member {cmd:1}
was a victim of cycle theft. */

{PSQ:LOOPS_Q3B}
/* {bf:(b)}

Victim information is available for these crimes:
{cmd:cycletheft robbery theft molestation eveteasing attack extortion assault falsecase othercrime}.
Each crime has two victim variables so that households can list multiple victims.
For example, cycle theft had two victim variables:
{cmd:cycletheftvictim_1} and {cmd:cycletheftvictim_2}.

Create a dummy variable named {cmd:anycrime1} for whether household member {cmd:1}
was the victim of any crime.
To do this, loop through all crimes. */

{PSQ:LOOPS_Q3C}
/* {bf:(c)}

Loop through all crimes.
For each crime, first {cmd:display} the crime.
Then {cmd:tabulate} the two victim variables for the crime.
What is the maximum household member number
among members who were victims? */

{PSQ:LOOPS_Q3D}
/* {bf:(d)}

Reload the dataset: */

{USE}

/* For each household member with member number {cmd:1} through the maximum
(determined in part {cmd:(c)}),
create a dummy variable for whether the household member
was a victim of any crime. */

{PSQ:LOOPS_Q3E}
/* {bf:(e)}

Using the dummy variables from part {cmd:(d)},
create a variable named {cmd:nvictims}
that equals the number of unique victims in the household.
For example, if household members {cmd:1} and {cmd:3}
were victims, then {cmd:nvictims} should equal {cmd:2}.
This is the case whether household member {cmd:1} experienced
one crime or 10.

Using {cmd:nvictims} and information from a household roster,
we could estimate what fraction of the sample was a victim of any of these crimes. */

/* {FOOT}

{LOOPS_ANS2}
{TOMOD}{LOOPS}

{START} */
