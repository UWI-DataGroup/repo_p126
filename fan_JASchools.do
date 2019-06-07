
**  DO-FILE METADATA
//  algorithm name						FaN Jamaica Schools
//  project:							FaN
//  analysts:							Catherine Brown
//	date last modified		            05-Jun-2019

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






