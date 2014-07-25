* Purpose: Regress one variable, specified to global $y, on another variable,
* specified to $x.

display "Regressing $y on $x..."

* Describe $y.
describe $y
summarize $y

* Describe $x.
describe $x
summarize $x

* Regress $y on $x.
regress $y $x
