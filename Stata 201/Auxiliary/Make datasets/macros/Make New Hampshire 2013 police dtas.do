vers 13

set varabbrev off

c hitrain

u "Raw/India 2013 high intermediate", clear

replace castename = "KUMHAR" if inlist(hhid, "1101008", "1113003")

c adv13
compress
svold "Raw/New Hampshire 2013 police 1", replace 10

loc keepvars hhid sex occupation occupationother castename castecode age educ
keep `keepvars'
order `keepvars'

ren sex				s1_q1
ren occupation		s1_q2
ren occupationother	s1_q2_other
ren castename		s1_q3
ren castecode		s1_q4
ren age				s1_q5
ren educ			s1_q6

compress
svold "Raw/New Hampshire 2013 police 2", replace 10

u "Raw/New Hampshire 2013 police 1", clear

renpfix surveydate SurveyDate
renpfix surveytime SurveyTime
renpfix superpresent SuperPresent

mata:
rename = (
"hhid", "HHID" \
"surveyid", "SurveyID" \
"surveyorid", "SurveyorID" \
"sex", "Sex" \
"scrutinizedyn", "ScrutinizedYN" \
"backcheckedyn", "BackCheckedYN" \
"addressdur", "AddressDuration_Number" \
"addressdur_unit", "AddressDuration_Unit" \
"areadur", "AreaDuration_Number" \
"areadur_unit", "AreaDuration_Unit" \
"occupation", "Occupation" \
"occupationother", "OccupationOther" \
"castename", "CasteName" \
"castecode", "CasteCode" \
"age", "Age" \
"educ", "Education" \
"literateyn", "LiterateYN" \
"own4wheeleryn", "Own4WheelerYN" \
"own4wheelernum", "Own4WheelerNum" \
"own4wheelertheft", "Own4WheelerTheft" \
"own4wheelertheftnum", "Own4WheelerTheftNum" \
"theftfromcaryn", "TheftFromCarYN" \
"theftfromcarnum", "TheftfFomCarNum" \
"own2wheeleryn", "Own2WheelerYN" \
"own2wheelernum", "Own2WheelerNum" \
"own2wheelertheft", "Own2WheelerTheft" \
"own2wheelertheftnum", "Own2WheelerTheftNum" \
"own2wheelertheftvictim_1", "Own2WheelerTheftVictim_1" \
"own2wheelertheftvictim_2", "Own2WheelerTheftVictim_2" \
"cycleownyn", "CycleOwnYN" \
"cycleownnum", "CycleOwnNum" \
"cycletheftyn", "CycleTheftYN" \
"cycletheftnum", "CycleTheftNum" \
"cycletheftvictim_1", "CycleTheftVictim_1" \
"cycletheftvictim_2", "CycleTheftVictim_2" \
"burglaryyn", "BurglaryYN" \
"burglarynum", "BurglarYNum" \
"attemptedburglaryyn", "AttemptedBurglaryYN" \
"attemptedburglarynum", "AttemptedBurglarYNum" \
"vandalismyn", "VandalismYN" \
"vandalismnum", "VandalismNum" \
"trespassingyn", "TrespassingYN" \
"trespassingnum", "TrespassingNum" \
"robberyyn", "RobberyYN" \
"robberynum", "RobberYNum" \
"robberyvictim_1", "RobberyVictim_1" \
"robberyvictim_2", "RobberyVictim_2" \
"theftyn", "TheftYN" \
"theftnum", "TheftNum" \
"theftvictim_1", "TheftVictim_1" \
"theftvictim_2", "TheftVictim_2" \
"molestationyn", "MolestationYN" \
"molestationnum", "MolestationNum" \
"molestationvictim_1", "MolestationVictim_1" \
"molestationvictim_2", "MolestationVictim_2" \
"eveteasingyn", "EveteasingYN" \
"eveteasingnum", "EveteasingNum" \
"eveteasingvictim_1", "EveteasingVictim_1" \
"eveteasingvictim_2", "EveteasingVictim_2" \
"attackyn", "AttackYN" \
"attacknum", "AttackNum" \
"attackvictim_1", "AttackVictim_1" \
"attackvictim_2", "AttackVictim_2" \
"extortionyn", "ExtortionYN" \
"extortionnum", "ExtortionNum" \
"extortionvictim_1", "ExtortionVictim_1" \
"extortionvictim_2", "ExtortionVictim_2" \
"assaultyn", "AssaultYN" \
"assaultnum", "AssaultNum" \
"assaultvictim_1", "AssaultVictim_1" \
"assaultvictim_2", "AssaultVictim_2" \
"falsecaseyn", "FalseCaseYN" \
"falsecasenum", "FalseCaseNum" \
"falsecasevictim_1", "FalseCaseVictim_1" \
"falsecasevictim_2", "FalseCaseVictim_2" \
"othercrimesyn", "OtherCrimesYN" \
"othercrimesnum", "OtherCrimesNum" \
"othercrimevictim_1", "OtherCrimeVictim_1" \
"othercrimevictim_2", "OtherCrimeVictim_2" \
"thanavisityn", "ThanaVisitYN" \
"thanavisitreason", "ThanaVisitReason" \
"thanavisitreason_other", "ThanaVisitReason_Other")
st_local("names", strofreal(rows(rename)))
end

forv i = 1/`names' {
	mata: st_local("from", rename[`i', 1])
	mata: st_local("to",   rename[`i', 2])
	rename `from' `to'
}

foreach var of varl _all {
	assert regexm("`var'", "^[A-Z]")
}

compress
svold "Raw/New Hampshire 2013 police 3", replace 10
