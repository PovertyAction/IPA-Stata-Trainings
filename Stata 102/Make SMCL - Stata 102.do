/*
Author: Matt White, Innovations for Poverty Action, mwhite@poverty-action.org
Purpose: Convert the pseudo-SMCL files for the post-Kenya 2013 high
	intermediate Stata training to SMCL files and do-files. Pseudo-SMCL is like
	SMCL, with the following differences:
	1. Pseudo-SMCL looks more like a do-file than a SMCL file, although it may
	contain SMCL directives. Commands are converted to clickable {stata}
	directives and comments are converted to text. Paragraph directives are
	rare in pseudo-SMCL: the conversion handles most of that by converting
	whitespace in the pseudo-SMCL file.
	- Loops and other blocks are converted to text, but there's a clickable
	"Click here to execute" below them that executes them. The blocks' code is
	stored in a do-file associated with the resulting SMCL file.
	2. There are more directives. See below for a list.
Notes: Sorry this is such a kludge. If it's not running and you don't understand
	it, try to find old output to see what it should be creating. This do-file
	uses "Do to SMCL.do." Because they involve braces, "Do to SMCL.do" will
	issue an (uninformative) error message if you use a nonexistent pseudo-SMCL
	code.
Date of last revision: July 18, 2013
*/

/* Author: Harrison Diamond Pollock, IPA, hpollock@poverty-action.org
Purpose: revise to produce files for New Hampshire 2014 - Stata 102 training
Last revision: Sept 8, 2014
*/ 


vers 10

* The directory structure (directories and subdirectories) of the Pseudo-SMCL,
* SMCL, and Do directories.
loc dirstruct ///
	Introduction Concepts Tasks ///
	"Problem sets/Concepts" "Problem sets/Tasks" "Problem sets/Concepts answers" "Problem sets/Tasks answers"
* Directories that contain answer key files
loc ansdirs ""Problem sets/Concepts answers" "Problem sets/Tasks answers""
assert `:list ansdirs in dirstruct'
* Maximum number of questions in a problem set
loc maxq 7
conf integer n `maxq'
assert `maxq' > 0
* Default indent
loc p {pstd}
* End-of-line delimiter for SMCL files
loc eol `=char(13)'`=char(10)'
* Width of text boxes (not including indent)
loc boxwidth 80
* Number of males in the dataset
loc curdir "`c(pwd)'"
nobreak {
	* -c- is from the SSC -fastcd- package
	c stata102
	u "Raw/Stata 102", clear
	cd "`curdir'"
}
cou if sex == 1
loc VAR3 = r(N)
* Mean/SD of cycleownnum
summarize cycleownnum
loc VAR5 = string(r(mean), "%9.0g")
loc VAR6 = string(r(sd),   "%9.0g")
loc VAR7 = strlen("`VAR6'") - strpos("`VAR6'", ".")
loc VAR8 = strlen("`r(sd)'") - strpos("`r(sd)'", ".")
ds, has(t numeric)
mata:
varl = st_global("r(varlist)")
limit = 243
assert(strlen(varl) > 244 & strlen(varl) > limit)
if (anyof((substr(varl, limit, 1), substr(varl, limit + 1, 1)), " "))
	varl = substr(varl, 1, limit)
