/* {HEAD}

{RESHAPE!}
{PSANS!}

{RESHAPE_ANSQ1}
{RESHAPE_ANSQ2} */

{RESHAPE_Q1TOP}

{RESHAPE_Q1A}

reshape long sport, i(country year)

drop _j
bysort country year (sport): generate j = _n
reshape wide sport, i(country year) j(j)

{RESHAPE_Q1B}

* Here is one approach:

generate sportchange = 0
forvalues i = 1/46 {
	bysort country (year): replace sportchange = 1 ///
		if sport`i' != sport`i'[_n - 1] & _n > 1
}

{RESHAPE_Q1C}

bysort country (sportchange): generate nochange = !sportchange[_N]

* Or in two steps:

bysort country: egen anychange = max(sportchange)
generate nochange = !anychange

tabulate country if nochange

/* {hline}

{NEW46} */

{RESHAPE_Q2}

/* The key is realizing that it is straightforward to create a set of
dummy variables from a single variable.
There are multiple approaches to this; {helpb xi} is one.
This is a theme in our use of {cmd:reshape}:
if we want to use a command designed for a single variable but
are currently working with a list of variables,
we may first need to prepare the dataset with {cmd:reshape}.

As with {cmd:{DATA_OLYMPICS2}}, our first task is to {cmd:split s2_q8} so that
it is a list of variables rather than a variable that is a list: */

split s2_q8, generate(response)

browse

reshape long response, i(id)
drop if missing(response)

browse

destring response, replace

* Now our variable is in a form that we can feed to {cmd:xi}:

xi i.response, noomit
renpfix _Iresponse s2_q8

browse

* Transforming the dataset back to wide form requires
* that the dummy variables be constant within {cmd:id}:

foreach var of varlist s2_q8_* {
	bysort id (`var'): replace `var' = `var'[_N]
}

browse

* Perhaps unnecessary, we may run the following to ensure
* that all dummy variables were created:

forvalues i = 1/12 {
	capture generate s2_q8_`i' = 0
}

browse

* Now returning the dataset to wide form:

reshape wide response, i(id) j(_j)
drop response*

* or

drop response _j
duplicates drop

browse

