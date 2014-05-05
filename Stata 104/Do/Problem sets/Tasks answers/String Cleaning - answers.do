args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

levelsof newcaste
foreach level in `r(levels)' {
    display "`level'"
}

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

levelsof newcaste
foreach caste in `r(levels)' {
    if strpos("`caste'", " ") {
        local nospaces = subinstr("`caste'", " ", "", .)
        count if newcaste == "`nospaces'"
        if r(N) > 0 {
            replace newcaste = "`nospaces'" if newcaste == "`caste'"
        }
    }
}

	}
	if `trace' set trace off
}
