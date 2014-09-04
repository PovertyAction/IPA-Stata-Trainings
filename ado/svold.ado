*! version 0.1.0 Matthew White 03nov2013
pr svold
	vers 13

	syntax anything(name=fn id=filename), ///
		[9 10 11 12] ///
		[exe12(str) *]

	if c(os) != "Windows" {
		di as err "Stata for Windows required"
		ex 198
	}

	* Parse the version options.
	loc version `9'`10'`11'`12'
	if "`version'" == "" ///
		loc version 12
	else {
		forv i = 9/11 {
			forv j = `=`i' + 1'/12 {
				if "``i''" != "" & "``j''" != "" {
					di as err "options `i' and `j' are mutually exclusive"
					ex 198
				}
			}
		}

		if inlist(`version', 10, 11) ///
			loc version 9
	}

	* Parse the -exe*()- options.
	if "`exe12'" == "" ///
		loc exe12 C:\Program Files (x86)\Stata12\StataSE-64.exe
	if `version' < 12 ///
		conf f "`exe12'"

	tempfile temp
	foreach i in 9 12 {
		if `i' != `version' {
			loc qui`i' qui
			loc fn`i' `temp'
			loc options`i' replace
		}
	}
	loc fn`version' "`fn'"
	loc options`version' "`options'"

	* Save the dataset in Stata 12 format.
	`qui12' saveold `fn12', `options12'
	* Save the dataset in Stata 9/10/11 format.
	if `version' < 12 {
		save_batch, u(`temp') sa(`fn9') opt(`options9') ///
			exe("`exe12'") `qui9'
	}
end

pr save_batch
	syntax, Use(str asis) SAve(str asis) exe(str) [OPTions(str asis) QUIetly]

	* Write the do-file to run in batch mode.
	tempname fh
	tempfile dofile
	file open `fh' using `dofile', w
	file w `fh' `"use `use', clear"' _n
	file w `fh' `"saveold `save', `options'"' _n(2)
	file close `fh'

	* Run the do-file in batch mode.
	loc do = cond("`quietly'" == "", "do", "run")
	!"`exe'" /q /s /e `do' `dofile'

	* Display the log.
	mata: st_local("log", ///
		pathrmsuffix(pathbasename(st_local("dofile"))) + ".smcl")
	if "`quietly'" == "" ///
		type `log', smcl

	erase `log'
end
