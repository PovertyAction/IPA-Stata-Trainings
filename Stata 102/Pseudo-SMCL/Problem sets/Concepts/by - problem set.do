/* {HEAD}

{BY!}
{PS!}

{BY_PSQ1}
{BY_PSQ2}
{BY_PSQ3}
{BY_PSQ4}
{BY_PSQ5}
{BY_PSQ6} */


{PSQ:BY_Q1}

* What are by-groups and by-variables?

{PSQ:BY_Q2}

* What is the {cmd:bysort} command?
* How does it differ from {cmd:by}?
* When should you use {cmd:bysort}?

{PSQ:BY_Q3}

/* We know that without {cmd:by},
{BIGN...} is the number of observations in the dataset,
and {LITTLEN...} is the the observation number of an individual observation.
However, the use of {cmd:by}
can change the definitions of {cmd:_N} and {cmd:_n}. Please explain. */

{PSQ:BY_Q4}

{USE}

/* Create a variable named {cmd:sexn} that is the number of respondents
of a given sex. For example, if {cmd:sex = Male}, {cmd:sexn} should equal {cmd:{VAR3}}.

What group(s) are the command(s) you used? */

{PSQ:BY_Q5}

{USE}

/* Create a variable named {cmd:treatment} that is {cmd:1} or {cmd:0}.
Use {cmd:by}, {cmd:_N}, and {cmd:_n}
to ensure that treatment is balanced with respect to {cmd:sex}
by assigning {cmd:treatment = 1} to the first half of males
and the first half of females
and {cmd:treatment = 0} to the second half of males and the second half of females.

To check that you got it right: */

bysort sex: tabulate treatment

* Or:

tabulate sex treatment

{PSQ:BY_Q6}

{USE}

/* Using the {cmd:by} {it:varlist1} {cmd:(}{it:varlist2}{cmd:)} syntax,
create a variable named {cmd:over30} that is
{cmd:1} if any member of a respondent's {cmd:castename} is older than {cmd:30},
and {cmd:0} otherwise. */

/* {FOOT}

{BY_ANS2}
{TOMOD}{BY}

{START} */
