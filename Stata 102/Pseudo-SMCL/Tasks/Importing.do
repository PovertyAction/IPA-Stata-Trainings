/* {HEAD}

{IMPORTING!}

Throught the training, we have worked with an existing Stata dataset and loaded that data
into Stata using the {helpb use:use} command. While it would be nice if every dataset started off in Stata format, 
this is rarely the case. What are the different ways to import data into Stata? In this module, we'll discuss
how to use the {cmd:import} command to import data from various formats such as Excel and .csv. We'll go over the common
but crucial tasks of {bf:merging} and {bf:appending} datasets together. Finally, the concept of
{bf:relative references} will be introduced - a means of greatly enhacing the reproducibility of your work. 

{view `"{IMPORTING-}##import"':1. The Import Command}{BR}
{view `"{IMPORTING-}##merging"':2. Merging}{BR}
{view `"{IMPORTING-}##appending"':3. Appending}{BR}
{view `"{IMPORTING-}##relative"':4. Relative References}{BR}

{hline}{marker import}

{bf:1. The Import Command}

{hline} 

{helpb import:import} is a flexible command that allows you to read in data to Stata from a variety of formats. 
In this section, we'll cover two of the most common formats data might take before
it is imported into Stata: Excel and text delimited. For Excel data, the required command is {helpb import excel:import excel}.
Let's see an example: */

import excel using {DATA_DEMOXLS}, clear firstrow
browse

/* We have succesfully loaded in data from Excel (.xlsx) format. Notice the two options used here.
You've seen the first before: {bf:clear} replaces any data in memory before importing
new data. Stata cannot have two datasets loaded at once, thus it is typical to add {bf:clear} when importing.
The second option, {bf:firstrow} is also important, in that it tells Stata to treat the first
row of the Excel data as Stata variable names. 

Let's import the same data again, except that now it's stored as a comma delimited (.csv) file. The command
to be used here is {helpb import delimited:import delimited}. */

import delimited using {DATA_DEMOCSV}, clear varnames(1)
browse

/* Note the different option for specifying that the first row should be the variable
name for delimited data, but the same {bf:clear} option as before. Here we have
imported a comma delimited file, but Stata can read in text files which use other
kinds of delimeters as well, such as spaces, tabs and semicolons. See the
{helpb import delimited:help file} for more. 

After any data import, it is critical to inspect our data to verify everything worked
as intended. Given we have so few variables and observations here, a {cmd:browse}
along with a {cmd:describe} is likely sufficient to catch any major issues. */

describe

/*Is this dataset ready to work with? Remember our discussion of which 
{view `"{TYPES-}"':variable types} are best for analysis? Immediately we
should see that the {bf:sex} and {bf:educ} variables are strings, which would
stop us from running most useful analysis commands on them. Recall that we
can use the {view `"{TYPES-}##encode"':encode} command to turn these variables
into numerics while keeping the current string names as value labels. What other
modifications might you want to make to this dataset? 

{hline}{marker merging}

{bf:2. Merging}

{hline} */

{USE}

/*When working with data, you will often want to add additional variables to existing
observations. For instance, you've collected baseline data and now want to add endline
data so as to compare changes across key variables. This task will involve
{helpb merge:merging} datasets. A critical point to consider when merging
is the importance of {view `"{DUPLICATES-}"':unique identifiers}.
To merge datasets together, Stata requires a variable that is common across both datasets
so as to match observations between the two. In this way, the correct observations from the second
dataset will be transfered to the first dataset. Let's see an example:

Imagine we have a separate dataset that contains information on the number of
children and grandchildren of each respondent. We now want to merge these
variables into our main household dataset. First, let's load and take a look
at our data. */

use {DATA_MERGE}, clear
describe
browse

/* The common variable between the two datasets is {bf:hhid}, which is the variable
we will match our observations on. Before merging however, we need check whether
our match variable is unique in both datasets, as this will
determine the type of merge we will implement. Thinking back to the previous
module on {view `"{DUPLICATES-}"':unique identifiers}, we can run the simple
command {cmd:isid}: */

isid hhid

/* Great! {cmd:hhid} is unique in this dataset (i.e. there are no duplicates).
We'll use this dataset as our {bf:using} dataset, as we'll merge it into our main
data, which will be the {bf:master} dataset. Let's now complete the merge: */

{USE}

merge m:1 hhid using {DATA_MERGE}

/* There are several key elements to this syntax. {bf:m:1}, as you can see
in the merge {helpb merge:help file} means we're doing a "many-to-one" merge.
What does this mean? This is where it critical to understand whether
the variables on which we match are unique. Here, we
are merging on the variable {bf:hhid}. However, we know that {bf:hhid} is not
unique in the {bf:master} dataset, but is unique in the {bf:using} dataset. Hence, 
we will have to map multiple observations ("many") observations to "one" observation. 

If the using dataset had a non-unique matching variable and the master's was unique, we'd
be executing a "one-to-many" merge or {bf:1:m}. If the matching variable was unique in both
the master and using datasets, the merge would instead be "one-to-one" or 
{bf:1:1}. Let's inspect our new data to get a sense of what happened with our merge: */

browse hhid children grandchildren

