/* {HEAD}

{STRINGS!} */

/* Very often, whether due to the enumerator, the data entry operator, or just the
fact that certain places, people, and things have different names,
string variables will have multiple spellings for the same response.
For example, a single province variable may have
{cmd:"Chhattisgarh"}, {cmd:"Chattisgarh"}, and {cmd:"Chatisgarr"}.
Or, an occupation variable might have
{cmd:"tailor"}, {cmd:"sewer"}, and {cmd:"clothes repairer"},
all of which refer to the same job.
Creating good codes for your questionnaire can help prevent this.
However, you will almost always have open-ended response variables
that you need to standardize.

In some cases, such as the names of cities and states,
standardizing is pretty straightforward.
At other times,
whether or not two different responses are really the same
might involve a judgment call.
In these cases, you should discuss the coding with your supervisor.

There are two broad strategies for cleaning strings.
The first is specifying the exact changes you want to make.
For example, you might decide that {cmd:"Chhattisgarh"} and {cmd:"Chatisgarr"}
should be replaced as {cmd:"Chattisgarh"}.
The second main approach is specifying string {it:patterns}.
For instance, you might say that any string
that begins with {cmd:"Ch"} and contains {cmd:"tis"} followed somewhere by {cmd:"gar"}
should be replaced as {cmd:"Chattisgarh"}.

Either approach is typically preceded by some basic string standardization,
for example, making all strings lowercase
so that differences in letter case aren't counted as different responses.

This module is divided into three sections:

{view `"{STRINGS-}##basic"':1. Basic string cleaning}{BR}
{view `"{STRINGS-}##exact"':2. Specifying exact replacements}{BR}
{view `"{STRINGS-}##patterns"':3. Pattern and string matching}

{hline}{marker basic}

{bf:1. Basic string cleaning}

{hline} */

{USE}

/* Here, we will standardize the string variable {cmd:castename}.
First, we have to get a list of its unique values: */

tabulate castename

/* Notice that a lot of the differences in {cmd:castename} are caused by differences
in capitalization and punctuation. We can remove these by making all values of
{cmd:castename} the same case, removing punctuation, and removing excess spaces: */

tabulate castename
local oldr = r(r)
display "There are `oldr' unique values of castename."

bysort castename: generate oldn = _N

/* {cmd:r(r)} is a {view `"{RESULTS-}"':saved result}
stored by {cmd:tabulate}.
Recall also that in this case with {cmd:by},
{bf:_N} is
the number of observations in the by-group.

The following command converts all values of {cmd:castename} to uppercase: */

generate newcaste = upper(castename)

bysort newcaste: generate newn = _N

sort newcaste oldn
browse castename newcaste oldn newn if oldn != newn

* Using {helpb quietly} with {cmd:tabulate},
* since all we need from {cmd:tabulate} is its saved result {cmd:r(r)} {hline 2}
* we're not interested in its output:

quietly tabulate newcaste
local newr = r(r)
display "Letter case has been standardized. newcaste now has " `oldr' - `newr' " fewer values than castename."

* The following replaces all instances of {cmd:"."} in {cmd:newcaste} with {cmd:""}:

replace newcaste = subinstr(newcaste, ".", "", .)

* This replaces all instances of {cmd:","} in {cmd:newcaste} with {cmd:""}:

replace newcaste = subinstr(newcaste, ",", "", .)

quietly tabulate newcaste
local newr = r(r)
display "Punctuation has been removed. newcaste now has " `oldr' - `newr' " fewer values than castename."

* This removes all spaces at the start or end of {cmd:newcaste}:

replace newcaste = trim(newcaste)

/* This replaces multiple, consecutive internal spaces {hline 2}
that is, two or more spaces in a row in the middle of {cmd:newcaste} {hline 2}
with a single space: */

replace newcaste = itrim(newcaste)

quietly tabulate newcaste
local newr = r(r)
display "Spaces have been trimmed. newcaste now has " `oldr' - `newr' " fewer values than castename."

