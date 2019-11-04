
**  DO-FILE METADATA
//  algorithm name						FaN Jamaica Schools
//  project:							FaN
//  analysts:							Catherine Brown / Ian Hambleton
//	date last modified		            31-Oct-2019

** General algorithm set-up
version 15
clear all
macro drop _all
set more 1
set linesize 80

** Set working directories: this is for DATASET and LOGFILE import and export
** DATASETS to encrypted SharePoint folder
local datapath "X:\The University of the West Indies\DataGroup - repo_data\data_p126"
** LOGFILES to unencrypted OneDrive folder
local logpath X:\OneDrive - The University of the West Indies\repo_datagroup\repo_p126

** Close any open log fileand open a new log file
capture log close
cap log using "`logpath'\fan_JASchools", replace

**Open dataset
import excel "`datapath'\version01\1-input\JASchools_final.xlsx", firstrow clear


**Rename variables**
rename Schoolcode id
rename Schoolname school
rename Gender gender
rename Schoolorganisation time
rename Class class
rename Locale locale
rename Percentattendance attend
rename Capacity cap
rename Enrolment enrol
rename Numberofteachers teachno
rename Pupilteacherratio ptrat
rename Parish parish
rename Level level
rename Year year

**Transform string to numeric**
replace attend = "." if attend=="N/A"
destring attend, replace 
destring enrol, replace 
split ptrat , parse(:)
drop ptrat ptrat2
rename ptrat1 ptrat 
destring ptrat, replace 

**Transform string to coded numeric variables**
encode gender, generate(gender2) 
encode time, generate(time2) 
encode class, generate(class2)
encode locale, generate(locale2) 
encode parish, generate(parish2) 
encode level, generate(level2) 
encode year, generate(year2) 

**Drop transformed variables**
drop gender 
drop time
drop class
drop locale
drop parish
drop level
drop year

**Rename new variables**
rename gender2 gender 
rename time2 time
rename class2 class
rename locale2 locale
rename parish2 parish
rename level2 level
rename year2 year

**Reorder variables**
order locale, after(school) 
order parish, after(locale)
order level, after(parish)
order gender, after(level)
order time, after(gender)
order class, after(time)


** Tabulatiion by School Type and Urban/Rural Status
** Grouping "All age" (2), Primary (4), Primary and Junior High (5)  
gen level2 = .
replace level2 = 1 if level==2 | level==4 | level==5
replace level2 = 2 if level==6
label define level2_ 1 "Primary" 2 "Secondary",modify 
label values level2 level2_
label var level2 "Primary and Secondary Schools"
tab level2 locale 
tab locale level2  

recode locale 1=2
tab locale level2  

gen stype = level2 
gen ltype = locale  
label var stype "School type (1=Primary, 2=Secondary)"
label define _stype 1 "Primary" 2 "Secondary", modify 
label values stype _stype 
label var ltype "Location type (1=Urban, 2=Rural" 
recode ltype 3=1
label define _ltype 1 "Urban" 2 "Rural", modify 
label values ltype _ltype 

keep id school stype ltype parish
order id school stype ltype parish
drop if stype == . 

** Randomly order schools. Stratified by
**  - (level2)  --> Primary / Secondary
**  - (locale)  --> Urban / Rural

set seed 150219
generate rnum = runiform(1,100)


** GROUP 1: URBAN PRIMARY
preserve 
    set linesize 120 
    sort rnum 
    keep if stype==1 & ltype==1 
    gen order = _n
    keep in 1/20
    list order rnum school stype ltype parish in 1/20, clean noobs

    ** Schools 1 to 10 
    export excel order school stype ltype parish in 1/10 using "`datapath'\version01\1-input\20191031_fan_sampled_schools.xlsx",    ///
            sheet("urban_primary", replace) cell(A3) first(var)
    ** Schools 11 to 20
    export excel order school stype ltype parish in 11/20 using "`datapath'\version01\1-input\20191031_fan_sampled_schools.xlsx",    ///
            sheet("urban_primary", modify) cell(A15) 
    putexcel set "`datapath'\version01\1-input\20191031_fan_sampled_schools.xlsx", sheet("urban_primary") modify
    putexcel A1 = "PRIMARY SCHOOLS: URBAN" , bold  font("Calibri", 16, "black")     
    putexcel A2 = "FIRST 10 SCHOOLS CHOSEN" , bold font("Calibri", 12, "black")      
    putexcel A14 = "SCHOOLS 11- 20: BACKUP SCHOOL CHOICES (WORK DOWN LIST)" , bold font("Calibri", 12, "black")
    putexcel (A3:A13), hcenter 
    putexcel (A15:A25), hcenter 
restore


