/* {HEAD}

{STRINGS!}
{PS!}

{STRINGS_PSQ1}
{STRINGS_PSQ2}
{STRINGS_PSQ3}
{STRINGS_PSQ4}
{STRINGS_PSQ5}
{STRINGS_PSQ6} */


{PSQ:STRINGS_Q1}

* Explain the two main approaches to string cleaning.

{PSQ:STRINGS_Q2}

{USE}

* Recreating {cmd:newcaste}:

generate newcaste = upper(castename)
replace newcaste = subinstr(newcaste, ".", "", .)
replace newcaste = subinstr(newcaste, ",", "", .)
replace newcaste = trim(itrim(newcaste))

/* Using {view `"{OTHERCHECKS-}##levelsof"':{bf:levelsof}} and {cmd:foreach},
display each unique value of {cmd:newcaste} on its own line.
Copy these values to Excel. */

{PSQ:STRINGS_Q3}

{USE}

/* What is an alternative to {cmd:replace}
that can be used for making multiple, simultaneous replacements?
Why can't it be used to make replacements to {cmd:castename}?
(If you don't know, try it and see!) */

#define "{STRINGS_Q4}" = "{STRINGS_Q4TOP}{O2}{STRINGS_Q4A}{O2}{STRINGS_Q4B}{O2}{STRINGS_Q4C}"
{PSQ:STRINGS_Q4TOP}

* {Q4QTITLE}

/* In {view `"{STRINGS-}##version_loop"':this loop},
many replacements were made using
{cmd:#delimit}, multiple local macros, and for-loops. */

{PSQ:STRINGS_Q4A}
/* {bf:(a)}

How was {cmd:#delimit {SEMI}} useful for defining the local macros? */

{PSQ:STRINGS_Q4B}
/* {bf:(b)}

Why was it necessary to enclose {cmd:"MEHTA JAIN"} in double quotes? */

{PSQ:STRINGS_Q4C}
/* {bf:(c)}

Are there limitations to this approach? */

{PSQ:STRINGS_Q5TOP}

* {Q5QTITLE}

{USE}

{PSQ:STRINGS_Q5A}

/* {bf:(a)}

Standardize the letter case of {cmd:castename}
so that for each caste,
words begin with an uppercase letter
and are followed by lowercase.
For example, {cmd:"suthar"} should become {cmd:"Suthar"},
and {cmd:"RAVAN RAJPUT"} should become {cmd:"Ravan Rajput"}.
Use {helpb string functions:help string functions} to find the correct function. */

{PSQ:STRINGS_Q5B}

/* {bf:(b)}

After making this change,
how many unique caste names are there? */

{PSQ:STRINGS_Q6TOP}

* {Q6QTITLE}

{USE}

* First, recreate {cmd:newcaste}:

generate newcaste = upper(castename)
replace newcaste = subinstr(newcaste, ".", "", .)
replace newcaste = subinstr(newcaste, ",", "", .)
replace newcaste = trim(itrim(newcaste))

{PSQ:STRINGS_Q6A}

/* {bf:(a)}

Create a variable named {cmd:multiword}
that equals {cmd:1} if {cmd:newcaste} is more than one word long,
equals {cmd:0} if it is exactly one word,
and equals {cmd:.} (missing) if it is missing.

You may need to use {helpb string functions:help string functions}
to find the correct function. */

{PSQ:STRINGS_Q6B}

/* {bf:(b)}

How many unique caste names are more than one word long? */

{PSQ:STRINGS_Q6C}

/* {it:Extra credit:}

{bf:(c)}

If we {help tabulate oneway:tabulate} {cmd:newcaste},
it is clear that several multiword caste names
are actually single words with spaces incorrectly inserted,
for example, {cmd:"RAJ PUT"}: */

tabulate newcaste

/* How could you remove these spaces
while leaving true multiword caste names intact? */

/* {FOOT}

{STRINGS_ANS2}
{TOMOD}{STRINGS}

{START} */
