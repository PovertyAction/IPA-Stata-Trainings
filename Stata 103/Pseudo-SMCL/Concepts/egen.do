/* {HEAD}

{EGEN!} */

{USE}

/* It can take a moment to figure out how to use {BY...}, {BIGN...}, and {LITTLEN...}
to create variables whose values depend on multiple observations.

However, in many cases there's a shortcut available.
{helpb egen} ("{ul:e}xtensions to {cmd:{ul:gen}erate}") creates variables
whose values are calculated from multiple observations in the dataset.
For example, to create a variable that is the maximum value of {cmd:age},
you could code using {cmd:_N}: */

sort age
generate maxage = age[_N]

drop maxage

/* The alternative with {cmd:egen} is:

{TRYITCMD}
egen maxage = max(age)
{DEF} */

drop maxage

/* With {cmd:generate},
unless {cmd:_n} or one of a small number of functions
(for example, {cmd:sum()}) is used,
the calculation of a new variable's values occurs within the observation.
That is, an observation's value of the new variable depends
only on other values {it:within} the observation.

Not so with {cmd:egen}.
One of {cmd:egen}'s jobs is to make calculations {it:across} observations.
Above, {cmd:egen max(age)} involves a calculation
across all the observations of {cmd:age}.
An observation's value of {cmd:maxage} depends not just
on other values within the observation,
but also on other observations
(specifically, the value of {cmd:age} in other observations).

{cmd:egen} is especially useful for by-groups,
for example, calculating the minimum value of {cmd:age by sex}.
Without {cmd:egen}: */

bysort sex (age): generate minage = age[1]

drop minage

/* This line of code requires some thought.
You have to use {cmd:(age)} so the data is sorted correctly,
and also use {cmd:age[1]} knowing that {cmd:generate} is a {GROUP3...} command.
Alternatively:

{TRYITCMD}
bysort sex: egen minage = min(age)
{DEF} */

drop minage

/* Above, {cmd:min()} and {cmd:max()} are {cmd:egen} functions.
This means that you can't use them outside {cmd:egen}.
Remember, one of {cmd:egen}'s chief roles is to create variables
that depend on multiple observations.
Using these functions with {cmd:generate} will result in an error.
For example: */

bysort sex: generate minage = min(age)

/* In Stata, {cmd:min()} comes in two forms.
In one, it is a normal Stata function that requires multiple arguments;
it can be used with {cmd:generate}.
In the other, it is an {cmd:egen} function requiring just one argument.
We tried to use it as an {cmd:egen} function outside of {cmd:egen},
so we got an error.

Let's see another example, with a different {cmd:egen} function. 
Say we want to calculate the number of literate people whom
each surveyor interviewed. */ 

bysort surveyorid: egen literate = total(literateyn)

/* Here we use the {cmd:total} function, which outputs the sum of a given variable,
here {bf:literateyn}, which takes the value 1 if the person is literate and 0 otherwise. 
Using {cmd:bysort} calculates different sums for each value of {bf:surveyorid}. Let's browse
the relevant variables:  */ 

browse surveyorid literateyn literate

/* Values of {bf:literate} reflect the total number of literate people per {bf:surveyorid}.
Note the difficulty in calculating the average of {bf:literate} per {bf:surveyorid}. If
we simply execute {cmd:summarize literate}, our answer will be biased by the number of 
observations per {bf:surveyorid}. How might we resolve this issue? 

There are many more {cmd:egen} functions,
and I encourage you to review the {help egen:{bf:egen} help file} when you start cleaning your data,
and periodically throughout the process. 
You'll likely discover new ways to resolve coding problems you encounter. 

Also note that not all {cmd:egen} functions allow the {BY...} prefix. See the {bf:help file}
for which functions can be combined with {cmd:by}. 

User-written {cmd:egen} functions are also available on {help SSC}: */

ssc install egenmore

/* {FOOT}

{GOTOPS}{EGEN_PS}

{PREV}{BY}
{START} */
