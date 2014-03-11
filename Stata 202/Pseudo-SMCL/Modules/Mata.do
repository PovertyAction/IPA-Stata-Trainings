/* {HEAD}

{MATA!}

{help Mata} is Stata's matrix programming language.
This module will briefly highlight the advantages of Mata,
presenting examples of Mata along the way.
We will touch on these topics:

{view `"{MATA-}##what_is_mata"':1. What is Mata?}{BR}
{view `"{MATA-}##speed"':2. Mata for speed}{BR}
{view `"{MATA-}##data_structures"':3. Mata for data structures}{BR}
{view `"{MATA-}##strings"':4. Mata for strings}{BR}
{view `"{MATA-}##wrapping_up"':5. Wrapping up}{BR}

{hline}{marker what_is_mata}

1. What is Mata?

{hline}

Mata is a full-fledged programming language with a C-like syntax that
was designed with matrix operations in mind.
It offers the robustness and speed of other programming languages,
but it integrates easily with Stata.

To enter Mata, type {cmd:mata}: */

mata
MATACMD

* In Mata, you can enter an expression to see its result:

1 + 1

* To exit Mata, type {cmd:end}:

end
STATACMD

/* Mata does not have commands;
rather, everything is implemented through {it:functions}
(which you can spot from their telltale parentheses).

Below, we create a single variable and {cmd:sort} it.
First we do it in Stata, then in Mata.

Stata version */

* {cmd:* Create variable.}
clear
set obs 10
gen x = 100 - _n ^ 2
list

* {cmd:* Sort it.}
sort x
list

* Mata version

mata
MATACMD

* {cmd:* Create variable.}
x = 100 :- (1::10):^2
x

* {cmd:* Sort it.}
x = sort(x, 1)
x

end
STATACMD

/* {cmd:sort} in Stata is {cmd:sort()} in Mata.

Mata has no {help macro:macros}: there are no locals or globals.
Everything, from single values to large matrices, are stored in {it:variables}.
These bear the same name as Stata variables,
but there is no real relation.

As there are no macros, for-loops look dramatically different: */

* {cmd:* Stata version}

forvalues i = 1/10 {
	replace x = x + `i'
}

list

* {cmd:* Mata version}

mata
MATACMD

{BLOCK}for (i = 1; i <= 10; i++)
	{BLOCK}x = x :+ i

x

end
STATACMD

/* Mata has a very different syntax from Stata,
and there is an upfront cost to learning it rather than
sticking wholly to Stata.
Next, we discuss the circumstances under which Mata's benefits may
justify the cost.

{hline}{marker speed}

2. Mata for speed

{hline}

Most of our work is well suited to Stata.
What's better than being able to execute complex estimation commands with
a simple syntax? */

sysuse auto, clear
regress weight length

/* Fantastic!

Stata has a {help language:basic language syntax} to which many commands adhere.
Yet the syntax of many other commands differ from this, and
Stata's flexible syntactical rules permit this.

The lack of a rigid global syntax means that
macros become a key part of work in Stata.

Macros are convenient, but they have downsides:{BR}
- They are relatively slow.{BR}
- They make it hard to work with difficult strings.

Let's see some examples of these.

Here is an example of the Stata/Mata speed difference,
borrowed from the blog
{browse "http://www.econometricsbysimulation.com/2012/09/mata-speed-gains-over-stata.html":Econometrics by Simulation}.
We will calculate the sum of many squares, first in Stata, then in Mata.

Stata */

{BLOCK}timer clear 1
{BLOCK}timer on 1
{BLOCK}
{BLOCK}local x2 0
{BLOCK}forvalues i = 1/1000000 {
	{BLOCK}local x2 = `x2' + `i'^2
{BLOCK}}
{BLOCK}
{BLOCK}timer off 1
{BLOCK}timer list 1
{BLOCK}
{BLOCK}display `x2'

* Mata

mata
MATACMD

{BLOCK}timer_clear(1)
{BLOCK}timer_on(1)
{BLOCK}
{BLOCK}x2 = 0
{BLOCK}for (i = 1; i <= 1000000; i++)
	{BLOCK}x2 = x2 + i^2
{BLOCK}
{BLOCK}timer_off(1)
{BLOCK}timer(1)
{BLOCK}
{BLOCK}x2

end
STATACMD

/* Mata is many times faster than Stata.

Mata is also much stronger at recursion than Stata.

If an algorithm is very slow in Stata, or if you are considering recursion,
you may wish to implement the algorithm in Mata instead.

{hline}{marker data_structures}

3. Mata for data structures

{hline}

A much cited fault of Stata is that
you can have only one dataset open in memory.
Mata does not have this requirement:
you may define as many Mata variables of whatever type as
your machine can handle {hline 2}
even if each variable is itself a dataset.

Since it is possible to easily move objects from Stata to Mata and back again,
this means that you can load a dataset in Stata,
save it to Mata,
load another dataset,
save it to Mata,
then have both accessible in Mata.
For instance: */

sysuse cancer, clear

mata
MATACMD
* {cmd:* Store the Stata dataset in the Mata variable cancer.}
cancer = st_data(., .)
end
STATACMD

sysuse voter, clear

mata
MATACMD
voter = st_data(., .)
end
STATACMD

clear

* There is no Stata dataset in memory,
* yet Mata still has access to both datasets:

mata
MATACMD
cancer
voter
end
STATACMD

/* Another complaint is that Stata supports only rectangular data,
resulting in endless {cmd:reshape}s and {cmd:merge}s.
On the other hand, Mata offers
{help [M-2] struct:structures},
{help [M-2] class:object-oriented classes},
and {help [M-2] pointers:pointers}.
Mata allows vectors and matrices of all data types.
This means that macro lists stored as strings,
which require parsing, can be a relic of the past:
Mata has its own lists, lists of lists, hash tables, and so on.

{hline}{marker strings}

4. Mata for strings

{hline}

Stata has a difficult time manipulating strings that
contain characters with a special meaning to Stata, for instance,
{cmd:`}, {cmd:$}, {cmd:"}, and {cmd:\}.

These characters are uncommon, but they are by no means impossible:
enumerators sometimes enter {cmd:`} instead of {cmd:'}, and
{cmd:$} appears in some Windows filenames.

If you are forced to deal with such strings, your best bet is Mata.
For instance, if you are looping over files with difficult filenames
or parsing files that contain difficult characters,
Mata is an excellent choice.

{hline}{marker wrapping_up}

5. Wrapping up

{hline}

Consider using Mata if...{BR}
- You are manipulating matrices:
Mata has many more matrix operations than Stata.{BR}
- You are working with difficult strings{BR}
- You are manipulating files and their contents{BR}
- You are running a custom algorithm that is slow in Stata{BR}
- You are using heavy-duty recursion{BR}
- You would like access to more than one dataset at once{BR}
- You require a data structure more complex than rectangular data

If you would like to learn more about Mata,
the {help mata:Mata help} is fantastic,
and will walk you through step by step from the beginning.
Start with {helpb m1_first:help m1_first}. */

