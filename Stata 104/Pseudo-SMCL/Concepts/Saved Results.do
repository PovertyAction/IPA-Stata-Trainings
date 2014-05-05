/* {HEAD}

{RESULTS!} */

{USE}

/* Stata commands can show a lot of information.
Among other summary statistics, {cmd:summarize} displays mean and standard deviation: */

summarize cycleownnum

/* What if we want to use this information?
Say we want to create a standardized version of {cmd:cycleownnum}:

{cmd:generate cyclenumstd = (cycleownnum - }{it:mean}{cmd:) /} {it:standard_deviation}

One option is to copy and paste the values shown by summarize:

{CMD}
generate cyclenumstd = (cycleownnum - {VAR5}) / {VAR6}
{DEF}

This isn't the best strategy.
First, if these numbers ever change, {cmd:cyclenumstd} will be incorrect.
Second, Stata calculates standard deviations to more than {VAR7} significant digits,
and we'd like to use that information in {cmd:generate} if it's accessible.
Third, someone looking at this command might be mystified
about where {cmd:{VAR5}} and {cmd:{VAR6}} came from:
you'd probably need to add an extra comment.

The alternative is utilizing {help return:saved results},
values that are saved in the classes  {cmd:r()}, {cmd:e()}, and rarely {cmd:s()}.
If you ever want to refer back to values that a previous command displayed,
it may be an option with saved results.
You can type {helpb return list} after a command
to display a list of {cmd:r()} saved results and
{helpb ereturn list} to display a list of {cmd:e()} saved results:

{TRYITCMD}
summarize cycleownnum{BR}
return list
{DEF}

Among other results, we see the mean and standard deviation of {cmd:cycleownnum}
saved as {cmd:r(mean)} and {cmd:r(sd)}.
{cmd:r(sd)} has a whopping {VAR8} significant digits.
You can use these as you would other values: */

display r(mean)
display r(sd)

/* {...}
{TRYITCMD}
summarize cycleownnum{BR}
generate cyclenumstd = (cycleownnum - r(mean)) / r(sd)
{DEF} */

drop cyclenumstd

/* Some commands save results that they never display.
For example, {cmd:summarize} saved the sum
of all values of {cmd:cycleownnum}
in {cmd:r(sum)}
even though it didn't show it: */

summarize cycleownnum
return list

/* We could have learned this by visiting the
{help summarize##saved_results:saved results section of the {bf:summarize} help file}.
It pays to glance at this section of help files, even for commands you know.

{marker r_and_e}{...}
{TECH}
{COL}{bf:r() vs. e()}{CEND}
{MLINE}
{COL}I mentioned three classes of saved results: {helpb r()}, {helpb e()}, and {helpb s()}. {cmd:s()} is rare{CEND}
{COL}enough that I won't discuss it here, but {cmd:r()} and {cmd:e()} saved results are both{CEND}
{COL}often available. To determine whether a command returns {cmd:r()} or {cmd:e()} saved{CEND}
{COL}results (it's rare that it's both), check the Saved Results section of its{CEND}
{COL}help file. Most estimation commands (for example, {helpb regress}, {helpb mean}, and {helpb pca}){CEND}
{COL}return {cmd:e()} saved results, and most other commands return {cmd:r()} saved results.{CEND}
{COL}The chief difference between {cmd:r()} and {cmd:e()} saved results is that you refer to{CEND}
{COL}an {cmd:r()} saved result as {cmd:r(}{it:whatever}{cmd:)}, while you refer to an {cmd:e()} saved result{CEND}
{COL}as {cmd:e(}{it:whatever}{cmd:)}. For example:{CEND}
{BLANK}
{CMD}
{COL}{bf:{stata summarize cycleownnum}}{CEND}
{COL}{bf:{stata return list}}{CEND}
{COL}{bf:{stata display r(mean)}}{CEND}
{COL}{bf:{stata regress cycleownnum sex}}{CEND}
{COL}{bf:{stata ereturn list}}{CEND}
{COL}{bf:{stata display e(df_r)}}{CEND}
{DEF}
{BLANK}
{COL}In this training, we'll use {cmd:r()} saved results exclusively.{CEND}
{BOTTOM}

{cmd:r()} saved results can disappear after the next command,
so you should utilize them immediately or store them in macros.
For example: */

summarize cycleownnum
return list
describe cycleownnum
return list
generate cyclenumstd = (cycleownnum - r(mean)) / r(sd)
tabulate cyclenumstd, missing

drop cyclenumstd

/* {cmd:summarize} returned the saved results {cmd:r(mean)} and {cmd:r(sd)},
but after {cmd:describe},
they were gone, replaced with a new set of saved results.
{cmd:generate} should have come immediately after {cmd:summarize}.
Or, {cmd:r(mean)} and {cmd:r(sd)} should have been stored in locals: */

