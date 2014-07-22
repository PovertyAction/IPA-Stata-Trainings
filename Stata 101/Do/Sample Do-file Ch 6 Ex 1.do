/* 
Name: Sample Do-file Class 2 Ex 1.do
Date Created: December 18, 2011
Date Last Modified: January 12, 2012
Created by: AS
Modified By: GS
Last modified by: GS
Uses data: intro.dta
Creates data: 
Description: This file is a part of exercises that are designed as an introduction to Stata for beginners, used at IPA-JPAL Staff Training. 
This particular do-file is created during Class 2 of the absolute beginners (Level 1) series in order to give the trainees their first experience with a do-file and demonstrate 
some of the common practices for do-file organization
*/

*Opening commands:

	clear
	set more off
	set mem 10m
	version 10.0
	cap log close


*Opening the data:
	
	use "C:\Documents and Settings\asolomon\Desktop/intro.dta"
	
*Avg of the attendance rate & frequency

	summ attendance
	tab attendance

*Now we create a variable to see how many people are at risk of having to retake the class due to low attendance (less than 60%)

	gen lowattendance = ( attendance < .60 )
	summ lowattendance

*Comparing low attendance percentage in private vs public schools

	summ lowattendance  if school==1 | school==3
	summ lowattendance  if school==2 | school==4
	
	*Note: you can also use tab
	
*Avg rate of attendance for boys in public schools

	summ attendance if female==0 & (school==2 | school==4)
