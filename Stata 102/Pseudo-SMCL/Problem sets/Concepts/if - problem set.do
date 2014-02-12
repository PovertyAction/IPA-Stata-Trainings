/* {HEAD}

{IF!}
{PS!}

{IF_PSQ1}
{IF_PSQ2}
{IF_PSQ3} */


#define "{IF_Q1}" = "{IF_Q1TOP}{O2}{IF_Q1A}{O2}{IF_Q1B}{O2}{IF_Q1C}{O2}{IF_Q1D}"
{PSQ:IF_Q1TOP}

* {Q1QTITLE}

{USE}

* Which {cmd:if} should be used: the {cmd:if} command or the {cmd:if} qualifier?

{PSQ:IF_Q1A}
/* {bf:(a)}

List the genders of respondents less than {cmd:30}. */

{PSQ:IF_Q1B}
/* {bf:(b)}

Determine the number of values of {cmd:sex} that are less than {cmd:0}
and save it in a local.
If this number is greater than {cmd:0}, {cmd:summarize sex}. */

{PSQ:IF_Q1C}
/* {bf:(c)}

{help tabulate oneway:Tabulate} the occupation frequencies of women. */

{PSQ:IF_Q1D}
/* {bf:(d)}

Determine the number of values of {cmd:sex} that are less than {cmd:0}
and save it in a local.
If this number is greater than {cmd:0},
list the values of {cmd:hhid} for which {cmd:sex} is less than {cmd:0}. */

{PSQ:IF_Q2TOP}

* {Q2QTITLE}

{PSQ:IF_Q2A}

/* {bf:(a)}

How can you tell whether a command allows the {cmd:if} qualifier? */

{PSQ:IF_Q2B}

/* {bf:(b)}

Name a command that allows the {cmd:if} qualifier (besides {cmd:summarize})
and another that does not (other than {cmd:display}). */

#define "{IF_Q3}" = "{IF_Q3TOP}{O2}{IF_Q3A}{O2}{IF_Q3B}{O2}{IF_Q3C}"
{PSQ:IF_Q3TOP}

* {Q3QTITLE}

{USE}

{PSQ:IF_Q3A}

* For the following questions, be sure to have the (fully) duplicated {bf:hhid} observations dropped:

duplicates drop

/* {bf:(a)}

There are two observations with {cmd:hhid "1813023"}.
If they differ on the variable {cmd:surveyid},
have Stata display {cmd:"Difference!"}. */

{PSQ:IF_Q3B}

/* {bf:(b)}

What are all the variables
on which the observations with {cmd:hhid "1813023"} differ? */

{PSQ:IF_Q3C}

/* {bf:(c)}

Get Stata to count the number of variables
on which the observations with {cmd:hhid "1813023"} differ. */

/* {FOOT}

{IF_ANS2}
{TOMOD}{IF}

{START} */
