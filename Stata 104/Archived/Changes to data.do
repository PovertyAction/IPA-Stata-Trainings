/*
Harrison Diamond Pollock 
Last updated Jan 17, 2014
Original High Intermediate data file is in Stata/High Intermediate/Post-Kenya 2013 High Intermediate Stata/Raw folder

Making changes to Stata 103/104 dataset 

1) ensuring that own2wheelertheft has several don't know values (this was the case previously
but somehow was changed. 

*/

replace own2wheelertheft = 99 in 1
replace own2wheelertheft = 99 in 34

*both obs 1/34 were previously missing, now are 99

save Kenya 2014 - Stata 104.dta, replace
