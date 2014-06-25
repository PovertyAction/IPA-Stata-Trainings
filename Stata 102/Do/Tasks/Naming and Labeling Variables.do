args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

#delimit ;
label define timeunit2
    1 milliseconds
    2 seconds
    3 minutes
    4 hours
    5 days
    6 weeks
    7 months
    8 quarters
    9 trimesters
    10 semesters
    11 years
    12 decades
;
#delimit cr

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

label define timeunit2 ///
    1 milliseconds ///
    2 seconds ///
    3 minutes ///
    4 hours ///
    5 days ///
    6 weeks ///
    7 months ///
    8 quarters ///
    9 trimesters ///
    10 semesters ///
    11 years ///
    12 decades

	}
	if `trace' set trace off
}
