program drop reverse
program define reverse
    /* this program reverses the values
	   and labels of a factor variable using
	   extended macro functions */
	syntax varname, GENerate(name)
	
	* extract the name of the label of the factor variable
	local lab : value label `varlist'
	
	* count the number of factors
	qui label list `lab'
	local n = r(max)
	
	* create new variable with values reversed
	g `generate' = `n' - `varlist'
	
	/* loop through the value levels and apply the
	   the labels to the new variable in reverse order */
	forval i = 1/`n' {
		local num = `n' - `i'
		local text : label `lab' `i'
		label define revlab `num' "`text'", modify
	}
	
	* attach the value label to the new variable
	label values `generate' revlab
end

* example: program in action!
reverse scheier1, gen(revscheier)	
