/*
Author: Matt White, Innovations for Poverty Action, mwhite@poverty-action.org
Purpose: Convert a pseudo-SMCL file to a SMCL file and do-file. Pseudo-SMCL is like
	SMCL, with the following differences:
	1. Pseudo-SMCL looks more like a do-file than a SMCL file, although it may
	contain SMCL directives. Commands are converted to clickable {stata}
	directives and comments are converted to text. Paragraph directives are
	rare in pseudo-SMCL: the conversion handles most of that by converting
	whitespace in the pseudo-SMCL file.
	- Loops and other blocks are converted to text, but there's a clickable
	"Click here to execute" below them that executes them. The blocks' code is
	stored in a do-file associated with the resulting SMCL file.
	2. There are more directives. They are specified through `subinstr'.
Date of last revision: June 30, 2013
*/

vers 10

/*
c postk
loc module Concepts/Saved results
loc infile   Pseudo-SMCL/`module'.do
loc smclfile SMCL/`module'.smcl
loc dofile   Do/`module'.do
loc replace 1
*/


********************************************************************************
********************************PARSE PARAMETERS********************************
********************************************************************************

if "`infile'`smclfile'`dofile'`trim'`viewsmcl'`viewdo'`replace'`preserve'" == "" & !`:length loc subinstr' {
	mata: st_local("0", ", " + st_local("0"))
	syntax, infile(str) smclfile(str) dofile(str) [trim(str) subinstr(str asis) viewsmcl viewdo replace preserve]

	foreach option in viewsmcl viewdo replace preserve {
		loc `option' = "``option''" != ""
	}
}
else {
	foreach option in viewsmcl viewdo replace preserve {
		if "``option''" == "" ///
			loc `option' 0
	}
}

conf f "`infile'"

assert regexm("`smclfile'", "\.smcl$")

assert regexm("`dofile'", "\.do$")

assert !inlist("`infile'", "`smclfile'", "`dofile'")

foreach option in viewsmcl viewdo replace preserve {
	assert inlist(``option'', 0, 1)
}

if !`replace' {
	conf new f "`smclfile'"
	conf new f "`dofile'"
}

loc ok commands comments
loc trimcmds 0
loc trimcomments 0
foreach el of loc trim {
	if !`:list el in ok' {
		di as err "invalid option trim()"
		ex 198
	}

	if "`el'" == "commands" ///
		loc trimcmds 1
	else if "`el'" == "comments" ///
		loc trimcomments 1
}

* Pilfered from -cfout2-
* -subinstr()-
glo subinstr "`subinstr'"
loc syntaxerr 0
loc len : length loc subinstr
while `len' {
	* "dq" for "double quotes"
	gettoken from subinstr : subinstr, p("=") qed(dq)
	if !`dq' ///
		loc syntaxerr 1
	* "cq" for "compound quotes"
	loc temp : subinstr loc from `"""' "", count(loc cq)
	loc subfromcq `subfromcq' `cq'
	if `cq' ///
		loc subfrom "`subfrom' `"`from'"'"
	else ///
		loc subfrom "`subfrom' "`from'""

	* "thisao" for "this assignment operator"
	gettoken thisao subinstr : subinstr, p("=")
	loc ao "="
	if !`:list thisao == ao' ///
		loc syntaxerr 1

	gettoken to subinstr : subinstr, p("\") qed(dq)
	if !`dq' ///
		loc syntaxerr 1
	loc temp : subinstr loc to `"""' "", count(loc cq)
	loc subtocq `subtocq' `cq'
	if `cq' ///
		loc subto "`subto' `"`to'"'"
	else ///
		loc subto "`subto' "`to'""

	gettoken thisbs subinstr : subinstr, p("\")
	loc bs \
	if `:length loc thisbs' & !`:list thisbs == bs' ///
		loc syntaxerr 1

	if `syntaxerr' ///
		continue, break
	else ///
		loc len : length loc subinstr
}
if `syntaxerr' {
	di as err "option subinstr() invalid"
	ex 198
}

glo subfrom "`subfrom'"
glo subto   "`subto'"


********************************************************************************
**********************************IMPORT FILE***********************************
* Variables created: line, ws, indent
********************************************************************************

if `preserve' preserve

tempname fh
file open `fh' using "`infile'", r

clear
gen line = ""
loc first 1
while `first' | !r(eof) {
	file r `fh' line
	set obs `=_N + 1'
	replace line = `"`macval(line)'"' in L
	loc first 0
}

file close `fh'

/*
* -subinstr()-
forv i = 1/`:list sizeof subfrom' {
	foreach str in from to {
		loc `str'   : word `i' of `sub`str''
		loc `str'cq : word `i' of `sub`str'cq'
		if ``str'cq' ///
			loc `str' "`"``str''"'"
		else ///
			loc `str' ""``str''""
	}

	qui replace line = subinstr(line, `from', `to', .)
}*/

* -subinstr()-

assert "`:type line'" != "str`c(maxstrvarlen)'"
recast str244 line

mata:

X = st_sdata(., "line")
subfrom = tokens(st_local("subfrom"))
subto   = tokens(st_local("subto"))
for (i = 1; i <= cols(subfrom); i++) {
	X = subinstr(X, subfrom[i], subto[i], .)
}

end

mata:

// "pstr" for "parse string"
pstr = "{O} "
if (!any(strpos(X, pstr)))
	st_sstore(., "line", X)
else {
	split = J(0, 1, "")
	sort = J(0, 2, .)
	n = 1::rows(X)
	X = X :+ pstr
	pstrlen = strlen(pstr)
	max = max((strlen(X) - strlen(subinstr(X, pstr, "", .))) / pstrlen)
	for(i = 1; i <= max; i++) {
		// Extract the next piece from X.
		pos = strpos(X, pstr)
		piece = select(substr(X, 1, pos :- 1), pos)
		// Add the piece to split.
		split = split \ piece
		// Remove the piece from X.
		X = substr(X, pos :+ pstrlen, .)
		// Sort order of piece
		rows = rows(piece)
		sort = sort \ select(n, pos), J(rows(piece), 1, i)
	}
	_collate(split, order(sort, 1..2))

	st_addobs(rows(split) - st_nobs())
	st_sstore(., "line", split)
}

end

assert line != "XXX"

cou if strpos(strlower(line), "other data checks")
loc n1 = r(N)
cou if strpos(strlower(line), "problem set") & _n < 20
loc n2 = r(N)
if `n1' & `n2' & !regexm(strlower("`infile'"), "alternative|working") ///
	di //stop

compress line
assert "`:type line'" != "str`c(maxstrvarlen)'"

* Replace tabs as spaces.
replace line = subinstr(line, char(9), "    ", .)

* Save leading whitespace in variable ws.
gen ws = regexs(0) if regexm(line, "^ *")

* Remove leading and trailing whitespace.
replace line = trim(line)

* Variable indent contains the SMCL paragraph mode setting.
gen wslen = strlen(ws)
* The indent in the SMCL file will be four spaces more than the indent in the
* input file.
replace wslen = wslen + 4
#d ;
gen indent =
	cond(wslen == 4,  "{pstd}",
	cond(wslen == 8,  "{pmore}",
	cond(wslen == 12, "{pmore2}",
	cond(wslen == 16, "{pmore3}",
	"{p " + strofreal(wslen) + " " + strofreal(wslen) + " 2}"
	))))
;
#d cr
drop wslen


********************************************************************************
************************************COMMENTS************************************
* Variables created: comment
********************************************************************************

* Note: // comment indicators aren't accounted for.

* * comment indicator
gen comment = regexm(line, "^\*")

* /* */ comment delimiter
gen incomment = regexm(line, "^/\*")
gen endcomment = regexm(line, "\*/$")
replace incomment = 1 if incomment[_n - 1] == 1 & !endcomment[_n - 1]
replace comment = 2 if incomment
drop incomment endcomment

* Remove comment indicators.
replace line = regexr(line, "^\*", "") if comment == 1
replace line = regexr(regexr(line, "^/\*", ""), "\*/$", "") if comment == 2
replace line = trim(line)

* -trim()-
if `trimcomments' ///
	replace line = itrim(line) if comment
else {
	count if strpos(line, "  ") & comment
	while r(N) {
		gen spaces = regexs(0) if regexm(line, "  +") & comment
		replace line = subinstr(line, spaces, "{space " + strofreal(strlen(spaces)) + "}", 1) if spaces != "" & comment
		drop spaces

		count if strpos(line, "  ") & comment
	}
}

* Indent comments.
gen toindent1 = comment & !regexm(line, "^[`=char(13)'`=char(10)']*$") & ///
	!regexm(line, "^({\.\.\.})?({marker [^}]+})?({\.\.\.})?$") & substr(line, 1, 3) != "{* "
gen toindent2 = !regexm(line, "^[`=char(13)'`=char(10)']*{(hline|p|pstd|pmore[23]?|(p|p2colset) [0-9 ]+)}") & ///
	(!toindent1[_n - 1] | indent != "{pstd}")
	//(!comment[_n - 1] | regexm(line[_n - 1], "^[`=char(13)'`=char(10)']*$") | indent != "{pstd}")
gen toindent = toindent1 & toindent2
replace line = indent + line if toindent
replace line = "{p_end}" + line + "{p_end}{pstd}" if toindent & toindent1[_n - 1] & indent != "{pstd}"

//cou if strpos(line, "XXXXX")
//if r(N) stop


********************************************************************************
************************************COMMANDS************************************
* Variables created: cmd
* Note: Not dropping other variables for debugging purposes. They won't appear
*	after this section.
********************************************************************************

gen cmd = !comment & line != ""

* -trim()-
if `trimcmds' replace line = itrim(line) if cmd

gen startblock = regexm(line, "{$") & cmd
gen endblock = -(regexm(line, "(^|[^({BLOCK)])}") & cmd)
gen inblock = sum(startblock + endblock)

* Now all variables are 0 or 1, and embedded loops have startblock != 0 and
* endblock != 0.
replace startblock = 0 if inblock > 1
replace endblock = 0 if inblock
replace endblock = -endblock
* Final close braces
replace inblock = 1 if !inblock & endblock
replace inblock = 1 if inblock

gen linenum = _n

cap pr drop extendends
pr extendends
	syntax, start(varname) in(varname) end(varname)

	gsort -linenum
	tempvar newstart
	gen `newstart' = 0
	replace `newstart' = 1 if (`start'[_n - 1] == 1 | `newstart'[_n - 1] == 1) & line != ""
	replace `start' = 0 if `newstart'[_n + 1] == 1
	replace `in' = 1 if `newstart'
	replace `newstart' = 0 if `newstart'[_n + 1] == 1
	sort linenum
	replace `start' = 1 if `newstart'

	tempvar newend
	gen `newend' = 0
	replace `newend' = 1 if (`end'[_n - 1] == 1 | `newend'[_n - 1] == 1) & line != ""
	replace `end' = 0 if `newend'[_n + 1] == 1
	replace `in' = 1 if `newend'
	replace `newend' = 0 if `newend'[_n + 1] == 1
	replace `end' = 1 if `newend'
end

extendends, start(startblock) in(inblock) end(endblock)

gen startdelim = regexm(line, "^#(d|de|del|deli|delim|delimi|delimit) +;$") & cmd
gen delim = startdelim
gen enddelim = regexm(line, "^#(d|de|del|deli|delim|delimi|delimit) +cr;?$") & cmd
replace delim = 1 if delim[_n - 1] == 1 & !enddelim[_n - 1]

extendends, start(startdelim) in(delim) end(enddelim)

assert !(inblock & ((startdelim & !startblock) | (enddelim & !endblock)))
replace startblock = 1 if startdelim
replace inblock = 1 if delim
replace endblock = 1 if enddelim

gen join = regexm(line, "///$") & cmd
gen startjoin = join & !join[_n - 1]
gen endjoin = !join & join[_n - 1] == 1
replace join = 1 if endjoin

extendends, start(startjoin) in(join) end(endjoin)

assert !(inblock & ((startjoin & !startblock) | (endjoin & !endblock)))
replace startblock = 1 if startjoin
replace inblock = 1 if join
replace endblock = 1 if endjoin

* "direc" for "{BLOCK} directive"
gen direc = regexm(line, "^{BLOCK}") & cmd
gen startdirec = direc & !direc[_n - 1]
gen enddirec = direc & !direc[_n + 1]

assert !(inblock & ((startdirec & !startblock) | (enddirec & !endblock)))
replace startblock = 1 if startdirec
replace inblock = 1 if direc
replace endblock = 1 if enddirec

replace line = regexr(line, "^{BLOCK}", "") if cmd

gen blocknum = sum(startblock)

count if startblock
if r(N) {
	* Write do-file.
	if "`:type line'" == "str`c(maxstrvarlen)'" {
		di as err "line too long"
		ex 198
	}
	file open `fh' using "`dofile'", w replace
	file w `fh' ///
		"args example" _n(2) ///
		`"loc trace = c(trace) == "on""' _n ///
		"if " _char(96) "trace' set trace off" _n(2) ///

	forv i = 1/`=_N' {
		if inblock[`i'] {
			if blocknum[`i'] != blocknum[`i' - 1] {
				file w `fh' ///
					"`=cond(blocknum[`i'] == 1, "", "else ")'if " _char(96) "example' == `=blocknum[`i']' {" _n ///
						_tab "if " _char(96) "trace' set trace on" _n ///
						_tab "noi {" _n(2)
			}

			loc line = line[`i']
			file w `fh' `"`=ws[`i']'`macval(line)'"' _n

			if endblock[`i'] {
				file w `fh' ///
						_n _tab "}" _n ///
						_tab "if " _char(96) "trace' set trace off" _n ///
					"}" _n
			}
		}
	}
	file close `fh'
}

* Bold blocks.
replace line = "{cmd}" + line + "{txt}" if inblock & line != ""

* -trim()-
gen spaceline = line if cmd
if !`trimcmds' {
	count if strpos(spaceline, "  ")
	while r(N) {
		gen spaces = regexs(0) if regexm(spaceline, "  +") & cmd
		replace spaceline = subinstr(spaceline, spaces, "{space " + strofreal(strlen(spaces)) + "}", 1) ///
			if spaces != "" & cmd
		drop spaces

		count if strpos(spaceline, "  ")
	}
}

* Enclose commands outside blocks in {stata} directives,
* adding indent and internal spaces.
gen nointernal = line == spaceline
replace line = indent + "{bf:{stata `" + `"""' + line + `"""' + "'}}{p_end}" ///
	if cmd & !inblock & nointernal
replace line = indent + "{bf:{stata `" + `"""' + line + `"""' + "':" + spaceline + "}}{p_end}" ///
	if cmd & !inblock & !nointernal
drop nointernal

* Add indent and internal spaces to comments to blocks.
replace line = indent + spaceline + "{p_end}" if inblock & line != ""

drop spaceline

replace line = line + "{p_end}" if comment & (toindent | toindent1[_n - 1]) & cmd[_n + 1] == 1

* Add "Click here to execute" after blocks.
expand 4 if endblock, gen(copy)
replace line = "" if copy
* So "Click here to execute" is not written multiple times
replace endblock = 0 if copy
* So "Click here to execute" is not indented
replace indent = "{pstd}" if copy
sort linenum copy
replace line = indent + "{stata `" + `""run "`dofile'" "' + strofreal(blocknum) + `"""' + "':Click here to execute.}" ///
	if endblock[_n - 2] == 1
drop if copy & line == "" & line[_n + 1] == ""
drop copy


********************************************************************************
***********************************FINISH UP************************************
********************************************************************************

* Write .smcl file.
if "`:type line'" == "str`c(maxstrvarlen)'" {
	di as err "line too long"
	ex 198
}
file open `fh' using "`smclfile'", w replace
file w `fh' "{smcl}" _n "{txt}{...}" _n
forv i = 1/`=_N' {
	loc line = line[`i']
	file w `fh' `"`macval(line)'"' `=cond(`i' < _N, "_n", "")'
}
file close `fh'

if `viewsmcl' view "`smclfile'"
if `viewdo'   doedit "`dofile'"
