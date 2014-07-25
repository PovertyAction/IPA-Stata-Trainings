args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

clear
input id f1 f2 f3 f4 f5 f6
1 . 12 23 . . 56
2 . 62 . . . .
3 881 . 453 34 55 .
4 . 92 . . . .
5 . 62 . . . .
6 . . . . . 67
7 91 . . . 87 .
8 . . . 66 . .
9 . . 53 . . 76
end

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

clear
input id f1 f2 f3 f4 f5 f6
1 12 23 56 . . .
2 62 . . . . .
3 881 453 34 55 . .
4 92 . . . . .
5 62 . . . . .
6 67 . . . . .
7 91 87 . . . .
8 66 . . . . .
9 53 76 . . . .
end

	}
	if `trace' set trace off
}
else if `example' == 3 {
	if `trace' set trace on
	noi {

by id date (project): replace projects = projects[_n - 1] + ///
    cond(missing(projects[_n - 1]), "", ", ") + string(project)

	}
	if `trace' set trace off
}
else if `example' == 4 {
	if `trace' set trace on
	noi {

forvalues i = 1/12 {
    generate s2_q8_`i' = strpos(s2_q8, " " + string(`i') + " ") != 0
}

	}
	if `trace' set trace off
}
