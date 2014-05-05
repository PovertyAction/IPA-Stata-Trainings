* Author: Matt White, Innovations for Poverty Action, mwhite@poverty-action.org
* Purpose: List the commands of a do-file.
* Date of last revision: May 12, 2013

* The do-file whose commands will be listed
local dofile Pseudo-SMCL/Concepts/by.do


********************************************************************************
**********************************IMPORT FILE***********************************
********************************************************************************

if `:length loc 1' ///
	loc dofile `1'

tempname fh
file open `fh' using `"`dofile'"', r

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

* Replace tabs as spaces.
replace line = subinstr(line, char(9), "    ", .)

* Save leading whitespace in variable ws.
//gen ws = regexs(0) if regexm(line, "^ *")

* Remove leading and trailing whitespace.
replace line = trim(line)

* Remove blank lines.
drop if missing(line)


********************************************************************************
************************************COMMENTS************************************
********************************************************************************

* * comment indicator
gen comment = regexm(line, "^\*")

* // comment indicator
replace comment = 3 if regexm(line, "^//")

* /* */ comment delimiter
gen incomment = regexm(line, "^/\*")
gen endcomment = regexm(line, "\*/$")
replace incomment = 1 if incomment[_n - 1] == 1 & !endcomment[_n - 1]
replace comment = 2 if incomment
drop incomment endcomment


********************************************************************************
************************************COMMANDS************************************
********************************************************************************

gen cmd = !comment

gen join = regexm(line, "///$") & cmd
gen startjoin = join & !join[_n - 1]
gen endjoin = !join & join[_n - 1] == 1
replace join = 1 if endjoin

* "dsc" for "delimit semicolon"
gen dsc = regexm(line, "^# *(d|de|del|deli|delim|delimi|delimit) *;+$")
gen dcr = regexm(line, "^# *(d|de|del|deli|delim|delimi|delimit) +cr *;+$")

gen startdelim = dsc & cmd
gen delim = startdelim
gen enddelim = dcr & cmd
replace delim = 1 if delim[_n - 1] == 1 & !enddelim[_n - 1]

* Lines for which the delimiter is ; and that contain more than two semicolons
* are not supported.
//assert strlen(line) - strlen(subinstr(line, ";", "", .)) < 2
* Lines with code after the ; are not supported.
gen sc = strpos(line, ";") != 0
//assert regexm(line, ";$") if sc
gen cmdend = sc if delim
gen cmdstart = inlist(1, cmdend[_n - 1], dsc[_n - 1]) if delim


********************************************************************************
***********************************FINISH UP************************************
********************************************************************************

keep if cmd & cmdstart & (!join | startjoin)

gen command = word(line, 1)
replace command = regexr(command, ";$", "") if delim
keep command

replace command = regexr(command, ",$", "")

if _N ///
	duplicates drop

drop if inlist(command, "{", "}") | strmatch(command, "#*")

gen invalid = 0
gen user = 0
forv i = 1/`=_N' {
	cap unabcmd `=command[`i']'
	if _rc ///
		replace invalid = 1 in `i'
	else {
		loc cmd `r(cmd)'
		replace command = "`cmd'" in `i'
		cap findfile `cmd'.ado, path(UPDATES;BASE)
		if _rc {
			cap findfile `cmd'.ado
			if !_rc ///
				replace user = 1 in `i'
		}
	}
}

sort invalid user command
