/* {HEAD}

{LOOPS!} */

{USE} 
/* 
{view `"{LOOPS-}##introduction"':1. Variants on foreach}{BR}
{view `"{LOOPS-}##tracing"':2. Tracing}{BR}
{view `"{LOOPS-}##macros"':3. More on Macros}{BR}
{view `"{LOOPS-}##loops"':4. More Loops}

{hline}{marker variants}

{bf:1. Variants on foreach}

{hline}

In {bf:Stata 102}, we introduced the {bf:foreach in} loop, which you
should be familiar with. A simple example: 

{TRYITCMD}
foreach x in a b c {{BR}
	display "`x'"{BR}
}
{DEF}

In the above loop, each item following "in" is substituted into the macro `x'. 
However, there are several very useful variants on this syntax, used
when dealing with lists of variables or numbers. 

{hline}{marker varlist}

Say we want to run a loop for 20 variables, all listed consecutively (var1, var2, ... var20).
If you used {bf:foreach in}, you would have to list them all manually.
However, when using {bf:foreach of varlist}, you can simply tell Stata
to use the 1st through 20th variables, only listing those two with a dash in between.
Thus, this code would tabulate all twenty variables: 

{CMD}			
foreach i of varlist var1-var20 {{BR}
	tabulate `i'{BR}
}
{DEF}

If you had tried using this shorthand with {cmd:foreach in}
Stata would get confused and would try to look for a variable that was named "var1-var20",
and would just tell you the loop is impossible to run because that variable doesn’t exist.
  
Here's another very useful example. Compare the output of: */

foreach var of varlist _all {
	display "`var'"
}

*and:

foreach var in _all {
	display "`var'"
}

/* Note that there are many ways to specify a list of variables in Stata. See
this very useful {helpb varlist:help file} for more. In particular, notice
the use of special characters such as "*" to indicate a certain subset
of variables. Can you think of a time when you might use them?

{hline}{marker numlist}

When we want to loop over a list of numbers, {cmd:foreach of numlist} is a great
shorthand. 

Let's look at the following loop: 

{TRYITCMD}
foreach i of numlist 1/10 {{BR}
	display "`i'"{BR}
}
{DEF}

A numlist ("number list") is a list of numbers specified in shorthand.
The shorthand used above is the one you'll see most frequently.
The / symbol means "to" so 1/10 means 1 to 10:  1/10 is shorthand for 1 2 3 4 5 6 7 8 9 10.
Another useful shorthand allows you to move from one number to another in steps of a third number.
Multiples of a number follow this pattern. For example: */

foreach i of numlist 10(5)50 {
	display "`i'"
}

/*#1(#d)#2 means "#1 to #2 in steps of #d". Thus, 10(5)50 means 10 to 50 in steps of 5,
in other words, all the multiples of 5 between 10 and 50, inclusive.
These aren't all the numlist shortcuts: see the {help numlist:help file} for more.

{hline}

{bf:Note:} Almost all Stata users will at some point get mixed up between {bf:in} and {bf:of}
when using the {cmd:foreach} command. Remember that when using {bf:in}, you must spell
out all of the items that will be pasted into the resulting macro. Using {bf:of}, 
when combined with {bf:varlist} or {bf:numlist}, allows you to use some shorthand
specifically when the items that you want to loop through are either all variables
or all numbers. 

Note how the output of the following two loops are the same: */

foreach num in 1 2 3 4 5 {
	display "`num'"
}

foreach num of numlist 1/5 {
	display "`num'"
}

/*{hline}{marker tracing}

{bf:2. Tracing}

{hline}

Loops can be confusing, and they're also difficult to debug,
because for a loop that results in an error,
Stata doesn't clearly indicate which command in the loop is causing the problem.
For example, here's a loop with a bug introduced: */

foreach var in sex age educ {
	display "Checking `var' for missing values..."
	list hhid `var' if `var == .
}

/* To get around this, you can turn on {help trace:tracing}:

{TRYITCMD}
set trace on
{DEF}

This gives details about the commands Stata is executing: */

foreach var in sex age educ {
	display "Checking `var' for missing values..."
	list hhid `var' if `var == .
}

