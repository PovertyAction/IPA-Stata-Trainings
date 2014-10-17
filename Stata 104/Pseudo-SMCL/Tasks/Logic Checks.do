/* {HEAD}

{LOGICCHECKS!} */

{USE}

/* After the data is organized
through managing variable properties
and {view `"{RECODING-}"':recoding},
and the most important check {hline 2}
that of the unique ID {hline 2}
is complete,
it's time for other data checks.

A broad category of such checks are {it:logic checks}.
These examine whether the data makes sense conceptually and looks as expected.
Is it reasonable that this variable has such and such a value?
Is it reasonable given that this other variable has such and such a value?

Skip patterns are one object of logic checks.
A skip pattern specifies that a question will not be asked
because of the responses to one or more previous questions.
For example:

{TOP}
{COL}{cmd:own4wheeleryn}{CEND}
{MLINE}
{COL}Has anyone in your household had for private use any car, van, tractor, bus,{CEND}
{COL}3 wheeler, or truck?{CEND}
{BLANK}
{COL}{cmd:1}{space 2}Yes{CEND}
{COL}{cmd:2}{space 2}No (skip to {cmd:own2wheeleryn}){CEND}
{COL}{cmd:.d} Don't know (skip to {cmd:own2wheeleryn}){CEND}
{COL}{cmd:.r} Refuse to answer (skip to {cmd:own2wheeleryn}){CEND}
{BOTTOM}

{TOP}
{COL}{cmd:own4wheelernum}{CEND}
{MLINE}
{COL}How many vehicles have you had most of the time?{CEND}
{BOTTOM}

{TOP}
{COL}{cmd:own2wheeleryn}{CEND}
{MLINE}
{COL}Has anyone in your household owned a moped, motor scooter, or motorcycle?{CEND}
{BLANK}
{COL}{cmd:1}  Yes{CEND}
{COL}{cmd:2}  No{CEND}
{COL}{cmd:.d} Don't know{CEND}
{COL}{cmd:.r} Refuse to answer{CEND}
{BOTTOM}

Here, there are two ways the skip pattern could be violated:

1. {cmd:own4wheeleryn == 1}, but {cmd:own4wheelernum} is {cmd:"."}.{BR}
2. {cmd:own4wheeleryn == 2}, {cmd:.d}, or {cmd:.r},
but {cmd:own4wheelernum} is not {cmd:"."}.

How do you check this in Stata?

{TRYITCMD}
assert own4wheelernum != . if own4wheeleryn == 1{BR}
assert own4wheelernum == . if own4wheeleryn == 2
{DEF}

{helpb assert} evaluates a logical expression.
If the logical expression is true for all observations, nothing happens.
Otherwise, {cmd:assert} results in an error.
{cmd:assert} is similar to {cmd:isid} in this way:
you declare an assumption {hline 2}
in this case, that {cmd:own4wheelernum != . if own4wheeleryn == 1},
and with {cmd:isid}, that a variable list uniquely identifies observations {hline 2}
and if the assumption is false, Stata results in an error;
otherwise it does nothing.

Unlike commands like {cmd:summarize} or {cmd:tabulate},
you never have to review the results of {cmd:assert}.
Either your assumption is true and no results were displayed,
or your assumption was false and your do-file stopped with an error.

{TECH}
{COL}Above, we used two lines to check the skip pattern:{CEND}
{BLANK}
{COL}{bf:{stata assert own4wheelernum != . if own4wheeleryn == 1}}{CEND}
{COL}{bf:{stata assert own4wheelernum == . if own4wheeleryn == 2}}{CEND}
{BLANK}
{COL}We could have combined them into one:{CEND}
{BLANK}
{COL}{bf:{stata assert (own4wheeleryn == 1) + (own4wheelernum != .) != 1}}{CEND}
{BLANK}
{COL}Logical expressions evaluate to either {bf:1} or {bf:0}. Each logical expression in{CEND}
{COL}the command evaluates to {cmd:1} or {cmd:0}, then those results are summed. So{CEND}
{COL}{cmd:(own4wheeleryn == 1) + (own4wheelernum != .)} can take on three values: {cmd:0}, if{CEND}
{COL}both expressions are false; {cmd:1}, if one expression is true and the other is{CEND}
{COL}false; and {cmd:2}, if both expressions are true. These conditions should go hand{CEND}
{COL}in hand, so we'd expect {cmd:0} or {cmd:2}, but not {cmd:1} {hline 2} and that's what the command{CEND}
{COL}checks.{CEND}
{BLANK}
{COL}We've reduced two lines to one, but it required many more lines of{CEND}
{COL}explanation. In this case, it might be easiest to keep the check as two{CEND}
{COL}lines.{CEND}
{BOTTOM} */

