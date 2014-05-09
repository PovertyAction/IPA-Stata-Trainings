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




{FOOT}

{NEXT}{IMPORTING}
{PREV}{MACROS}
{START} */
