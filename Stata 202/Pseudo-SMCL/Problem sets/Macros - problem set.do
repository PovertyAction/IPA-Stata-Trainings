{PSQ:MACROS_Q1}

* The following dataset contains variables from psychological scales:

use {DATA_PSYCH}, clear

tabulate scheier1
tabulate cesd1

/* Let's say we want to use both {cmd:scheier1} and {cmd:cesd1} in an index.
For ease, we want their scales to point in the same direction.
Right now this is not the case: */

label list scheier
label list cesd

/* Create a new variable named {cmd:schierrev1}
that is {cmd:scheier} with a reverse scale,
with {cmd:scheier1 1} ({cmd:always}) equal to {cmd:scheierrev1 5},
{cmd:scheier1 2} ({cmd:sometimes}) equal to {cmd:scheierrev 4},
and so on.
Reverse not just the values of {cmd:schier1},
but also the value label {cmd:schier}.

To check that you got it right:

{cmd:tabulate scheier1 scheierrev1}

{bf:Hint:} Use the {helpb extended_fcn:label} extended macro function.
{cmd:label} {it:valuelabelname #} assigns
value label {it:valuelabelname}'s text for {it:#} to a macro. For example: */

local example : label cesd 1
display "`example'"
* {cmd:* Confirm the result using -label list-.}
label list cesd

{PSQ:MACROS_Q2}

/* Modify the {view `"{MACROS-}##combinations_loop"':loop over combinations}
from earlier in the module
to loop over all combinations
of {it:three} of {cmd:s1_q2 s1_q2_other s1_q3 s1_q4 s1_q5}.
That is, find all observations for which
at least three of the variables {cmd:s1_q2 s1_q2_other s1_q3 s1_q4 s1_q5}
have the same nonmissing values as another observation. */

{FOOT}
