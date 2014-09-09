/* {HEAD}

{RESHAPE!}

In this module, I will discuss advanced uses of {helpb reshape}.
I will touch on these two uses:

{view `"{RESHAPE-}##sort_across"':1. Sorting across variables}{BR}
{view `"{RESHAPE-}##list_vars"':2. Manipulating variables that are lists}

{hline}{marker preface}

{bf:Preface: A reshape warm-up}

{hline}

We are about to discuss exciting ways to use the {cmd:reshape} command.
Before that, let's stretch our {cmd:reshape} muscles. */

use {DATA_HH}, clear

describe
browse

/* We have loaded a household dataset:
every observation is a household,
and many variables are repeated for each household member.
For example, {cmd:age1} is the age of household member {cmd:1},
{cmd:age2} is the age of member {cmd:2}, and so on.

How can we use {cmd:reshape} to transform the data to
a member-level dataset
in which every observation is not a household,
but rather a household {it:member}?
In the new dataset, there will be a single {cmd:age} variable.

{NEW46} */

reshape long age female married, i(hhid) j(memid)

/* How do we {cmd:reshape} it back,
transforming the member-level dataset to a household dataset?

{NEW46} */

reshape wide age female married, i(hhid) j(memid)

/* How could we use {cmd:reshape}
as part of code to list all household members
who are younger than {cmd:10} but recorded as married?
Is this any easier than looping over the household member variables?

{NEW46} */

reshape long age female married, i(hhid) j(memid)
list if age < 10 & married

/* {hline}{marker sort_across}

{bf:1. Sorting across variables}

{hline}

This is an actual request from {help Statalist}. Danny Tu writes:

"I would like to re-structure my panel data
which currently sit in the fixed column format ... to left adjusted format."

Danny wants to transform this dataset: */

{BLOCK}clear
{BLOCK}input id f1 f2 f3 f4 f5 f6
{BLOCK}1 . 12 23 . . 56
{BLOCK}2 . 62 . . . .
{BLOCK}3 881 . 453 34 55 .
{BLOCK}4 . 92 . . . .
{BLOCK}5 . 62 . . . .
{BLOCK}6 . . . . . 67
{BLOCK}7 91 . . . 87 .
{BLOCK}8 . . . 66 . .
{BLOCK}9 . . 53 . . 76
{BLOCK}end

browse

* To this one:

{BLOCK}clear
{BLOCK}input id f1 f2 f3 f4 f5 f6
{BLOCK}1 12 23 56 . . .
{BLOCK}2 62 . . . . .
{BLOCK}3 881 453 34 55 . .
{BLOCK}4 92 . . . . .
{BLOCK}5 62 . . . . .
{BLOCK}6 67 . . . . .
{BLOCK}7 91 87 . . . .
{BLOCK}8 66 . . . . .
{BLOCK}9 53 76 . . . .
{BLOCK}end

browse

/* Danny talks about "left alignment,"
but another way to think about the task is
that Danny wants to sort {it:across} the {cmd:f} variables.
First, he wants to sort the missing {cmd:f} values after the nonmissing ones,
then he wants to sort the nonmissing {cmd:f} values
according to their original relative order.

Another way to make this point is through transposing the dataset.
As an example, we will transpose one observation using {helpb xpose},
sort it according to Danny's rules,
then transpose it back.
The desired results are achieved.
(Don't worry about learning {cmd:xpose} well:
we will soon learn a superior alternative {hline 2} any guesses what?)

{stata run Do/Modules/reshape 1:Click here to input the original dataset.} */

keep in 1

browse

xpose, clear varname

browse

generate id = _varname == "id"
generate miss = missing(v1)
generate n = _n
gsort -id miss n
drop id miss n

browse

* {cmd:_varname} needs to be changed so that the new sort order sticks
* after the second tranpose:

replace _varname = "f" + string(_n - 1) in 2/L

browse

xpose, clear

browse

/* Thinking about the left-right sort (a sort {it:across},
not {it:within} variables) as tranpose-sort-tranpose was
so compelling to me that after deciding that transposing in Stata
was too laborious,
my response to Danny involved transposing then sorting using Mata.

Neither Stata nor Mata has a simple command or function for
left-right sorting.
Transposing becomes appealing simply as a means of
transforming the dataset to one for which
{cmd:sort}, {cmd:gsort}, and other sorting tools are useful.

So is Mata the solution for Danny?
Well, it's probably telling that this module is on {cmd:reshape}, not Mata.
It turned out that a much easier solution was possible with {cmd:reshape}:

{stata run Do/Modules/reshape 1:Click here to input the original dataset.} */

reshape long f, i(id)

browse

/* One way to think about this structure is
that each observation has been transposed separately
and then stacked together.
You can think of it as the result of {cmd:xpose} for each observation
appended together,
where {cmd:_varname} has been replaced by an index for variables
(a variable unique ID), {cmd:_j}. */

generate miss = missing(f)
sort id miss _j
drop miss

browse

/* Just as with {cmd:xpose} when we needed to change {cmd:_varname},
we now need to change {cmd:_j} so that the new sort order remains
when we {cmd:reshape wide}, transposing back. */

drop _j
by id: generate j = _n

browse

reshape wide f, i(id) j(j)

browse

{RESHAPE_Q1}

/* {hline}

{NEW46}

{hline}{marker list_vars}

{bf:2. Manipulating variables that are lists}

{hline}

This variant on the Olympics dataset has a variable named {cmd:sports} that
is the list of a country's medaling sports: */

use {DATA_OLYMPICS2}, clear

browse

/* However, again, the order of the sports is a mess.

By first {helpb split}ting the variable,
we can use the same steps as Question 1 to recreate the variable: */

rename sports sport
split sport, parse(", ")
drop sport
destring sport*, replace

browse

reshape long sport, i(country year)
drop if missing(sport)

browse

sort country year sport

browse

* Now recreating {cmd:sports} from {cmd:sport}:

generate sports = ""

by country year (sport): replace sports = sports[_n - 1] + ///
	cond(missing(sports[_n - 1]), "", ", ") + string(sport)

browse

by country year (sport): replace sports = sports[_N]

browse

* And finally, the second {cmd:reshape}:

reshape wide sport, i(country year) j(_j)

keep country year sports

browse

/* {cmd:sports} was a variable whose values were themselves lists.
Using {cmd:reshape}, we sorted those lists.
We have now seen two different uses of {cmd:reshape} for atypical sorting. */

{RESHAPE_Q2}

/* {hline}

{NEW46}

You can count on {cmd:reshape} to manipulate variables that are lists.
However, in some cases, a loop might suffice: */

use {DATA_S2Q8}, clear

replace s2_q8 = " " + s2_q8 + " "

browse

forvalues i = 1/12 {
	generate s2_q8_`i' = strpos(s2_q8, " " + string(`i') + " ") != 0
}

browse

replace s2_q8 = strtrim(s2_q8)

browse
