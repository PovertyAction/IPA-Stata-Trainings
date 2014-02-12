/* {HEAD}

{LITTLEN!}
{PSANS!}

{LITTLEN_ANSQ1}
{LITTLEN_ANSQ2}
{LITTLEN_ANSQ3}
{LITTLEN_ANSQ4} */


{LITTLEN_Q1TOP}

{LITTLEN_Q1A}

/* {cmd:_n} refers to the observation number,
while {cmd:_N} is a constant
that indicates the total number of observations in the dataset.
Thus, {cmd:_n} ranges from {cmd:1} to {cmd:_N}. */

{LITTLEN_Q1B}

/* {cmd:_N} is a constant that equals the number of observations,
and it is unaffected by how those observations are sorted.
On the other hand, {cmd:_n} refers to the observation number,
{view `"{SUBSCRIPTING_ANSWERS-}##q1"':which depends on the sort order}.
When using {cmd:_n}, you must be sure that the dataset is sorted as you expect. */

{LITTLEN_Q2}

/* This tests whether the observation's value of {cmd:hhid} is
equal to the previous observation's value of {cmd:hhid}.
If this condition is true, the expression equals {cmd:1};
if it is false, the result is {cmd:0}. */

{LITTLEN_Q3}

generate cleanid = _n

{LITTLEN_Q4TOP}

{LITTLEN_Q4A}

generate n = _n

{LITTLEN_Q4B}

generate rsum = sum(n)

{LITTLEN_Q4C}

generate triangular = n * (n + 1) / 2

{LITTLEN_Q4D}

count if rsum == triangular

/* {FOOT}

{LITTLEN_PS2}
{TOMOD}{LITTLEN}

{START} */
