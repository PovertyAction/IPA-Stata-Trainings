/* {HEAD}

{BY!} */

{USE}

/* In Stata, you often find yourself needing to repeat a command,
perhaps making minor adjustments from one call to another.
For example, suppose you want to examine summary statistics for variable {cmd:educ}
for all the different castes. You could try: */

tabulate castecode, missing nolabel

summarize educ if castecode == 1
summarize educ if castecode == 2
summarize educ if castecode == 3
summarize educ if castecode == 4
summarize educ if castecode == 5
summarize educ if castecode == 6
summarize educ if castecode == .

/* The similarity between the 7 lines implies a more efficient approach:
only 1 character out of 32 changes from one line to the next.
Imagine if you wanted to {cmd:summarize} by {cmd:castecode} not just {cmd:educ},
but also variables {cmd:sex}, {cmd:age}, and {cmd:literateyn}:
the code would catapult to 28 lines.
Not only is this hard to update when a variable name or something else changes,
more lines means greater risk of human error {hline 2}
especially when the coding is repetitive,
and it's hard to pay careful attention to each line.

What's the solution?
We've seen one enormously flexible way to respond to this task:
{view `"{LOOPS-}"':for-loops}.
Here's how we could use one here: */

foreach i of numlist 1/6 . {
	summarize educ if castecode == `i'
}

/* That's a big step forward.
Yet, loops that run through each value of a variable are
so common that they have their own command: {helpb by}.
Above, we looped over each value of {cmd:castecode},
but instead we could use this {cmd:by} command:

{TRYITCMD}
sort castecode{BR}
by castecode: summarize educ
{DEF}

{cmd:by} repeats Stata commands on subsets of the data, called "by-groups."
All observations of each by-group share the same value of the "by-variable"
(for example, {cmd:castecode} above).
The {cmd:by} command above first ran {cmd:summarize} for
all observations with {cmd:castecode == 1}, then
all those with {cmd:castecode == 2}, and so on.
Each of these was its own by-group.

{cmd:by} is followed by a list of by-variables.
This list can include more than one variable.
For example, suppose you want summary statistics by caste and by sex,
contrasting not just OBC and SC, but also OBC male and OBC female, SC male and SC female, and so on:

{TRYITCMD}
sort castecode sex{BR}
by castecode sex: summarize educ
{DEF}

You might be wondering why we needed to {cmd:sort} by {cmd:castecode sex} before using {cmd:by}.
{cmd:by} requires the dataset to be sorted by the by-variables.
You can do this before {cmd:by}, as we did above,
or at the same time by combining {cmd:by} and {cmd:sort} into one command,
named {cmd:bysort}:

{TRYITCMD}
bysort castecode sex: summarize educ
{DEF}

You'll get an error message if you try {cmd:by} without sorting by the by-variables,
either beforehand or through {cmd:bysort}. For example: */

by sex: summarize educ
/*
{TECH}
{COL}While {cmd:sort} only allows for sorting in ascending order, {helpb gsort}{CEND}
{COL}allows one to sort in both ascending and descending order.{CEND}
{COL}Use {cmd:gsort} as you use {cmd:sort}, but add a negative sign to any variable{CEND}
{COL}you wish to sort in descending order.{CEND}
{BLANK}
{COL}An example:{CEND}
{COL}{bf:{stata gsort surveyorid -surveydate1}}{CEND}
{COL}{bf:surveydate1} is now sorted in descending order within a given {bf:surveyorid}{CEND}
{COL}{bf:{stata browse surveyorid surveydate1}}{CEND}
{BOTTOM}

{marker n}{...}
There's a nuance about {cmd:by} that can be extremely confusing if you aren't careful:
the behavior of {BIGN...} and {LITTLEN...}.

We've seen that when you're {it:not} using {cmd:by},
{cmd:_N} is the number of observations, and
{cmd:_n} is the observation number.
For many commands, {cmd:_N} and {cmd:_n} continue to mean this when you use {cmd:by}.
Other commands don't allow {cmd:by} at all (aren't "byable").
For a third group of commands, {cmd:_N} and {cmd:_n} have the following meanings:

{cmd:_N}: the number of observations {it:in the by-group}{BR}
{cmd:_n}: the observation number {it:within the by-group}

Here's an example:

{TRYITCMD}
sort sex{BR}
generate datasetn = _n{BR}
by sex: list datasetn if _n == 1
{DEF}

On the second line ({cmd:generate}), {cmd:_n} is the observation number within the dataset as a whole,
because there is no {cmd:by}; this is an ordinary use of {cmd:_n}.
In contrast, on the third line, {cmd:_n} is the observation number within groups of {cmd:sex}.
Thus, {cmd:_n == 1} for the first observation such that {cmd:sex == 1} and the first observation such that {cmd:sex == 2}.
The result was that on the third line, {cmd:_n == 1} even when {cmd:datasetn == {VAR4}}.

Most commands for which you use {cmd:by} along with either {cmd:_N} or {cmd:_n} are of this third group,
including {cmd:list}, {cmd:generate}, and {cmd:drop}.

Let's take a look at the data,
inspecting in particular where it switches from one by-group of {cmd:sex} to another: */

by sex: generate byn = _n
browse sex datasetn byn

/* We've touched on three subsets of commands. There's a rare fourth one:
commands that are byable but interpret {cmd:_N} and {cmd:_n} unpredictably.
Because of this unpredictability, you shouldn't use {cmd:_N} and {cmd:_n} with these commands.

Here are examples of these four groups:

{marker group1}{it:Group 1:} Not byable

{cmd:display}

{marker group2}{it:Group 2:}
When using {cmd:by}, {cmd:_N} and {cmd:_n} are with respect to the dataset as a whole

{cmd:regress}

{marker group3}{it:Group 3:}
When using {cmd:by}, {cmd:_N} and {cmd:_n} are with respect to the by-group

{CMD}
generate{BR}
replace{BR}
drop{BR}
keep
{DEF}

{marker group4}{it:Group 4:}
When using {cmd:by}, the values of {cmd:_N} and {cmd:_n} are unpredictable

{cmd:egen}

{TECH}
{COL}How can you tell which of the four groups a command belongs to?{CEND}
{BLANK}
{COL}First of all, most commands for which you use {cmd:by} along with either {cmd:_N} or {cmd:_n}{CEND}
{COL}are {GROUP3...}. The most important of these are:{CEND}
{BLANK}
{COL}{cmd}generate{CEND}
{COL}replace{CEND}
{COL}drop{CEND}
{COL}keep{CEND}
{COL}list{CEND}
{COL}assert{txt}{CEND}
{BLANK}
{COL}See {view `"{GROUP3LIST-}"':here} for a fuller list of group 3 commands.{CEND}
{BLANK}
{COL}You can also use these guidelines to determine the group to which a command{CEND}
{COL}belongs:{CEND}
{BLANK}
{COL}1. Does the command allow the {cmd:if} qualifier?{CEND}
{COL}- If {bf:no}: the command is group 1; skip remaining questions.{CEND}
{COL}- If {bf:yes}: the command is group 2, 3, or 4.{CEND}
{BLANK}
{COL}2. Is the command a "built-in command"? To find out, use {helpb which}:{CEND}
{BLANK}
{COL}{bf:{stata which generate}}{CEND}
{COL}{bf:{stata which regress}}{CEND}
{BLANK}
{COL}{cmd:generate} is a built-in command, but {cmd:regress} isn't. Although written by{CEND}
{COL}StataCorp, {cmd:regress} is written in Stata, unlike {cmd:generate}. (Yes, many Stata{CEND}
{COL}commands are themselves written in Stata!){CEND}
{COL}- If {bf:yes} (built-in): the command is group 3; skip remaining question.{CEND}
{COL}- If {bf:no} (not built-in): the command is group 2 or group 4.{CEND}
{BLANK}
{COL}3. Is the command {cmd:egen} or user-written?{CEND}
{COL}- If {bf:no}: the command is group 2.{CEND}
{COL}- If {bf:yes}: the command is group 4.{CEND}
{BOTTOM} */

{BY_Q4}

{BY_Q5}

/* {hline}

You've now achieved the "stratified" part of stratified randomization.
Congratulations!

{TECH}
{COL}Two Stata FAQs describe how to use {cmd:by}, {cmd:_N}, and {cmd:_n} to detect duplicates:{CEND}
{BLANK}
{COL}{browse "http://www.stata.com/support/faqs/data-management/duplicate-observations/":How do I identify duplicate observations in my data?}{CEND}
{BLANK}
{COL}{browse "http://www.stata.com/support/faqs/data-management/number-of-distinct-observations/":How do I compute the number of distinct observations?}{CEND}
{BOTTOM}

{marker by_paren}{...}
We will now touch on a variant of {cmd:by}.
How can we use {cmd:by} to create a variable
that is the maximum age within the respondent's sex?
For example, if the oldest female is {cmd:103},
then this variable would equal {cmd:103} for all female respondents.

{TRYITCMD}
bysort sex (age): generate maxage = age[_N]
{DEF}

{cmd:generate} is a {GROUP3...} command,
so {cmd:_N} is the number of observations of the by-group of {cmd:sex}.
Thus, this command creates a variable named {cmd:maxage} that is the {cmd:age} of the last observation in the by-group.
You might be wondering
why this would necessarily be the {it:maximum} {cmd:age} in the by-group;
this is where {cmd:(age)} comes in.
{cmd:(age)}, after the by-variable {cmd:sex}, ensures that
after the dataset is sorted by the by-variable (i.e., {cmd:sex}), it is then sorted by {cmd:age}.
The dataset will then be sorted by {cmd:sex age}, which means that {cmd:age[_N]} will be both
the {cmd:age} of the last observation in the by-group of {cmd:sex}
and the maximum {cmd:age} in the by-group.
The by-groups are still of {cmd:sex} and not {cmd:sex age} {hline 2}
{cmd:age} is not a by-variable {hline 2}
but {cmd:(age)} has the effect that the by-groups of {cmd:sex} will be
internally sorted by {cmd:age}. */

tabulate sex maxage
by sex: summarize age

/* We can use this feature of {cmd:by} for duplicates cleaning.
Recall that {view `"{IF-}##loop"':before},
we determined the differences between {cmd:hhid "1802011"} duplicates as follows: */

sort hhid
foreach var of varlist _all {
	if `var'[{VAR1}] != `var'[{VAR2}] {
		display "The two observations of 1802011 differ on `var'."
	}
}

