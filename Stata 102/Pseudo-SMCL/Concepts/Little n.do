/* {HEAD}

{LITTLEN!} */

{USE}

/* {helpb _n} is the observation number according to the current sort order.
For example:

{TRYITCMD}
{cmd:* Variable order will equal the observation number.}{BR}
generate order = _n
{DEF} */

browse order
* {cmd:* Change the sort order.}
sort sex
* {cmd:* Since the sort order has changed, order is jumbled.}
browse order
* {cmd:* Restore the initial sort order.}
sort order
browse order

/* {helpb _n} changes every time you sort, 
so you should never use it in combination with {cmd:generate}, {cmd:drop}, or other 
commands without explicitly sorting by a unique variable first.
Note that the variable for sort has to be a unique ID – if you sort by a non-unique variable (say household ID),
the individual observations will be randomized within it. 
When you then proceed to, for example, drop the 1st observation in each household,
the observation dropped will be different each time you re-run the dofile. 
This is a mistake that can lead to significant issues with your cleaning down the line.  

{cmd:_n} is different from {BIGN...}:
while {cmd:_n} is the observation number
and therefore changes from observation to observation,
{cmd:_N} is constant as long as the number of observations stays the same.
They are similar in the sense that both are built-in system variables.
They do not need to be created, unlike the {view `"{LOOPS-}"':locals} you've
seen previously, rather, they are automatically generated and updated by Stata.

We can use {cmd:_n} to refer to the previous observation, the one two previous,
the next observation, and so on.
For example, the following code creates a variable
that equals the {cmd:hhid} of the previous observation:

{TRYITCMD}
generate previousid = hhid[_n - 1]
{DEF} */

browse hhid previousid

/* Note the value of {cmd:previousid} in the first observation,
for which {cmd:_n == 1}.
{cmd:previousid[1]} was defined as {cmd:hhid[0]},
which doesn't exist, so
{cmd:previousid[1]} was set to missing.

We can use {cmd:_n}
as part of our favorite check:
that of the {view `"{DUPLICATES-}"':unique ID}.
The code below creates a dummy variable named {cmd:iddup}:

{TRYITCMD}
sort hhid{BR}
generate iddup = hhid == hhid[_n - 1]
{DEF} */

{LITTLEN_Q2}

/* {hline}

How would {cmd:iddup} perform as an indicator
that an observation is a duplicate on {cmd:hhid}?

{NEW46}

{cmd:iddup} can correctly give us the number of observations that are "surplus"
in the sense that they are the second or third or fourth copy
of the first observation of each group of duplicates.
In other words,
{cmd:iddup} indicates the number of observations
that {cmd:hhid} is from being unique. */

count if iddup > 0

* However, not all duplicates have {cmd:iddup == 1}:

duplicates tag hhid, gen(duptag)

list hhid iddup duptag if iddup > 0 | duptag > 0

/* One observation of each duplicate {cmd:hhid} (the first observation)
has {cmd:iddup == 0}.
To fix this, we have to modify the logical expression for {cmd:iddup}: */

drop iddup

sort hhid
generate iddup = hhid == hhid[_n - 1] | hhid == hhid[_n + 1]

count if iddup > 0

list hhid iddup duptag if iddup > 0 | duptag > 0

/* When using {cmd:_n},
the sort order is paramount.
Before creating {cmd:iddup}, we sorted by {cmd:hhid},
but suppose we had sorted by {cmd:sex} instead: */

sort sex
generate iddup2 = hhid == hhid[_n - 1] | hhid == hhid[_n + 1]

count if iddup  > 0
count if iddup2 > 0

{LITTLEN_Q4}

/* {FOOT}

{GOTOPS}{LITTLEN_PS}

{NEXT}{BY}
{PREV}{BIGN}
{START} */
