/* {HEAD}

{DUPLICATES!} */

{USE}

/* Almost all datasets have a unique ID {hline 2} a variable that uniquely identifies each observation.
Unique IDs can distinguish respondents from each other, so that
John Doe is identified by the value {cmd:1} of variable {cmd:uniqueid}, Jane Smith is
identified by the value {cmd:2}, and so on.
A combination of variables, such as a household ID and a respondent ID together,
can also be used to uniquely identify observations.

{TECH}
{COL}Windows users may wonder why we used a forward slash ({cmd:/}) with {cmd:use} instead of{CEND}
{COL}the standard backslash ({cmd:\}). While other Windows programs often prefer{CEND}
{COL}backslashes, Stata doesn't care. Further, using forward slashes in your{CEND}
{COL}do-files makes them compatible across operating systems, including for PIs{CEND}
{COL}on Macs. Forward slashes also play better with local and global macros. For{CEND}
{COL}example, the following works fine:{CEND}
{BLANK}
{COL}{bf:{stata local dataset {DATA_BASE}}}{CEND}
{COL}{bf:{stata use "Raw/`dataset'", clear}}{CEND}
{BLANK}
{COL}In contrast, a single backslash doesn't work:{CEND}
{BLANK}
{COL}{bf:{stata use "Raw\`dataset'", clear}}{CEND}
{BLANK}
{COL}To use backslashes here, you need to insert two before {cmd:`dataset'}:{CEND}
{BLANK}
{COL}{bf:{stata use "Raw\\`dataset'", clear}}{CEND}
{BLANK}
{COL}Again, this is only an issue with local and global macros. Normally, only a{CEND}
{COL}single backslash is required:{CEND}
{BLANK}
{COL}{bf:{stata use {DATA_BACK}, clear}}{CEND}
{BLANK}
{COL}For more, see {browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0042":{it:Stata tip 65: Beware the backstabbing backslash}}.{CEND}
{BOTTOM}

We will start with cleaning the ID.
More specifically, we will make sure that the ID is unique.
If it isn't, we will find out how many and which IDs are duplicates and resolve them.

Why is our first data cleaning task after {view `"{NAMING-}"':variable naming and labeling}
to clean the ID? A unique ID is important for all sorts of reasons: */

{DUPLICATES_Q1}

/* {hline}

Unique ID problems are serious and can be very hard to solve when a lot of time has passed.
Therefore, you should immediately clean the IDs for all incoming data.

It is common to assign respondents not just one but {it:two} unique IDs.
This makes it much easier to resolve ID problems.

{marker isid}{...}
The unique ID in this dataset is {cmd:hhid}. Here's one straightforward way to check
its uniqueness: */

isid hhid

/* {helpb isid} ("is ID") does nothing
if the variable or variable list uniquely identifies observations
and issues an error message if it doesn't.
We received an error message here,
which means there are duplicate IDs.
We need more information about these duplicates.
Are they:

(1) Different respondents?

Action: at least one observation has an incorrect ID; correct it.
Then figure out how the problem occurred.
(Did an enumerator miswrite the ID? Are there duplicates in the master ID list?)

(2) The same respondent with the exact same data?

Action: keep only one copy of the duplicate observations.
Then figure out how the problem occurred.
(Was the same survey entered or uploaded twice?)

(3) The same respondent with slightly different data?

Action: keep only one copy (probably either the earliest or the latest).
Then figure out how the problem occurred.
(Was the same respondent interviewed twice, by two different enumerators?
Did the computer-assisted interviewing survey program create a copy
after the enumerator stopped the interview midway then returned?)

{marker duplicates}{...}
The {helpb duplicates} command offers subcommands for
reporting, listing, tagging, and dropping duplicate observations.
We will use it now to see which specific IDs are causing the problem.

{TRYITCMD}
duplicates list hhid
{DEF}

The easiest type of duplicate to deal with is (2). {helpb duplicates drop} searches
for observations that are identical on all variables, and drops all but one:

{TRYITCMD}
duplicates drop
{DEF} */

{DUPLICATES_Q2}

/* {hline}{NEW48}

We still have observations that are either (1) or (3). We don't even know
which one they are: (1) or (3). The way to figure it out is to compare these
observations on variables other than {cmd:hhid}.
In reality, you could compare on variables like
name, location, and official IDs,
but this dataset has already been stripped of personally identifiable information (PII),
so we will compare on sex, age, education, and occupation.

{marker list}{...} */
list hhid sex age educ occupation if hhid == "1802011" | hhid == "1813023"

/* It looks like {cmd:"1802011"} is (3) and {cmd:"1813023"} is (1). We can confirm by
{help browse:inspecting}: */

browse if hhid == "1802011" | hhid == "1813023"

/* {FOOT}

{GOTOPS}{DUPLICATES_PS}

{NEXT}{MACROS}
{PREV}{TYPES}
{START} */
