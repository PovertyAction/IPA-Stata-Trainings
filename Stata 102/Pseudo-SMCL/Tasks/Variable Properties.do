/* {HEAD}

{PROPERTIES!} */

{USE}

/* {marker stuffofstata}{...}
Variables are the stuff of Stata.
After all, a Stata dataset is just a collection of variables.
Whether you're manipulating the data,
calculating summary statistics,
or running a regression,
you're working with variables.

To some extent, variables are just a set of values.
However, they're also characterized by a series of properties:
a {help varname:name},
{help label:variable and value labels},
a {help data_types:storage type} (numeric or string),
and a {help format:display format}.
These properties are essential information about a variable,
and you usually want to get them right before moving on
to more advanced data work.
For example, it doesn't make sense to use a variable throughout a do-file
only to rename it at the end.
Thus, attending to variable properties is typically the first task in the data cleaning process.

This module is divided into sections for these variable properties:

{view `"{PROPERTIES-}##names"':1. Variable Names}{BR}
{view `"{PROPERTIES-}##labels"':2. Labels}{BR}
{view `"{PROPERTIES-}##types"':3. Storage Types}

{TECH}
{COL}{bf:Display formats}{CEND}
{MLINE}
{COL}In addition to its name, labels, and storage type, a variable is{CEND}
{COL}characterized by a {help format:display format} that determines how it is displayed in the{CEND}
{COL}absence of a value label. This module doesn't cover formats in depth, but{CEND}
{COL}below is a short example. The following code first formats variable{CEND}
{COL}{cmd:gear_ratio} in the auto dataset so that it is displayed with exactly one{CEND}
{COL}digit after the decimal, then with exactly three:{CEND}
{BLANK}
{COL}{bf:{stata sysuse auto, clear}}{CEND}
{COL}{bf:{stata format gear_ratio %9.1f}}{CEND}
{COL}{bf:{stata list gear_ratio}}{CEND}
{COL}{bf:{stata format gear_ratio %9.3f}}{CEND}
{COL}{bf:{stata list gear_ratio}}{CEND}
{COL}{bf:{stata {USE}}}{CEND}
{BOTTOM}

{hline}{marker names}

{bf:1. Variable Names}

{hline}

You probably already know {helpb rename}.
Another command for renaming variables is {helpb renpfix},
which adds, changes, or removes prefixes on variable names.

This dataset is from the baseline,
and if we'd like to merge it with the endline data,
we might first want to add a prefix like {cmd:bl_} to all variables:

{TRYITCMD}
renpfix "" bl_
{DEF}

This changes the prefix from {cmd:""} (in other words, no prefix) to {cmd:bl_}.

There's one variable that shouldn't have been renamed: */

rename bl_hhid hhid

/* This is because {cmd:hhid} would be used to merge the two datasets.

Using {cmd:renpfix}, we can change the prefix:

{TRYITCMD}
renpfix bl_ baseline
{DEF}

As before,
first specified is the prefix to change {it:from} (blank or nonblank),
followed by the prefix to change {it:to}.
The second prefix can also be blank.
For example, the following command removes the prefix:

{TRYITCMD}
renpfix baseline
{DEF}

The new {helpb rename group:rename} introduced in Stata 12
is a big improvement over the previous version,
and offers many options for renaming groups of variables.
If you have Stata 12 or higher, you can use {cmd:rename} instead of {cmd:renpfix}.
For example, this adds the prefix {cmd:bl_} to all variables: */

rename * bl_*

* Again in Stata 12 and higher, this changes all variable names to lowercase:

rename *, lower

/* {marker renvars}{...}
If you don't have Stata 12 or higher,
but {cmd:rename}'s extended functionality appeals to you,
{cmd:renvars} is a user-written program that provides many of the same options: */

net search renvars

* For example, this use of {cmd:renvars} changes all variable names to lowercase:

renvars *, lower

/* {hline}{marker labels}

{bf:2. Labels}

{hline} */

{USE}

/* We will now review {helpb label}.
There are two main types of labels: variable labels and value labels.

Variable labels are descriptions of variables,
and are usually more informative than variable names.
Variable {cmd:areadur_unit} ("area duration unit") is the time unit (day/week/etc.)
for variable {cmd:areadur}.
However, while it's clear from its variable label what {cmd:areadur} represents,
{cmd:areadur_unit} is missing a variable label: */

