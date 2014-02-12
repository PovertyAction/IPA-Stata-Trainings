/* {HEAD}

{SUBSCRIPTING!} */

{USE}

/* {marker loop}{...}
It looks like the two observations for {cmd:hhid "1802011"} are very similar: */

list hhid sex age educ occupation if hhid == "1802011"

/* We know from the module on {view `"{DUPLICATES-}"':unique IDs and duplicates}
that they aren't perfectly identical.
So how idential are they?
We can use the following loop to find out: */

foreach var of varlist _all {
	display "`var'"
	display `var'[{VAR1}]
	display `var'[{VAR2}]
	display
}

/* Generally, for any variable {it:varname} and observation number {it:obs_num},
{it:varname}{cmd:[}{it:obs_num}{cmd:]} is the value of {it:varname}
in observation number {it:obs_num}. For example:

{TRYITCMD}
display hhid[1]{BR}
display surveyorid[10]
{DEF}

This is called {help subscripting:"explicit subscripting,"} and it depends on the sort order.
For example, the dataset is currently sorted by {cmd:hhid}: */

describe, short

/* If we sort it by another variable list, there's no guarantee the observation numbers will continue
to refer to the same observations: */

sort surveydate1 surveytime1
display hhid[1]
display surveyorid[10]

sort hhid

/* Let's return to the loop above.
It loops through all variables.
For each variable, it first displays the name of the variable ({cmd:"`var'"}),
then the value of the variable in observation {cmd:{VAR1}} ({cmd:`var'[{VAR1}]}),
then the value of the variable in observation {cmd:{VAR2}} ({cmd:`var'[{VAR2}]}).
The final {cmd:display} just inserts a blank line.

So, if John Doe and Jane Smith belonged to observations {cmd:{VAR1}} and {cmd:{VAR2}}, respectively,
the loop would display the name of each variable
followed by the values corresponding to John Doe (observation {cmd:{VAR1}}) and Jane Smith (observation {cmd:{VAR2}}).

{TECH}
{COL}Above, you see {cmd:display} typed out fully, and you might wonder why the shorter{CEND}
{COL}{cmd:disp} wasn't used. Or you might wonder why it's not {cmd:di} or {cmd:dis}. And that's the{CEND}
{COL}reason: users have different command abbreviation preferences. In this{CEND}
{COL}training, you'll see full command names, but you're also encouraged to use{CEND}
{COL}command abbreviations in your own work {hline 2} whichever ones you prefer.{CEND}
{BOTTOM}

{FOOT}

{GOTOPS}{SUBSCRIPTING_PS}

{NEXT}{LOOPS}
{PREV}{DUPLICATES}
{START} */
