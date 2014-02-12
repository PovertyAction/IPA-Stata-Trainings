/* {HEAD}

{LITTLEN!}
{PS!}

{LITTLEN_PSQ1}
{LITTLEN_PSQ2}
{LITTLEN_PSQ3}
{LITTLEN_PSQ4} */


{PSQ:LITTLEN_Q1TOP}

* {Q1QTITLE}

{PSQ:LITTLEN_Q1A}

/* {bf:(a)}

What is the difference between {cmd:_n} and {cmd:_N}? */

{PSQ:LITTLEN_Q1B}

/* {bf:(b)}

Do you have to be attentive to the sort order when using {cmd:_n}?
How about {cmd:_N}? */

{PSQ:LITTLEN_Q2}

* Can you interpret the logical expression {cmd:hhid == hhid[_n - 1]}?

{PSQ:LITTLEN_Q3}

{USE}

/* {view `"{DUPLICATES-}"':As we have seen},
there are duplicates on the ID variable {cmd:hhid}.
Use {cmd:_n} to create a new, clean unique ID variable named {cmd:cleanid}. */

#define "{LITTLEN_Q4}" = "{LITTLEN_Q4TOP}{O2}{LITTLEN_Q4A}{O2}{LITTLEN_Q4B}{O2}{LITTLEN_Q4C}{O2}{LITTLEN_Q4D}"
{PSQ:LITTLEN_Q4TOP}

* {Q4QTITLE}

{USE}

{PSQ:LITTLEN_Q4A}
/* {bf:(a)}

There are {cmd:1001} observations in the dataset.
Use {cmd:_n} to create a variable of consecutive integers from {cmd:1} to {cmd:1001},
named {cmd:n}. */

{PSQ:LITTLEN_Q4B}
/* {bf:(b)}

Using {helpb sum()}, create a variable named {cmd:rsum} that is the running sum of {cmd:n}. */

{PSQ:LITTLEN_Q4C}
/* {bf:(c)}

Create a variable named {cmd:triangular} that is equal to {cmd:n * (n + 1) / 2}. */

{PSQ:LITTLEN_Q4D}
/* {bf:(d)}

For how many observations is {cmd:rsum == triangular}? */

/* {FOOT}

{LITTLEN_ANS2}
{TOMOD}{LITTLEN}

{START} */