describe areadur areadur_unit

/* The following command adds a variable label to {cmd:areadur_unit}:

{TRYITCMD}
label variable areadur_unit "How long has your household been living in this area? (unit)"
{DEF} */

describe areadur areadur_unit

/* This added descriptive text to {cmd:areadur_unit}.
A common choice for the variable label is the question text.
However, variable labels are limited to 80 characters,
so some questions may not fit.
In this dataset, the variable label of {cmd:own4wheeleryn} has been truncated: */

describe own4wheeleryn

/* An alternative is to add question text in {helpb notes},
leaving the variable label free for a shorter description.
Here's how we might do this for {cmd:own4wheeleryn}: */

notes own4wheeleryn: Over the past 12 months, has anyone in your household had for private use any car, van, tractor, bus, 3 wheeler, or truck?
label variable own4wheeleryn "Household member had 4-wheeled vehicle for private use in last 12 months"
describe own4wheeleryn
notes own4wheeleryn

/* While variable labels describe variables as a whole,
value labels describe particular values.
A value label is a list of associations of integers and descriptive text.
After a value label is attached to a variable,
the values of the variable are shown as their associated text, not as numbers,
for example, when you {cmd:browse}.

Currently, the values of {cmd:areadur_unit} are not labeled: */

tabulate areadur_unit

/* This is a problem, because even if {cmd:areadur} equals {cmd:1},
{cmd:1} week is very different from {cmd:1} year.
First we need to define the value label,
declaring the integer to text correspondences:

{TRYITCMD}
label define timeunit 1 days 2 weeks 3 months 4 years
{DEF}

Then we attach the value label to the variable:

{TRYITCMD}
label values areadur_unit timeunit
{DEF}

Let's see if it worked: */

tabulate areadur_unit

/* Much better.

Now, while the values of {cmd:areadur_unit} are {it:displayed} differently
in commands like {cmd:tabulate},
the actual values of the variable are unchanged,
and the variable has not been converted to a string variable.
For example, the results of {cmd:summarize} are the same
as before {cmd:areadur_unit} was value labeled: */

summarize areadur_unit

/* Value labels are just for display,
and they make working with numeric variables easier.
A value labeled numeric variable is typically easier to work with
than a string variable with values equal to the value label text.
For example, it's easier to create dummy variables from numeric variables than string variables.

{marker dummy_sets}{...}
{TECH}
{COL}What's the best way to create a set of dummy variables from a variable?{CEND}
{BLANK}
{COL}First, ask whether it's even necessary to create the dummies: if you're{CEND}
{COL}using Stata 11 or higher, you can use {help fvvarlist:factor variables}. For example:{CEND}
{BLANK}
{COL}{bf:{stata regress thanavisityn i.castecode}}{CEND}
{BLANK}
{COL}It's easy to specify interactions with factor variables {hline 2} all without{CEND}
{COL}creating a single dummy variable:{CEND}
{BLANK}
{COL}{bf:{stata regress thanavisityn castecode#sex}}{CEND}
{BLANK}
{COL}If you don't have Stata 11 or higher, {helpb xi} can complete some of the same tasks{CEND}
{COL}as factor variables. Even if you have Stata 11 or higher, some commands{CEND}
{COL}don't allow factor variables, but do take the {cmd:xi} prefix. {cmd:xi} can also create{CEND}
{COL}a set of dummy variables for use outside a single command, and can be more{CEND}
{COL}convenient than the equivalent for factor variables, {helpb fvrevar}. Unlike factor{CEND}
{COL}variables, {cmd:xi} works with string variables in addition to numeric.{CEND}
{BLANK}
{COL}There are also great user-written programs for the job. Check out these {help SSC}{CEND}
{COL}programs:{CEND}
{BLANK}
{COL}{bf:{stata ssc install todummy}}{CEND}
{COL}{bf:{stata ssc install dummieslab}}{CEND}
{COL}{bf:{stata ssc install dummies2}}{CEND}
{BOTTOM}

We used {cmd:timeunit} for the name of the value label that we attached to {cmd:areadur_unit}.
The name of the value label was different from the variable name,
but Stata also would have allowed it to be the same.

You can modify value labels: */

