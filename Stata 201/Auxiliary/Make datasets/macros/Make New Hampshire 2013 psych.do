vers 13

set seed 19370131

clear
set obs 100

gen id = _n
lab var id "Unique ID"

gen scheier1 = ceil(5 * runiform())
lab var scheier1 "Scheier question 1"
#d ;
lab de scheier
	1 always
	2 sometimes
	3 "half of the time"
	4 rarely
	5 never
;
#d cr
lab val scheier1 scheier

gen cesd1 = ceil(4 * runiform())
lab var cesd1 "CESD question 1"
#d ;
lab de cesd
	1 rarely
	2 "a little"
	3 occasionally
	4 "all of the time"
;
#d cr
lab val cesd1 cesd

compress
c adv13
svold "Raw/New Hampshire 2013 psych", replace 10