{LOGICCHECKS_Q5}

/* {hline}

Whenever you find data that doesn't make sense,
you should first check with field staff, including enumerators and data entry operators,
to see if there's a simple explanation
of the problem. If you're still unsure of the cause, you should discuss what to
do with your supervisor. It is not appropriate to modify illogical data without
first making an effort to understand the problem and informing your supervisor
of the changes.

{marker dummy}{...}
There's no way you can miss it when {cmd:assert} informs you with an error
that there's a problem with your data.
However, if you want to complete these checks without seeing error messages,
you have a few options.
For many of them, it's helpful to create a dummy variable
that is {cmd:1} if there is a data issue and {cmd:0} otherwise. */

generate problem = 0
replace  problem = 1 if own4wheeleryn == 1 & own4wheelernum == .
replace  problem = 1 if own4wheeleryn == 2 & own4wheelernum != .

browse hhid own4wheeleryn own4wheelernum if problem

list hhid own4wheeleryn own4wheelernum if problem

tabulate own4wheeleryn own4wheelernum if problem, missing

/* {marker capture}{...}
Alternatively, you can use {helpb capture}.
If you prefix a command with {cmd:capture}, the command will never result in an error.
This doesn't mean that errors go away;
a command that didn't work before still won't work,
but the error message is suppressed,
and within a do-file, Stata will continue to the next command without stopping.
For example, suppose we forgot the double quotes needed for {cmd:display}:

{TRYITCMD}
display "Hello world!"{BR}
display Hello world!{BR}
capture display Hello world!
{DEF}

{cmd:display Hello world!} resulted in an error,
but when we added {cmd:capture}, it was suppressed.
{cmd:capture} suppresses not just error messages, but all output.
Even if a command does not result in an error,
{cmd:capture} will suppress its output. For example:

{TRYITCMD}
display "Hello world!"{BR}
capture display "Hello world!"
{DEF}

We know that the {cmd:assert} commands from the start result in errors,
so we can use {cmd:capture} to suppress the error messages:

{TRYITCMD}
capture assert own4wheelernum != . if own4wheeleryn == 1
{DEF}

This seems a little pointless,
since now we can't tell whether the {cmd:assert}ions are true.

However, there are two ways to learn about the result of a command
while using {cmd:capture}.

The first is {helpb noisily}.
When you add {cmd:noisily} after {cmd:capture},
{cmd:capture} no longer suppresses output:

{TRYITCMD}
capture noisily assert own4wheelernum != . if own4wheeleryn == 1
{DEF}

There is still no error,
and a do-file would not stop at this line,
but the command's output, including its error message, is shown.

The second way to learn about the results is {helpb _rc}.
There are two possibilities for a command prefixed by {cmd:capture}:
either it results in an error or it doesn't.
If it does, Stata issues an error message associated with a number,
called the {ul:r}eturn {ul:c}ode (of which {cmd:_rc} is an abbreviation).
For example, the following command results in an error
with a return code of {cmd:111}: */

display Hello world!

/* Prefixing this command with {cmd:capture} stores the return code in {cmd:_rc}:

{TRYITCMD}
capture display Hello world!{BR}
display _rc
{DEF}

If a command doesn't result in an error, {cmd:_rc} equals {cmd:0}: */

capture display "Hello world!"
display _rc

/* If a command is not prefixed by {cmd:capture},
the return code is not stored in {cmd:_rc}:
{cmd:_rc} is always the return code from the latest command
with which {cmd:capture} was used.
The following command results in an error with return code {cmd:111},
but because it is not prefixed by {cmd:capture},
{cmd:_rc} remains {cmd:0} from the last {cmd:capture} command: */

display Hello world!
display _rc

{LOGICCHECKS_Q6}

