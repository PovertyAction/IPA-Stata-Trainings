* Purpose: Regress one variable, specified to the first argument, on another
* variable, specified to the second argument.

* The local `0' contains what was typed after the do-file name after -do-:
display "`0'"

* Each argument (each element of the list specified after -do-)
* is assigned to its own local, starting with `1':
display "`1'"
display "`2'"

* -args- copies these locals:
args y x

* Here, `1' has been copied to `y', and `2' has been copied to `x':
display "`y'"
display "`x'"

display "Regressing `y' on `x'..."

* Describe `y'.
describe `y'
summarize `y'

* Describe `x'.
describe `x'
summarize `x'

* Regress `y' on `x'.
regress `y' `x'