** GROUP 2: URBAN SECONDARY
preserve 
    set linesize 120 
    sort rnum 
    keep if stype==2 & ltype==1 
    gen order = _n
    keep in 1/20
    list order rnum school stype ltype parish in 1/20, clean noobs

   ** Schools 1 to 10 
    export excel order school stype ltype parish in 1/10 using "`datapath'\version01\1-input\20191031_fan_sampled_schools.xlsx",    ///
            sheet("urban_secondary", replace) cell(A3) first(var)
    ** Schools 11 to 20
    export excel order school stype ltype parish in 11/20 using "`datapath'\version01\1-input\20191031_fan_sampled_schools.xlsx",    ///
            sheet("urban_secondary", modify) cell(A15) 
    putexcel set "`datapath'\version01\1-input\20191031_fan_sampled_schools.xlsx", sheet("urban_secondary") modify
    putexcel A1 = "SECONDARY SCHOOLS: URBAN" , bold  font("Calibri", 16, "black")     
    putexcel A2 = "FIRST 10 SCHOOLS CHOSEN" , bold font("Calibri", 12, "black")      
    putexcel A14 = "SCHOOLS 11- 20: BACKUP SCHOOL CHOICES (WORK DOWN LIST)" , bold font("Calibri", 12, "black")
    putexcel (A3:A13), hcenter 
    putexcel (A15:A25), hcenter 
restore

** GROUP 3: RURAL PRIMARY
preserve 
    set linesize 120 
    sort rnum 
    keep if stype==1 & ltype==2 
    gen order = _n
    keep in 1/20
    list order rnum school stype ltype parish in 1/20, clean noobs

   ** Schools 1 to 10 
    export excel order school stype ltype parish in 1/10 using "`datapath'\version01\1-input\20191031_fan_sampled_schools.xlsx",    ///
            sheet("rural_primary", replace) cell(A3) first(var)
    ** Schools 11 to 20
    export excel order school stype ltype parish in 11/20 using "`datapath'\version01\1-input\20191031_fan_sampled_schools.xlsx",    ///
            sheet("rural_primary", modify) cell(A15) 
    putexcel set "`datapath'\version01\1-input\20191031_fan_sampled_schools.xlsx", sheet("rural_primary") modify
    putexcel A1 = "PRIMARY SCHOOLS: RURAL" , bold  font("Calibri", 16, "black")     
    putexcel A2 = "FIRST 10 SCHOOLS CHOSEN" , bold font("Calibri", 12, "black")      
    putexcel A14 = "SCHOOLS 11- 20: BACKUP SCHOOL CHOICES (WORK DOWN LIST)" , bold font("Calibri", 12, "black")
    putexcel (A3:A13), hcenter 
    putexcel (A15:A25), hcenter 
restore

** GROUP 2: RURAL SECONDARY
preserve 
    set linesize 120 
    sort rnum 
    keep if stype==2 & ltype==2 
    gen order = _n
    keep in 1/20
    list order rnum school stype ltype parish in 1/20, clean noobs

   ** Schools 1 to 10 
    export excel order school stype ltype parish in 1/10 using "`datapath'\version01\1-input\20191031_fan_sampled_schools.xlsx",    ///
            sheet("rural_secondary", replace) cell(A3) first(var)
    ** Schools 11 to 20
    export excel order school stype ltype parish in 11/20 using "`datapath'\version01\1-input\20191031_fan_sampled_schools.xlsx",    ///
            sheet("rural_secondary", modify) cell(A15) 
    putexcel set "`datapath'\version01\1-input\20191031_fan_sampled_schools.xlsx", sheet("rural_secondary") modify
    putexcel A1 = "SECONDARY SCHOOLS: RURAL" , bold  font("Calibri", 16, "black")     
    putexcel A2 = "FIRST 10 SCHOOLS CHOSEN" , bold font("Calibri", 12, "black")      
    putexcel A14 = "SCHOOLS 11- 20: BACKUP SCHOOL CHOICES (WORK DOWN LIST)" , bold font("Calibri", 12, "black")
    putexcel (A3:A13), hcenter 
    putexcel (A15:A25), hcenter 
restore



/*
bysort ltype stype: sample 10









/*

** Data from 
** Nutritional Quality of Lunches Served in South East England Hospital Staff Canteens
** Jaworowska. Nutrients. 2018

** DATA
** totfat = total fat (g/100g)
** salt = salt (g/100g)
clear 
input num totfat salt 
1   0.6     0.49
2   6.0     0.36
3   5.7     0.61
4   3.1     0.55
5   7.0     0.30
6   12.9    0.61
7   3.3     1.03
8   3.1     0.27
9   5.0     0.49
10  14.4    0.59
11  8.1     0.35
12  9.7     1.12
13  13.2    0.80
end 

egen me_tf = mean(totfat)
egen me_sa = mean(salt)
egen sd_tf = sd(totfat) 
egen sd_sa = sd(salt) 

