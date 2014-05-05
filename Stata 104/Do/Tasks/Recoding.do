args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

ds, has(vallabel yes1no0)
* "varl" for "variable list"
local varl `r(varlist)'
recode `varl' (0=2)
label values `varl' yesno

	}
	if `trace' set trace off
}
