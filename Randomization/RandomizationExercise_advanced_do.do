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

**Wherever it says INSERT, it means that the command is missing and needs to be filled in
*Wherever it says COMMENT?, it means that you need to comment about the purpose of the command that follows
******************************************************************************

set more off
pause on

* THIS DATA SET (Exercise2_balsakhi_data.dta) HAS 5 IMPORTANT VARIABLES
*	schoolid 
*	language
*	gender
*	pretest_mean
* (IT ALSO HAS AREA ID, BUT THAT CAN BE IGNORED)

use "RandomizationExercise_balsakhi_data.dta", clear

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
sort schoolid
set seed 20110402
INSERT

* SORT BY THIS RANDOM NUMBER:
* (BECAUSE THE SORTING IS RANDOM, THERE IS NO STATISTICAL REASON WHY 
* THE FIRST HALF OF THE OBSERVATIONS WOULD BE ANY DIFFERENT FROM THE SECOND HALF)
INSERT

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

* CREATE A RANDOM NUMBER
INSERT 

* WITHIN EACH LANGUAGE GENDER, SORT RANDOMLY
INSERT

* COMMENT?
by language gender: gen strata_size = _N

* ASSIGN A VALUE REFLECTING THE CURRENT (RANDOM) ORDER OF THESE SCHOOLS IN EACH STRATUM
INSERT

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
INSERT

* SORT BY LANGUAGE GENDER AND pretest_mean
INSERT

* FIGURE OUT HOW MANY SCHOOLS IN EACH STRATUM
INSERT

*COMMENT?
by language gender: gen group = group(strata_size/2)

* WITHIN EACH GROUP, SORT RANDOMLY
INSERT

* FIGURE OUT HOW MANY SCHOOLS IN EACH GROUP 
*	(SHOULD BE 2, BUT MAY BE 1 IF THERE ARE AN ODD NUMBER OF SCHOOLS)
*	(IT IS WORTH NOTING THAT USING THIS CODE, THE SCHOOL WITH THE 
*	HIGHEST pretest_mean IN EACH "ODD" language WILL ALWAYS BE THE ONE WITH NO PAIR) 
sort language gender group
by language gender group: gen groupsize = _N


*COMMENT?
bys language gender group (random): gen groupindex = _n
*COMMENT?
replace groupindex = 0 if groupsize == 1

* WE CREATE A VARIABLE "treatment" WHICH EQUALS 1 IF TREATMENT AND 0 IF CONTROL
* (FOR THE SCHOOLS THAT ARE IN GROUPS OF 2)
INSERT

*COMMENT?
sum school if groupindex == 0
scalar oddSCHOOL = r(N)

*COMMENT?
sort groupindex random
replace treatment = 1 if _n <= (oddSCHOOL/2)

*COMMENT?
ttest pretest_mean, by(treatment)

* WE NOW HAVE A VARIABLE THAT DEFINES WHICH SCHOOLS ARE TREATMENT 
* AND WHICH ARE CONTROL, STRATIFIED BY language GENDER AND pretest_mean


