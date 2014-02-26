args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

foreach caste in hami jain rawat {
    summarize sex age educ if castename == "`caste'"
}

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

foreach caste in hami jain rawat {
    foreach var of varlist sex age educ {
        summarize `var' if castename == "`caste'"
    }
}

	}
	if `trace' set trace off
}
else if `example' == 3 {
	if `trace' set trace on
	noi {

foreach caste in hami jain rawat {
    display "`caste'"
    summarize sex age educ if castename == "`caste'"
}

	}
	if `trace' set trace off
}
else if `example' == 4 {
	if `trace' set trace on
	noi {

foreach i of numlist 1/6 {
    generate castecode`i' = castecode == `i' if castecode != .
}

	}
	if `trace' set trace off
}
else if `example' == 5 {
	if `trace' set trace on
	noi {

foreach crime in cycletheft robbery theft molestation eveteasing attack extortion assault falsecase othercrime {
    replace anycrime1 = 1 if `crime'victim_1 == 1 | `crime'victim_2 == 1
}

	}
	if `trace' set trace off
}
else if `example' == 6 {
	if `trace' set trace on
	noi {

foreach crime in cycletheft robbery theft molestation eveteasing attack extortion assault falsecase othercrime {
    display "`crime'"
    tabulate `crime'victim_1
    tabulate `crime'victim_2
}

	}
	if `trace' set trace off
}
else if `example' == 7 {
	if `trace' set trace on
	noi {

foreach i of numlist 1/8 {
    generate anycrime`i' = 0
    foreach crime in cycletheft robbery theft molestation eveteasing attack extortion assault falsecase othercrime {
        replace anycrime`i' = 1 if `crime'victim_1 == `i' | `crime'victim_2 == `i'
    }
}

	}
	if `trace' set trace off
}
else if `example' == 8 {
	if `trace' set trace on
	noi {

generate nvictims = 0
foreach i of numlist 1/8 {
    replace nvictims = nvictims + anycrime`i'
}

	}
	if `trace' set trace off
}
