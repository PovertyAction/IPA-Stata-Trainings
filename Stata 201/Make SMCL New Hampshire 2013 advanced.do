* Author: Matt White, Innovations for Poverty Action, mwhite@poverty-action.org
* Date of last revision: September 9, 2013

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
* Default indent
loc p {pstd}
* End-of-line delimiter for SMCL files
loc eol `=char(13)'`=char(10)'
* Width of text boxes (not including indent)
loc boxwidth 80

c adv13
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

/* Guide to pseudo-SMCL directives:

----------conventions and abbreviations----------
/			The opposite of another directive
!			A title/caption
.			Followed by "."
-			A part/piece/substring
--			Followed by {hline}
...			Not followed by a page break (when a page break is the default)
{DATA_*}	Location of a dataset
MOD			Module
PS			Problem set
ANS			Answer key
PREV		Previous

----------essentials----------
{BLOCK}		Designate a command as part of a block. It will be rendered as text,
			and "Click here to execute" will appear below the block.
"{O} "		Stands for "observation." {O} by itself is meaningless: it must be
			follwed by a space. Splits a pseudo-SMCL line into two lines in the
			SMCL file at the position of {O}. Used for lines too long for
			"Do to SMCL.do" (such as the header box) or (rarely) to start a new
			new paragraph.

----------problem sets----------
{CT}		Starts the comment delimiter -/*-.
{CT/}		Ends the comment delimiter -*/-.
{SEMI}		Semicolon: ";".
{DQ}		Double quote: `"""'
{LSQ}		Left single quote: "`".

