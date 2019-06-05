* HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    fan_fao_005a.do
    //  project:				    Food and Nutrition (FaN)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	        22-OCT-2018
    //  algorithm task			    AVERAGE DIETARY ENERGY SUPPLY ADEQUACY

    ** General algorithm set-up
    version 15
    clear all
    macro drop _all
    set more 1
    set linesize 80

    ** Set working directories: this is for DATASET and LOGFILE import and export
    ** DATASETS to encrypted SharePoint folder
    local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p126"
    ** LOGFILES to unencrypted OneDrive folder (.gitignore set to IGNORE log files on PUSH to GitHub)
    local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p126

    ** Close any open log file and open a new log file
    capture log close
    log using "`logpath'\fan_fao_005a", replace
** HEADER -----------------------------------------------------


** ---------------------------------------------------------------------------------------------
** Read the EXCEL spreadsheet
** DATA from
** http://www.fao.org/economic/ess/ess-fs/ess-fadata/en/#.W822G2hyrg4
**
** A core set of food security indicators
**
** Following the recommendation of experts gathered in the Committee on World Food Security (CFS)
** Round Table on hunger measurement, hosted at FAO headquarters in September 2011, an initial set
** of indicators aiming to capture various aspects of food insecurity is presented here.
**
** The choice of the indicators has been informed by expert judgment and the availability of data
** with sufficient coverage to enable comparisons across regions and over time. Many of these indicators
** are produced and published elsewhere by FAO and other international organizations.
** They are reported here in a single database with the aim of building a wide food security information system.
** More indicators will be added to this set as more data will become available.
**
** Indicators are classified along the four dimension of food security:
** availability, access, utilization and stability.
**
** AVAILABILITY
** I_1.1	Average dietary energy supply adequacy
** I_1.2 	Average value of food production
** I_1.3	Share of dietary energy supply derived from cereals, roots and tubers
** I_1.4	Average protein supply
** I_1.5	Average supply of protein of animal origin
**
** ACCESS
** I_2.1	Rail lines density
** I_2.2	Gross domestic product per capita (in purchasing power equivalent)
** I_2.3	Prevalence of undernourishment
** I_2.4	Prevalence of severe food insecurity in the total population
**
** STABILITY
** I_3.1	Cereal import dependency ratio
** I_3.2	Percent of arable land equipped for irrigation
** I_3.3	Value of food imports over total merchandise exports
** I_3.4	Political stability and absence of violence/terrorism
** I_3.5	Per capita food production variability
** I_3.6	Per capita food supply variability
**
** UTILIZATION
** I_4.1	People using at least basic drinking water services
** I_4.2	People using safely managed basic drinking water
** I_4.3    People using at least basic sanitation services
** I_4.4    People using safely managed sanitation services
** I_4.5	Percentage of children under 5 years of age affected by wasting
** I_4.6	Percentage of children under 5 years of age who are stunted
** I_4.7	Percentage of children under 5 years of age who are overweight
** I_4.8	Prevalence of obesity in the adult population (18 years and older)
** I_4.9	Prevalence of anemia among women of reproductive age (15-49 years)
** I_4.10	Prevalence of exclusive breastfeeding among infants 0-5 months of age
**
** ADDITIONAL USEFUL STATISTICS
** A_1	Total population
** A_2	Number of people undernourished
** A_3  Number of severly food insecure people
** A_4	Minimum Dietary Energy Requirement (MDER)
** A_5	Average Dietary Energy Requirement (ADER)
** A_6	Coefficient of variation of habitual caloric consumption distribution
** A_7	Skewness of habitual caloric consumption distribution
** A_8	Incidence of caloric losses at retail distribution level
** A_9	Dietary Energy Supply (DES)
** A_10	Average fat supply


** ---------------------------------------------------------------------------------------------
** V_1.1	Average dietary energy supply adequacy
** ---------------------------------------------------------------------------------------------
import excel using "`datapath'/version01/2-working/Food_Security_Indicators_11SEP2018 Hambleton", sheet("I_1.1") cellra(c3:t251) first clear

** Country name
rename RegionsSubregionsCountries cname
label var cname "Country name"

** Internal Country, Region ID
gen id = _n
order id, before(cname)
label var id "Country or Region Internal ID"

** Assign string to labels
labmask id, values(cname)
drop cname

