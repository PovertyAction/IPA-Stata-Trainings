/*
Syntax

include "Shared directives.do" eol()

Options
-------
eol()		End-of-line delimiter for SMCL files
p()			Default paragraph indent
boxwidth()	Width of text boxes (not including indent)
*/

mata: st_local("0", ", " + st_local("0"))
syntax, [eol(str) p(str) boxwidth(integer 80)]

* Parse -eol()-.
if !`:length loc eol' ///
	loc eol `=char(13)'`=char(10)'

* Parse -p()-.
if !`:length loc p' ///
	loc p {pstd}

* New line directives
loc new ""{NEW}" = "`eol'" \"
foreach i of numlist 2 46 48 {
	loc new "`new' "{NEW`i'}" = "`:di _dup(`i') "`eol'"'" \"
}

#d ;
loc shared_subinstr1 (
	"QTITLE" = "\`=cond(\`isans', "ANS", "--")'" \
);
loc shared_subinstr2 (
	"{CT}"   = "/{STAR}" \
	"{CT/}"  = "{STAR}/" \
	"{STAR}" = "*" \
	"{SEMI}" = ";" \
	"{DQ}"   = `"""' \
	"{LSQ}"  = "`" \

	"{AQ}"   = "\`=cond(\`isans', "{IT}", "")'" \

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
);
#d cr
forv i = 1/2 {
	mata: st_local("shared_subinstr`i'", ///
		substr(st_local("shared_subinstr`i'"), 2, ///
		strlen(st_local("shared_subinstr`i'")) - 2))
}
* For backwards compatibility
mata: st_local("shared_subinstr", st_local("shared_subinstr2"))
