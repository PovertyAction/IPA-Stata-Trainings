/* {HEAD}

{DUPLICATES!}
{PSANS!}

{DUPLICATES_ANSQ1}
{DUPLICATES_ANSQ2}
{DUPLICATES_ANSQ3} */


{DUPLICATES_Q1}

/* Some of the tasks for which a unique ID is important:{BR}
- Matching respondents across rounds (for example, matching baseline and endline
observations) and across datasets (for example, survey data and administrative
data){BR}
- Data entry reconciliation{BR}
- Analyzing data, when personally identifiable information (PII) must be
separated from the rest of the data{BR}
- Publishing data, when PII must be stripped from the dataset */

{DUPLICATES_Q2}

duplicates list hhid
duplicates drop
duplicates list hhid

* This reveals that only {cmd:hhid "1807077"} was resolved.

{DUPLICATES_Q3TOP}

{DUPLICATES_Q3A}

isid surveyid

* We see that {cmd:surveyid} does not uniquely identify the observations.

duplicates list surveyid

* There are two observations with {cmd:surveyid 981}.

{DUPLICATES_Q3B}

duplicates drop

isid surveyid
duplicates list surveyid

/* The observations with {cmd:surveyid 981} were identical across all variables.
Thus, following the use of {cmd:duplicates drop},
{cmd:surveyid} is now a unique identifier. */

/* {FOOT}

{DUPLICATES_PS2}
{TOMOD}{DUPLICATES}

{START} */
