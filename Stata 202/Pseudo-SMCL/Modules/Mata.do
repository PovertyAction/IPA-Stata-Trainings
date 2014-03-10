/* {HEAD}

{MACROS!}

In this module, I'll discuss advanced macro manipulation.
I'll touch on these topics:

{view `"{MACROS-}##extended_fcn"':1. Extended macro functions}{BR}
{view `"{MACROS-}##expressions"':2. Macros and expressions}{BR}
{view `"{MACROS-}##gettoken"':3. {bf:gettoken}}{BR}
{view `"{MACROS-}##arguments"':4. Passing arguments to do-files}

{hline}{marker extended_fcn}

{bf:1. Extended macro functions}

{hline}

You already know multiple ways to define macros.

You can assign a string to a macro,
using enclosing {help quotes##double:double quotes} or not: */

* {cmd:* Enclosing "Hello world" in double quotes}
local string "Hello world!"
display "`string'"

* {cmd:* No enclosing quotes}
local string Hello world!
display "`string'"

* You can assign the evaluation of an expression to a macro
* using the {cmd:=} assignment operator:

local string = 1 + 1
display "`string'"

local string = "ABC" + "DEF"
display "`string'"

/* Another way to define macros is {help extended_fcn:extended macro functions}.
These have the following form:

{{cmd:local} | {cmd:global}} {it:macname} {cmd::} {it:extended_function}

After {cmd:local} or {cmd:global} and the macro's name ({it:macname}),
you have a colon ({cmd::}) followed by the function ({it:extended_function}).

First, let's load the auto dataset: */

sysuse auto, clear

/* Here's an example of an extended macro function:

{TRYITCMD}
local varlab : variable label make{BR}
display "`varlab'"
{DEF}

Here, {cmd:variable label} {it:varname} is an extended macro function
that assigns the variable label of {it:varname} to a macro.
Here, the variable label of {cmd:make} has been assigned to {cmd:`varlab'}.

There are many extended macro functions.
We will touch on a few, but the full list is {help extended_fcn:here}.

One category of extended macros functions extracts variable attributes: */

local varlab : variable label foreign
local vallab : value label foreign
local type   : type foreign
local format : format foreign

display "`varlab'"
display "`vallab'"
display "`type'"
display "`format'"

/* Another category of extended macro functions manipulates lists.

For example, say we have two lists:
{cmd:`nolabvars'}, the list of variables without a value label,
and {cmd:`strvars'}, the list of variables with a string storage type. */

use {DATA_POLICE1}, clear

ds, not(vallab)
local nolabvars `r(varlist)'

ds, has(type string)
local strvars `r(varlist)'

/* A variable is in {cmd:`nolabvars'}
if either it is numeric but without a value label
or it is string (so cannot have a value label).
Using the two lists {cmd:`nolabvars'} and {cmd:`strvars'},
how can we create a list of variables in the former category,
that is, variables that are numeric but without a value label?

Here's one option, with a loop: */

{BLOCK}ds, not(vallab)
{BLOCK}local nolabvars `r(varlist)'
{BLOCK}
{BLOCK}ds, has(type string)
{BLOCK}local strvars `r(varlist)'
{BLOCK}
{BLOCK}foreach nolabvar of local nolabvars {
	{BLOCK}local isnumvar 1
{BLOCK}
	{BLOCK}foreach strvar of local strvars {
		{BLOCK}if "`nolabvar'" == "`strvar'" {
			{BLOCK}local isnumvar 0
		{BLOCK}}
	{BLOCK}}
{BLOCK}
	{BLOCK}if `isnumvar' {
		{BLOCK}local numnolabvars `numnolabvars' `nolabvar'
	{BLOCK}}
{BLOCK}}
{BLOCK}
{BLOCK}display "`numnolabvars'"

/* The {helpb macrolists:list} extended macro function makes
this process easier.

{cmd:local} {it:macname} {cmd:: list x in y}

assigns {cmd:1} to {it:macname}
if all the elements of {cmd:`x'} are in {cmd:`y'}
(if the elements of {cmd:`x'} are a subset of the elements of {cmd:`y'})
and {cmd:0} otherwise. For example: */

