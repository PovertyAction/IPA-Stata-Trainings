/* {HEAD}

{OTHERCHECKS!}

{view `"{OTHERCHECKS-}##codes"':1. Variable Codes}{BR}
{view `"{OTHERCHECKS-}##missing"':2. Missing Data}{BR}
{view `"{OTHERCHECKS-}##other"':3. Other Checks}


{hline}{marker codes}

{bf:1. Variable Codes}

{hline} */

{USE}

/* It is important to check that variables are coded as you expect. For
example, {cmd:cycleownyn} can only be {cmd:Yes} or {cmd:No}.

{marker levelsof}{...}
{helpb levelsof} displays
a list of the unique values of a variable,
saving the list in
{view `"{RESULTS-}"':{bf:r(levels)}}:

{TRYITCMD}
levelsof cycleownyn{BR}
assert "`r(levels)'" == "1 2"
{DEF}

{marker inrange}{...}
Alternatively, you can use {helpb inrange()}.
{cmd:inrange(}{it:z}{cmd:,} {it:a}{cmd:,} {it:b}{cmd:) == 1}
if {it:a} {ul:<} {it:z} {ul:<} {it:b},
and {cmd:0} otherwise:

{TRYITCMD}
assert inrange(cycleownyn, 1, 2)
{DEF} */

{OTHERCHECKS_Q1}

{OTHERCHECKS_Q2}

/* {hline}{marker missing}

{bf:2. Missing Data}

{hline} */

{USE}

/* Another important set of checks has to do with missing values. For example,
required questions should have no missing values. In this dataset, {cmd:sex} should
have no missing values. Nor should {cmd:scrutinizedyn}, or {cmd:educ}. */

foreach var of varlist sex scrutinizedyn educ {
	display "Checking `var' for missing values..."
	list hhid `var' if missing(`var')
}

/* {cmd:missing(}{it:varlist}{cmd:) == 1} if any of {it:varlist} are missing
(system missing or {view `"{RECODING-}##extended_missing"':extended missing})
in any observation, and {cmd:0} otherwise.

Notice how I only wrote {cmd:if missing(`var')}, not {cmd:if missing(`var') == 1}.
If a logical expression has no logical operator, {cmd:!= 0} is assumed.
So {cmd:if missing(`var')} is the same as {cmd:if missing(`var') != 0}, and since
{cmd:missing(`var')} is either {cmd:0} or {cmd:1},
this is the same as {cmd:if missing(`var') == 1}.

The opposite of this shortcut is {cmd:!} by itself (pronounced "not"). For example: */

foreach var of varlist sex scrutinizedyn educ {
	display "Checking `var' for missing values..."
	assert !missing(`var')
}

/* Here, {cmd:!missing(`var')} is short for {cmd:missing(`var') == 0}.

An alternative to this sort of loop is {helpb codebook}, which displays the frequency of missing values:

{TRYITCMD}
codebook sex scrutinizedyn educ
{DEF}

You might still prefer the loop: {cmd:codebook} gives a little {it:too} much information. */

{OTHERCHECKS_Q3}

/* {hline}{NEW48}

Again, instead of a loop, {cmd:codebook} could be useful:

{TRYITCMD}
codebook, problems
{DEF}

If you have Stata 11 or higher, you can use {helpb misstable}:

{TRYITCMD}
misstable summarize
{DEF}

If you have Stata 10 or lower, you can use the {help SSC} program {cmd:mdesc}.
You may want this program even if you have Stata 11 or higher. */

/* {...}
{TRYITCMD}
ssc install mdesc
{DEF}

{* I'm putting this text box here because this is the first time -ssc install-}{...}
{* has been used since -net search- was used in the variable properties module.}{...}
{TECH}
{COL}When should you use {helpb ssc install} to install user-written programs, and when{CEND}
{COL}should you use {helpb net search}? (You can always use {cmd:net search} instead of{CEND}
{COL}{helpb findit}.) While {cmd:ssc install} downloads the version of a program stored on the{CEND}
{COL}Boston College Statistical Software Components (SSC) archive, {cmd:net search}{CEND}
{COL}often lists other versions. That said, the SSC version is often the most{CEND}
{COL}up-to-date. However, not all user-written programs are available through{CEND}
{COL}SSC. For example, the user-written program {bf:renvars} isn't on SSC.{CEND}
{COL}In such cases, use {cmd:net search} to find the most recent version.{CEND}
{BOTTOM}

{hline}{marker other}

{bf:3. Other Checks}

{hline}

There are many data checks you can implement that we haven't discussed.
It's highly recommended that you run data checks as soon as possible after the data is collected.
If the data is received in batches, run checks on each batch.

A final note. If you're regularly receiving data from the field, then
as data collection is ongoing, you'll be able pick up on unexpected trends in the data and think of new data checks.
To make sure you discover these trends, commit to spending a portion of each day or each week
just inspecting your data and dreaming up new data checks.
Tabulate frequencies, graph distributions, calculate means, and just eyeball variables in the Stata Data Browser
and make sure their values look right.
It's important to complete the normal data checks,
but you must also look out for issues specific to your data and project.

{FOOT}

{GOTOPS}{OTHERCHECKS_PS}

{NEXT}{STRINGS}
{PREV}{LOGICCHECKS}
{START} */