summarize cycleownnum
return list
local mean = r(mean)
local sd   = r(sd)
describe cycleownnum
return list
generate cyclenumstd = (cycleownnum - `mean') / `sd'
tabulate cyclenumstd, missing

/* An important command that returns an {cmd:r()} saved result is {helpb ds}.
Its behavior is similar to {helpb describe:{ul:d}escribe, {ul:s}imple}, which {cmd:describe}s the dataset
insomuch as it lists its variable names: */

describe, simple

/* {cmd:ds} similarly displays a list of variables, but of a subset.
For example, {cmd:ds, has(type numeric)} lists
just the subset of variables with numeric type:

{TRYITCMD}
ds, has(type numeric)
{DEF}

If you're trying to get a subset of variables that satisfy certain criteria,
{cmd:ds} will usually be able to it: */

* {cmd:* Variables of type long}
ds, has(type long)
* {cmd:* Variables with the value label yes1no0}
ds, has(vallab yes1no0)
* {cmd:* Variables with variable labels that contain the string "victim"}
ds, has(varlab *victim*)

/* {cmd:ds} returns the saved result {cmd:r(varlist)},
the list of variables that meet the criteria: */

ds, has(type numeric)
return list

/* Unlike {cmd:r(mean)} and {cmd:r(sd)} of {cmd:summarize},
{cmd:r(varlist)} is a string value.
This means it should be enclosed by single quotes ({cmd:`} and {cmd:'}):

{TRYITCMD}
ds, has(type numeric){BR}
display "`r(varlist)'"
{DEF}

What happens if you don't use these quotes? */

ds, has(type numeric)
display r(varlist)

/* {cmd:r(varlist)} is cut off at variable {cmd:{VAR9}}.
Without the single quotes,
a string saved result is truncated around 244 characters.
Variable lists in particular are frequently longer than this,
and Stata recommends that you always enclose string saved results by single quotes.

{bf:Note:} Beginning with Stata 13, this restriction has been lifted, so
that there is no limit on the character length of string saved results (absent
single quotes), or strings more broadly. 
If you are using Stata 13, you should see no difference between the {cmd:r(varlist)} 
outputed with and without single quotes. 
Note in Stata 13 there is no change to the relationship between
numeric saved results and single quotes. 

We have seen that numeric saved results don't need these single quotes.
However, they're always allowed,
and they don't do any harm unless you need a {it:lot} of precision
(for example, if you're doing iterative calculations).
Here's an example: */

summarize cycleownnum
display r(mean)
display `r(mean)'

/* {cmd:r(mean)} and {cmd:`r(mean)'} are treated the same.

Actually,
the single quotes are sometimes required even for numeric saved results.
Let's say we wanted to sum all the integers
between the minimum and maximum values of {cmd:cycleownnum}.
These two values are accessible through {cmd:summarize} as the saved results {cmd:r(min)} and {cmd:r(max)}: */

summarize cycleownnum
display r(min)
display r(max)

* Let's try to use {cmd:r(min)} and {cmd:r(max)} without single quotes in a for-loop:

local sum 0
summarize cycleownnum
foreach i of numlist r(min)/r(max) {
	local sum = `sum' + `i'
}
display "The sum is: `sum'"

/* Unlike {cmd:display} and {cmd:generate},
both of which we have seen handle numeric saved results not enclosed by single quotes,
{cmd:foreach} requires them: */

local sum 0
summarize cycleownnum
foreach i of numlist `r(min)'/`r(max)' {
	local sum = `sum' + `i'
}
display "The sum is: `sum'"

/* If you have connected the single quotes enclosing saved results to those enclosing locals,
you're on the right track:
{cmd:`r(varlist)'}, {cmd:`r(min)'}, and {cmd:`r(max)'} are local macros
and behave just like them.
In the loop above, the values of {cmd:`r(min)'} and {cmd:`r(max)'}
are substituted ("copied and pasted") in the command before it is executed.
{cmd:foreach} never knows that it's processing saved results:
{cmd:`r(min)'} and {cmd:`r(max)'} are expanded, and only then is {cmd:foreach} executed.

{marker enclosing_saved_results}{...}
{TECH}
{COL}When do numeric saved results need single quotes, and when do they not? If a{CEND}
{COL}command understands {help expressions}, as {cmd:display} and and {cmd:generate} do, they're not{CEND}
{COL}needed. However, commands that take only evaluated values and not{CEND}
{COL}expressions, such as {cmd:foreach}, require the single quotes. {cmd:foreach} can't{CEND}
{COL}handle any expressions, even the simplest:{CEND}
{BLANK}
{CMD}
{COL}foreach i of numlist (1+1)/(2+2) {c -(}{CEND}
{COL}    display `i'{CEND}
{COL}{c )-}{CEND}
{DEF}
{BLANK}
{COL}{stata `"run "Do/Text boxes.do" "saved results" 1"':Click here to execute.}{CEND}
{BLANK}
{COL}Rather, {cmd:foreach} needs all expressions to be evaluated beforehand:{CEND}
{BLANK}
{CMD}
{COL}local start = 1 + 1{CEND}
{COL}local end   = 2 + 2{CEND}
{COL}foreach i of numlist `start'/`end' {c -(}{CEND}
{COL}    display `i'{CEND}
{COL}{c )-}{CEND}
{DEF}
{BLANK}
{COL}{stata `"run "Do/Text boxes.do" "saved results" 2"':Click here to execute.}{CEND}
{BLANK}
{COL}Not enclosed by single quotes, a numeric saved result counts as part of an{CEND}
{COL}expression. Enclosed by them, it's treated like a macro and expanded{CEND}
{COL}immediately.{CEND}
{BLANK}
{COL}I should also say that the distinction between numeric and string saved{CEND}
{COL}results is actually one between scalar and macro saved results. For more,{CEND}
{COL}see the technical note in {bf:{mansection U 18.8Accessingresultscalculatedbyotherprograms:[U] 18.8 Accessing results calculated by other}}{CEND}
{COL}{bf:{mansection U 18.8Accessingresultscalculatedbyotherprograms:programs}}.{CEND}
{BOTTOM}

Below is a loop (introduced in {bf:Stata 103}) that lists the variables
on which two observations of {cmd:hhid "1802011"} differ: */

