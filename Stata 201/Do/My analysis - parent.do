* Purpose: Regress mpg separately on each numeric variable.

global y mpg

ds mpg, not
ds `r(varlist)', has(type numeric)
foreach var in `r(varlist)' {
	global x `var'

	do "Do\My analysis - globals"
}
