/* {HEAD}

{IF!} */

{USE}

/* Let's return to the {view `"{SUBSCRIPTING-}##loop"':loop from the module on explicit subscripting}: */

foreach var of varlist _all {
	display "`var'"
	display `var'[{VAR1}]
	display `var'[{VAR2}]
	display
}

/* {marker loop}{...}
We probably don't want to see all this output.
Instead, we could use the {help ifcmd:{bf:if} command} to show only differences: */

foreach var of varlist _all {
	if `var'[{VAR1}] != `var'[{VAR2}] {
		display "The two observations of 1802011 differ on `var'."
	}
}

/* You may never have seen {cmd:if} used this way.
This is the {cmd:if} command,
different from the {help if:{bf:if} "qualifier"} that you've all seen.
The {cmd:if} command is a stand-alone command;
it's not tacked on to the end of another command.
It evaluates a logical expression, and then if (and only if) the expression is true,
it executes the block of commands that follows it.
This block is enclosed by the braces {cmd}{{txt} and {cmd}}{txt}
(as with {view `"{LOOPS-}"':{bf:foreach}}).
Above, the block contains just one command: {cmd:display}.

In contrast, the {cmd:if} qualifier is appended to commands that allow it, and means
that the command should limit itself to observations that satisfy the condition
that follows {cmd:if}.

We could try rewriting the loop using the {cmd:if} qualifier: */

foreach var of varlist _all {
	display "The two observations of 1802011 differ on `var'." if `var'[{VAR1}] != `var'[{VAR2}]
}

/* Oops. Why didn't that work? It's because {cmd:display} doesn't allow the {cmd:if}
qualifier. This is because {cmd:display} doesn't do work with any observations, so
it doesn't make sense to limit its effects to a subset of them.

To tell whether a command allows the {cmd:if} qualifier, look at its help file.
If it does, you'll see [{it:{help if}}] on the first line of the Syntax section.
For example,
look at {helpb display:help display}:
there's no [{it:{help if}}].
Now look at {helpb summarize:help summarize}: it's
there. Even without looking at the help file, most of the time you should be
able to figure it out conceptually by asking whether it makes sense to limit the
command to a subset of the data. While this doesn't make sense for {cmd:display},
it does for {cmd:summarize}.

Let's look at another example highlighting the difference between the {cmd:if}
command and the {cmd:if} qualifier. Say we want to summarize the variable {cmd:age} for
men ({cmd:sex == 1}):

{TRYITCMD}
summarize age if sex == 1
{DEF}

Here we've used the {cmd:if} qualifier (after {cmd:summarize}) rather than the {cmd:if}
command (which would have come before {cmd:summarize}) because we just want the {cmd:if}
to limit the command to a subset (observations for which {cmd:sex == 1}). This is exactly
the function of the {cmd:if} qualifier. Compare this with:

{TRYITCMD}
if 1 + 1 == 2 {{BR}
	summarize age{BR}
}
{DEF}

The logical expression {cmd:1 + 1 == 2} is evaluated as true, so the {cmd:summarize} command is executed.
But the subset of the data that {cmd:summarize} uses isn't limited in any way.

What would happen if you executed the following:

{TRYITCMD}
if sex == 1 {{BR}
	summarize age{BR}
}
{DEF}

The {cmd:if} command evaluates a logical expression,
and here compares {it:one} value of {cmd:sex} {hline 2} not the entire variable {hline 2}
with another value, {cmd:1}.
If {cmd:sex} here doesn't represent the entire variable {cmd:sex}, what is it?
The {cmd:if} command requires it to be a single value,
so it assumes you meant the first observation of {cmd:sex}.
So the above {cmd:if} block is the same as: */

if sex[1] == 1 {
	summarize age
}

/* This means that {cmd:summarize age} (without any subset limitations) will be
executed if and only if the first observation of the variable {cmd:sex} equals {cmd:1}. This
isn't what we're trying to do.

If you're wondering in a given situation whether to use the {cmd:if} command or the
{cmd:if} qualifier, first, chances are you want the {cmd:if} qualifier. If you want to
limit a command's effects to a subset of the data, that's the {cmd:if} qualifier.
If instead you want to execute a block of commands if and only if a logical
expression is true, that's the {cmd:if} command. Time for a pop quiz: */

{IF_Q1}

/* {hline}

Above, we used the {cmd:if} command to {cmd:display} under certain conditions: */

foreach var of varlist _all {
	if `var'[{VAR1}] != `var'[{VAR2}] {
		display "The two observations of 1802011 differ on `var'."
	}
}

/* A question before an exercise: Do you remember where {cmd:{VAR1}} and {cmd:{VAR2}} came from?

{NEW46}

These are the observation numbers of the two observations with {cmd:hhid "1802011"}.

Touching on style, notice above that for every left brace, I indented once.
My code stays indented until the right brace.
Thus, it's easy to tell what's in the loop and what's not, and what's in the {cmd:if} block and what's not. */

{IF_Q3}

/* {hline}

{TOP}
{COL}{bf:More on if}{CEND}
{MLINE}
{COL}For more on the difference between the {cmd:if} command and {cmd:if} qualifier, see {browse "http://www.stata.com/support/faqs/programming/if-command-versus-if-qualifier/":this}{CEND}
{COL}{browse "http://www.stata.com/support/faqs/programming/if-command-versus-if-qualifier/":StataCorp FAQ}.{CEND}
{BOTTOM}

{FOOT}

{GOTOPS}{IF_PS}

{NEXT}{BIGN}
{PREV}{LOOPS}
{START} */