foreach var of varlist _all {
	if `var'[{VAR1}] != `var'[{VAR2}] {
		display "The two observations of 1802011 differ on `var'."
	}
}

/* Now, any difference between the two observations is troubling.
However, a difference in an open-ended string variable is more understandable
than a difference in a numeric variable like {cmd:sex} or {cmd:age}.
How could we modify the loop to list only the {it:numeric} variables
on which the observations differ? */

ds, has(type numeric)
foreach var in `r(varlist)' {
	if `var'[{VAR1}] != `var'[{VAR2}] {
		display "The two observations of 1802011 differ on numeric variable `var'."
	}
}

{RESULTS_Q4}

/* {hline}

You are likely already familiar with {helpb duplicates list} and {helpb duplicates drop}.
Here's another subcommand of {cmd:duplicates} that utilizes saved results:

{TRYITCMD}
duplicates tag hhid, generate(iddup){BR}
list hhid if iddup > 0{BR}
tabulate iddup
{DEF}

{helpb duplicates tag} generates a variable (here {cmd:iddup})
that indicates the number of duplicates on a certain variable list (here just {cmd:hhid})
for each observation.
In this case, observations with a unique value of {cmd:hhid} will have {cmd:iddup == 0},
while observations with a duplicate value will have {cmd:iddup} equal
to the number of extra observations with that value.
For example, there are {cmd:2} values of {cmd:hhid "1802011"},
that is, {cmd:1} extra,
so {cmd:iddup == 1} when {cmd:hhid == "1802011"}: */

list hhid iddup if hhid == "1802011"

/* Since an observation has a duplicate value of {cmd:hhid}
if and only if {cmd:iddup > 0},
if we can find out the number of observations with {cmd:iddup > 0},
we can determine the number of {cmd:hhid} duplicates:

{helpb count} displays the number of observations that satisfy a condition, and
stores it as the saved result {cmd:r(N)}:

{TRYITCMD}
count if iddup > 0{BR}
display r(N)
{DEF} */

drop iddup

/* Before another exercise, I'll touch briefly on {helpb quietly}.
When added before a command, {cmd:quietly} suppresses output from the command.
For example:

{TRYITCMD}
display "Hello world!"{BR}
quietly display "Hello world!"
{DEF}

On the other hand, {helpb noisily} counteracts the effect of {cmd:quietly}:

{TRYITCMD}
quietly noisily display "Hello world!"
{DEF}

By itself, {cmd:noisily} has no effect, since by default output is not suppressed:

{TRYITCMD}
noisily display "Hello world!"
{DEF}

{hline}

{bf:Problem Set Question 5 (partial)}

{hline} */

{USE}

{RESULTS_Q5A}

{RESULTS_Q5B}

/* {hline}

{TECH}
{COL}{bf:c-class values}{CEND}
{MLINE}
{COL}In addition to r-, e-, and s-class saved results, which we have already{CEND}
{COL}discussed, there are also {help creturn:c-class values}. These store system parameters and{CEND}
{COL}settings, such as the current date in {cmd:c(current_date)} and the {view `"{LOOPS-}##tracing"':{bf:set trace}}{CEND}
{COL}setting in {cmd:c(trace)}, as well as constants like pi, in {cmd:c(pi)}:{CEND}
{BLANK}
{BF}
{COL}{stata display c(current_date)}{CEND}
{COL}{stata display c(trace)}{CEND}
{COL}{stata display c(pi)}{CEND}
{DEF}
{BLANK}
{COL}It's worth taking a look at the {help creturn:full list} of c-class values.{CEND}
{BOTTOM}

{FOOT}

{GOTOPS}{RESULTS_PS}

{NEXT}{RECODING}
{PREV}{DUMMIES}
{START} */