local x a
local y a b c
local xiny : list x in y
* {cmd:* Can you guess what `xiny' will be?}
display "`xiny'"

/* Both {cmd:`x'} and {cmd:`y'} are lists,
and {cmd:list in} returns a result based on the relation between them.

We can use {cmd:list in} to make the loop above more efficient: */

{BLOCK}ds, not(vallab)
{BLOCK}local nolabvars `r(varlist)'
{BLOCK}
{BLOCK}ds, has(type string)
{BLOCK}local strvars `r(varlist)'
{BLOCK}
{BLOCK}foreach nolabvar of local nolabvars {
	{BLOCK}local instrvars : list nolabvar in strvars
	{BLOCK}if !`instrvars' {
		{BLOCK}local numnolabvars `numnolabvars' `nolabvar'
	{BLOCK}}
{BLOCK}}
{BLOCK}
{BLOCK}display "`numnolabvars'"

/* Notice that I wrote {cmd:list nolabvar in strvars},
not {cmd:list `nolabvar' in `strvars'}:
the local macro names are not enclosed in single quotes, as they usually are.
This is because we are referring to the locals themselves, not their values;
we do not want to expand the locals, substituting them for their values.
Extended macro functions usually (though not always)
look like this, expecting local macro names without the single quotes.

{cmd:list} can also return the union of two lists, that is,
the list of elements found in one or both of two lists: */

