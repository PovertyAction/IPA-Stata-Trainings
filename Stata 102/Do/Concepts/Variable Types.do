args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
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
