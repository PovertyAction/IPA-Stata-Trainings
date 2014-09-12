/* {P}{bf}
{ul:RANDOMIZATION IN STATA}{BR}
Rohit Naimpally{BR}
16 September 2014
{DEF}

{cmd:* Load the Balsakhi dataset.} */
{USE}
browse

/* The dataset has five variables. What do these variables mean? Do you need them for the randomization?

{hline}

{bf:EXAMPLE 1: SIMPLE RANDOMIZATION}

{hline} */

{USE}

/* In this example, we will simply randomize the schools into treatment and control
groups. Let us start by {stata sort schoolid:sorting by school ID}.

{bf:1. Setting seed}

Apart from the actual randomization, this is the most important part of the do-file.
Why? */

set seed 20140402

/* Why that number specifically? Because that is a landmark date: The day India won the
cricket World Cup final. You could just as easily select another number, like {cmd:19830625}
(the day on which India won its other final.)

More seriously, the choice of seed doesn't matter for now.

{bf:2. Generating Random Numbers}

Sharing the secret with all of you... */

generate random = runiform()

/* {bf:3. Assigning treatment and control}

Now, the next step is to assign treatment and control to schools.

First, let us start by {stata sort random:sorting by random number}.
This is done using the following command line:

{cmd:sort random}

Depending on how comfortable you are with Stata, you can try out either
of the following to generate the treatment variable:

{cmd:generate treatment = 0}{BR}
{cmd:replace treatment = 1 if _n <= _N / 2}

Or you can combine this in one step ... */

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
taking on the value {cmd:0}.

Note that there are other ways of doing this as well:

For example, I could have set the bottom half of schools to be treatment and
because it is all {it:random}, it would not have mattered! How would the
{cmd:generate treatment} command have looked if I had decided to set the bottom half
of schools to be treatment and the top half control?

Lastly, let us {stata sort schoolid:sort by school ID} again and {stata browse:look at the result of our effort!}

{hline}

{bf:EXAMPLE 2:STRATIFICATION AND RANDOMIZATION}

{hline}

{cmd:* Reset the dataset.} */
{USE}

/* In this example, we will randomize schools after stratifying them by language and gender.

{bf:1. Usual generation of the random number}

{stata sort schoolid:Sort by school ID}{BR}
{stata set seed 20140402:Set seed}{BR}
{stata generate random = runiform():Generate random number}

{bf:2. Stratification by language and gender}

This isn't rocket science either. What you want to do is the following: */

by language gender: generate strata_size = _N

* This tells us how many schools there are in a language-gender group.
* Now let us assign a serial number to each school in a language-gender group.

bysort language gender (random): generate strata_index = _n

/* What I've now done is to create a variable called {cmd:strata_index} that takes on the
observation number for each observation within a given language and gender group.
For instance, the value of {cmd:strata_index} for the {cmd:16}th observation in a particular
language and gender combination will be {cmd:16}.

Moreover, notice the syntax of the {helpb bysort} command here: I have sorted on three
variables: {cmd:language}, {cmd:gender}, and {cmd:random}. However, the {cmd:by} command is only applied
to the {cmd:language} and {cmd:gender} groups, i.e., the {cmd:strata_index} variable is generated for each
{cmd:language} and {cmd:gender} combination rather than for each {cmd:language}, {cmd:gender}, and {cmd:random}
combination. For more on the {cmd:bysort} syntax, consult the Stata 103 training module.

{bf:2. Assigning treatment and control within the strata}

We can now use similar syntax to what we used in the simple randomization: */

generate treatment = strata_index <= strata_size / 2

/* Let us now {stata browse:check the result}.

{hline}

{bf:EXAMPLE 3: STRATIFICATION BY DISCRETE AND CONTINUOUS VARIABLES}

{hline}

{cmd:* Reset the dataset.} */
{USE}

/* The previous example discussed stratification by discrete variables only,
namely {cmd:language} and {cmd:gender}.
Let us now additionally stratify by pre-test mean (which is a continuous variable) as well.

{bf:1. Usual generation of the random number}

{stata sort language gender pretest_mean:Sort by language gender and pre-test mean}{BR}
{stata set seed 20140402:Set seed}{BR}
{stata generate random = runiform():Generate random number}

{it:Why is this sorting different as compared to the previous one?}

{bf:2. Stratification by language, gender and pre-test mean}

First, figure out how many schools are there in each stratum. */

by language gender: generate strata_size = _N

/* We now want to split the schools into "groups" of 2, where each group represents one treatment and one control group and they have similar pre-test means.

To do this: */

by language gender: generate group = group(strata_size / 2)

* {bf:3. Assigning treatment and control within the strata}

bysort language gender group (random): generate groupindex = _n
generate treatment = groupindex == 2

/* {it:How should one read the logical expression used to generate the treatment variable here?}

{stata "bysort language gender group (random): generate treatment_the_cool_way = _n - 1":Challenge! Assigning treatment in one step}

{stata ttest pretest_mean, by(treatment):Are the means the same?}

{bf:Now go randomize everything. Eggs or pancakes for breakfast? RANDOMIZE!}

Actually, the correct answer to the above is: both. */

