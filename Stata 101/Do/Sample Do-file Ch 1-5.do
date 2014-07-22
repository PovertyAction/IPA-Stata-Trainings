/*
This dofile contains all of the commands for chapters 1-5 and the accompanying exercises
from the Beginners' Stata Manual from the IPA/JPAL staff training.

Created by: Gean Spektor (any questions to gspektor@poverty-action.org)
Modified by: --
Last updated on: 5/28/12
*/
	
***CHAPTER 1***

*Opening the dataset
	use intro.dta
	
*Learning what a command is
	display "hello!"

*Learning browse
	browse
	
***CHAPTER 2***

	browse female school
	br math

*Learning sum
	sum math
	sum math, detail

*Learning tab
	tab school
	
*Watching out for missing variables
	sum math
	sum reading
	tab reading, miss
	tab reading
	
*Learning list
	list
	list reading
	
***CHAPTER 3***

*Learning the "if" condition
	sum math if female==1
	sum math if female==0 // Being male is signified in this dataset with female == 0 (not female)
	
	*Comparing with count
	count if female==0
	count if female==1

*The "in" qualifier
	list reading in 1/5
	
*Learning and/or
	sum math if female==1 & school==3
	sum math if school==1 | school==
	
	sum reading if math<65 | math>90
	sum reading if (math<65 | math>90) & school == 1
	
	sum math if female==1 (school==1 | school==2)
	
***CHAPTER 4***
	
*Saving
	save "intro_modified.dta", replace
	
*Sorting
	sort student
	sort school student

	*sort school, stable
	
***CHAPTER 5***

*Generating variables
	gen test=1
	*br
	gen private=1 if school==3

*modifying variables
	replace test=2
	*br
	
	replace private=1 if school==1
	*br
	replace private=0 if school==2 | school==4
	
	replace test = test*2

*The "not" symbol
	gen test2 = 1 if school ~= 1
	gen test3 = 1 if school ~= 1

*Dropping
	drop test
	
*Saving again
	*save, replace
	
***EXERCISES for CHAPTERS 1-5***

*1a
	gen male_pr=1 if female==0 & private==1
	replace male_pr=0 if male_pr~=1
	sum math if male_pr==1

*1b
	sum math if male_pr==1
	sum math if male_pr!=1 & female==0 // to compare with other boys (not in private school)
	sum math if male_pr~=1 // to compare with everyone else, incl. girls

*2a
	replace reading=reading*100
	
*2b
	gen failing_reading=1 if reading<65
	replace failing_reading=0 if failing_reading>=65

	*2b note
		gen failing_reading2 = (reading < 65)
		
*2c
	tab failing_reading if reading == .
*2d
	replace failing_reading = . if reading == .
*2e
	gen failing_reading3 = (reading < 65) if reading ~= .
*2f
	tab reading
	gen level = 1 if reading < 65 | reading == .
	replace level = 2 if reading >= 65 & reading < 90
	replace level = 3 if reading >= 90
	
*** ADDITIONAL EXERCISES ***

	summ attendance
	tab attendance
	
	gen lowattendance = (attendance < .60)
	summ lowattendance
	
	tab lowattendance if school == 1 | school == 3 // use the private school variable if you still have it
	tab lowattendance if school == 2 | school == 4 // ditto
	
	summ attendance if ( school == 2 | school == 4 ) & female == 0

*Saving again
	save, replace
