/* {HEAD}

{RECODING!}
{PSANS!}

{RECODING_ANSQ1}
{RECODING_ANSQ2}
{RECODING_ANSQ3} */


{RECODING_Q1}

{BLOCK}ds, has(vallabel yes1no0)
{BLOCK}* "varl" for "variable list"
{BLOCK}local varl `r(varlist)'
{BLOCK}foreach var in `varl' {
{BLOCK}	replace `var' = 2 if `var' == 0
{BLOCK}}
{BLOCK}label values `varl' yesno

{RECODING_Q2TOP}

{RECODING_Q2A}

/* {cmd:1} ({cmd:Farming or livestock}) will be recoded as {cmd:2},
and {cmd:2} ({cmd:Manual labor on other people’s land, farm, house})
will be recoded as {cmd:1}. */

{RECODING_Q2B}

/* {cmd:recode occupation (1=2) (2=1)}

swaps values of {cmd:1} and {cmd:2}: values of {cmd:1} are now {cmd:2}, and values of {cmd:2} are now {cmd:1}.
That is, a simultaneous recoding of two values is completed. However,

{cmd:replace occupation = 2 if occupation == 1}{BR}
{cmd:replace occupation = 1 if occupation == 2}

simply replaces values of {cmd:2} with {cmd:1}.
First, values of {cmd:1} are recoded as {cmd:2},
then all values of {cmd:2}, including the former values of {cmd:1} now newly recoded, are replaced with {cmd:1}.

Here, an alternative to {cmd:recode} using {cmd:replace} would look like:

{cmd}replace occupation = 100 if occupation == 1{BR}
replace occupation = 1 if occupation == 2{BR}
replace occupation = 2 if occupation == 100{txt}

where {cmd:100} is not otherwise a value of {cmd:occupation}. */

{RECODING_Q3}

recode castecode (1=2) (2=3) (3=1)
label define castecode 1 SC 2 General 3 OBC, modify

/* {FOOT}

{RECODING_PS2}
{TOMOD}{RECODING}

{START} */
