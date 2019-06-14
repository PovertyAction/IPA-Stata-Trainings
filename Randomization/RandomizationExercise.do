/* {P}{bf}
{ul:RANDOMIZATION IN STATA}{BR}
Rohit Naimpally{BR}
16 September 2014
{DEF}

Let's load the Balsakhi dataset: */

{USE}

browse

/* The dataset has five variables. What do these variables mean? Do you need them for the randomization?

We will discuss two common types of randomization:

{view "{RAND}##simple":1. Simple randomization}{BR}
{view "{RAND}##stratified":2. Stratified randomization}{BR}

{hline}{marker simple}

{bf:EXAMPLE 1: SIMPLE RANDOMIZATION}

{hline} */

{USE}

/* In this example, we will simply randomize the schools into treatment and control
groups.

{bf:1. Setting seed}

Apart from the actual randomization, this is the most important part of the do-file.
Why? */

set seed 20140402

/* Why that number specifically? Because that is a landmark date: The day India won the
cricket World Cup final. You could just as easily select another number, like {cmd:19830625}
(the day on which India won its other final.)

More seriously, the choice of seed doesn't matter for now.
When you write a real-life randomization,
do not choose dates or other numbers with human meaning,
but rather use a service like {browse "http://www.random.org/":random.org} to
randomly generate a seed.

{bf:2. Generating Random Numbers}

We want to create a variable of random numbers.
Before that, we must {cmd:sort} by a unique ID.
This is important for the reproducibility of the randomization:
if the sort order is not replicable,
it will not be possible to create the same random number variable.
In this dataset, {cmd:schoolid}, the school ID, uniquely identifies
observations: */

isid schoolid
sort schoolid

* Sharing the secret with all of you...

generate random = runiform()

/* {bf:3. Assigning treatment and control}

Now, the next step is to assign treatment and control to schools.

First, let us start by sorting by random number.
This is done using the following command line: */

sort random

/* Depending on how comfortable you are with Stata, you can try out either
of the following to generate the treatment variable: */

generate treatment = 0
replace treatment = 1 if _n <= _N / 2

* Or you can combine this in one step:

generate treatment = _n <= _N / 2

/* The logical expression above can be read as "create a variable named
{cmd:treatment} that takes on the value {cmd:1} whenever
the observation number ({cmd:_n}) is less than or equal to half of
the total number of observations ({cmd:_N}), and {cmd:0}
whenever the observation number is more than half of the total number of
observations." For more about such logical expressions, refer to the Stata
103 training module.

What is important to note here is that I have assigned the top half of
schools to the treatment condition and the bottom half of schools to the
control condition (where treatment is designated by the {cmd:treatment} variable
taking on the value {cmd:1} and control is designated by the {cmd:treatment} variable
taking on the value {cmd:0}).

Note that there are other ways of doing this as well:

For example, I could have set the bottom half of schools to be treatment and
because it is all {it:random}, it would not have mattered! How would the
{cmd:generate treatment} command have looked if I had decided to set the bottom half
of schools to be treatment and the top half control?

Lastly, let us sort by school ID again and look at the result of our effort: */

sort schoolid
browse

/* {...}
{TECH}
{COL}In case there are sort-order ties on the random number variable {hline 2} if the{CEND}
{COL}variable contains duplicates, which happens more often than you may{CEND}
{COL}imagine {hline 2} it is actually {browse "http://blog.stata.com/2012/08/03/using-statas-random-number-generators-part-2-drawing-without-replacement/":best practice} to generate and sort on two random{CEND}
{COL}variables:{CEND}
{BLANK}
{BF}
{COL}{stata sort schoolid}{CEND}
{COL}{stata generate random1 = runiform()}{CEND}
{COL}{stata generate random2 = runiform()}{CEND}
{COL}{stata sort random1 random2}{CEND}
{COL}{stata generate treatment = _n <= _N / 2}{CEND}
{DEF}
{BLANK}
{BOTTOM}

{hline}{marker stratified}

{bf:EXAMPLE 2:STRATIFICATION AND RANDOMIZATION}

{hline}

{cmd:* Reset the dataset.} */
{USE}

/* In this example, we will randomize schools after stratifying them by language and gender.

{bf:1. Usual generation of the random number} */

* {cmd:* Set the seed.}
set seed 20140402
* {cmd:* Sort by school ID.}
sort schoolid
* {cmd:* Generate the random number variable.}
generate random = runiform()

/* {bf:2. Stratification by language and school type}

This isn't rocket science either. What you want to do is the following: */

bysort language school_type: generate strata_size = _N

* This tells us how many schools there are in a language-school type group.
* Now let us assign a serial number to each school in a language-school type group.

bysort language school_type (random): generate strata_index = _n

/* What I've now done is to create a variable called {cmd:strata_index} that takes on the
observation number for each observation within a given language and school type group.
For instance, the value of {cmd:strata_index} for the {cmd:16}th observation in a particular
language and school type combination will be {cmd:16}.

Moreover, notice the syntax of the {helpb bysort} command here: I have sorted on three
variables: {cmd:language}, {cmd:school_type}, and {cmd:random}. However, the {cmd:by} command is only applied
to the {cmd:language} and {cmd:school_type} groups, i.e., the {cmd:strata_index} variable is generated for each
{cmd:language} and {cmd:school_type} combination rather than for each {cmd:language}, {cmd:school_type}, and {cmd:random}
combination. For more on the {cmd:bysort} syntax, consult the Stata 103 training module.
An alternative would have been: */

sort language school_type random
by language school_type: generate strata_index = _n

/* This clarifies that while we are also {it:sorting} on {cmd:random},
we are repeating the {cmd:generate} command for only combinations of
{cmd:language} and {cmd:school_type}.

{bf:3. Assigning treatment and control within the strata}

We can now use similar syntax to what we used in the simple randomization: */

generate treatment = strata_index <= strata_size / 2

* Let us now check the result:

browse

/* {bf:Now go randomize everything. Eggs or pancakes for breakfast? RANDOMIZE!}

Actually, the correct answer to the above is: both. */

