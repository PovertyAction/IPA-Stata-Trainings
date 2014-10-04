/* {HEAD}

{COMMANDS!} */

{USE}
/*
{view `"{COMMANDS-}##introduction"':1. Introduction}{BR}
{view `"{COMMANDS-}##ssc"':2. SSC Commands}{BR}
{view `"{COMMANDS-}##online"':3. Commands Found Elsewhere Online}{BR}

{hline}{marker introduction}

{bf:1. Introduction}

{hline}

One of the great features of Stata is its many user-written commands,
which extend Stata’s capabilities and can make your data work easier.
Some of these are tremendously useful and will save you a lot of time.
Therefore, before you begin a given stage of working with your data, it is good
to check whether a new user-written command will simplify it significantly.

User-written commands are really no different than Stata-created commands:
they perform the operations stated, have help files, and follow standard syntax.
The only major difference between user-written commands and Stata-created commands
is that user-written commands are not built into Stata automatically and
have to be downloaded from the internet.
Once downloaded, they start to function like a regular command. 

In this module, we'll introduce you to the primary source of user-written
commands, the Boston College Statistical Software Components (SSC) archive. We'll also
point to some commands that are available elsewhere online.

{hline}{marker ssc}

{bf:2. SSC Commands}

{hline}

{helpb SSC:SSC} contains an extremely large collection of commands, of which we will introduce
but a few here. We won't learn the specifics of using these commands,
but several of them will be brought up in future modules. 

First off, how do you install commands that are found on SSC? The syntax is pretty simple: 

{bf:ssc install "command", replace}

As an example, let's install the popular exporting command {cmd:estout}: */

ssc install estout, replace

*Once the installation is complete, we can look at its {view `"{RESOURCES-}##help"':help} file:
 
help estout

/*{bf:estout} as well as the SSC commands {cmd:outreg2} and {cmd:orth_out} are all useful
for exporting regression and summary statistics results. 

There are an extremely useful set of commands that have been developed at IPA for reconciling
differences between multiple datasets. They are useful for a variety of purposes, but were
designed when comparing differences when doing double data entry:

{bf:cfout} reconciles two entries of data and outputs an excel sheet
with the differences for easy checking against the original surveys.
It also produces discrepancy rate statistics, including statistics by
data entry operator, making it simple to see the error rates of each
operator and incentivize the data entry accordingly.

The associated {cmd:readreplace} modifies the dataset currently in memory
by making replacements that are specified in an external dataset, the replacements file.
The list of differences outputed by {cmd:cfout} is designed to be used by
{cmd:readreplace}. After the addition of a new variable to the {cmd:cfout} differences
file that holds the new (correct) values, the file can be used as the
{cmd:readreplace} replacements file.

All of these commands can be found on SSC. 

A final SSC command that's proved invaluable to many has been {cmd:odkmeta}. 
If you use {browse "www.opendatakit.org":Open Data Kit} / {browse "www.surveycto.com":Survey CTO}
as a means of data collection, the command is a fantastic tool to import information
from ODK forms into Stata.

{hline}{marker online}

{bf:3. Commands Found Elsewhere Online}

{hline}

If a command is not found on SSC, it might be found elsewhere online. 
The way to find the command, assuming you have internet access, is to execute: 

{bf:net search 'command'}

A list of commands or packages (sets of commands) will appear. Click on the link you want and follow the
instructions to install the command. If you know of a particular command, but not its exact name, executing
a net search will likely be a good start to finding it. 

{FOOT}

{NEXT}{NAMING}
{PREV}{RESOURCES}
{START} */
