* Author: Matt White, Innovations for Poverty Action, mwhite@poverty-action.org
* Purpose: Search all do-files and pseudo-SMCL files in specified directories
* for lines matching a specified regular expression.
* Date of last revision: September 6, 2013

vers 10

* Search for do-file lines matching this regular expression.
loc regex {string

* 1 for case-sensitive regular expression matching; 0 otherwise.
loc sensitive 0

c adv13
loc dirs Introduction Modules Answers
mata: st_local("dirs", ///
	invtokens(`""Pseudo-SMCL/"' :+ tokens(st_local("dirs")) :+ `"""'))


/* -------------------------------------------------------------------------- */
				/* initialize				*/

* Check the parameters.
foreach dir of loc dirs {
	mata: assert(direxists(st_local("dir")))
}
assert inlist(`sensitive', 0, 1)

set varabbrev off

clear mata

* Set up the search in Mata.

loc RS real scalar
loc RC real colvector
loc SS string scalar
loc SR string rowvector
loc SC string colvector
loc SM string matrix

mata:
mata set matastrict on

string matrix function searchfile(`SS' _fn, `SR' _fileinfo, `SS' _regex,
	`RS' _sensitive)
{
	`RS' fh, pos, rows, i
	`RC' eol, linenums, select
	`SC' lines
	`SM' info
	transmorphic t

	// Read _fn, storing it in lines.
	fh = fopen(_fn, "r")
	fseek(fh, 0, 1)
	pos = ftell(fh)
	fseek(fh, 0, -1)
	t = tokeninit("", (char(13) + char(10), char(10), char(13)), "")
	tokenset(t, fread(fh, pos))
	fclose(fh)
	lines = tokengetall(t)'

	// Define linenums and remove EOL delimiters.
	eol = lines :== char(13) + char(10) :| lines :== char(13) :| lines :== char(10)
	linenums = runningsum(eol) :+ 1
	lines    = select(lines,    !eol)
	linenums = select(linenums, !eol)

	// Apply the regex filter.
	if (length(lines))
		select = regexm((_sensitive ? lines : strlower(lines)), _regex)
	else
		select = J(0, 1, .)
	lines    = select(lines,    select)
	linenums = select(linenums, select)

	// Return result.
	if (rows = rows(lines))
		lines = subinstr(lines, char(9), "<T>", .)
	info = J(0, cols(_fileinfo), "")
	for (i = 1; i <= rows; i++) {
		info = info \ _fileinfo
	}
	return(info, (rows ? lines, strofreal(linenums) : J(0, 2, "")))
}

end


/* -------------------------------------------------------------------------- */
				/* search					*/

* `sensitive'
if !`sensitive' ///
	mata: st_local("regex", strlower(st_local("regex")))

* Search.
mata: lines = J(0, 4, "")
foreach dir of loc dirs {
	loc files : dir `"`dir'"' file "*.do", respect
	foreach file of loc files {
		di as res `"`dir'/`file'"'
		mata: lines = lines \ ///
			searchfile(`"`dir'/`file'"', (`"`dir'"', `"`file'"'), ///
			st_local("regex"), `sensitive')
	}
}

* Load the search results into memory.

drop _all

mata:

st_addobs(rows(lines))
(void) st_addvar("str244", ("dir", "file", "line", "linenum"))
// Remove leading and trailing blanks.
st_sstore(., ., strtrim(lines))

end

destring, replace

compress

di as txt "Number of observations: " as res _N
