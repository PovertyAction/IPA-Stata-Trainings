args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

foreach var of varlist own2wheelertheftnum own2wheelertheftvictim_1 {
    assert `var' != . if own2wheelertheft == 1
    assert `var' == . if own2wheelertheft != 1
}

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

assert own2wheelertheftvictim_2 == . ///
    if own2wheelertheftnum < 2 | own2wheelertheftnum == .

	}
	if `trace' set trace off
}
else if `example' == 3 {
	if `trace' set trace on
	noi {

* Loop over all yes/no variables.
foreach ynvar of varlist *yn {
    * Remove "yn" from the end of `ynvar'. This makes it easy to determine the name of
    * the num variable.
    local base = substr("`ynvar'", 1, length("`ynvar'") - 2)
    capture noisily list `ynvar' `base'num ///
        if (`ynvar' == 1 & `base'num == .) | (`ynvar' == 2 & `base'num != .), ///
        abbreviate(32)
}

	}
	if `trace' set trace off
}