/* The combination of {cmd:trim()} and {cmd:itrim()} removes all excess spaces.
However, for castes that are more than one word long,
it preserves a single space between words.
For string variables that are supposed to be only one word,
you may want to remove all spaces entirely.
To do this for {cmd:newcaste}, we could have coded:

{cmd:replace newcaste = subinstr(newcaste, " ", "", .)}

See {helpb subinstr()} for more options for string substitution.

We now have a much shorter list of caste names: */

tabulate newcaste

/* I saw after my first use above of {cmd:tabulate castename}
that we needed to remove periods, commas, and excess spaces.
You can also use the {help SSC} program {cmd:charlist}
to get the list of characters in a string: */

ssc install charlist

/* {...}
{TRYITCMD}
charlist castename
{DEF}

We now have a cleaner list of caste names.
You might want to copy this list of names to Excel
for easy viewing and further cleaning.
However, copying the table from {cmd:tabulate} above doesn't work. What to do? */

{STRINGS_Q2}

/* {hline}{NEW48}

There's an alternative solution:

{TRYITCMD}
egen tag = tag(newcaste)
{DEF} */

browse newcaste if tag

/* {help egen:{bf:egen tag(}{it:varlist}{bf:)}} "tags" one observation
in each distinct group of {varlist}.
The result will be {cmd:1} for observations that are tagged
and for which {it:varlist} is all nonmissing,
and {cmd:0} otherwise.

The following command:

{cmd:browse newcaste if tag}

displays each unique value of {cmd:newcaste} just once.
You can then copy this list to Excel.

{hline}{marker exact}

{bf:2. Specifying exact replacements}

{hline} */

{USE}

* Recreating {cmd:newcaste} by completing
* {view `"{STRINGS-}##basic"':basic string cleaning}:

generate newcaste = upper(castename)
replace newcaste = subinstr(newcaste, ".", "", .)
replace newcaste = subinstr(newcaste, ",", "", .)
replace newcaste = trim(itrim(newcaste))

/* Once you've decided on the standardized responses, you can make
replacements. For example, suppose these are all the same caste:

{cmd:SUDAT SUDHAR SUHALAKA SUMEJA SUNAR SUTAR SUTHAR}

If I wanted to standardize {cmd:newcaste} by changing all these values to {cmd:"SUDAT"}, I could code: */

replace newcaste = "SUDAT" if newcaste == "SUDHAR" | ///
	newcaste == "SUHALAKA" | newcaste == "SUMEJA"  | ///
	newcaste == "SUNAR"    | newcaste == "SUTAR"   | ///
	newcaste == "SUTHAR"

* To be efficient, I could use the function {helpb inlist()} in place of this code:

replace newcaste = "SUDAT" if inlist(newcaste, "SUDHAR", "SUHALAKA", "SUMEJA", "SUNAR", "SUTAR", "SUTHAR")

/* {cmd:inlist(}{it:z}{cmd:,} {it:a}{cmd:,} {it:b}{cmd:,} {it:...}{cmd:) == 1} if {it:z} {cmd:==} {it:a} {cmd:|} {it:z} {cmd:==} {it:b} {cmd:|}
{it:...}, and {cmd:0} otherwise.
As you can see, {cmd:inlist()} results in much less code than multiple logical expressions. */

{STRINGS_Q3}

* {hline}

{USE}

* Recreating {cmd:newcaste}:

generate newcaste = upper(castename)
replace newcaste = subinstr(newcaste, ".", "", .)
replace newcaste = subinstr(newcaste, ",", "", .)
replace newcaste = trim(itrim(newcaste))

/* {marker version_loop}{...}
Here's yet another alternative, useful if you are making many replacements: */

#delimit ;
local SUDAT_versions
	SUDHAR
	SUHALAKA
	SUMEJA
	SUNAR
	SUTAR
	SUTHAR
;
local MEHTA_versions
	MEHLA
	MEHRA
	MEHRAAT
	MEHRAJ
	MEHRAT
	"MEHTA JAIN"
	MEHTAR
	MEKHBAL
	MEKHWAL
;
local REGARA_versions
	RAZAR
	RAZER
	REBARI
	REDAS
	REGAR
	REGRA
;
#delimit cr
foreach name in SUDAT MEHTA REGARA {
	foreach version of local `name'_versions {
		replace newcaste = "`name'" if newcaste == "`version'"
	}
}

