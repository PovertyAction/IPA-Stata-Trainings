/* {HEAD}

{RECODING!}
{PS!}

{RECODING_PSQ1}
{RECODING_PSQ2}
{RECODING_PSQ3} */


{PSQ:RECODING_Q1}

{USE}

/* Recode all variables with the value label {cmd:yes1no0}
so that {cmd:Yes = 1} and {cmd:No = 2},
and attach the value label {cmd:yesno} to them. */

#define "{RECODING_Q2}" = "{RECODING_Q2TOP}{O2}{RECODING_Q2A}{O2}{RECODING_Q2B}"
{PSQ:RECODING_Q2TOP}

* {Q2QTITLE}

{PSQ:RECODING_Q2A}
/* {bf:(a)}

What do the rules {cmd:(1=2) (2=1)} specify? */

{PSQ:RECODING_Q2B}
/* {bf:(b)}

How does

{cmd:recode occupation (1=2) (2=1)}

differ from:

{cmd:replace occupation = 2 if occupation == 1}{BR}
{cmd:replace occupation = 1 if occupation == 2} */

{PSQ:RECODING_Q3}

{USE}

/* Recode {cmd:castecode} so that {cmd:1} is recoded as {cmd:2}, {cmd:2} is recoded as {cmd:3},
and {cmd:3} is recoded as {cmd:1}. Modify the value label to reflect these changes. */

/* {FOOT}

{RECODING_ANS2}
{TOMOD}{RECODING}

{START} */