/* This worked, but there is a downside to this approach: it depends on two observation numbers,
{cmd:{VAR1}} and {cmd:{VAR2}},
so if the sort order is changed, {cmd:hhid} is modified,
an observation is added or dropped, and so on,
the code could very well stop working.
If there's any code we've used so far that's likely to result in a bug, this is it.

Instead, we can achieve the same result using {cmd:by}: */

foreach var of varlist _all {
	bysort hhid (`var'): generate unequal = `var'[1] != `var'[_N]
	list hhid `var' if unequal == 1
	drop unequal
}

/* Again, we're looping over all variables. For each variable, we create a variable named {cmd:unequal}
that is {cmd:1} if an observation differs from another {cmd:hhid} duplicate on the variable, and {cmd:0} otherwise.
We're executing {cmd:generate} (again, a {GROUP3...} command)
for each by-group of {cmd:hhid}, which is sorted by {cmd:`var'}.
If a value of {cmd:hhid} has no duplicates, then its by-group will have exactly {cmd:1} observation, so {cmd:_N == 1},
so {cmd:`var'[1] == `var'[_N]}, so {cmd:unequal = 0}. If instead a value of {cmd:hhid} does have duplicates (for example, {cmd:"1802011"}),
then {cmd:unequal} equals {cmd:1} if the first value of {cmd:`var'} (for numeric variables: the minimum; for strings: the first alphabetically) differs
from the last value of {cmd:`var'} (for numeric variables: the maximum; for strings: the last alphabetically), and {cmd:0} otherwise. */

{BY_Q6}

/* {hline}

{TOP}
{COL}{bf:More on by}{CEND}
{MLINE}
{COL}For more on by, see the terrific Stata Journal article {browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0004":{it:Speaking Stata: How}}{CEND}
{COL}{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0004":{it:to move step {bf:by} step}}. It's really worth the short read to learn more about{CEND}
{COL}this key command.{CEND}
{BOTTOM}

{FOOT}

{GOTOPS}{BY_PS}

{NEXT}{EGEN}
{PREV}{LITTLEN}
{START} */
