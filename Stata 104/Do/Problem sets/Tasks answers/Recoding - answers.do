args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

ds, has(vallabel yes1no0)
* "varl" for "variable list"
local varl `r(varlist)'
foreach var in `varl' {
replace `var' = 2 if `var' == 0
}
label values `varl' yesno

	}
	if `trace' set trace off
}
