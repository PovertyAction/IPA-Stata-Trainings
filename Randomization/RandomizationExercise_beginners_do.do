/***********************************
***	THIS CODE HELPS US RANDOMIZE ***
***********************************/
/*	WE HAVE A NUMBER OF SCHOOLS THAT WE WANT TO ASSIGN TO EITHER TREATMENT OR CONTROL.
	1. IN OUR FIRST EXAMPLE, WE WILL DO A SIMPLE RANDOMIZATION
	2. FOR THE SECOND EXAMPLE, WE WILL STRATIFY BY THE SCHOOL'S GENDER COMPOSITION 
	AND LANGUAGE OF INSTRUCTION
	3, IN THE THIRD EXAMPLE, WE WILL STRATIFY BY LANGUAGE, GENDER AND 
	AVERAGE PRE-TEST SCORE OF THE SCHOOL (A CONTINUOUS VARIABLE)*/


*************************************************************************
************************  INSTRUCTIONS **********************************
*************************************************************************
*Wherever it says COMMENT?, it means that you need to comment about the purpose of the command that follows
******************************************************************************
set more off
pause on

* THIS DATA SET (RandomizationExercise_balsakhi_data.dta) HAS 5 IMPORTANT VARIABLES
*	schoolid 
*	language
*	gender
*	pretest_mean
* (IT ALSO HAS AREA ID, BUT THAT CAN BE IGNORED)

use "RandomizationExercise_balsakhi_data.dta", clear

* FIRST EXAMPLE *
* SIMPLE RANDOMIZATION *
* WE CREATE A RANDOM NUMBER
*** BEFORE CREATING A RANDOM NUMBER, SORT BY A UNIQUE ID, THEN SET A SEED
*** SO YOU CAN RECREATE YOUR SAME RANDOM NUMBER SEQUENCE EVERY TIME

*COMMENT?
sort schoolid
*COMMENT?
set seed 20110402
*COMMENT?
gen random = runiform()

* SORT BY THIS RANDOM NUMBER:
* (BECAUSE THE SORTING IS RANDOM, THERE IS NO STATISTICAL REASON WHY 
* THE FIRST HALF OF THE OBSERVATIONS WOULD BE ANY DIFFERENT FROM THE SECOND HALF)
sort random

*COMMENT?
gen treatment = 0
replace treatment = 1 if _n <= _N/2
* OR: gen treatment =_n <= _N/2
* WE COULD HAVE DECIDED THAT treatment = 1 WHEN _n > _N/2

* WE NOW HAVE A VARIABLE THAT DEFINES WHICH SCHOOLS ARE TREATMENT 
* AND WHICH ARE CONTROL
pause

***********************
* RESET
drop random treatment
***********************

* SECOND EXAMPLE *
* STRATIFY BY LANGUAGE AND GENDER *

* COMMENT?
sort schoolid
set seed 20110402
gen random = runiform()

* COMMENT?
sort language gender random

* COMMENT?
by language gender: gen strata_size = _N

* ASSIGN A VALUE REFLECTING THE CURRENT (RANDOM) ORDER OF THESE SCHOOLS IN EACH STRATUM
bys language gender (random): gen strata_index = _n

*COMMENT?
gen treatment = 0
replace treatment = 1 if strata_index <= (strata_size/2)

* WE NOW HAVE A VARIABLE THAT DEFINES WHICH SCHOOLS ARE TREATMENT 
* AND WHICH ARE CONTROL, STRATIFIED BY LANGUAGE AND GENDER
pause

************************************************
* RESET
drop random treatment strata_size strata_index 
************************************************

* THIRD EXAMPLE *
* STRATIFY BY language AND pretest_mean RATE *

* CREATE A RANDOM NUMBER
sort schoolid
set seed 20110402
gen random = runiform()

*COMMENT?
sort language gender pretest_mean

* COMMENT?
by language gender: gen strata_size = _N

* WE WANT TO SPLIT SCHOOLS INTO "GROUPS" of 2
* WHERE EACH GROUP REPRESENTS ONE TREATMENT SCHOOL AND ONE CONTROL, AND HAS SIMILAR pretest_mean
* SO, FOR EXAMPLE, IF THERE ARE 30 SCHOOLS IN A STRATUM, 
* WE WANT TO BREAK THE STRATUM INTO 15 GROUPS: (30/2 = 15) 
by language gender: gen group = group(strata_size/2)

* COMMENT?
sort language group random

* FIGURE OUT HOW MANY SCHOOLS IN EACH GROUP 
*	(SHOULD BE 2, BUT MAY BE 1 IF THERE ARE AN ODD NUMBER OF SCHOOLS)
*	(IT IS WORTH NOTING THAT USING THIS CODE, THE SCHOOL WITH THE 
*	HIGHEST pretest_mean IN EACH "ODD" language WILL ALWAYS BE THE ONE WITH NO PAIR) 
sort language gender group
by language gender group: gen groupsize = _N


*COMMENT?
bys language gender group (random): gen groupindex = _n
* COMMENT?
replace groupindex = 0 if groupsize == 1

*COMMENT?
gen treatment = 0
replace treatment = 1 if groupindex == 1

* FOR THE SINGLE SCHOOLS (WITH NO PAIR IN A GROUP), WE CAN RANDOMIZE AS IF THEY 
* ARE ALL EQUIVALENT AND PART OF THE SAME LANGUAGE/GENDER
sum school if groupindex == 0
scalar oddSCHOOL = r(N)

sort groupindex random
replace treatment = 1 if _n <= (oddSCHOOL/2)

*COMMENT?
ttest pretest_mean, by(treatment)

* WE NOW HAVE A VARIABLE THAT DEFINES WHICH SCHOOLS ARE TREATMENT 
* AND WHICH ARE CONTROL, STRATIFIED BY language GENDER AND pretest_mean


