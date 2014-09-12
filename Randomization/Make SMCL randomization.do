vers 12.1

include "../Shared directives"

loc base RandomizationExercise
loc do whatever.do
#d ;
do "../Do to SMCL.do"
	infile("`base'.do") smclfile("`base'.smcl") dofile("`do'") replace
	subinstr(
		`shared_subinstr1'
		`shared_subinstr2'
		"TEMP" = ""
	)
	preserve viewsmcl
	, /* comma so that we can specify "," to -subinstr()- without
	-do- thinking we are specifying options */
;
#d cr

* Confirm that no do-file was created.
conf new f "`do'"