/* {hline}

We can use {cmd:capture} and {cmd:_rc}
to learn about the results of {cmd:assert}
while suppressing any errors. For example: */

capture assert own4wheelernum != . if own4wheeleryn == 1
display _rc
capture assert own4wheelernum == . if own4wheeleryn == 2
display _rc

/* We will now turn briefly from checks of skip patterns and logical consistency
to say more about {cmd:capture}.

You wouldn't use {cmd:capture} if you knew a command wouldn't result in an error:
there'd be no point.
Similarly, you wouldn't use {cmd:capture}
if you knew a command {it:would} result in an error.
{cmd:capture} is helpful when you're not sure whether a command will succeed.

For example, suppose you want to loop through a list of .dta files,
dropping the personally identifiable information (PII) variable {cmd:gps} in each.
But suppose only some of the datasets contain the variable {cmd:gps}.
You could use the following loop:

{CMD}
foreach dta in `dtas' {{BR}
	use "`dta'", clear{BR}
	capture drop gps{BR}
	save "`dta' - no PII", replace{BR}
}
{DEF}

If {cmd:gps} (or other variables that begin with {cmd:gps}) exist in the dataset, they are dropped.
If they are not, {cmd:drop} results in an error, but you don't see the error message,
and the loop continues unimpeded.

{TECH}
{COL}In a {view `"{RESULTS-}##q5"':problem set question of the saved results module}, we asked which{CEND}
{COL}combinations of two numeric variables uniquely identified observations{CEND}
{COL}(after dropping the exact copy of {cmd:hhid "1807077"}). {view `"{RESULTS_ANSWERS-}##q5"':One way} to find out was:{CEND}
{BLANK}
{COL}{bf:{stata {USE}}}{CEND}
{BLANK}
{COL}{bf:{stata duplicates drop}}{CEND}
{BLANK}
{CMD}
{COL}ds, has(type numeric){CEND}
{COL}local numvars `r(varlist)'{CEND}
{COL}foreach var1 in `numvars' {c -(}{CEND}
{COL}    foreach var2 in `numvars' {c -(}{CEND}
{COL}        if "`var1'" != "`var2'" {c -(}{CEND}
{COL}            quietly duplicates tag `var1' `var2', generate(dup){CEND}
{COL}            quietly count if dup > 0{CEND}
{COL}            if r(N) == 0 {c -(}{CEND}
{COL}                display "`var1' `var2' uniquely identify observations."{CEND}
{COL}            {c )-}{CEND}
{COL}            drop dup{CEND}
{COL}        {c )-}{CEND}
{COL}    {c )-}{CEND}
{COL}{c )-}{CEND}
{DEF}
{BLANK}
{COL}{stata `"run "Do/Text boxes.do" "logic checks" 1"':Click here to execute.}{CEND}
{BLANK}
{COL}A much faster alternative uses the combination of {cmd:isid} and {cmd:capture}:{CEND}
{BLANK}
{CMD}
{COL}ds, has(type numeric){CEND}
{COL}local numvars `r(varlist)'{CEND}
{COL}foreach var1 in `numvars' {c -(}{CEND}
{COL}    foreach var2 in `numvars' {c -(}{CEND}
{COL}        if "`var1'" != "`var2'" {c -(}{CEND}
{COL}            capture isid `var1' `var2'{CEND}
{COL}            if _rc == 0 {c -(}{CEND}
{COL}                display "`var1' `var2' uniquely identify observations."{CEND}
{COL}            {c )-}{CEND}
{COL}        {c )-}{CEND}
{COL}    {c )-}{CEND}
{COL}{c )-}{CEND}
{DEF}
{BLANK}
{COL}{stata `"run "Do/Text boxes.do" "logic checks" 2"':Click here to execute.}{CEND}
{BLANK}
{COL}Here, after {cmd:capture isid `var1' `var2'}, {cmd:_rc == 0} if and only if the command{CEND}
{COL}did not result in an error, that is, if and only if {cmd:`var1'} {cmd:`var2'} uniquely{CEND}
{COL}identifies observations.{CEND}
{BOTTOM}

{FOOT}

{GOTOPS}{LOGICCHECKS_PS}

{NEXT}{OTHERCHECKS}
{PREV}{RECODING}
{START} */