Question/exercise headers (see above for more; exercises are now called
questions)
{Q#}		Header for question #
{Q#.}		Header for question # followed by "."
{Q#--}		Header for question # followed by {hline}
{Q#ANS}		Header for the answer to question #

QTITLE		Stands for "question title." {Q#QTITLE} becomes {Q#--} if !`isans'
			and {Q#ANS} otherwise.
{AQ}		Stands for "answer quote". If !`isans', does nothing. Otherwise,
			formats the quotation of a problem set question by italicizing it.

----------variables----------
{VAR*}		Used to save frequently referenced text unrelated to formatting.

----------data----------
{DATA}				The location of the training dataset
{DATA_BASE}			The base name of the training dataset
{DATA_BACK}			The location of the training dataset with backslashes instead of
					forward slashes
{USE}				The -use- command to load {DATA}
{DATA_CASTECSV}		The location of the caste names .csv file
{DATA_CASTEDTA}		The location of the caste names .dta file

----------headers, footers, and boxes----------
{HEAD}		The header box that links back to the start page. See above: search
			for "header directive."
{HEAD1}		Used in {HEAD}
{PS!}		The problem set caption
{PSANS!}	The caption for a problem set answer key
{FOOT}		The page footer
{TECH}		The top of a technical tips box
{TRYIT}		A "try it yourself" box
{TRYITCMD}	A "try it yourself" box followed by {cmd}

----------footer links----------
{GOTOPS}	Prefaces a link to a problem set.
{TOMOD}		Prefaces a link to a module.
{NEXT}		"Next" prefacing a link to the next page, aligned with a proceeding
			"Previous"
{NEXT1}		"Next" followed by one space, not aligned with a proceeding
			"Previous"
{NEXTC}		"Next concept" prefacing a link to the next concept, aligned with a
			proceeding "Previous concept"
{NEXT1C}	"Next concept" followed by one space, not aligned with a proceeding
			"Previous task"
{NEXTT}		"Next task" prefacing a link to the next task, aligned with a
			proceeding "Previous task"
{NEXT1T}	"Next task" followed by one space, not aligned with a proceeding
			"Previous task"
{NEXT2T}	Unused/obsolete
{NEXT3T}	"Next task" aligned with a preceding "Next concept"
{PREV}		Prefaces a link to the previous page.
{PREVC}		Prefaces a link to the previous concept.
{PREVT}		Prefaces a link to the previous task.
{PREV2T}	Unused/obsolete
{ALTMAP}	Stands for "alternative map." Links to the Alternative Table of
			Contents.

----------page links----------
See above: search for "page links."
{[Mod. code]}		Links to a module.
{[Mod. code]!}		Title of a module
{[Mod. code]...}	Links to a module, but isn't followed by a page break (a
					page break is the default).
{[Mod. code]-}		The location of a module's SMCL file
{[Mod. code]_PS}	Links to a module's problem set.
{[Mod. code]_PS2}	Links to a module's problem set, but with the simple link
					text "Problem set" rather than the module title.
{[Mod. code]_ANS}	Links to a module's answer key.
{[Mod. code]_PS2}	Links to a module's answer key, but with the simple link
					text "Answer key" rather than the module title.

----------box formatting----------
{TOP}		Top of a box
{BOTTOM}	Bottom of a box
{COLSET}	{p2colset} with arguments
{RESET}		{p2colreset}{...}
{TLINE}		Top line of a box
{MLINE}		Line in the middle of a box
{BLINE}		Bottom line of a box
{COL}		Start of a line in a box
{CEND}		Stands for "column end." End of a line in a box.
{BLANK}		A blank line in a box

----------formatting----------
{P}			Default paragraph indent: {pstd}.
{BR}		Synonym for {break}
{O#}		{O} repeated # times
{NEW}		The end-of-line delimiter. Cannot be used to make "Do to SMCL.do"
			start a new paragraph: use {O} instead.
{NEW#}		Skip # lines. See above: search for "new line directives."
{DEF}		Stands for "default". Default text style: turns off bold, italics,
			underline, {cmd}, etc.
{BF}		{bf}{...}
{IT}		{it}{...}
{UL}		{ul on}{...}
{CMD}		{cmd}{...}

----------automatic problem set directive creation----------
In the problem set do-files, the following directives are used to automatically
create new directives. The following directives are not used in this do-file.
See above: search "automatic problem set directive creation."
{PSQ:[directive]}	Create a new directive {[directive]} for the text that
					follows. The directive ends when another {PSQ:} directive or
					{FOOT} is encountered.
#define				Define a new directive.
*/


/* -------------------------------------------------------------------------- */
					/* convert				*/

timer clear 1
timer on 1

loc curdir "`c(pwd)'"

c otherstata
loc otherstata "`c(pwd)'"

c adv13

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
	{START}			0	0	1	"New Hampshire 2013 Advanced.smcl"				"High Intermediate Start"
	{INTRO}			0	0	1	"SMCL/Introduction/Training Introduction.smcl"	""
	{MACROS}		1	1	1	"SMCL/Modules/Macros.smcl"						""
	{RESHAPE}		1	1	1	"SMCL/Modules/reshape.smcl"						"{bf:reshape}"
	{EXPORT}		0	1	1	"SMCL/Modules/Exporting Tables.smcl"			"Exporting Tables"
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
{c |}{HEAD1} Staff Training - New Hampshire 2013{space 7}}{c |}{BR}{O}
{c |}{HEAD1} Advanced Stata{space 28}}{c |}{BR}{O}
{sf}{...}{O}
{c BLC}{hline 43}{c BRC}
;
#d cr

* New line directives
loc new ""{NEW}" = "`eol'""
foreach i of numlist 2 46 48 {
	loc new "`new' \ "{NEW`i'}" = "`:di _dup(`i') "`eol'"'""
}

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
	do "`otherstata'/Do to SMCL.do"
		infile("`infile'") smclfile("`smclfile'") dofile("`dofile'")
		subinstr(
			`define'
			`questions'
			"{CT}"   = "/{STAR}" \
			"{CT/}"  = "{STAR}/" \
			"{STAR}" = "*" \
			"{SEMI}" = ";" \
			"{LSQ}"  = "`" \
			"{DQ}"   = `"""' \
			"QTITLE" = "`=cond(`isans', "ANS", "--")'" \
			"{AQ}"   = "`=cond(`isans', "{IT}", "")'" \
			`qe'

			"{VAR_BADK}"    = "`badk'" \
			"{VAR_LASTVAR}" = "`var_lastvar'" \
			"{VAR_WD}"      = "C:\Users\mwhite.IPA\Dropbox\RM&T\New Hampshire 2013 advanced Stata training\My project folder" \
			"{VAR_WDBASE}"  = "My project folder" \

			"{USE}"           = "use {DATA}, clear" \
			"{DATA}"          = `""Raw/India 2013 high intermediate""' \
			"{DATA_BASE}"     = "India 2013 high intermediate" \
			"{DATA_BACK}"     = `""Raw\India 2013 high intermediate""' \
			"{DATA_CASTECSV}" = `""Raw/Clean castename.csv""' \
			"{DATA_CASTEDTA}" = `""Raw/Clean castename""' \
			"{DATA_POLICE1}"   = `""Raw/New Hampshire 2013 police 1""' \
			"{DATA_POLICE2}"  = `""Raw/New Hampshire 2013 police 2""' \
			"{DATA_POLICE3}"  = `""Raw/New Hampshire 2013 police 3""' \
			"{DATA_PSYCH}"    = `""Raw/New Hampshire 2013 psych""' \
			"{DATA_S2Q8}"     = "{DATA_S2_Q8}" \
			"{DATA_S2_Q8}"    = `""Raw/New Hampshire 2013 s2_q8""' \
			"{DATA_PROJ1}"    = `""Raw/New Hampshire 2013 projects 1""' \
			"{DATA_PROJ2}"    = `""Raw/New Hampshire 2013 projects 2""' \
			"{DATA_HH}"       = `""Raw/New Hampshire 2013 household""' \

			"{HEAD}"     = "`head'" \
			"{HEAD1}"    = `"{view `"{START-}"':"' \
			"{PS!}"      = "{it:Problem set}{BR}" \
			"{PSANS!}"   = "{it:Answer key}{BR}" \
			"{FOOT}"     = "{NEW}{hline}" \
			"{TECH}"     = "{TOP}{NEW}{COL}{it:Technical Tip!}{CEND}{NEW}{MLINE}" \
			"{TRYITCMD}" = "{TRYIT}{cmd}" \
			"{TRYIT}"    = "{TOP}{NEW}{COL}{it:It's the first time!} {bf:Try it yourself.}{CEND}{NEW}{BOTTOM}{NEW}{P}{...}" \

			"{GOTOPS}" = "Problem Set: " \
			"{TOMOD}"  = "Return to Module: " \
			"{NEXT1}"  = "Next: " \
			"{NEXT}"   = "Next:     " \
			"{PREV}"   = "Previous: " \
			"{ALTMAP}" = `"{view `"{ALTTOC-}"':Alternative Courses}{BR}"' \
			"{NEXT1C}" = "Next Concept: " \
			"{NEXTC}"  = "Next Concept:     " \
			"{PREVC}"  = "Previous Concept: " \
			"{NEXT1T}" = "Next Task: " \
			"{NEXT3T}" = "Next Task:    " \
			"{NEXTT}"  = "Next Task:     " \
			"{PREVT}"  = "Previous Task: " \

			`links'

			"{TOP}"    = "{COLSET}{NEW}{TLINE}" \
			"{COLSET}" = "{p2colset 5 `=`boxwidth' + 4' 0 0}{...}" \
			"{TLINE}"  = "{P}{c TLC}{hline `=`boxwidth' - 2'}{c TRC}{p_end}" \
			"{BLANK}"  = "{COL}{CEND}" \
			"{COL}"    = "{p2col:{c |} " \
			"{CEND}"   = "}{c |}{p_end}" \
			"{MLINE}"  = "{P}{c LT}{hline `=`boxwidth' - 2'}{c RT}{p_end}" \
			"{BOTTOM}" = "{BLINE}{NEW}{RESET}" \
			"{BLINE}"  = "{P}{c BLC}{hline `=`boxwidth' - 2'}{c BRC}{p_end}" \
			"{RESET}"  = "{p2colreset}{...}" \

			"{P}"   = "`p'" \
			"{BR}"  = "{break}" \
			"{DEF}" = "{txt}{sf}{ul off}{...}" \
			"{BF}"  = "{bf}{...}" \
			"{IT}"  = "{it}{...}" \
			"{UL}"  = "{ul on}{...}" \
			"{CMD}" = "{cmd}{...}" \
			"{O2}"  = "{O} {O} " \
			`new'
		)
		preserve
		, /* comma so that I can specify "," to -subinstr()- without -do-
		thinking I'm specifying options */
	;
	#d cr
}

* Move the start page to a different directory.
loc intro New Hampshire 2013 Advanced.smcl
copy  "SMCL/Introduction/`intro'" "`intro'", replace
erase "SMCL/Introduction/`intro'"
//view "`intro'"
cd "`curdir'"


/* -------------------------------------------------------------------------- */
					/* finish up			*/

timer off 1
timer list 1
