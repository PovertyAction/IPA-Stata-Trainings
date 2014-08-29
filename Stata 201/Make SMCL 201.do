vers 13

* The directory structure (directories and subdirectories) of the Pseudo-SMCL,
* SMCL, and Do directories.
loc dirstruct Introduction Modules "Problem sets" Answers
* Directories that contain answer key files
loc ansdirs	Answers
* Maximum number of questions in a problem set
loc maxq 2
conf integer n `maxq'
assert `maxq' > 0

c stata_training
cd "Stata 201"
u "Raw/New Hampshire 2013 police 3", clear
unab all : _all
assert `:length loc all' > 245
loc badk = wordcount(substr("`all'", 1, 245))
assert `badk' < c(k)
* Check that a variable name is cut in the middle at the 244 (or whatever) mark.
assert !strpos(substr("`all'", 243, 4), " ")
loc var_lastvar = word(substr("`all'", 1, 245), ///
	wordcount(substr("`all'", 1, 245)))
assert !`:list var_lastvar in all'

u "Raw/New Hampshire 2013 police 2", clear

foreach id in 1101008 1113003 {
	cou if hhid == "`id'"
	assert r(N) == 1
}
assert s1_q2 == 1        if inlist(hhid, "1101008", "1113003")
assert s1_q3 == "KUMHAR" if inlist(hhid, "1101008", "1113003")


/* -------------------------------------------------------------------------- */
					/* convert				*/

timer clear 1
timer on 1

loc curdir "`c(pwd)'"

foreach dir of loc dirstruct {
	loc files : dir "Pseudo-SMCL/`dir'" file "*.do", respect
	foreach file of loc files {
		loc stub = regexr("`file'", "\.do$", "")
		loc infiles   "`infiles'   "Pseudo-SMCL/`dir'/`file'""
		loc smclfiles "`smclfiles' "SMCL/`dir'/`stub'.smcl""
		loc dofiles   "`dofiles'   "Do/`dir'/`stub'.do""
		loc dirq ""`dir'""
		loc ans `ans' `:list dirq in ansdirs'
	}
}