/* Once you've identified the problem:

{TRYITCMD}
set trace off
{DEF}

Notice the behavior of {cmd:set trace on} with macros: */

set trace on

foreach var in sex age educ {
	display "Checking `var' for missing values..."
	list hhid `var' if `var' == .
}

set trace off

/* {cmd:set trace on} first shows the commands as they were originally typed,
before the values of macros are substituted.
It then shows the commands
after the macros have been "expanded."
Here, we see:

- foreach var in sex age educ {{BR}
- display "Checking `var' for missing values..."{BR}
= display "Checking sex for missing values..."{BR}
Checking sex for missing values...{BR}
- list hhid `var' if `var' == .{BR}
= list hhid sex if sex == .{BR}
- }

First, we see the command as it was first typed:

- display "Checking `var' for missing values..."

Then the command after the macro expansion:

= display "Checking sex for missing values..."{BR}

Then the result:

Checking sex for missing values...

{hline}{marker macros}

{bf:3. More on Macros}

{hline}

A few more points about macros.

Local macros don't exist after the do-file ends.
For example, copy these commands to a new do-file, then run it:

{CMD}
local x Hello world{BR}
display "`x'"
{DEF}

Now try the following command: */

display "`x'"

/* It doesn't work, because the local doesn't exist now that the do-file is done.

We will now briefly discuss global macros.
Basically, they're like local macros
except they stick around even after the do-file ends,
so they can be used in the Command window afterwards
or by other do-files.
Rather than being enclosed by ` and ', they
start with {cmd:$}.
Copy these commands to a new do-file, then run it:

{CMD}
global x Hello world{BR}
display "$x"
{DEF}

Now try the following command: */

display "$x"

/* It works!

{TECH}
{COL}I defined {cmd:`x'} as follows:{CEND}
{BLANK}
{COL}{cmd:local x Hello world}{CEND}
{BLANK}
{COL}But I also could have coded:{CEND}
{BLANK}
{COL}{cmd:local x "Hello world"}{CEND}
{BLANK}
{COL}Here, I enclosed the value of {cmd:`x'} with double quotes. Usually, these quotes{CEND}
{COL}are not required. For example, they were not needed here. However, they are{CEND}
{COL}always allowed. The only times they are necessary are when the value of the{CEND}
{COL}macro begins with double quotes or a macro operator, such as {cmd:=}, or when it{CEND}
{COL}contains leading leading or trailing spaces. Let's look at an example where{CEND}
{COL}the quotes are necessary.{CEND}
{BLANK}
{CMD}
{COL}foreach x in "Hello world" "a" "b" "c" {c -(}{CEND}
{COL}	display "`x'"{CEND}
{COL}{c )-}{CEND}
{DEF}
{BLANK}
{COL}{stata `"run "Do/Text boxes.do" "for-loops and macros" 1"':Click here to execute.}{CEND}
{BLANK}
{COL}The loop above {cmd:display}ed the four string values that followed {cmd:foreach in}.{CEND}
{COL}Let's examine a variation on this loop:{CEND}
{BLANK}
{CMD}
{COL}local list ""Hello world" "a" "b" "c""{CEND}
{COL}foreach x in `list' {c -(}{CEND}
{COL}	display "`x'"{CEND}
{COL}{c )-}{CEND}
{DEF}
{BLANK}
{COL}{stata `"run "Do/Text boxes.do" "for-loops and macros" 2"':Click here to execute.}{CEND}
{BLANK}
{COL}We see the same output. In the definition of {cmd:`list'}, we used enclosing{CEND}
{COL}double quotes. Here is what would have happened if we hadn't:{CEND}
{BLANK}
{CMD}
{COL}local list "Hello world" "a" "b" "c"{CEND}
{COL}foreach x in `list' {c -(}{CEND}
{COL}	display "`x'"{CEND}
{COL}{c )-}{CEND}
{DEF}
{BLANK}
{COL}{stata `"run "Do/Text boxes.do" "for-loops and macros" 3"':Click here to execute.}{CEND}
{BLANK}
{COL}Do you notice the difference in output? {cmd:macro list}, which shows the values{CEND}
{COL}of macros, is one way to see it. Here, {cmd:`list1'} is the list with the extra{CEND}
{COL}set of double quotes, and {cmd:`list2'} is the list without it:{CEND}
{BLANK}
{COL}{bf:{stata local list1 ""Hello world" "1" "2" "3" "a" "b" "c""}}{CEND}
{COL}{bf:{stata local list2 "Hello world" "1" "2" "3" "a" "b" "c"}}{CEND}
{COL}{bf:{stata macro list _list1 _list2}}{CEND}
{BLANK}
{COL}If {cmd:`list'} is defined without the extra set of double quotes, its own first{CEND}
{COL}and last quotes are removed. This is one of the few situations in which{CEND}
{COL}enclosing double quotes are required. This is because {cmd:`list'} began with a{CEND}
{COL}double quote. However, while not always required, the extra double quotes{CEND}
{COL}are always allowed.{CEND}
{BOTTOM}

There are more advanced ways to use macros. For example:

{TRYITCMD}
local num = 1 * 2 + 3{BR}
display "`num'"
{DEF}

{cmd:local num = 1 * 2 + 3} first evaluates {cmd:1 * 2 + 3},
then stores the result in the local {cmd:`num'}.
Notice the {cmd:=} operator.

Compare this with:

{TRYITCMD}
local num 1 * 2 + 3{BR}
display "`num'"
{DEF}

There's no {cmd:=} operator before the expression, so Stata doesn't evaluate it,
and just stores the string as-is in the local {cmd:`num'}.

{marker counting}{...}
A common use of this feature is counting:

{TRYITCMD}
local i 0{BR}
foreach var of varlist _all {{BR}
	local i = `i' + 1{BR}
}
{DEF} */

