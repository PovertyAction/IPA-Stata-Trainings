* Purpose: Regress one variable, specified to option -y()-, on another variable,
* specified to option -x()-.

display "`0'"

* Store the variable name specified to -y()- in `y'; save the variable specified
* to -x()- in `x'.
local 0 , `0'
syntax, y(varname) x(varname)

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
