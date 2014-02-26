args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

#delimit ;

display

    "Hello world!"

    ;

#delimit cr
display "Hello world!"

	}
	if `trace' set trace off
}
else if `example' == 2 {
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
else if `example' == 3 {
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
else if `example' == 4 {
	if `trace' set trace on
	noi {

label define visitreasonlab ///
    1  "To register a Crime" ///
    2  "To answer charges filed against you" ///
    3  "To say hello/to chat" ///
    97 "Refuse to answer" ///
    98 "Other" ///
    99 "Don't Know"

	}
	if `trace' set trace off
}
