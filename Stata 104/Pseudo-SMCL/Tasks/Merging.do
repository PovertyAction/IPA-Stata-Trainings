/* {HEAD}

{MERGING!}

Here are three tips to avoid common merging pitfalls.
I assume you already know the syntax of {helpb merge} and have used it before.

{TOP}
{COL}{bf:Tip 1:} Specify the merge type{CEND}
{BOTTOM}

Always specify the merge type: one-to-one (1:1), many-to-one (m:1), or one-to-many (1:m).
In Stata 11 or higher, you're required to specify this,
but in Stata 10 or lower,
it's possible to accidentally complete a merge of one type when you intended another.
If you're using Stata 10 or lower, take advantage of the following options.
(Users of Stata 11 and higher:
click {help merge_10:here} for the help file for the old {cmd:merge}.)

Option {cmd:unique}
specifies a 1:1 match merge.

Option {cmd:uniqmaster}
specifies a 1:m match merge if options {cmd:unique} and {cmd:uniqusing} are not specified.

Option {cmd:uniqusing}
specifies a m:1 match merge if options {cmd:unique} and {cmd:uniqmaster} are not specified.

Option {cmd:sort}
sorts the master and using datasets before merging
and implies option {cmd:unique}
if options {cmd:uniqmaster} and {cmd:uniqusing} are not specified.
(In Stata 11 and higher, the datasets are automatically sorted
unless option {cmd:sorted} is specified.)

Your default choice should be to use one of these option combinations:

{p2colset 5 36 0 0}{...}
{pstd}{c TLC}{hline 12}{c TT}{hline 17}{c TRC}{p_end}
{p2col:{c |} {bf:Merge type} {c |} {bf:Options}}{c |}{p_end}
{pstd}{c LT}{hline 12}{c +}{hline 17}{c RT}{p_end}
{p2col:{c |} 1:1 match  {c |} {cmd:sort}}{c |}{p_end}
{p2col:{c |} m:1 match  {c |} {cmd:sort uniqusing}}{c |}{p_end}
{p2col:{c |} 1:m match  {c |} {cmd:sort uniqmaster}}{c |}{p_end}
{pstd}{c BLC}{hline 12}{c BT}{hline 17}{c BRC}{p_end}
{p2colreset}{...}

If you don't specify a different merge type
through options {cmd:unique}, {cmd:uniqmaster}, {cmd:uniqusing}, and {cmd:sort},
then the implication is that you're completing a many-to-many merge.
Here's what the Stata documentation says about many-to-many merges:

{TOP}
{COL}{manlink D merge}{CEND}
{MLINE}
{COL}A many-to-many merge ... is a bad idea. In an m:m merge, observations are{CEND}
{COL}matched within equal values of the key variable(s), with the first{CEND}
{COL}observation being matched to the first; the second, to the second; and so{CEND}
{COL}on. If the master and using have an unequal number of observations within{CEND}
{COL}the group, then the last observation of the shorter group is used repeatedly{CEND}
{COL}to match with subsequent observations of the longer group. Thus m:m merges{CEND}
{COL}are dependent on the current sort order{hline 2}something which should never{CEND}
{COL}happen. ...{CEND}
{BLANK}
{COL}If you think that you need an m:m merge, then you probably need to work with{CEND}
{COL}your data so that you can use a 1:m or m:1 merge.{CEND}
{BOTTOM}

If you don't specify any of the options {cmd:unique}, {cmd:uniqmaster}, {cmd:uniqusing}, and {cmd:sort},
you could be implementing a many-to-many merge unknowingly.
To prevent this, always specify the merge type.

{TOP}
{COL}{bf:Tip 2:} Check all identifying variables{CEND}
{BOTTOM}

Even if a merge seems successful, check other identifying variables. For example,
if {cmd:ID 1} has {cmd:sex = Male} in the master data but {cmd:sex = Female} in the using, it doesn't
matter that the {cmd:ID 1} observations were matched by the merge, because the match
was probably incorrect. To check for incorrect matches:

{cmd:merge 1:1} {it:uniqueid} {cmd:using} {it:filename},
{cmd:update replace keep(}{it:other_identifying_vars}{cmd:)}{BR}
{cmd:list} {it:uniqueid} {cmd:if _merge == 5}

Where {it:other_identifying_vars} is the list of other identifying variables, such as {cmd:sex}.

You can also use the IPA {help SSC} program {cmd:cfout}: */

ssc install cfout

/* {...}
{TOP}
{COL}{bf:Tip 3:} Use string IDs{CEND}
{BOTTOM}

Be extremely suspicious of numeric ID variables with more than 7 digits.
Unless much care is taken,
these variables can have insufficient {help data_types:precision}
and incorrect values,
and {cmd:merge} will match observations incorrectly.
For exactly this reason,
{cmd:hhid} is a string variable in the training dataset,
even though it has all numeric values.

{TOP}
{COL}{bf:Learning more}{CEND}
{BOTTOM}

For more merging pitfalls, check out the Stata blog:

{browse "http://blog.stata.com/2011/04/18/merging-data-part-1-merges-gone-bad/":{it:Merging data, part 1: Merges gone bad}}{BR}
{browse "http://blog.stata.com/2011/05/27/merging-data-part-2-multiple-key-merges/":{it:Merging data, part 2: Multiple-key merges}}

Does anyone here have stories of merges gone wrong?

{FOOT}

{PREV}{STRINGS}
{START} */
