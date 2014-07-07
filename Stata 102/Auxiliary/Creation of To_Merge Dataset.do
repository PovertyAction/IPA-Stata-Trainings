/*Creating dataset of children/granchildren to merge into main dataset
Author: Harrison Diamond Pollock
Date: July 4, 2014 */

cd "C:\Users\hpollock\Documents\GitHub\Stata_Training\Stata 102"	

use "Raw/Post Kenya 2014 - Stata 102.dta", clear

set seed 1500

keep hhid age

*Want to first eliminate hhid duplicates, just deleting 1st instance
duplicates drop hhid, force
 
*Creating new variables

generate children = . 
generate grandchildren = . 
lab var children "Number of Children"
lab var grandchildren "Number of Grandchildren"

replace children = 0 if age < 26
replace children = int(5*runiform()) if age > 25

replace grandchildren = int(5*runiform()*children) 
drop age

save "Raw/New Variables", replace