{STRINGS_Q4}

/* {hline}

A similar approach does not have these limitations, but brings us outside Stata.
In Excel, you can create a .csv file like
{bf:{stata !{DATA_CASTECSV}:{DATA_CASTECSV}}}
that displays unclean {cmd:castename} versions next to the standardized {cmd:newcaste}.
You can then use {helpb insheet} to import the .csv file to Stata.
(If you're using Stata 12 or higher,
you could opt for an Excel file and {helpb import excel} instead.) */

insheet using {DATA_CASTECSV}, comma names clear

list

save {DATA_CASTEDTA}, replace

/* This dataset contains two variables: {cmd:castename} and {cmd:newcaste}.
We can merge {cmd:newcaste} into the original dataset
by using {cmd:castename} as the merge key variable.

For values of {cmd:castename} in {cmd:{DATA_CASTECSV}},
we want {cmd:newcaste} in the final dataset to equal {cmd:newcaste}
in the .csv file.
For values of {cmd:castename} {it:not} specified in the .csv file,
we want {cmd:newcaste} to equal {cmd:castename}.
We can then clean those values using other methods.

To do this, we'll first make {cmd:newcaste} a copy of {cmd:castename}: */

{USE}

generate newcaste = castename

/* We'll then use the {cmd:update replace} options of {helpb merge}
to replace {cmd:newcaste} with its value from the .csv file.

We'll merge using the suggestions from the {view `"{MERGING-}"':module on merging}.

Stata 11 or higher:

{TRYITCMD}
merge m:1 castename using {DATA_CASTEDTA}, update replace{BR}
drop if _merge == 2{BR}
{DEF}

Stata 10 or lower:

{TRYITCMD}
merge castename using {DATA_CASTEDTA}, sort uniqusing update replace{BR}
drop if _merge == 2{BR}
{DEF}

Let's examine the results: */

browse castename newcaste if _merge >= 3

/* It was easy to specify the desired replacements in the .csv file,
and we were then able to merge the changes into the original dataset.
This is probably easier than any of the other solutions we've seen:
multiple logical expressions, {cmd:inlist()}, and multiple local macros with for-loops.
However, some people may prefer to see the replacements within their do-file,
or would rather keep everything in Stata
instead of using two different programs.

{hline}{marker patterns}

{bf:3. Pattern and string matching}

{hline} */

{USE}

