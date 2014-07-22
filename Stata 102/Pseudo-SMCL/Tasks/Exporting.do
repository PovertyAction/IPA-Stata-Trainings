/* {HEAD}

{EXPORTING!} */

{USE}

/* While {view `"{IMPORTING-}"':importing} in Stata consists solely of reading in
{it:data}, exporting can take two forms: outputting some or all of the data into
another data format, or outputting Stata {it:results} in terms of graphs
or tables. This module will cover both of these exporting functions. 

{view `"{EXPORTING-}##exportdata"':1. Exporting Data}{BR}
{view `"{EXPORTING-}##exporttables"':2. Exporting Tables: Orthogonality and Regression}{BR}
{view `"{EXPORTING-}##exportgraphs"':3. Exporting Graphs}{BR}

{hline}{marker exportdata}

{bf:1. Exporting Data}

{hline}

Exporting data out of Stata, not surprisingly, is roughly analagous to importing
it. The exporting commands are even in the same help files as the importing ones!
Let's take a closer look: 

To export data as an Excel file, use {helpb export excel:export excel}. The syntax
is similar to the {cmd:import excel} command that we saw in the last module. As an example, 

{TRYITCMD}
export excel hhid surveyid sex age educ using "Raw/Tables and Graphs/excel", firstrow(variables) replace
{DEF}

Now navigate into the "Raw/Tables and Graphs" folder to check out the file. Let's describe the key elements
of the above syntax. First, we define which variables we want to export (here they are
hhid, suveyid, sex, age, and educ). Then we define the file path where we want to export to (note that
quotes are necessary here because there are spaces in the file path). Finally, we include two options:
{bf:first(var)} indicates we want the variable name as the first row in Excel, and {bf:replace} which overwrites
any existing file with the same name. Feel free to test this out: re-run the command but change the list
of variables to export. Though remember to close the Excel file before doing so! 

There's one other option that's important to highlight here: {bf:nolabel}. As you may have noticed, the default
is to export the {view `"{NAMING-}##vallabels"':value labels} rather than the underlying values of numeric
variables (e.g. 'Male' and 'Female' rather than 1 and 2). If you want to export these values instead, specify
the option {bf:nolabel} at the end of the command. 

Let's briefly touch on {helpb export delimited:export delimited}. 

{TRYITCMD}
export delimited using "Raw/Tables and Graphs/text_delimited", replace
{DEF}
 
Here we export the entire dataset as a text delimited (.csv) file. Again navigate to the "Raw/Tables and Graphs"
folder to open the file. Note that here, we didn't need to specify an option
to output the variable name as the first row, but still used the {bf:replace} option. 

Also, note that for both {cmd:export} variations, you can limit the output to just to a certain subset
of the data, using the {helpb if:if} and {helpb in:in} qualifiers. Feel free to play around with the above
commands to gain more understanding of how they work. 

{hline}{marker exporttables}

{bf:2. Exporting Tables: Orthogonality and Regression}

{hline} */

{USE}

/*While exporting data may well be useful in some cases, the majority of exporting in Stata will likely be in terms
of outputting actual {it:results}, be it in terms of graphs or tables. This section will introduce some examples of how
to do this. 

First, a common task is exporting summary statistics or orthogonality (balance) tables. IPA has developed a
very useful command for this purpose: {cmd:orth_out}. Let's install the command and see it in action: */

ssc install orth_out

/*{TRYITCMD}
orth_out age literateyn educ using "Raw/Tables and Graphs/orth_table", by(sex) se colnum replace
{DEF}

Like almost all results-exporting commands, {cmd:orth_out} takes a large number of options, of which we've used
but a few here. Like always check out the detailed {helpb orth_out:help file} for more on the many ways to 
customize the command. There are few key points to make. First, notice the table appeared both
in the Stata Results window and as an Excel file in our "Tables and Graphs" folder.
Next, let's identify the key syntax elements:

The table calculates means and standard deviations for several variables divided by the distinct values
within the variable found within the {bf:by()} option. So here, the means and sds of {bf:age, literateyn,}
and {bf:educ} are compared across both 'Male' and 'Female', which are the two values of the {bf:sex} variable. 
The other options are fairly simple: {bf:se} displays standard errors, {bf:colnum} puts in the (1) and (2) over the
columns, and you know all about {bf:replace} by now! 

{bf:Note:} If you read papers that discuss the results of RCTs, you'll often see a similar table as one of the first
of the paper. As you might have guessed, the {bf:by} variable typically corresponds to the treatment variable and 
the table as a whole would compare key variables for differences between the treatment and control groups.

{hline}

Let's now introduce exporting regression results from Stata. There are a large number of commands in this
area. Some of the most popular at IPA are {cmd:outreg2}, {cmd:xml_tab}, {cmd:estout}. 
The simplest of these commands is {cmd:esttab} (along with {cmd:eststo}) so we will introduce its functionality here. 

First let's make sure we've installed the needed commands: */

ssc install estout

/* And let's now run the regressions and export:

{TRYITCMD}
eststo: regress literateyn sex age {BR}
eststo: regress literateyn sex age educ{BR}
esttab using "Raw/Tables and Graphs/regs", se replace
{DEF}

For a useful primer on these commands, see this {browse "http://repec.org/bocode/e/estout/esttab.html":site}.
The essence here is that we run and store regression results which are then used as the inputs for the
{cmd:esttab} command. Notice the nicely formatted regression table! Note here that you should execute 
{bf:eststo clear} if you want to re-run the above commands or else new regressions will simply be 
appended to the existing table (even with the replace option). 

There is of course much additional complexity with this and the other regression exporting commands
mentioned above. We will leave it here for now, but it is highly encouraged to engage with IPA's many Stata
help {view `"{RESOURCES-}"':resources} as you delve further into this topic. 

{hline}{marker exportgraphs}

{bf:3. Exporting Graphs}

{hline}

As a final note in this module, let's introducing graphing. Like tables, graphs appear throughout
academic papers, and their creation is an important skill. Graphs can be a final output, but can
also be extremely useful as you go about checking and cleaning data. Being able to visualize
your data can help greatly in spotting outliers, and observing the relationship between variables. 

Here a simple example using the {help graph box:graph box} command: 

{TRYITCMD}
graph box age
{DEF}

And another with {helpb graph bar:graph bar} and then exporting it as a {bf:.png} file: */

graph bar age, over(sex)
graph export "Raw/Tables and Graphs/graph.png", replace

/*As with regression exporting, there is a wealth of possiblities when it comes to graphing
in Stata. Spending time experimenting yourself and utilizing IPA's {view `"{RESOURCES-}"':resources}
is your best bet to improve your skills. 

Finally, a useful {helpb ssc:SSC} command for graphing is {cmd:eclplot}, as it can quite powerfully
plot coefficients in sophisticated ways. Keep it in mind as needed. 

{FOOT}

{PREV}{IMPORTING}
{START} */
