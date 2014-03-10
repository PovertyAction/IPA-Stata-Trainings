/* {HEAD}{BR}
{BF}{IT}{UL}
(All pages have a header like the one above.
You can click it to return to the start page.)
{DEF}

{INTRO!}

The fact that we're using SMCL means
that we can run commands from within the training files.
For example: */

display "Hello world!"

/* Commands that are one line long are blue and clickable.
Blocks and commands that are more than one line long are bold black,
and can be executed by clicking the blue "Click here to execute" below them.
For example: */

foreach i of numlist 1/10 {
	display `i'
}

/* Further, you will see links like {help contents:this one} that
take you to different spots in the training, to help files,
or to locations in a Stata manual.
These links work like those in an Internet browser,
so you can always press the Back button
to return to your exact previous location.
Further, if you right-click on a link,
you have the option to open it in a new tab or window.
Links to Stata manuals, such as {bf:{mansection U:[U] Stata User's Guide}},
function only in Stata 11 and higher.

Throughout the training,
you'll see text boxes like the one below holding technical tips.
Although not essential,
these tips can help you reach the next level of Stata mastery.
If the text box is misaligned,
resize your viewer to a larger size and click the Reload button.
Alternatively, right click on the page, click Font,
then select a smaller font size.

{TECH}
{COL}Typing {helpb contents:help} by itself is the same as {helpb contents:help contents}.{CEND}
{BOTTOM}

When a command is introduced for the first time,
it'll usually appear as text instead of a link.
It'll be preceded by a text box reminder
to type out the command fully in the Command window.
({it:Don't just copy and paste!})
For example:

{TRYITCMD}
display "{c -(}hline}"
{DEF}

{NEXT1}{MATA}
*/