display "The dataset has `i' variables."

/*{...}
{TECH}
{COL}{bf:More on macros}{CEND}
{MLINE}
{COL}If you've never read a {help manuals:Stata manual}, and would never intend to otherwise,{CEND}
{COL}you should still read {manlink U 18.3 Macros} in the Stata User's Guide. Especially{CEND}
{COL}if you are an office PA/RA, this section is a must-read about one of the{CEND}
{COL}most important and powerful tools in Stata: macros.{CEND}
{BLANK}
{COL}Afterwards, read more about {help extended_fcn:extended macro functions} and {help macro lists},{CEND}
{COL}advanced macro features.{CEND}
{BOTTOM}

{hline}{marker loops}

{bf:4. More on Loops}

{hline}

{cmd:foreach} isn't the only loop or even the only for-loop in
Stata. For instance, {helpb forvalues} loops over certain {it:numlists}, and especially abbreviated as
{cmd:forv} or {cmd:forval}, is easier to type than {view `"{LOOPS-}##numlist"':foreach of numlist}.
The {helpb while} loop is a more advanced, but useful loop that we'll look at below: 

Instead of designating text/variables/numbers to substitute within the loop, 
{cmd:while} simply sets a condition that must be met for the loop to run. 
You are essentially telling Stata that if X is true, it needs to do Y. 
The syntax is very simple, as follows: 

{CMD}
while x = true {
	do Y
}
{DEF}

Try this loop (with a local thrown in for good measure) if you feel comfortable
with loops so far – it’s a bit more advanced. */  

local i = 1
while  `i' < 15 {
	display "Round `i'"
	local i = `i' + 1
}

/* At the beginning of the loop, `i’ was set to 1.
For the first loop, the {cmd:while} command read: if 1 < 15, 
Stata would display “Round 1”, and then reset `i’ to 2 (one more than it was before). 
Since the condition was in fact met, (1 is less than 15), Stata then cycled through the loop 14 times,
making `i’ first 2, then 3, etc, until `i’ hit 15.
Then, once the condition imposed on the {cmd:while} loop was no longer true 
(15 is not less than 15), Stata stopped performing the operation and moved on to the next command. 

{FOOT}

{GOTOPS}{LOOPS_PS}

{NEXT}{IF}
{PREV}{SUBSCRIPTING}
{START} */
