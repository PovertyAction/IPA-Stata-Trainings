/* {HEAD}

{DUMMIES!} */

{USE}

/* Suppose you want to create a dummy variable named {cmd:female} that is {cmd:1} if the
respondent is female ({cmd:sex == 2}) and {cmd:0} otherwise. One way to do this is: */

generate female = 0
replace  female = 1 if sex == 2

tabulate sex female

drop female

* However, there's a way to combine these two lines:

/* {...}
{TRYITCMD}
generate female = sex == 2
{DEF} */

tabulate sex female

drop female

/* The expression after the {cmd:=} operator, {cmd:sex == 2},
is a {it:logical expression}.
A logical expression equals {cmd:1} if it is true and {cmd:0} if it is false.
Thus, above, {cmd:female = 1} if {cmd:sex == 2} is true,
and {cmd:female = 0} if {cmd:sex == 2} is false.

Here are examples of other logical expressions:

{TRYITCMD}
local x = 1 + 1 == 2{BR}
display `x'{BR}
local x = 1 + 2 == 4{BR}
display `x'{BR}
local x = (1 + 1 == 2) + (1 + 2 == 4){BR}
display `x'
{DEF}

Let's analyze the last definition of {cmd:`x'}.
Logical expressions evaluate to {cmd:1} or {cmd:0}.
{cmd:(1 + 1 == 2) + (1 + 2 == 4)} contains two logical expressions,
{cmd:1 + 1 == 2} and {cmd:1 + 2 == 4},
each of which evaluates to {cmd:1} or {cmd:0}.
The results from the two logical expressions are then summed.
Thus, {cmd:(1 + 1 == 2) + (1 + 2 == 4)} could take on three values:
{cmd:0}, if both expressions are false;
{cmd:1}, if one expression is true and the other is false;
and {cmd:2}, if both expressions are true.
Here, {cmd:1 + 1 == 2} is true ({cmd:1}), but {cmd:1 + 2 == 4} is false ({cmd:0}), so
{cmd:(1 + 1 == 2) + (1 + 2 == 4)} equals {cmd:1}.

{TECH}
{COL}We used a logical expression to create {cmd:female}:{CEND}
{BLANK}
{COL}{bf:{stata generate female = sex == 2}}{CEND}
{BLANK}
{COL}{bf:{stata drop female}}{CEND}
{BLANK}
{COL}If you know {helpb cond()}, this is equivalent to:{CEND}
{BLANK}
{COL}{bf:{stata generate female = cond(sex == 2, 1, 0)}}{CEND}
{BLANK}
{COL}You can see the logical expression contained within {cmd:cond()}:{CEND}
{BLANK}
{COL}{cmd:generate female = cond({ul:sex == 2}, 1, 0)}{CEND}
{BOTTOM}

Another place where logical expressions are common is after
the {bf:if qualifier}. 
The expression that follows {cmd:if} in a command
is a logical expression.

Referring back to {bf:Variable Properties} module in {bf:Stata 103}, remember that you can use
{help fvvarlist:factor variables} to act as dummies in a regression without having to
create a single dummy variable. As some commands don't allow factor varibles, the {helpb xi}
prefix can also be used. It creates dummies for use outside a single command, and can be more 
convenient than the equivalent for factor variables, {helpb fvrevar}. Unlike factor
variables, {cmd:xi} works with string variables in addition to numeric. 

{FOOT}

{NEXT}{RESULTS}
{PREV}{INTRO}
{START} */
