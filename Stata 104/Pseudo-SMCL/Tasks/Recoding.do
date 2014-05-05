/* {HEAD}

{RECODING!} */

{USE}

/* Recoding entails
changing variables' values in order to
standardize codes across variables
or otherwise make variables easier to understand or use.
After working with variable properties,
recoding is one of the first steps in the data cleaning process,
often coming before even unique ID checks.
Clarifying and standardizing variables facilitate
the many uses of variables,
so this data cleaning task
should come before more advanced data work.

Suppose you'd like to run a series of regressions
involving all variables with a binary yes/no response.
Before this, you need to make sure that all yes/no response variables
are coded in the same way.
In this dataset, there are two yes/no value labels: */

label dir
label list yesno yes1no0

ds, has(vallabel yesno)
ds, has(vallabel yes1no0)

{RECODING_Q1}

* {hline}{NEW48}

{USE}

/* An alternative is {helpb recode}.
{cmd:recode} recodes a variable list according to one or more rules.
For example, the following command recodes variable {cmd:sex}
according to the rule {cmd:(2=0)},
changing all values of {cmd:2} to {cmd:0}:

{TRYITCMD}
recode sex (2=0)
{DEF}

Now {cmd:sex} is a dummy variable for whether the respondent is male.
Here's a more advanced example, demonstrating an alternate solution to Exercise 1: */

{BLOCK}ds, has(vallabel yes1no0)
{BLOCK}* "varl" for "variable list"
{BLOCK}local varl `r(varlist)'
{BLOCK}recode `varl' (0=2)
{BLOCK}label values `varl' yesno

/* Above, the rule
was {cmd:(0=2)},
which specified that {cmd:0} be recoded as {cmd:2}.

Here's a third example of {cmd:recode}: */

describe occupation
* {cmd:* occup is the value label of occupation.}
label list occup

/* {...}
{TRYITCMD}
recode occupation (1=2) (2=1)
{DEF} */

{RECODING_Q2}

/* {hline}

Note, however, that the {it:value label} of {cmd:occupation} did not change: */

label list occup

{RECODING_Q3}

/* {hline}

It is important to have special codes for missing values,
including "don't know" and "refusal."
This helps you understand {it:why} a variable has missing values,
allowing you to complete checks that you wouldn't be able to otherwise.
For this dataset's numeric variables, {cmd:97} is "refusal", and {cmd:99} is "don't know."

However, there is a downside to such codes.
For example, the mean of {cmd:own2wheelertheft} should be between {cmd:1} and {cmd:2}: */

describe own2wheelertheft
* {cmd:* yesno is the value label of own2wheelertheft.}
label list yesno

summarize own2wheelertheft

/* What's going on? The {cmd:Don't Know} values are skewing the mean
so that the mean is greater than {cmd:2}: */

tabulate own2wheelertheft

* What's to be done? Here's one option:

summarize own2wheelertheft if own2wheelertheft != 97 & own2wheelertheft != 99

/* That works, but imagine adding that {cmd:if} qualifier
to every statistical command you run: it's a pain.

{marker extended_missing}{...}
Special codes that are nonmissing provide information but are inconvenient,
while converting all codes to missing ({cmd:.}) provides less information but is easier.
Fortunately, there's a third option: {help missing:extended missing values}.
You already know the missing value {cmd:.} (called the "system missing value" or {cmd:sysmiss}),
but there are also missing values {cmd:.a}, {cmd:.b}, {cmd:.c}, all the way to {cmd:.z},
called "extended missing values."
These values are each distinct:

all nonmissing values < {cmd:.} < {cmd:.a} < {cmd:.b} < {cmd:.c} < ... < {cmd:.z}

More importantly, extended missing values {hline 2} unlike {cmd:sysmiss} {hline 2} can be value labeled.
They offer the best of both worlds.
With their value labels, they provide information about their origin ("don't know," "refusal," and so on).
At the same time, they're convenient to use and don't figure into most statistical calculations.

{TRYITCMD}
recode own2wheelertheft (97=.r) (99=.d){BR}
label define yesno .d "Don't know" .r "Refusal", add{BR}
label define yesno 97 "" 99 "", modify{BR}
{DEF} */

label list yesno

summarize own2wheelertheft

* We can do this for all variables labeled with the value label {cmd:yesno}:

ds, has(vallabel yesno)
recode `r(varlist)' (97=.r) (99=.d)

/* Ultimately, we'd like to make these changes to all value labels
and value labeled variables.

{FOOT}

{GOTOPS}{RECODING_PS}

{NEXT}{LOGICCHECKS}
{PREV}{RESULTS}
{START} */
