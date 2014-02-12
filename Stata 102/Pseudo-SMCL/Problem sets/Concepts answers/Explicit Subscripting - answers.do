/* {HEAD}

{SUBSCRIPTING!}
{PSANS!}

{SUBSCRIPTING_ANSQ1}
{SUBSCRIPTING_ANSQ2} */


{SUBSCRIPTING_Q1}

/* The explicit subscript {it:varname}{cmd:[}{it:obs_num}{cmd:]}
is the value of variable {it:varname} in observation number {it:obs_num}.
Explicit subscripting allows you to refer to a variable's value
in a particular observation number.
However, the association between observations and their observation numbers isn't fixed:
an observation can have any observation number
between {cmd:1} and the number of observations.
The order of the observations {hline 2}
the correspondence of observations and their observation numbers {hline 2}
depends on the sort order.

This means that when using explicit subscripting,
you have to be careful that the sort order is the way you expect.
If the sort order changes {hline 2}
if the list of variables by which the data is sorted is changed or
if any of those variables are modified {hline 2}
then the same observation number may refer to a different observation.
This can lead to difficult-to-detect bugs,
so solutions that don't rely on sort order and explicit subscripting
are often preferable. */

{SUBSCRIPTING_Q2}

sort hhid

foreach var in age educ castecode {
	display "`var'"
	display `var'[5]
	display `var'[6]
	display
}

browse age educ castecode in 5/6

/* {FOOT}

{SUBSCRIPTING_PS2}
{TOMOD}{SUBSCRIPTING}

{START} */
