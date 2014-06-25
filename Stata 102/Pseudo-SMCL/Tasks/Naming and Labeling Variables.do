/* {HEAD}

{NAMING!} */

{USE}

/* Variables are the stuff of Stata.
After all, a Stata dataset is just a collection of variables.
Whether you're manipulating the data,
calculating summary statistics,
or running a regression,
you're working with variables.

To some extent, variables are just a set of values.
However, they're also characterized by a series of properties:
a {help varname:name},
{help label:variable and value labels},
a {help data_types:variable type} (numeric or string),
and a {help format:display format}.
These properties are essential information about a variable,
and you usually want to get them right before moving on
to more advanced data work.
For example, it doesn't make sense to use a variable throughout a do-file
only to rename it at the end.
Thus, attending to variable properties is typically the first task in the data cleaning process.

This module will go over naming and labeling, as well as a note about delimiters. In the next
{view `"{TYPES-}"':module}, we'll discuss variable types and ways to work with different variables. 

{view `"{NAMING-}##names"':1. Variable Names}{BR}
{view `"{NAMING-}##varlabels"':2. Variable Labels}{BR}
{view `"{NAMING-}##vallabels"':3. Value Labels}{BR}
{view `"{NAMING-}##delimit"':4. Delimiters}{BR}

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

Renaming variables is a common task when doing data cleaning
and analysis. An old name might have been clunky, or you might
be looking to combine different datasets and want variable
names to be consistent. Mastering the {cmd:rename} command
is essential for this task.

The syntax for the basic {helpb rename:rename} command
is simple. Say we want to change the name
of the variable {bf:sex} to be {bf:gender}. We simply execute:

{TRYITCMD}
rename sex gender
{DEF}

However, what if you want to rename multiple variables, or
don't want to change a complete variable's name to another, but instead,
add a prefix to a group of variables. Luckily, {cmd:rename} offers much additional
functionality. We'll cover a few of the most commonly used methods of {cmd:rename}
here, but it is highly suggested to browse through the entire {helpb rename group:help file}.

First, we can rename sets of variables at once, say: 

{TRYITCMD}
rename (educ addressdur areadur) (education addressduration areaduration)
{DEF}

Changing the case of variables is another useful potential task: */

rename surveyid, upper
rename SURVEYID, lower

/* One of the most common renaming tasks is to attach some sort of prefix or suffix
to many variables at once. For instance, you may want to assign all baseline variables with
the prefix {cmd:bl_} so that when you merge with data from the endline, it is easy
to determine from which round each variable came from. Doing so is straightforward
with {cmd:rename}:

{TRYITCMD}
rename * bl_*
{DEF}

Here, the symbol * means "zero or more characters." Thus, the command looks
for all variables with zero or more characters (i.e. all of them) and attaches the prefix
{cmd:bl_} to them (see the {helpb rename group:help file} for more on this
and other "wildcard" symbols. Let's now change this prefix to {cmd:base_} instead, and then remove
the prefix from the unique ID, {bf:hhid}: */

rename bl_* base_*
rename base_hhid hhid

/* {bf:Note:} The {cmd:rename} command as described above was introduced only in Stata 12.
If you have an earlier version of Stata, commands such as {cmd:renpfix} and the
{view `"{COMMANDS-}"':user-written} {cmd:renvars} provided much of the same functionality. 

{hline}{marker varlabels}

{bf:2. Variable Labels}

{hline} */

{USE}

/* We will now review {helpb label:labelling}.
There are two main types of labels: variable labels and value labels.

Variable labels are descriptions of variables,
and are usually made more informative than variable names. They are displayed each time
Stata calls a variable, e.g. when summarizing or tabulating. Good variable labelling
is critical to ensuring that variables are understandable to others. 

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

/*{hline}{marker vallabels}

{bf:3. Value Labels}

{hline}

While variable labels describe variables as a whole,
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
In the following module on {view `"{TYPES-}"':variable types}, we'll discuss different methods
of converting from string to numeric variables and vice versa.  

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

/*{hline}{marker delimit}

{bf:4. Delimiters}

{hline}

The {helpb #delimit} command sets the character that indicates the end of a command.
By default, it's a carriage return, the character that the enter key makes.
This means that in a do-file, once you press enter and continue to the next line,
the previous command is registered as complete;
the command does not extend to the next line.

Alternatively, you can make the delimiter a semicolon.
This means that Stata considers a command to be complete only once it sees a semicolon,
even if new lines have been started.
The following sets the delimiter to a semicolon.
Try it yourself by typing it out in a new do-file, then running it.
You can change the delimiter only within do-files, not interactively in the Command window.

{marker delimit}{...}
{cmd:#delimit ;} is very useful for long value labels.
Compare: */

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
Note that {cmd:#delimit ;} sets the delimiter to the semicolon, while {cmd:#delimit cr}
sets it back to the {ul:c}arriage {ul:r}eturn.

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

/*{FOOT}

{NEXT}{TYPES}
{PREV}{COMMANDS}
{START} */