* Automatic problem set directive creation
tempname fhin fhnew fhdo
tempfile psqdo
//foreach dir in {
	loc fulldir Pseudo-SMCL/Problem sets // /`dir'
	loc files : dir "`fulldir'" file "*.do", respect
	foreach f of loc files {
		di as res "`f'"

		loc ffn "`fulldir'/`f'"
		loc base : subinstr loc f ".do" ""

		tempfile newps
		* Replace `ffn' with `newps', a modified version of `ffn' that does not
		* contain the {PSQ:} directives or #define.
		file open `fhin'  using "`ffn'", r
		file open `fhnew' using `newps', w

		loc inpsq 0
		loc linenum 0
		file r `fhin' line
		while !r(eof) {
			//mata: st_local("line")

			// New PSQ
			if strmatch(`"`macval(line)'"', "#define*") {
				loc direc : subinstr loc line "#define" ""
				loc define "`define' `=cond(`:length loc define', "\", "")' `direc'"
			}
			else if strmatch(`"`macval(line)'"', "{PSQ:*") {
				* End the previous PSQ.
				if `inpsq' {
					file w `fhdo' /*"{O}" _n*/ `"* {DEF}""' "'" `"";"' _n
					#d ;
					file w `fhdo'
						"#d cr" _n
						`"mata: st_local("questions", "'
						`"st_local("questions") + (st_local("questions") != "") * " \ " + "'
						`"st_local("question"))"' _n
					;
					#d cr
					file close `fhdo'
					include `psqdo'

					file w `fhnew' "{`psq'}" _n(2)
				}

				loc inpsq 1
				loc linenum 0

				* Write the start of the PSQ do-file.
				file open `fhdo' using `psqdo', w replace
				loc psq : subinstr loc line "{PSQ:" ""
				loc psq : subinstr loc psq "}" ""
				file w `fhdo' ///
					"#d ;" _n ///
					/// `"loc questions "\`questions' \`=cond(\`:length loc questions', "\", "")' "{`psq'}" = "' ///
					`"loc question ""{`psq'}" = "' ///
					"`" `"""'
				if regexm("`psq'", "[0-9]+$") ///
					file w `fhdo' "* {Q\`=regexs(0)'QTITLE}{O} {O}" _n
			}
			* End of PSQ
			else if `inpsq' & strpos(`"`macval(line)'"', "{FOOT}") {
				file w `fhdo' /*"{O}" _n*/ `"* {DEF}""' "'" `"";"' _n
				#d ;
				file w `fhdo'
					"#d cr" _n
					`"mata: st_local("questions", "'
					`"st_local("questions") + (st_local("questions") != "") * " \ " + "'
					`"st_local("question"))"' _n
				;
				#d cr
				file close `fhdo'
				include `psqdo'

				* Add the newly created directive to `newps'.
				file w `fhnew' "{`psq'}" _n(2)
				file w `fhnew' `"`macval(line)'"' _n

				loc inpsq 0
			}
			* Write the next PSQ line.
			else if `inpsq' {
				* Skip blank lines immediately after {PSQ:}.
				if `linenum' | `:length loc line' {
					loc ++linenum

					* Modify `line'.
					* I'm having trouble getting {AQ} and QTITLE to play nicely
					* together, hence this workaround.
					if !strpos(`"`macval(line)'"', "QTITLE}") {
						loc line : subinstr loc line "/*" "{CT}{AQ}", all
						mata: if (substr(st_local("line"), 1, 1) == "*") ///
							st_local("line", "*{AQ}" + substr(st_local("line"), 2, .));;
					}
					else ///
						loc line : subinstr loc line "/*" "{CT}", all
					loc line : subinstr loc line "*/" "{CT/}", all
					loc line : subinstr loc line ";" "{SEMI}", all
					loc line : subinstr loc line "`" "{LSQ}", all
					loc line : subinstr loc line `"""' "{DQ}", all

					if `linenum' > 1 ///
						file w `fhdo' "{O}" _n
					file w `fhdo' `"`macval(line)'"'
				}
			}
			* Line outside a PSQ
			else ///
				file w `fhnew' `"`macval(line)'"' _n

			file r `fhin' line
		}

		file close `fhin'
		file close `fhnew'

		* Replace `ffn' in `infiles' with `newps'.
		//macro li _infiles _ffn
		loc infiles : subinstr loc infiles `""`ffn'""' "`newps'", word all cou(loc n)
		assert `n' == 1
	}
//}

cap noi macro li _questions

/* Page links

Column 1: {code}
Column 2: Create a problem set code of the form {code_PS} (1/yes, 0/no) and an
		  answers code of the form {code_ANS} (1/0)
Column 3: Create a "no break" code of the form {code...} (1/0). Normally, a line
		  break is added after the link, but the no break code doesn't insert a
		  line break.
Column 4: Create an "unfinished" code of the form {code-} (1/0). This contains
		  just the location of the SMCL file.
Column 5: The args part of {view args:text}.
Column 6: The text part of {view args:text}. */
#d ;
loc codeslinks
	{START}			0	0	1	"Stata 201.smcl"								"High Intermediate Start"
	{INTRO}			0	0	1	"SMCL/Introduction/Training Introduction.smcl"	""
	{MACROS}		1	1	1	"SMCL/Modules/Macros.smcl"						""
	{RESHAPE}		1	1	1	"SMCL/Modules/reshape.smcl"						"{bf:reshape}"
;
#d cr
assert mod(`:list sizeof codeslinks', 6) == 0
while `"`codeslinks'"' != "" {
	gettoken code  codeslinks : codeslinks
	loc code ""`code'""
	* ps" for "problem set"
	gettoken ps    codeslinks : codeslinks
	* "nb" for "no break"
	gettoken nb    codeslinks : codeslinks
	* "uf" for "unfinished"
	gettoken uf    codeslinks : codeslinks
	gettoken smcl  codeslinks : codeslinks
	gettoken title codeslinks : codeslinks

	if "`title'" == "" ///
		mata: st_local("title", pathrmsuffix(pathbasename("`smcl'")))

	if !strpos(`"`smcl'"', `".smcl"##"') ///
		loc smcl ""`smcl'""
	loc link "`"{view `"`smcl'"':`title'}{BR}"'"

	loc c : subinstr loc code "}" "!}"
	* "cl" suffix for "codes/links": "titlecl" for "title codes/links"
	loc titlecl "`c' = "{bf:`title'}{BR}""

	loc ufcode : subinstr loc code "}" "-}"
	loc uflink "`smcl'"

	loc pscl
	if `ps' {
		foreach type in ps ans {
			loc suffix = cond("`type'" == "ps", "_PS", "_ANS")
			loc newcode  : subinstr loc code "}" "`suffix'}"
			loc newcode2 : subinstr loc code "}" "`suffix'2}"
			foreach newuf in "" uf {
				if "`type'" == "ps" ///
					loc suffix
				else ///
					loc suffix " answers"
				//loc `newuf'newlink : subinstr loc `newuf'link    "/Concepts/" "/Problem sets/Concepts`suffix'/"
				//loc `newuf'newlink : subinstr loc `newuf'newlink "/Tasks/"    "/Problem sets/Tasks`suffix'/"
				loc `newuf'newlink : subinstr loc `newuf'link "/Modules/" "/Answers/"
				if "`type'" == "ps" ///
					loc suffix " - problem set"
				else ///
					loc suffix " - answers"
				loc `newuf'newlink : subinstr loc `newuf'newlink ".smcl" "`suffix'.smcl"
			}
			loc text = cond("`type'" == "ps", "Problem set", "Answer key")
			loc newlink2 "`"{view `"`ufnewlink'"':`text'}{BR}"'"
			loc pscl "`pscl' `=cond(`:length loc pscl', "\", "")' `newcode' = `newlink' \ `newcode2' = `newlink2'"

			foreach task in Question /*Exercise*/ {
				loc uptask = strupper("`task'")
				loc lotask = strlower("`task'")
				loc ab     = substr("`lotask'", 1, 1)
				loc AB     = substr("`uptask'", 1, 1)

				/*
				* {[Mod. code]_(PS|ANS)(Q|E)}
				loc c : subinstr loc newcode "}" "`AB'}"
				loc l "`"{view `"`ufnewlink'##`lotask's"':`task's}{BR}"'"
				loc pscl "`pscl' \ `c' = `l'"
				*/

				* {[Mod. code]_(PS|ANS)(Q|E)#}
				forv i = 1/`maxq' {
					loc c : subinstr loc newcode "}" "`AB'`i'}"
					loc l "`"{view `"`ufnewlink'##`ab'`i'"':`task' `i'}{BR}"'"
					loc pscl "`pscl' \ `c' = `l'"
				}
			}
		}
	}

	loc nbcode
	loc nblink
	if `nb' {
		loc nbcode : subinstr loc code "}"    "...}"
		loc nblink : subinstr loc link "{BR}" ""
	}

	if `uf' ///
		loc uflink "`"`uflink'"'"
	else {
		loc ufcode
		loc uflink
	}

	#d ;
	loc links "
		`links' `=cond(`:length loc links', "\", "")'
		`code' = `link' \
		`titlecl'
		`=cond(`ps', "\", "")'
		`pscl'
		`=cond(`nb', "\", "")'
		`nbcode' `=cond(`nb', "=", "")' `nblink'
		`=cond(`uf', "\", "")'
		`ufcode' `=cond(`uf', "=", "")' `uflink'
	";
	#d cr
}

