args example

loc trace = c(trace) == "on"
if `trace' set trace off

if `example' == 1 {
	if `trace' set trace on
	noi {

replace newcaste = "SUDAT" if newcaste == "SUDHAR" | ///
    newcaste == "SUHALAKA" | newcaste == "SUMEJA"  | ///
    newcaste == "SUNAR"    | newcaste == "SUTAR"   | ///
    newcaste == "SUTHAR"

	}
	if `trace' set trace off
}
else if `example' == 2 {
	if `trace' set trace on
	noi {

#delimit ;
local SUDAT_versions
    SUDHAR
    SUHALAKA
    SUMEJA
    SUNAR
    SUTAR
    SUTHAR
;
local MEHTA_versions
    MEHLA
    MEHRA
    MEHRAAT
    MEHRAJ
    MEHRAT
    "MEHTA JAIN"
    MEHTAR
    MEKHBAL
    MEKHWAL
;
local REGARA_versions
    RAZAR
    RAZER
    REBARI
    REDAS
    REGAR
    REGRA
;
#delimit cr
foreach name in SUDAT MEHTA REGARA {
    foreach version of local `name'_versions {
        replace newcaste = "`name'" if newcaste == "`version'"
    }
}

	}
	if `trace' set trace off
}