else {
	i = limit + 2
	while (!anyof((" ", ""), substr(varl, i, 1)))
		i++
	varl = substr(varl, 1, i - 1)
}
t = tokens(varl)
st_local("VAR9", t[length(t)])
end
di "`VAR9'"

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
{VAR#}		Used to save frequently referenced text unrelated to formatting.

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
			/* convert						*/

timer clear 1
timer on 1

loc curdir "`c(pwd)'"

c otherstata
loc otherstata "`c(pwd)'"

c stata102

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
foreach dir in Concepts Tasks {
	loc fulldir Pseudo-SMCL/Problem sets/`dir'
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
}

macro li _questions

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
	{START}			0	0	1	"Stata 102.smcl"						        "Stata 102 Start"
	{INTRO}			0	0	1	"SMCL/Introduction/Training Introduction.smcl"			""
	{RESOURCES}		0	0	1	"SMCL/Concepts/Resources.smcl"							""
	{COMMANDS}		1	0	1	"SMCL/Concepts/Commands.smcl"							""
	{NAMING}		1	0	1	"SMCL/Tasks/Naming and Labeling Variables.smcl"			""	
	{TYPES}			1	0	1	"SMCL/Concepts/Variable Types.smcl"						""
	{DUPLICATES}	1	0	1	"SMCL/Tasks/Unique IDs and Duplicates.smcl"				""
	{MACROS}		1	0	1	"SMCL/Concepts/Macros and Locals.smcl"					""
	{LOOPS}			1	0	1	"SMCL/Concepts/Loops.smcl"								""
	{IMPORTING}		1	0	1	"SMCL/Tasks/Importing.smcl"								""
	{EXPORTING}		1	0	1	"SMCL/Tasks/Exporting.smcl"								""	
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
				loc `newuf'newlink : subinstr loc `newuf'link    "/Concepts/" "/Problem sets/Concepts`suffix'/"
				loc `newuf'newlink : subinstr loc `newuf'newlink "/Tasks/"    "/Problem sets/Tasks`suffix'/"
				if "`type'" == "ps" ///
					loc suffix " - problem set"
				else ///
					loc suffix " - answers"
				loc `newuf'newlink : subinstr loc `newuf'newlink ".smcl"      "`suffix'.smcl"
			}
			loc text = cond("`type'" == "ps", "Problem set", "Answers")
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
		"
	;
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
			"{`AB'`i'}"    = "{hline}{marker `ab'`i'}{NEW2}{P}{bf:`=cond("`task'" == "Question", "Problem Set Question", "`task'")' `i'}" \
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
{c |}{HEAD1} Staff Training{space 28}}{c |}{BR}{O}
{c |}{HEAD1} Stata 102{space 33}}{c |}{BR}{O}
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
		foreach file of loc files {
			erase "`dir'/`subdir'/`file'"
		}
	}
}

* Loop over the pseudo-SMCL files, converting each to a SMCL file and do-file.
assert `:list sizeof infiles' == `:list sizeof smclfiles' & `:list sizeof infiles' == `:list sizeof dofiles'
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
			`define' \
			`questions' \
			"{CT}"   = "/{STAR}" \
			"{CT/}"  = "{STAR}/" \
			"{STAR}" = "*" \
			"{SEMI}" = ";" \
			"{LSQ}"  = "`" \
			"{DQ}"   = `"""' \
			"QTITLE" = "`=cond(`isans', "ANS", "--")'" \
			"{AQ}"   = "`=cond(`isans', "{IT}", "")'" \
			`qe' \

			"{VAR1}" = "597" \
			"{VAR2}" = "598" \
			"{VAR3}" = "`VAR3'" \
			"{VAR4}" = "`=`VAR3' + 1'" \
			"{VAR5}" = "`VAR5'" \
			"{VAR6}" = "`VAR6'" \
			"{VAR7}" = "`VAR7'" \
			"{VAR8}" = "`VAR8'" \
			"{VAR9}" = "`VAR9'" \

			"{USE}"           = "use {DATA}, clear" \
			"{DATA}"          = `""Raw/Stata 102""' \
			"{DATA_BASE}"     = "Stata 102" \
			"{DATA_BACK}"     = `""Raw\Stata 102""' \
			"{DATA_CASTECSV}" = `""Raw/Clean castename.csv""' \
			"{DATA_CASTEDTA}" = `""Raw/Clean castename""' \
			"{DATA_DEMOXLS}"  = `""Raw/Demo Info.xlsx""' \
			"{DATA_DEMOCSV}"  = `""Raw/Demo Info.csv""' \
			"{DATA_MERGE}"    = `""Raw/New Variables.dta""' \
			"{DATA_APPEND}"   = `""Raw/New Observations.dta""' \
			
			"{HEAD}"     = "`head'" \
			"{HEAD1}"    = `"{view `"{START-}"':"' \
			"{PS!}"      = "{it:Problem set}{BR}" \
			"{PSANS!}"   = "{it:Problem set answers}{BR}" \
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

			`links' \

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
		/*preserve*/
		, /* comma so that I can specify "," to -subinstr()- without -do-
		thinking I'm specifying options */
	;
	#d cr
}

* Back up "Do to SMCL.do".
loc date = strofreal(date(c(current_date), "DMY"), "%tdCCYY.NN.DD")
copy "`otherstata'/Do to SMCL.do" "Archived/Do to SMCL/Do to SMCL `date'.do", replace

* Move the start page to a different directory.
loc intro Stata 102.smcl
copy  "SMCL/Introduction/`intro'" "`intro'", replace
erase "SMCL/Introduction/`intro'"

cd "`curdir'"


/* -------------------------------------------------------------------------- */
				/* old code					*/

/* Old directives:

"{NEXT2T}"   = "Next Task:        " \
"{PREV2T}"   = "Previous Task:    " \

*/

/*
//foreach dir in Concepts Tasks {
loc dir ""
{
	loc subdirs : dir "Pseudo-SMCL/Question directives/`dir'" dir *
	foreach subdir of loc subdirs {
		loc files : dir "Pseudo-SMCL/Question directives/`dir'/`subdir'" file "*.do", respect
		foreach f of loc files {
			di as res "`f'"

			loc base : subinstr loc f ".do" ""

			tempfile t1 t2 t3
			tempname fhin fhout

			filefilter "Pseudo-SMCL/Question directives/`dir'/`subdir'/`f'" `t1', from("/*") to("{CT}{AQ}")
			filefilter `t1'  `t2', from("*/") to("{CT/}")

			file open `fhin' using `t2', r
			* "nlines" for "number of lines"
			loc nlines 0
			file r `fhin' line
			while !r(eof) {
				loc ++nlines
				file r `fhin' line
			}
			file close `fhin'

			file open `fhin'  using `t2', r
			file open `fhout' using `t3', w replace

			file w `fhout' ///
				"#d ;" _n ///
				`"loc questions "\`questions' \`=cond(\`:length loc questions', "\", "")' "{`base'}" = "' ///
				"`" `"""'
			if regexm("`base'", "[0-9]+$") ///
				file w `fhout' "* {Q\`=regexs(0)'QDIRECTITLEFORM}{NEW}{O}" _n
			///file w `fhout' _n
			loc linenum 0
			file r `fhin' line
			while !r(eof) {
				if `++linenum' != `nlines' | `:length loc line' {
					if `linenum' > 1 ///
						file w `fhout' "{O}" _n
					mata: if (substr(st_local("line"), 1, 1) == "*") ///
						st_local("line", "*{AQ}" + substr(st_local("line"), 2, .));;
					file w `fhout' `"`macval(line)'"'
				}
				file r `fhin' line
			}
			file w `fhout' "{O}" _n `"* {DEF}""' "'" `"";"' _n

			file close `fhin'
			file close `fhout'

			//noi type `t3'
			include `t3'
		}
	}
}
*/

timer off 1
timer list 1
