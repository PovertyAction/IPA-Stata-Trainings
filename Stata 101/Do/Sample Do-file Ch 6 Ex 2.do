/* 
Name: Sample Do-file Class 2 Ex 2.do
Date Created: December 18, 2011
Date Last Modified: January 12, 2012
Created by: AS
Modified By: GS
Last modified by: GS
Uses data: intro.dta
Creates data: 
Description: This file is a part of exercises that are designed as an introduction to Stata for beginners, used at IPA-JPAL Staff Training. 
This particular do-file is created during Class 2 of the absolute beginners (Level 1) series in order to give the trainees a chance to learn various ways of importing data and labeling variables
*/

clear
set more off
set mem 50m

version 10.0
cap log close

*Set the directory

cd "C:\Documents and Settings\asolomon\Desktop"

*Insheet the data

insheet using "intro.xls"

sort id
save "intro_imported.dta", replace

*Insheet the 2nd dataset

use "intro_endline.dta",clear
sort id

*Merge

merge id using "intro_imported.dta" 

*New dataset

clear
use "childtest.dta" 

rename survey surveyround
lab var childid "Child's ID Number"

lab var standard_childtest "What standard is the child in?"

label define  extra_classes 0 "none" 1 "individual tutoring" 2 "coaching" 3 "special free classes" 4 "both tutoring and free classes"
