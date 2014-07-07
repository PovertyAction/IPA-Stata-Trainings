/* Creation of a to-append dataset for Stata 102 Importing module
Author: Harrison Diamond Pollock
Date: July 5, 2014 */

cd "C:\Users\hpollock\Documents\GitHub\Stata_Training\Stata 102"	

use "Raw/Post Kenya 2014 - Stata 102.dta", clear

*Creating new hhids
sort hhid
destring hhid, replace
keep in -10/-1 // last 10 obs
replace hhid = hhid + 3000
tostring hhid, replace

*Changing a few variable around
replace age = age + 5
recode sex (1 = 2) (2 = 1)


save "Raw/New Observations.dta", replace