local x a b c
local y 1 2 3
local xory : list x | y
* {cmd:* Can you guess what `xory' will be?}
display "`xory'"

local x a b c
local y c d e
local xory : list x | y
* {cmd:* Can you guess what `xory' will be?}
display "`xory'"
display "`x' `y'"

* {cmd:list} can return the intersection of two lists,
* the list of elements found in both lists:

local x a b c
local y c d e
local xandy : list x & y
* {cmd:* Can you guess what `xandy' will be?}
display "`xandy'"

* {cmd:list} can give us the elements in one list but not the other:

local x a b c
local y c d e
local xnoty : list x - y
* {cmd:* Can you guess what `xnoty' will be?}
display "`xnoty'"

* We can use this last feature
* for even more efficiency gains from the loop above:

local numnolabvars : list nolabvars - strvars
display "`numnolabvars'"

/* See {help macrolists:here}
for more on the extended macro function {cmd:list} and its many features.

So far in your Stata career,
you may have thought of locals exclusively as single values.
However, in some data scenarios,
it is helpful to conceptualize them instead as {it:lists} of values,
with elements separated by spaces.

Stata has many objects, including variables, macros,
{help scalar:scalars}, and {help matrix:matrices},
but it does not have a specific list object:
there are no arrays other than matrices, which are strictly numeric.
(In contrast, {help Mata} has both numeric and string vectors and matrices,
as well as its own {help mf_asarray:array} object.)
It is often possible to fill this gap with locals,
which act like lists with the {cmd:list} and other extended macro functions.

I would also be remiss to discuss extended macro functions without
mentioning one of the most popular functions, {helpb extended_fcn:dir}.
{cmd:dir} returns a list of files or directories.
For example, the following returns the list of files in
the working directory: */

local files : dir . files *
macro list _files

/* {hline}{marker expressions}

{bf:2. Macros and expressions}

{hline}

{TOP}
{COL}{bf:Note on Stata 13}{CEND}
{MLINE}
{COL}The following content was written for Stata 12 and below. Stata 13's new{CEND}
{COL}long string capabilities have removed the limits discussed below, and not{CEND}
{COL}all examples will work as intended in Stata 13, even if you set the {helpb version}.{CEND}
{BLANK}
{COL}However, even if you have Stata 13, it is important that you understand the{CEND}
{COL}constraints outlined below: after all, Stata 13's release was just three{CEND}
{COL}months ago. Many of our colleagues will continue to use earlier versions for{CEND}
{COL}some time, and you may need to write code that works on their computers. You{CEND}
{COL}may also sometimes be required to debug code written for earlier versions.{CEND}
{BOTTOM} */

use {DATA_POLICE2}, clear

describe

/* We have opened a dataset with variables
whose names refer to the questionnaire section number and the question number.
Suppose that now that the dataset is ready for analysis,
we want to give them more descriptive names.

We could do so manually: */

rename s1_q1 sex
rename s1_q2 occupation
rename s1_q2_other occupationother
rename s1_q3 castename
rename s1_q4 castecode
rename s1_q5 age
rename s1_q6 education

/* This isn't too bad for this dataset, which has few variables,
but it's repetitive,
and it would be inefficient for larger datasets.

An alternative is to loop over
{browse "http://www.stata.com/support/faqs/programming/looping-over-parallel-lists/":parallel lists}.
{helpb foreach} and {helpb forvalues} both loop over a single list,
but it is possible to use them to loop over two or more lists simultaneously,
first using the first elements of all the lists, then the second elements,
and so on. */

use {DATA_POLICE2}, clear

{BLOCK}#delimit ;
{BLOCK}* The first list to loop over;
{BLOCK}local vars
	{BLOCK}s1_q1
	{BLOCK}s1_q2
	{BLOCK}s1_q2_other
	{BLOCK}s1_q3
	{BLOCK}s1_q4
	{BLOCK}s1_q5
	{BLOCK}s1_q6
{BLOCK};
{BLOCK}* The second list to loop over;
{BLOCK}local newvars
	{BLOCK}sex
	{BLOCK}occupation
	{BLOCK}occupationother
	{BLOCK}castename
	{BLOCK}castecode
	{BLOCK}age
	{BLOCK}education
{BLOCK};
{BLOCK}#delimit cr
{BLOCK}
{BLOCK}local nvars = wordcount("`vars'")
{BLOCK}forvalues i = 1/`nvars' {
	{BLOCK}* `var' is the `i'th element of `vars'.
	{BLOCK}local var    = word("`vars'",    `i')
	{BLOCK}* `newvar' is the `i'th element of `newvars'.
	{BLOCK}local newvar = word("`newvars'", `i')
	{BLOCK}rename `var' `newvar'
{BLOCK}}

* Let's consider a similar case.

use {DATA_POLICE3}, clear

describe

/* These variable names came directly from the CAI program,
but now in Stata we want to make them all lowercase.

First of all, how many variables are there?
We used that number in the loop above,
and to try something similar, we will have to be able to determine it. */

ds
local vars `r(varlist)'
display "`vars'"
display wordcount("`vars'")

* Wait a second.
* This variable list has way more variables than {cmd:{VAR_BADK}}:

describe, short

* What does {cmd:wordcount()} think the last word (variable) is?

display word("`vars'", wordcount("`vars'"))

* That isn't even a variable name! An actual variable name has been truncated:

describe {VAR_LASTVAR}*, fullnames

/* What's happening?
You may know that string variables are limited to 244 characters.
Similarly, Stata's expression parser is limited
to handling strings of 245 characters.
Strings longer than 245 characters are automatically truncated {hline 2}
shortened {hline 2} to 245 characters.

For example, let's repeat {cmd:`vars'} twice: */

local vars2 = "`vars'" + "`vars'"
* {cmd:* `vars2' has been truncated, even before the end of the first `vars'.}
display "`vars2'"
* {cmd:* Therefore, length("`vars2'") equals the position of truncation, 245.}
display length("`vars2'")

/* {help exp:Expressions} are what appear after the {cmd:=} assignment operator,
for example, after {cmd:local} above.
Some commands, such as {cmd:generate} and {cmd:replace},
always take an expression,
which you can see from the {cmd:=} operator that they require.
Expressions also follow the {help if:{bf:if} qualifier}.

Wherever you have expressions, you have the possibility of string truncation:
string expressions are always truncated.

In contrast to commands,
{help functions} are strictly the domain of expressions.
Whenever you see a function, such as {cmd:wordcount()} or {cmd:length()} above,
you know it is part of an expression.
You can tell a function by its signature parentheses:
while {helpb logit} is a command, {helpb logit()} is a function.

Given this length restriction on expressions,
the evaluation of the expression {cmd:"`vars'" + "`vars'"} can be
at most 245 characters.
{cmd:"`vars'"} in {cmd:wordcount("`vars'")} is truncated,
which explains the incorrect word count.

There is even a difference between: */

local allvars `vars'
display "`allvars'"

* and:

local allvars = "`vars'"
display "`allvars'"

/* While the first {cmd:local} did not involve an expression {hline 2}
it assigned a string to {cmd:`allvars'} that required no evaluation {hline 2}
the second {cmd:local} did.
We can see this immediately from the telltale {cmd:=} assignment operator.

We have identified a problem, but what is the solution?

In many cases, there is an extended macro function for what you need.
Here is one for word counting, an alternative to {cmd:wordcount()}: */

local wc = wordcount("`vars'")
display `wc'

local wc : word count `vars'
display `wc'

* Here is another for extracting individual words:

local var{VAR_BADK} = word("`vars'", {VAR_BADK})
display "`var{VAR_BADK}'"

local var{VAR_BADK} : word {VAR_BADK} of `vars'
display "`var{VAR_BADK}'"

/* A couple of notes on these.

First, {cmd:`vars'} in {cmd:word count} and {cmd:word} cannot be
enclosed in double quotes;
the result would be wrong.

Second, {cmd:word count} and {cmd:word} actually have to do with "tokens,"
not words.
A token is a word (characters separated by spaces)
{it:or} a set of words enclosed in double quotes.
Here, all tokens are words: */

local sentence In my younger and more vulnerable years my father gave me some advice that I've been turning over in my mind ever since.

display length("`sentence'")
display word("`sentence'", 1)

local word1 : word 1 of `sentence'
display "`word1'"

/* What about the following? What is the first word?

{cmd:"I married him because I thought he was a gentleman," she said finally.}

It's {cmd:"I"}, right? */

local sentence `""I married him because I thought he was a gentleman," she said finally."'

display length(`"`sentence'"')
display word(`"`sentence'"', 1)

/* Recall that strings that themselves contain double quotes ({cmd:"})
must be enclosed in {help quotes##double:"compound" double quotes} ({cmd:`"""'})
not the normal "simple" double quotes ({cmd:""}).

Now, the {cmd:word} extended macro function returns the first token,
different from the first word: */

local word1 : word 1 of `sentence'
display `"`word1'"'

/* To put it another way,
the {cmd:word count} and {cmd:word} extended macro functions
have to do with elements of macro lists.
In macro lists, double quotes can be used
to join multiple words as a single element.
{cmd:word count `sentence'} counts
the number of elements (tokens) of the macro list {cmd:`sentence'},
just as {cmd:word 1 of `sentence'} returns
the {cmd:1}st element/token (not necessarily word).

Together with the {cmd:list} extended macro function,
{cmd:word} and {cmd:word count} round out the most essential tools for
using macro lists in Stata.

{cmd:length()} and {cmd:subinstr()} also have
extended macro function equivalents: */

display length("`vars'")

local len : length local vars
display `len'

display subinstr("`vars'", "_", "", .)

local newvars : subinstr local vars "_" "", all
display "`newvars'"

/* Let's return to the dataset from before for which
we want to convert all variable names to lowercase.
We could make {cmd:`newvars' = lower("`vars'")},
then loop over parallel lists,
but we also know that {cmd:lower()} cannot handle
a string as long as {cmd:"`vars'"}.

How about using an extended macro function instead?
Unfortunately, this is not possible,
because many string functions, including {cmd:lower()},
do not have an extended macro function equivalent.

However, there are still options.
We could use the user-written {helpb lstrfun}: */

ssc install lstrfun
help lstrfun

lstrfun newvars, lower("`vars'")
display "`newvars'"

/* {cmd:lstrfun} itself uses {help Mata}, which gives us another option.
If extended macro functions and {cmd:lstrfun} are not sufficient,
you will have to use Mata.

I will give a brief example of Mata.
You don't need to learn this now.

Mata's {helpb mf_st_local:st_local()} obtains the content of Stata locals: */

mata: st_local("vars")

* This can be converted to lowercase using {helpb strlower()},
* Mata's version of {cmd:lower()}.

mata: strlower(st_local("vars"))

* It can then be saved back to Stata:

mata: st_local("newvars", strlower(st_local("vars")))
display "`newvars'"

/* Now we can rename by looping over parallel lists,
using the extended macro functions {cmd:word count} and {cmd:word}
instead of {cmd:wordcount()} and {cmd:word()} like we did before. */

{BLOCK}ds
{BLOCK}local vars `r(varlist)'
{BLOCK}
{BLOCK}lstrfun newvars, lower("`vars'")
{BLOCK}
{BLOCK}local nvars : word count `vars'
{BLOCK}forvalues i = 1/`nvars' {
	{BLOCK}local var    : word `i' of `vars'
	{BLOCK}local newvar : word `i' of `newvars'
	{BLOCK}rename `var' `newvar'
{BLOCK}}

* In Stata 12 and higher, we could have used {helpb rename group:rename}'s
* new functionality instead:

rename *, lower

* In Stata 11 and below, the SSC program {helpb renvars} was another option:

renvars, lower

/* {hline}{marker gettoken}

{bf:3. gettoken}

{hline} */

use {DATA_POLICE2}, clear

/* Consider the following task (adopted from a real data clean!):
find all observations for which
at least two of the variables {cmd:s1_q2 s1_q2_other s1_q3 s1_q4 s1_q5}
have the same nonmissing values as another observation.

How could we implement this in Stata? The following is one possibility.
Below, {cmd:dup} is {cmd:1} if an observations meets these criteria
and {cmd:0} otherwise,
and {cmd:dupvars} is the list of duplicate variable pairs.
For example, {cmd:hhid "1101008"} has
{cmd:s1_q2 == Farming or livestock} and {cmd:s1_q3 == "KUMHAR"},
as does {cmd:hhid "1113003"},
so both should have {cmd:dup == 1} and {cmd:"s1_q2 s1_q3"}
within {cmd:dupvars}: */

list hhid s1_q2 s1_q3 if inlist(hhid, "1101008", "1113003")

* To create {cmd:dup} and {cmd:dupvars}:

generate dup = 0
generate dupvars = ""

local vars s1_q2 s1_q2_other s1_q3 s1_q4 s1_q5
foreach var1 of local vars {
	foreach var2 of local vars {
		if "`var1'" != "`var2'" {
			duplicates tag `var1' `var2', generate(loopdup)
			replace loopdup = 0 if missing(`var1', `var2')
			replace dup = 1 if loopdup
			replace dupvars = dupvars + cond(dupvars == "", "", "; ") + "`var1' `var2'" if loopdup
			drop loopdup
		}
	}
}

/* However, there is a problem:
we are running over all permutations of
{cmd:s1_q2 s1_q2_other s1_q3 s1_q4 s1_q5},
not combinations.
In other words, we are looping over pairs where
the order of the variables in the pair matters.
For example, we are running the test
for both {cmd:s1_q2 s1_q3} and {cmd:s1_q3 s1_q2}.
We can confirm this in {cmd:dupvars}: */

browse dupvars

/* A powerful alternative is {helpb gettoken}.

{cmd:gettoken} {it:macname1} {it:macname2} {cmd::} {it:macname3}

obtains the first token of the macro {it:macname3},
stores it in {it:macname1},
and returns the rest of {it:macname3} in {it:macname2}. For example: */

use {DATA_POLICE2}, clear

ds
local vars `r(varlist)'
gettoken var1 rest : vars
display "`vars'"
display "`var1'"
display "`rest'"

* {marker combinations_loop}{...}
* We can use {cmd:gettoken} to restrict the loop above to combinations:

generate dup = 0
generate dupvars = ""

local vars s1_q2 s1_q2_other s1_q3 s1_q4 s1_q5
local nvars : word count `vars'
forvalues i = 1/`nvars' {
	gettoken var1 vars : vars

	foreach var2 of local vars {
		duplicates tag `var1' `var2', generate(loopdup)
		replace loopdup = 0 if missing(`var1', `var2')
		replace dup = 1 if loopdup
		replace dupvars = dupvars + cond(dupvars == "", "", "; ") + "`var1' `var2'" if loopdup
		drop loopdup
	}
}

* {cmd:dupvars} now has no duplicate pairs:

browse dupvars

/* {cmd:gettoken} takes a macro list and returns two locals.
One is the first element of the list {hline 2} though
we could already get this using the {cmd:word} extended macro function.
{cmd:gettoken} also returns the remainder of the list, that is,
the list with the first element removed,
and it's this novel capability that makes {cmd:gettoken} worth learning. */

/* {marker arguments}

{bf:4. Passing arguments to do-files}

{hline}

You often need to pass information from one do-file to another,
for example, from a master do-file to the do-files it runs.
What are the options?

One possibility is to use globals: */

sysuse auto, clear

global y mpg
global x weight

doedit "Do/My analysis - globals"
do "Do/My analysis - globals"

/* This works, but there are downsides to globals.

Two different do-files can use the same globals. If these do-files interact,
mix-ups can happen, and a global can be accidentally overwritten.

{cmd:"Analysis - parent.do"} regresses {cmd:mpg} separately
on all other numeric variables in the dataset: */

sysuse auto, clear

do "Do/My analysis - parent"

* Now let's run {cmd:"Analysis - globals.do"} again:

do "Do/My analysis - globals"

/* {cmd:"Analysis - globals.do"} has completed a regression
of {cmd:mpg} on {cmd:foreign},
not on {cmd:weight} as expected.
What happened? */

doedit "Do/My analysis - parent"

/* {cmd:"Analysis - parent.do"} itself ran
{cmd:"Analysis - globals.do"},
using the globals {cmd:$y} and {cmd:$x}
and overwriting the original value of {cmd:$x}, {cmd:weight}.

Here, we could get around this by being careful
to define {cmd:$y} and {cmd:$x}
right before we run {cmd:"Analysis - globals.do"}.
For example, we could have redefined {cmd:$y} and {cmd:$x}
as {cmd:mpg} and {cmd:weight}
before the last run of {cmd:"Analysis - globals.do"} above.
However, for complex data management systems with
many do-files and many globals,
it can be hard to keep track of which do-files rely
on which global definitions at which time.
It is also more difficult to share do-files,
since you have to make sure that others' do-files
do not use the same globals as yours.
If nothing else, globals have the potential
to create hard-to-find bugs in your code.

None of this means that you should stop using globals, which can be very useful.
However, there are ways to minimize these risks.
First, do-files that are passed information through globals
should not modify those globals,
in case a master do-file will later run another do-file with the same globals.
Second, using longer global names decreases the chances that your do-files
will use the same globals as someone else's.

The only way to eliminate these risks is to stop using globals.
If you are working on a complex data project,
you may find that globals are more of a headache than they're worth.
In that case, there are other ways to pass information across do-files.

One of these is {cmd:args}.
Below, notice how {cmd:mpg weight} is specified after
{cmd:do "Do/My analysis - args"}:*/

sysuse auto, clear

do "Do/My analysis - args" mpg weight

doedit "Do/My analysis - args"

/* {cmd:args} worked great here,
but it can be confusing if there are many arguments.
Compare {cmd:args} from {cmd:"Analysis - args.do"}:

{cmd:args y x}

with {cmd:args} from a more complex data management do-file:

{p 4 8 2}
{cmd:args bccomplete checkday checkdkrfday lag examinesiddups quitreview maxdate showunedited maxsalivaid datedir}

This is from one of my do-files as a PA in Kenya!
Here, you have to be careful to run the do-file
with all these arguments in exactly the right order.
There is also potential for bugs.

This brings us to the next option: {cmd:syntax}.
Below, {cmd:mpg} and {cmd:weight} have been specified to the do-file
through options {cmd:y()} and {cmd:x()}. */

sysuse auto, clear

do "Do/My analysis - syntax" y(mpg) x(weight)

doedit "Do/My analysis - syntax"

/* One common use of globals is storing directory names.
For example, I might put the location of a project folder in a global: */

global projectdir {VAR_WD}

/* When I run do-files that use this directory,
they can refer to {cmd:$projectdir}.
For these do-files to work on others' computers,
only {cmd:$projectdir} needs to be changed.

An alternative is the SSC package {helpb fastcd}: */

ssc install fastcd
help fastcd

cd "{VAR_WDBASE}"

* Adding the project folder to the database:

c cur myproject
c

* Now no matter what our working directory is...

cd "C:\"

* ... it is easy to return to the project folder.

c myproject

/* Any computer with {cmd:myproject} in the {cmd:fastcd} database
can use this one command:
no globals necessary.

Now returning to the training folder: */

cd ..