** We convert these numeric values to alphanumeric variable names
local yr = 1999
foreach var in D E F G H I J K L M N O P Q R S T {
	rename `var' est`yr'
	label var est`yr' "Estimate (3-year) for `yr'"
	local yr = `yr'+1
	}

** Creating country groups
gen maj_region = .
**gen min_region = .
replace maj_region = 1 if id==1
replace maj_region = 2 if id>=8 & id<=70
replace maj_region = 3 if id>=71 & id<=133
replace maj_region = 4 if id>=134 & id<=171
replace maj_region = 5 if id>=172 & id<=197
replace maj_region = 6 if id>=198 & id<=248
replace maj_region = 7 if id==4

label define maj_region 1 "world"			///
						2 "africa"			///
						3 "asia"			///
						4 "lac"				///
						5 "oceania"			///
                        6 "na / europe"     ///
						7 "sids", modify
label values maj_region maj_region
order maj_region, after(id)


** ---------------------------------------------------------------------------
** GRAPHICS
** Equiplot for each Stratifier
** ---------------------------------------------------------------------------
** ColorBrewer purple  range (x9 classes)

	** PURPLE
	** LIGHT
**    252,251,253
**    239,237,245
**    218,218,235
**    188,189,220
**    158,154,200
**    128,125,186
**    106,81,163
**    84,39,143
**    63,0,125
    ** DARK
** ---------------------------------------------------------------------------

** Reshape to long
reshape long est, i(id) j(year)

** Country Grouping 1
** 148 	Saint Vincent
** 178 Fiji
gen group01 = 0
replace group01 = 1 if id==148 | id==178

** Country Grouping 2
** 148 	Saint Vincent
** 178 Fiji
** 4 all SIDS
gen group02 = 0
replace group02 = 1 if id==148 | id==178 | id==4

** Country Grouping 3
** 148 	Saint Vincent
** 178 	Fiji
** 4 	all SIDS
** 135 	Caribbean
** 176 	Oceania (excl. Australia and NZ)
** 2 	least developed
** 198 	na / europe
gen group03 = 0
replace group03 = 1 if id==148 | id==178 | id==4 | id==135 | id==176 | id==2 | id==198
/*
gen group = group03
keep if group==1
gen cid = .
replace cid = 1 if id==198
replace cid = 2 if id==2
replace cid = 3 if id==4
replace cid = 4 if id==176
replace cid = 5 if id==178
replace cid = 6 if id==135
replace cid = 7 if id==148
label define cid_  1 "NA / Europe" 2 "Least Developed" 3 "SIDS" 4 "Oceania" 5 "Fiji"  6 "Caribbean" 7 "St Vincent"
label values cid cid_

** Keeping selected time points
keep if year==2000 | year==2015

** Minimum / Maximum values for -equiplot- horizontal line connector
bysort id : egen min = min(est) if group==1
bysort id : egen max = max(est) if group==1

** ---------------------------------------------------------------------------
** X-axis
local tick1 = "80(20)140"
local tick2 = "80(10)140"
local tick3 = "80(5)140"
* y-axis range
local range "0.5(0.5)7.5"
** ---------------------------------------------------------------------------

#delimit ;
	gr twoway
		/// Line between min and max
		(rspike min max cid if group==1, hor lc(gs10) lw(0.35))
		/// year 2000
		(sc cid est if group==1 & year==2000, msize(6) m(o) mlc(gs0) mfc("218 218 235") mlw(0.1))
		/// year 2015
		(sc cid est if group==1 & year==2015, msize(6) m(o) mlc(gs0) mfc("84 39 143") mlw(0.1))
		,
			graphregion(color(gs16)) ysize(7.5) xsize(15)
			bgcolor(gs16)

			xlab(`tick1', labs(5) nogrid glc(gs16))
			xscale(fill )
			xtitle("", size(5) margin(l=2 r=2 t=5 b=2))
			xtick(`tick2') xmtick(`tick3')

			ylab(1(1)7
					,
			valuelabel labs(5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(reverse noline lw(vthin) range(`range'))
			ytitle("", size(3) margin(l=2 r=5 t=2 b=2))

			legend(size(4) position(2) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(1)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 3)
			lab(2 "2000") lab(3 "2015")
			)
			name(figure1, replace)
			;
	#delimit cr
