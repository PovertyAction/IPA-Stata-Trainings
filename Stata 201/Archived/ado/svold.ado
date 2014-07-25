*! version 0.1.0 Matthew White 29aug2013
pr svold
	vers 13

	syntax anything(name=fn id=filename), [10 11 12 exe(str) *]

	if c(os) != "Windows" {
		di as err "Stata for Windows required"
		ex 198
	}

	if "`10'`11'`12'" == "" ///
		loc 12 12
	else {
		forv i = 10/11 {
			forv j = `=`i' + 1'/12 {
				if "``i''" != "" & "``j''" != "" {
					di as err "options `i' and `j' are mutually exclusive"
					ex 198
				}
			}
		}
	}

	if "`12'" != "" ///
		saveold `fn', `options'
	else if "`10'`11'" != "" {
		tempfile data
		qui saveold `data'

		* Write the do-file to run in batch mode.
		tempname fh
		tempfile do
		file open `fh' using `do', w
		file w `fh' "use `data', clear" _n
		file w `fh' `"saveold `fn'"'
		if `:length loc options' ///
			file w `fh' `", `options'"'
		file w `fh' _n(2)
		file close `fh'

		* Run the do-file in batch mode.
		if "`exe'" == "" ///
			loc exe C:\Program Files (x86)\Stata12\StataSE-64.exe
		conf f "`exe'"
		!"`exe'" /q /s /e do `do'

		* Display the log, then erase it.
		mata: st_local("log", ///
			pathrmsuffix(pathbasename(st_local("do"))) + ".smcl")
		type "`log'", smcl
		erase "`log'"
	}
end