* Recreating {cmd:newcaste} by implementing
* the basic string cleaning described in
* {view `"{STRINGS-}##basic"':section 1} of the module:

generate newcaste = upper(castename)
replace newcaste = subinstr(newcaste, ".", "", .)
replace newcaste = subinstr(newcaste, ",", "", .)
replace newcaste = trim(itrim(newcaste))

/* So far we've covered four approaches to string cleaning:{BR}
1. {cmd:replace} with many logical expressions{BR}
2. {cmd:replace} with {cmd:inlist()}{BR}
3. {bf:For-loops}{BR}
4. {cmd:merge}

They have shared the following core strategy:
first, complete basic string cleaning (e.g., standardize letter case and remove punctuation),
then specify the exact recoding, that is, which particular strings should be replaced with which other ones.

There are other options for string cleaning that specify patterns (simple or complex)
rather than particular strings to recode.
For example, you might specify that any string that starts with {cmd:"RAJP"} be recoded as {cmd:"RAJPUT"}.
Here, a pattern ("starts with {cmd:"RAJP"}") has been specified for recoding
rather than a particular list of strings
({cmd:"RAJPOOT"}, {cmd:"RAJPUT PAWAR"}, {cmd:"RAJPUT RATHORE"}, {cmd:"RAJ PUROHIT."}, etc.).

One such option is {helpb strmatch()}. {cmd:strmatch(}{it:string}{cmd:,} {it:pattern}{cmd:) == 1} if
{it:string} matches {it:pattern}, and {cmd:0} otherwise. Two "wildcard" characters are allowed
in {cmd:strmatch()} patterns: {cmd:"?"} and {cmd:"*"}. {cmd:"?"} means that exactly one character goes
in the position that {cmd:"?"} holds, and {cmd:"*"} means that zero or more characters go in
the position that {cmd:"*"} holds.
For example, the following replaces any value of {cmd:newcaste}
that starts with {cmd:"PUS"},
is followed by exactly one character,
is followed by {cmd:"KARN"},
and is followed by zero or more characters
with the correct {cmd:castename} {cmd:"PUSHKARNA"}: */

replace newcaste = "PUSHKARNA" if strmatch(newcaste, "PUS?KARN*")

/* {cmd:"PUSHKARNEE"}, {cmd:"PUSHKARN"}, and {cmd:"PUSSKARNA"} are replaced.

Regular expression matching is a powerful tool; it's like an amplified version of {cmd:strmatch()}.
Regular expression syntax is involved, and I won't cover it here, but
here's an example of what's possible. The following command replaces any value of
{cmd:newcaste} that starts with {cmd:"R"}, is followed by one or more vowels,
then ends with a consonant
with the correct {cmd:castename} {cmd:"RAIEN"}: */

replace newcaste = "RAIEN" if regexm(newcaste, "^R[AEIOU]+[^AEIOU]$")

/* {cmd:"RAIK"}, {cmd:"RAV"}, and {cmd:"ROUT"} are replaced.
See {helpb regexm()} for more information.
See also
{browse "http://www.stata.com/support/faqs/data-management/regular-expressions/":this}
Stata FAQ on regular expressions.

Touching on even more complex string matching algorithms,
the SSC program {cmd:strgroup} matches strings by how similar they are: */

ssc install strgroup

/* {cmd:strgroup} matches strings
based on something called their "Levenshtein edit distance."
The Levenshtein distance between two strings is
the minimum number of insertions, deletions, or substitutions
necessary to change one string to the other.
Thus, the Levenshtein distance between {cmd:"VINAWA"} and {cmd:"VINAYA"} is {cmd:1},
while the distance between {cmd:"NAT"} and {cmd:"SWAMI BRAHMAN"} is {cmd:12}.
The following code matches all string pairs
with a distance of {cmd:3} or less:

{TRYITCMD}
strgroup newcaste, generate(levcaste) threshold(3) normalize(none)
{DEF} */

tabulate levcaste
sort levcaste newcaste
browse newcaste levcaste

* Using the
* {bf:by varlist1 (varlist2)}
* syntax to make {cmd:newcaste} constant within each group of {cmd:levcaste}:

bysort levcaste (newcaste): replace newcaste = newcaste[1]

drop levcaste

/* {...}
{TECH}
{COL}Instead of matching on the absolute Levenshtein distance, you could match on{CEND}
{COL}the {it:percent} distance. For example, the following command matches all string{CEND}
{COL}pairs whose Levenshtein distance is no more than 20% of the length of the{CEND}
{COL}shorter string:{CEND}
{BLANK}
{COL}{bf:{stata strgroup newcaste, generate(levcaste) threshold(0.2) normalize(shorter)}}{CEND}
{BOTTOM}

If you're intrigued by {cmd:strgroup},
{browse "http://openrefine.org/":OpenRefine} (formerly Google Refine),
a useful tool for working with messy data,
has a variety of string matching algorithms,
some of which perform better than
the Levenshtein edit distance for some types of strings.
Just be careful about documenting your work so that it's reproducible.

I'll mention just one more useful command.
{cmd:reclink} is a user-written program that matches observations between two datasets
when no perfect key variables exist {hline 2} essentially a fuzzy merge: */

ssc install reclink

/* If you're merging an unclean dataset with a clean one
or merging two unclean datasets,
{cmd:reclink} can be very useful
and for this use more convenient than
{cmd:strgroup} or {browse "http://openrefine.org/":OpenRefine}.

{FOOT}

{GOTOPS}{STRINGS_PS}

{NEXT}{MERGING}
{PREV}{OTHERCHECKS}
{START} */