label define timeunit 3 "lunar cycles", modify
label define timeunit 5 decades, add
label list timeunit

* Further, the same value label can be attached to multiple variables.
* The following command attaches the value label {cmd:timeunit}
* to the variable {cmd:addressdur_unit};
* {cmd:timeunit} is already attached to {cmd:areadur_unit}.

label values addressdur_unit timeunit

browse addressdur_unit areadur_unit

* It's also possible to remove value labels:

label values areadur_unit
label values addressdur_unit

browse areadur_unit addressdur_unit

* You can attach value labels to multiple variables at the same time:

label values areadur_unit addressdur_unit timeunit

browse areadur_unit addressdur_unit

* Or list all value labels:

label dir

label list

/* The {helpb #delimit} command sets the character that indicates the end of a command.
By default, it's a carriage return, the character that the enter key makes.
This means that in a do-file, once you press enter and continue to the next line,
the previous command is registered as complete:
the command does not extend to the next line.

Alternatively, you can make the delimiter a semicolon.
This means that Stata considers a command to be complete only once it sees a semicolon,
even if new lines have been started.
The following sets the delimiter to a semicolon.
Try it yourself by typing it out in a new do-file, then running it.
You can change the delimiter only within do-files, not interactively in the Command window.

{TRYITCMD}
#delimit ;{BR}
display "Hello world!";{BR}
summarize{BR}
	sex{BR}
;
{DEF}

{cmd:#delimit cr} returns to a {ul:c}arriage {ul:r}eturn delimiter: */

#delimit ;

display

	"Hello world!"

	;

#delimit cr
display "Hello world!"

/* {marker delimit}{...}
I rarely use {cmd:#delimit ;},
though others prefer the semicolon as a delimiter to the carriage return.
However, {cmd:#delimit ;} is very useful for long value labels.
Compare */

label define timeunit2 1 milliseconds 2 seconds 3 minutes 4 hours 5 days 6 weeks 7 months 8 quarters 9 trimesters 10 semesters 11 years 12 decades

* to:

label drop timeunit2

#delimit ;
label define timeunit2
	1 milliseconds
	2 seconds
	3 minutes
	4 hours
	5 days
	6 weeks
	7 months
	8 quarters
	9 trimesters
	10 semesters
	11 years
	12 decades
;
#delimit cr

/* The second definition is much more readable.
In a do-file, you might have to scroll across to see all of the first definition.

A middle path is to use the {cmd:///} {help comments:line-join indicator} with {cmd:#delimit cr}.
{cmd:///} indicates that the command runs onto the next line: */

label drop timeunit2

label define timeunit2 ///
	1 milliseconds ///
	2 seconds ///
	3 minutes ///
	4 hours ///
	5 days ///
	6 weeks ///
	7 months ///
	8 quarters ///
	9 trimesters ///
	10 semesters ///
	11 years ///
	12 decades

/* Like {cmd:#delimit}, the line-join indicator works only within do-files.
Try the following example by typing it out in a new do-file, then running it.

{TRYITCMD}
tabulate castecode ///{BR}
	if sex == 1 & age <= 35, ///{BR}
	missing nolabel
{DEF}

Here, the line-join indicator allowed the command to span three lines.
The first line contained the main piece of the command,
{cmd:tabulate castecode}.
The second line then held the {cmd:if} qualifier,
and the third line listed the command's options, {cmd:missing nolabel}.
This command is short enough that it probably could have been put on a single line,
but for longer commands,
it's often most readable to use the line-join indicator in this way
to divide the command at particular points of its syntax.

The {help SSC} packages {cmd:labutil} (which includes the useful {cmd:labmask})
and {cmd:labutil2} (which includes {cmd:labrecode})
offer a number of user-written programs
for working with variable and value labels: */

ssc install labutil
ssc install labutil2

/* {hline}{marker types}

{bf:3. Storage Types}

{hline}

We will now touch on the rich area of {help data_types:storage types}.
A variable's storage type determines
whether it is numeric or string
and how many significant digits it has.
Storage types include {cmd:byte}, {cmd:float}, and {cmd:str100}.
Storage types are emphatically different from {help format:display formats},
which control how a variable is {it:displayed}.
Display formats include {cmd:%9.0g}, {cmd:%td}, and {cmd:%15s}.

You can convert string variables to numeric using {helpb destring}: */

