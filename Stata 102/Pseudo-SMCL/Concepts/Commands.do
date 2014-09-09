/* {HEAD}

{COMMANDS!} */

{USE}
/*
{view `"{COMMANDS-}##introduction"':1. Introduction}{BR}
{view `"{COMMANDS-}##ssc"':2. SSC Commands}{BR}
{view `"{COMMANDS-}##box"':3. Commands Found on Box}{BR}
{view `"{COMMANDS-}##online"':4. Commands Found Elsewhere Online}{BR}

{hline}{marker introduction}

{bf:1. Introduction}

{hline}

One of the great features of Stata is its many user-written commands,
which extend Stata’s capabilities and can make your data work easier.
Some of these are tremendously useful and will save you a lot of time.
IPA RAs, PAs, and Data Coordinators have previously written many IPA-specific
commands that are useful for cleaning data, and more are in the works.
Therefore, before you begin a given stage of working with your data, it is good
to check whether a new user-written command will simplify it significantly.

User-written commands are really no different than Stata-created commands:
they perform the operations stated, have help files, and follow standard syntax.
The only major difference between user-written commands and Stata-created commands
is that user-written commands are not built into Stata automatically and
have to be downloaded from the internet.
Once downloaded, they start to function like a regular command. 

In this module, we'll introduce three main sources for finding user-written commands.
The primary one is the Boston College Statistical Software Components (SSC) archive, while
some commands are found in IPA's Research Resources on Box, and others elsewhere online.

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

All of these commands can be found on SSC. For more on data entry quality control, see our Box
{browse "https://ipastorage.box.com/s/ejpuvpzfs1tmxwew3q4l":resources} on the topic. 

A final SSC command that's proved invaluable to many IPA field staff has been {cmd:odkmeta}. 
If your project is using {browse "www.opendatakit.org":Open Data Kit} / {browse "www.surveycto.com":Survey CTO}
as a means of data collection, the command is a fantastic tool to import information
from ODK forms into Stata. For more, see {browse "https://ipastorage.box.com/odkmeta":here}.

{hline}{marker box}

{bf:3. Commands Found on Box}

{hline}

Some commands that have been written for IPA are not available on SSC, but have
been put on {browse "https://ipastorage.box.com/s/aacv8kayt9q6gv3it2rx":Box}.

A great example is {browse "https://ipastorage.box.com/bcstats":bcstats}, a command
that calculates statistics from back checks. Another is {browse "https://ipastorage.box.com/cbook":cbook},
a command that produces a codebook from a dataset, which is essentially an excel file that contains
key information about variables, such as its {view `"{NAMING-}"':labels}, {view `"{TYPES-}"':type},
mean, and standard deviation. 

User-written commands come with a {bf:.ado} file along with most often a help ({bf:.hlp or .sthlp})
file. To install commands from Box, use the {browse "https://ipastorage.box.com/install-ado":install_ado}
do-file. To run the do-file, specify the name of the command you want to install (after 'local ado')
and the directory you've downloaded the file to (after 'local dir'). Once you've modified these two lines,
run the do-file and the comamnd will be installed. 

For {cmd:bcstats} or {cmd:cbook} you will first need to extract the files from the zip file,
modify {bf:install_ado} and then run. Once it's installed, execute {bf:help bcstats / help cbook}
to learn more about the comamnd. 

If you encounter some problem with the installation, feel free to copy-paste the {bf:.ado} and
the {bf:.sthlp} (SMCL) file directly to your computer's ado folder, which is found at {bf:C:\ado\personal}.

And finally, if you're looking for a break from a busy day, check out this comamnd that you can install from Box:
{browse "https://ipastorage.box.com/nicewords":nicewords}. Have fun with it! 

{hline}{marker online}

{bf:4. Commands Found Elsewhere Online}

{hline}

Here is an extensive list of useful {browse "https://ipastorage.box.com/useful-stata-commands":commands}.
Notice that the source of most is 'Built-in', i.e. comes already installed with Stata. Some are 'SSC' and others
are 'Box'. 

However, there are a few commands whose source is listed as 'Other' - essentially they are found online, but 
not on IPA's Box or SSC. To install them (assuming you have internet access) execute:

{bf:net search 'command'}

A list of commands or packages (sets of commands) will appear. Click on the link you want and follow the
instructions to install the command. If you know of a particular command, but not its exact name, executing
a net search will likely be a good start to finding it. 

{FOOT}

{NEXT}{NAMING}
{PREV}{RESOURCES}
{START} */
