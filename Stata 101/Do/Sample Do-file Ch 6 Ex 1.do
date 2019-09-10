/* 
Name: Sample Do-file Class 2 Ex 1.do
Purpose: This dofile contains all of the commands for chapter 6 and the accompanying exercises
for the IPA/JPAL "Stata 101" training.

Uses data: intro.dta 
Creates data: N/A 

Originally created by: Gean Spektor, Arielle Solomon
Originally created on: December 18, 2011
Last modified by: Lindsey Shaughnessy
Last modified on: September 10, 2019
Questions/support from: researchsupport@poverty-action.org
*/

*Standard opening commands:

	clear
	set more off
	version 10.0
	cap log close


*Set the directory below to where you have copied the "Stata 101" folder, such as 

	cd "C:\Users\YourComputer\Desktop\Stata 101"

*Opening the data:
	
	use "data\intro.dta"
	
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