destring hhid, replace

* You can also convert numeric variables to string using {helpb tostring}:

tostring hhid, replace

/* {...}
{TECH}
{COL}Sometimes {cmd:tostring} will fail to convert a variable to string, delivering the{CEND}
{COL}warning "cannot be converted reversibly." For example:{CEND}
{BLANK}
{COL}{bf:{stata sysuse auto, clear}}{CEND}
{COL}{bf:{stata tostring gear_ratio, replace}}{CEND}
{BLANK}
{COL}The solution to this is not option {cmd:force}, which results in loss of{CEND}
{COL}information. Instead, use option {cmd:format(%24.0g)}:{CEND}
{BLANK}
{COL}{bf:{stata tostring gear_ratio, replace format(%24.0g)}}{CEND}
{BLANK}
{COL}Option {cmd:format(%24.0g)} works not just in this case to resolve the issue, but{CEND}
{COL}in all cases.{CEND}
{BLANK}
{COL}{bf:{stata {USE}}}{CEND}
{BOTTOM}

You can convert a string variable to a value labeled numeric variable
using {helpb encode}:

{TRYITCMD}
encode thanavisitreason, generate(visitreason)
{DEF} */

browse thanavisitreason visitreason

* You can use a specific value label:

label define visitreasonlab ///
	1  "To register a Crime" ///
	2  "To answer charges filed against you" ///
	3  "To say hello/to chat" ///
	97 "Refuse to answer" ///
	98 "Other" ///
	99 "Don't Know"

/* {...}
{TRYITCMD}
encode thanavisitreason, generate(visitreason2) label(visitreasonlab)
{DEF} */

browse thanavisitreason visitreason visitreason2 if visitreason != visitreason2

/* You can also convert a value labeled variable
to a string variable that contains the value label text
using {helpb decode}:

{TRYITCMD}
decode visitreason, generate(visitreasonstr)
{DEF} */

browse thanavisitreason visitreason visitreasonstr

/* {cmd:destring} and {cmd:tostring} are inverse operations,
as are {cmd:encode} and {cmd:decode}.

If a string variable has all numeric values, convert it to numeric using {cmd:destring}.
If the variable does not have all numeric values,
use {cmd:encode} or use {cmd:destring} with option {cmd:ignore()} or {cmd:force}.

If a numeric variable is not value labeled, convert it to string using {cmd:tostring}.
If the variable is value labeled,
you can use {cmd:encode} to retain the value label text or
{cmd:tostring} for just the numeric values.

{TECH}
{COL}If a variable has the wrong storage type, it might not be "precise" enough{CEND}
{COL}and can take on slightly incorrect values. For example:{CEND}
{BLANK}
{BF}
{COL}{stata generate big = 123456789}{CEND}
{COL}{stata local big = big[1]}{CEND}
{COL}{stata display "`big'"}{CEND}
{COL}{stata drop big}{CEND}
{DEF}
{BLANK}
{COL}Variable {cmd:big} was created as type {cmd:float} when it should have been stored as{CEND}
{COL}{cmd:long} or {cmd:double}. While {cmd:floats} have 7 digits of accuracy, {cmd:longs} and {cmd:doubles}{CEND}
{COL}have 9 and 16, respectively. Variable {cmd:big} is 9 digits, so it would be{CEND}
{COL}precise enough as a {cmd:long}:{CEND}
{BLANK}
{BF}
{COL}{stata generate long big = 123456789}{CEND}
{COL}{stata local big = big[1]}{CEND}
{COL}{stata display "`big'"}{CEND}
{COL}{stata drop big}{CEND}
{DEF}
{BLANK}
{COL}Click {help data_types:here} for more on precision. There's also a great {browse "http://blog.stata.com/2012/04/02/the-penultimate-guide-to-precision/":Stata blog post} on{CEND}
{COL}the subject.{CEND}
{BOTTOM}

{FOOT}

{GOTOPS}{PROPERTIES_PS}

{NEXT}{DUPLICATES}
{PREV}{INTRO}
{START} */