* Question/exercise headers
loc qe
foreach task in Question /*Exercise*/ {
	loc uptask = strupper("`task'")
	loc lotask = strlower("`task'")
	/*
	* {QUESTIONS} and {EXERCISES}
	#d ;
	loc qe "
		`qe' `=cond(`:length loc qe', "\", "")'
		"{`uptask'S}" = "{hline}{marker `lotask's}{NEW2}{P}{bf:`task's}{NEW2}{hline}"
		"
	;
	#d cr
	*/

	loc AB = substr("`uptask'", 1, 1)
	loc ab = substr("`lotask'", 1, 1)
	forv i = 1/`maxq' {
		#d ;
		loc qe "
			`qe' `=cond(`:length loc qe', "\", "")'
			"{`AB'`i'.}"   = "{`AB'`i'}{bf:.} " \
			"{`AB'`i'--}"  = "{`AB'`i'}{NEW2}{hline}" \
			"{`AB'`i'}"    = "{hline}{marker `ab'`i'}{NEW2}{P}{bf:`=cond("`task'" == "Question", "Question", "`task'")' `i'}" \
			"{`AB'`i'ANS}" = "{hline}{marker `ab'`i'}{NEW2}{P}{bf:Answer to `task' `i'}{NEW2}{hline}"
			"
		;
		#d cr
	}
}

* Header directive
#d ;
loc head
{P}{c TLC}{hline 43}{c TRC}{BR}{O}
{bf}{...}{O}
{c |}{HEAD1} Innovations for Poverty Action{space 12}}{c |}{BR}{O}
{c |}{HEAD1} The Abdul Latif Jameel Poverty Action Lab{space 1}}{c |}{BR}{O}
{c |}{HEAD1}{space 43}}{c |}{BR}{O}
{c |}{HEAD1} Global Staff Training{space 21}}{c |}{BR}{O}
{c |}{HEAD1} Stata 201{space 33}}{c |}{BR}{O}
{sf}{...}{O}
{c BLC}{hline 43}{c BRC}
;
#d cr

* Erase previous SMCL (not pseudo-SMCL) files and their associated do-files.
foreach dir in SMCL Do {
	foreach subdir of loc dirstruct {
		loc files : dir "`dir'/`subdir'" file *
		loc placeholder empty.txt
		loc files : list files - placeholder
		foreach file of loc files {
			erase "`dir'/`subdir'/`file'"
		}
	}
}