/* The two new variables from the {DATA_MERGE} dataset have been merged into our main dataset.
Let's take a close look at what happened for those duplicated values of {bf:hhid}.*/

duplicates tag hhid, generate(dup)
browse hhid children grandchildren if dup == 1

/* The values of both variables were simply repeated for the duplicated values
of {bf:hhid}. The "many" values of hhid 1802011 in the master dataset (in this case, two)
were mapped to the "one" value of hhid 1802011 in the using dataset.

Also notice that {cmd:merge} automatically creates a new variable, called {bf:_merge},
containing numeric codes that explain the origins and merging success of each observation.
They are typically 1, 2, and 3, where 1 means that the observation came from the master
dataset, and was not found in the using dataset,
2 means that the observation was only present in the using dataset,
and 3 means that the observation was present in both datasets and was merged.
When merging always pay special attention to this indicator variable and make sure that
the merge was conducted properly and all the observations that should have matched up actually matched up. 
Let's tabulate {bf:_merge} here: */

tabulate _merge

/*All values are 3, as they should be - every observation from the master dataset had a corresponding
observation in the using dataset and vice versa. Looking at {bf:_merge} is a great way to identify
any potential errors in merging. It should be dropped before completing any new merge: */

drop _merge

/*{hline}{marker appending}

{bf:3. Appending}

{hline} 

Another means of adding one dataset to another is through {helpb append:appending}. 
Appending is crucially different from merging: while a merge adds additional variables
to given observations, appending adds additional observations to existing variables. 
Think of appending as adding to a dataset's length while merging adds to its width. 

In what cases might you append a dataset to another? Imagine you interviewed a number of
households with the same questionnaire sometime after a first batch of interviews.
Instead of keeping the information separate, you are likely to want all your
observations in the same dataset. This is where appending comes in. Let's look
at an example: 

Here is a dataset with ten new observations: */

use {DATA_APPEND}, clear
browse
list hhid

*which we will now append to our main dataset:

{USE}
append using {DATA_APPEND}

sort hhid
list hhid in -10/-1

/*Note that the last ten values of hhid in the new dataset correpond with the values
in the dataset we appended. This is as it should be: we have essentially taken those
observations and pasted them to the end of the dataset. Take a look at the total
number of observations in the dataset in the Stata Properties window: it should read 1,011 - 
up from 1,001 previously.

A final note about {cmd:append}. There is no new variable that is created
after you append one dataset to another, unlike when {cmd:merging}. However, that
shouldn't stop you, like always, from inspecting the data after appending. Whenever
data is imported, no matter the manner, it is best practice to ensure that the data
is as you expect it to be. In {bf:Stata 104}, we will look in-depth at these sorts of
"logic checks" and introduce methods such as the {helpb assert:assert} command to aid with
the task. 

{hline}{marker relative}

{bf:4. Relative References}

{hline} 

Throughout this training, you might have been curious about why the full path
to a given file was never written out when calling it into Stata. In the past
when you've opened a file, you most likely would've had to type the entire path
to open it (such as "C:/Desktop/..."). What's going on here? The key is utilizing
the concept of {bf:relative references}. 

Relative references involve creating some sort of shorthand that Stata recognizes
to mean a certain location, and to then only change that one
line when switching users, moving data, etc. Subsequently, all new locations are
made {it:relative} to that initial location. 

There are a few ways to use relative references. One is by using a 
{view `"{MACROS-}"':local} or global (introduced in {bf:Stata 103}) macro to set a particular
path and then use the macro name throughout to refer to a set path. The second is to use
the {helpb cd:cd} command.

In essence, instead of spelling out "C:/Desktop/etc…" (which is called an absolute reference),
{cmd:cd} lets you temporarily (for the duration of the do-file) tell Stata that you will be
working from the X main folder and everything you refer to from then on will be located
in that folder. Basically, instead of starting its addresses with the entirety 
of your computer, Stata will now pretend that only the folder you specified exists.
To specify a folder execute:

{CMD}
cd "C:/path_to_your_main_Stata_project_folder/main_project_folder"
{DEF}

Now that you’ve specified you main folder containing all subfolders (say Data, Do-Files, etc.),
you only have to specify the path starting from there every time you use a file.
For instance, if you wanted to save a dataset as something else,
after you set the {cmd:cd} you’d only need to execute:

{CMD}
save “Data/Example.dta”, replace
{DEF}

Stata will read this as you telling it to go into the Project folder,
then the Data folder, and then save the dataset within the Data folder. 

Why are relative references important? Imagine you and a partner are working
on the same do-file. If you spell out the entire path to the file whenever 
you perform an operation, every time you switch users you would have to
change all the paths everywhere, which can sometimes be next to impossible.
Even if working alone, say you moved your data or code to a new directory; if
using absolute references, many lines of code would have to be modified. 

As a final note, the {view `"{COMMANDS-}"':user-written} command {bf:{stata "ssc install fastcd":fastcd}}
may also be of use when creating relative references. {bf:fastcd} allows the association
of a directory with a given code word which can then be used across files and users.
See the {helpb fastcd:help file} for more.

{FOOT}

{NEXT}{EXPORTING}
{PREV}{LOOPS}
{START}
