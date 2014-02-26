/* {HEAD}

{BIGN!} */

{USE}

* {helpb _N} is the number of observations in the dataset:

display _N

/* To return to that most important of checks {hline 2}
{view `"{DUPLICATES-}"':that the unique ID is in fact unique} {hline 2}
{cmd:_N} can be used to determine
whether there are duplicate IDs.

If there are no duplicates on {cmd:hhid},
then the number of unique values of {cmd:hhid} should equal the number of observations.
{cmd:tabulate} lists all the unique values of a variable: */

tabulate hhid

* It also stores the {it:number} of unique values as the {helpb return:saved result} {cmd:r(r)}:

return list

display r(r)

* This is less than the number of observations:

display _N

/* This means that (as we knew) there are duplicates on {cmd:hhid}.

{bf:Note:} For more examples of saved results such as {bf:r(r)}, see {bf:Stata 104}. 

{FOOT}

{NEXT}{LITTLEN}
{PREV}{IF}
{START} */
