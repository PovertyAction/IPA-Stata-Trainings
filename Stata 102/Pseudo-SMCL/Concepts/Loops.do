/* {HEAD}

{LOOPS!} */

{USE}
/* 
{view `"{LOOPS-}##introduction"':1. Introduction}{BR}
{view `"{LOOPS-}##foreach"':2. The Foreach Command}{BR}
{view `"{LOOPS-}##writing"':3. Writing a Loop}{BR}
{view `"{LOOPS-}##examples"':4. Loop Examples}{BR}

{hline}{marker introduction}

{bf:1. Introduction}

{hline}

In Stata, loops are used to repeat a command multiple times or to execute
a series of commands that are related. There are several commands that work as loops;
{cmd:foreach} is by far the most widely used, so we will focus on it in this module.
Once you understand the syntax of one of the type of loops, you can learn any of them easily. 

{hline}{marker foreach}

{bf:2. The Foreach Command}

{hline}

The most basic {cmd:foreach} syntax runs in the following way: 

{CMD}
foreach {it:item} in list_item1 list_item2 list_item3 {{BR}
	command `item'{BR}
}
{DEF}

where {it:item} is the {view `"{MACROS-}"':local macro} that is used to signify each item of the list.
So, as Stata loops through the command for each item on the list, it will
substitute each list_item into the macro, performing the following:

{CMD}
command list_item1{BR}
command list_item2{BR}
command list_item3
{DEF}

For example, execute the following loop: */

foreach letter in a b c d {
	display "`letter'"
}

/*Does this output make sense? Here, the command is {cmd:display}, 
a b c d is the list of items we want to loop over, and {it:letter} is
the local macro we want to use to first declare and then call the list. 

{bf:Note:} the opening bracket { has to come at the end of 
the line where the list is declared, and the closing bracket } comes
on a line by itself once the loop is complete. 

Why did Stata output these letters on separate lines? The {cmd:foreach}
command repeatedly sets the local macro `letter' to each element in the list
that follows {bf:in}, executing the commands in the loop for each value
of `letter'. {it:letter} is an arbitrary name, another could have been chosen
and the output of the loop would have been identical. 

{marker whats_in_a_name}{...}
{TECH}
{COL}{bf:What's in a name?}{CEND}
{MLINE}
{COL}The same rules generally apply to all Stata names, whether it's of a{CEND}
{COL}variable, macro, or something else. From {helpb varname:help varname}:{CEND}
{BLANK}
{COL}"Variable names may be 1 to 32 characters long and must start with {cmd:a-z}, {cmd:A-Z},{CEND}
{COL}or {cmd:_}, and the remaining characters may be {cmd:a-z}, {cmd:A-Z}, {cmd:_}, or {cmd:0-9}."{CEND}
{BLANK}
{COL}The exception to this rule is local macros, which may be 1 to 31 characters{CEND}
{COL}long (a character shorter), but may start with {cmd:0-9}.{CEND}
{BOTTOM}

{hline}{marker writing}

{bf:3. Writing a Loop}

{hline}

Imagine we want to write a loop that tabulates 3 variables in our dataset,
say, {bf:literateyn}, {bf:own4wheeleryn}, and {bf:theftfromcaryn}. How might
we go about doing so? We'll introduce here a handy way to go about
writing loops. This process is certainly not a must: the loop we're creating
here is relatively simple, and people write their loops in different ways, 
nonetheless, it should prove useful. 

First write the command as it would be for the first variable in the loop.
In this case: 

{CMD}
tabulate literateyn
{DEF}

Them, we write the loop around it:

{CMD}
foreach _ in ___ {{BR}
	tabulate literateyn{BR}
}
{DEF}

Now, you should see where literateyn and the other list variables should
be placed:

{CMD}
foreach _ in literateyn own4wheeleryn theftfromcaryn {{BR}
	tabulate literateyn{BR}
}
{DEF}

Finally, come up with a name for the local and insert it into the
{view `"{MACROS-}##declaring"':declaration} and calling parts of the loop: */ 

foreach var in literateyn own4wheeleryn theftfromcaryn {
	tabulate `var'
}

/* Remember the importance of putting single quotes around a local macro, 
in this case, {bf:var}, when it is being {view `"{MACROS-}##declaring"':called}. 

Also a quick note about style: notice that the code was indented on the line following
the opening brace while the closing brace stays aligned with {cmd:foreach}. This formatting
makes the code more readable; it's easy to tell what's in the loop and what's not. 
This is an important practice to adopt, especially when using more complex constructions
such as loops within loops. 

{TECH}
{COL}For more tips on Stata programming style, see these resources, available on{CEND}
{COL}Box:{CEND}
{BLANK}
{COL}{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0018":{it:Suggestions on Stata programming style}}{CEND}
{BLANK}
{COL}{browse "http://faculty.chicagobooth.edu/matthew.gentzkow/research/ra_manual_coding.pdf":{it:RA Manual: Notes on Writing Code}}{CEND}
{BOTTOM}

{hline}{marker examples}

{bf:4. Loop Examples}

{hline}

Let's look at a somewhat more complex example of using a loop to help us identify missing values in our
dataset. Execute the following loop:

{TRYITCMD}
foreach var in sex age educ {
	display "Checking `var' for missing values..."
	list hhid `var' if `var' == .
}
{DEF}

Here we loop over the variables {cmd:sex}, {cmd:age}, and {cmd:educ}.
In this dataset, these variables should never have missing values.
For each variable, the loop first displays the variable name as part of a message
({cmd:"Checking `var' for missing values..."}). 
It then lists all values of {cmd:hhid} for which the variable is missing.
Knowing these, we can then examine the problematic observations more closely.

The first element in the list is {cmd:"sex"}.
Thus, the local macro {cmd:`var'} is first set to {cmd:"sex"}.
The commands in the loop are then executed:

{CMD}
display "Checking {ul:`var'} for missing values..."{BR}
list hhid {ul:`var'} if {ul:`var'} == .
{DEF}

The value of {cmd:`var'} is immediately substituted for {cmd:`var'} in the commands,
so this is the same as:

{CMD}
display "Checking {ul:sex} for missing values..."{BR}
list hhid {ul:sex} if {ul:sex} == .
{DEF}

After {cmd:list}, all the commands in the for-loop have been executed,
so {cmd:`var'} is set to the next element in the list: {cmd:"age"} and then finally {cmd:"educ".}

Also note that the contents of a list when using {cmd:foreach...in} do not have to be of 
any specific variable {view `"{TYPES-}"':type}; they can be letters, variables, strings 
or numeric, assuming the command you're using works with it. Again returning to the {cmd:display}
command: */

foreach i in 1 2 3 purple cow "purple cow" {
	display "`i'"
}

/* In this module, we have only discussed one particular variation of the {cmd:foreach} command,
specifically {cmd:foreach...in}. In {bf: Stata 103} we'll discuss using
{cmd: of varlist} and {cmd: of numlist} along with {cmd:foreach} for added functionality.
As always, feel free to check out the {cmd:foreach} {help foreach:help file} to learn more
about the command. 

{FOOT}

{GOTOPS}{LOOPS_PS}

{NEXT}{IMPORTING}
{PREV}{MACROS}
{START} */