include "../Shared directives"

* Loop over the pseudo-SMCL files, converting each to a SMCL file and do-file.
assert `:list sizeof infiles' == `:list sizeof smclfiles' & `:list sizeof infiles' == `:list sizeof dofiles'
foreach loc in define questions qe links {
	mata: st_local("`loc'", ///
		st_local("`loc'") + (strlen(st_local("`loc'")) != 0) * " \")
}
forv i = 1/`:list sizeof infiles' {
	loc infile   : word `i' of `infiles'
	loc smclfile : word `i' of `smclfiles'
	loc dofile   : word `i' of `dofiles'
	* 1 if the pseudo-SMCL file is an answer key; 0 otherwise.
	loc isans    : word `i' of `ans'

	#d ;
	do "../Do to SMCL.do"
		infile("`infile'") smclfile("`smclfile'") dofile("`dofile'")
		subinstr(
			"{HEAD}"     = "`head'" \
			"{HEAD1}"    = `"{view `"{START-}"':"' \

			`define'
			`questions'
			`shared_subinstr1'
			`qe'
			`links'
			`shared_subinstr2'

			"{VAR_BADK}"    = "`badk'" \
			"{VAR_LASTVAR}" = "`var_lastvar'" \
			"{VAR_WD}"      = "C:\Users\mwhite.IPA\Dropbox\RM&T\New Hampshire 2013 advanced Stata training\My project folder" \
			"{VAR_WDBASE}"  = "My project folder" \

			"{DATA_POLICE1}"   = `""Raw/New Hampshire 2013 police 1""' \
			"{DATA_POLICE2}"  = `""Raw/New Hampshire 2013 police 2""' \
			"{DATA_POLICE3}"  = `""Raw/New Hampshire 2013 police 3""' \
			"{DATA_PSYCH}"    = `""Raw/New Hampshire 2013 psych""' \
			"{DATA_S2Q8}"     = "{DATA_S2_Q8}" \
			"{DATA_S2_Q8}"    = `""Raw/New Hampshire 2013 s2_q8""' \
			"{DATA_PROJ1}"    = `""Raw/New Hampshire 2013 projects 1""' \
			"{DATA_PROJ2}"    = `""Raw/New Hampshire 2013 projects 2""' \
			"{DATA_HH}"       = `""Raw/New Hampshire 2013 household""'
		)
		preserve
		, /* comma so that I can specify "," to -subinstr()- without -do-
		thinking I'm specifying options */
	;
	#d cr
}

* Move the start page to a different directory.
loc intro Stata 201.smcl
copy  "SMCL/Introduction/`intro'" "`intro'", replace
erase "SMCL/Introduction/`intro'"


/* -------------------------------------------------------------------------- */
					/* finish up			*/

cd "`curdir'"

timer off 1
timer list 1
