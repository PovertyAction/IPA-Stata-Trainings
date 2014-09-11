vers 13.1

c stata_training
cd "Stata 201/Auxiliary/Make datasets"

cap pr drop do_preserve_cd
pr do_preserve_cd
	loc curdir "`c(pwd)'"
	do `0'
	qui cd `"`curdir'"'
end
loc do do_preserve_cd

`do' "macros/Make Psych dta"
`do' "reshape/Make Household dta"
`do' "reshape/Make Olympics datasets"
`do' "reshape/Make s2_q8 dta"
