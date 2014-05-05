/* {HEAD}

{STRINGS!}
{PSANS!}

{STRINGS_ANSQ1}
{STRINGS_ANSQ2}
{STRINGS_ANSQ3}
{STRINGS_ANSQ4}
{STRINGS_ANSQ5}
{STRINGS_ANSQ6} */

{STRINGS_Q1}

/* The first approach to string cleaning is
making
{view `"{STRINGS-}##exact"':exact replacements}
to various string variables,
such that specific string values are replaced
with other specific string values.

The second broad strategy is specifying
{view `"{STRINGS-}##patterns"':{it:patterns}} to be replaced
rather than individual strings.
A particular pattern that describes string values is specified,
and all strings that match the pattern are replaced with another string.

Both methods are usually preceded by
{view `"{STRINGS-}##basic"':basic string cleaning},
which may involve standardizing letter case
and removing extraneous characters.
The two methods are also not mutually exclusive:
you'll often make at least a few exact replacements before
using pattern or string matching. */

{STRINGS_Q2}

levelsof newcaste
foreach level in `r(levels)' {
	display "`level'"
}

{STRINGS_Q3}

/* {view `"{RECODING-}"':{bf:recode}} is an alternative to {cmd:replace}.
However, {cmd:recode} takes only numeric variables. */

{STRINGS_Q4TOP}

{STRINGS_Q4A}

/* Similarly to
using {bf:#delimit ;} for value labels,
{cmd:#delimit ;} here allows
the different versions of the caste names to be spaced out,
enhancing readability. */

{STRINGS_Q4B}

/* It is because {cmd:"MEHTA JAIN"} contains a space. Without the double quotes, Stata
would ignore the space, and would interpret {cmd:"MEHTA JAIN"} as two different values:
{cmd:"MEHTA"} and {cmd:"JAIN"}. */

{STRINGS_Q4C}

/* Yes:{BR}
1. The standardized name cannot contain a space, since macro names cannot contain spaces.{BR}
2. The standardized name cannot be more than 22 characters, since
local macro names can be at most 31 characters,
and {cmd:"_versions"} is 9. */

{STRINGS_Q5TOP}

{STRINGS_Q5A}

* Using {helpb proper()}:

generate newcaste = proper(castename)

{STRINGS_Q5B}

quietly tabulate newcaste
display "There are `r(r)' unique caste names."

{STRINGS_Q6TOP}

{STRINGS_Q6A}

* Using {helpb wordcount()}:

generate multiword = wordcount(newcaste) > 1 if !missing(newcaste)

* Alternatively, using {helpb strpos()}:

generate multiword = strpos(newcaste, " ") != 0 if !missing(newcaste)

* Both approaches use {view `"{DUMMIES-}"':logical expressions}.

{STRINGS_Q6B}

quietly tabulate newcaste if multiword
display "There are `r(r)' unique multiword caste names."

{STRINGS_Q6C}

* Any truly robust process for this would be complicated,
* but here's a first attempt:

levelsof newcaste
foreach caste in `r(levels)' {
	if strpos("`caste'", " ") {
		local nospaces = subinstr("`caste'", " ", "", .)
		count if newcaste == "`nospaces'"
		if r(N) > 0 {
			replace newcaste = "`nospaces'" if newcaste == "`caste'"
		}
	}
}

/* Here, we first use {helpb strpos()} to determine
whether each value of {cmd:newcaste}, stored in {cmd:`caste'},
contains one or more spaces:

{CMD}
if strpos("`caste'", " ") {
{DEF}

If it does, we examine whether any value of {cmd:newcaste}
equals {cmd:`caste'} with its spaces removed ({cmd:`nospaces'}):

{CMD}
local nospaces = subinstr("`caste'", " ", "", .){BR}
count if newcaste == "`nospaces'"{BR}
if r(N) > 0 {
{DEF}

If there is such a value, then the spaces are removed from the original caste name,
and all values of {cmd:`caste'} are replaced with {cmd:`nospaces'}:

{CMD}
replace newcaste = "`nospaces'" if newcaste == "`caste'"
{DEF} */

/* {FOOT}

{STRINGS_PS2}
{TOMOD}{STRINGS}

{START} */
