
** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a082\"
log using "versions\version01\logfiles\a082_foodsecurity_001", replace

**  GENERAL DO-FILE COMMENTS
//  program:     a082_foodsecurity_001.do
//  project:     CFaH project: Food Security Profile 
//  author:      HAMBLETON \ 31-JUL-2017
//  task:        Import the relevant indicators

** DO-FILE SET UP COMMANDS
version 15
clear all
macro drop _all
set more 1
set linesize 80 


** ---------------------------------------------------------------------------------------------
** Read the EXCEL spreadsheet
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
** V_1.1	Average dietary energy supply adequacy
** V_1.2 	Average value of food production	
** V_1.3	Share of dietary energy supply derived from cereals, roots and tubers	
** V_1.4	Average protein supply
** V_1.5	Average supply of protein of animal origin
** 	
** ACCESS	
** V_2.1	Percent of paved roads over total roads	
** V_2.2	Road density	
** V_2.3	Rail lines density	
** V_2.4	Gross domestic product per capita (in purchasing power equivalent)	
** V_2.5	Domestic food price index
** V_2.6	Prevalence of undernourishment	
** V_2.7	Share of food expenditure of the poor 	
** V_2.8	Depth of the food deficit
** 	
** STABILITY	
** V_3.1	Cereal import dependency ratio	
** V_3.2	Percent of arable land equipped for irrigation	
** V_3.3	Value of food imports over total merchandise exports	
** V_3.4	Political stability and absence of violence/terrorism	
** V_3.5	Domestic food price volatility 	
** V_3.6	Per capita food production variability	
** V_3.7	Per capita food supply variability	
** 	
** UTILIZATION	
** V_4.1	Access to improved water sources	
** V_4.2	Access to improved sanitation facilities	
** V_4.3	Percentage of children under 5 years of age affected by wasting	
** V_4.4	Percentage of children under 5 years of age who are stunted	
** V_4.5	Percentage of children under 5 years of age who are underweight 	
** V_4.6	Percentage of adults who are underweight 	
** V_4.7	Prevalence of anaemia among pregnant women	
** V_4.8	Prevalence of anaemia among children under 5 years of age	
** V_4.9	Prevalence of vitamin A deficiency in the population	
** V_4.10	Prevalence of school-age children (6-12 years) with insufficient iodine intake	
** 	
** ADDITIONAL USEFUL STATISTICS	
** A_1	Total population	
** A_2	Number of people undernourished	
** A_3	Minimum Dietary Energy Requirement (MDER)	
** A_4	Average Dietary Energy Requirement (ADER)	
** A_5	Minimum Dietary Energy Requirement (MDER) - PAL=1.75	
** A_6	Coefficient of variation of habitual caloric consumption distribution	
** A_7	Skewness of habitual caloric consumption distribution	
** A_8	Incidence of caloric losses at retail distribution level	
** A_9	Dietary Energy Supply (DES)	
** A_10	Average fat supply 	
** A_11	Prevalence of food over-acquisition
** A_12	Maximum Dietary Energy Requirement (XDER)

   
   
   
** ---------------------------------------------------------------------------------------------
** V_1.1	Average dietary energy supply adequacy
** ---------------------------------------------------------------------------------------------
import excel using "output/data_audit/data/fao/food_security/Food_Security_Indicators.xlsx", sheet("V_3.3") cellra(b3:x260) first clear

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
local yr = 1990
foreach var in C D E F G H I J K L M N O P Q R S T U V W X {
	rename `var' est`yr'
	label var est`yr' "Estimate (3-year) for `yr'"
	local yr = `yr'+1
	}

** Creating country groups
gen maj_region = .
**gen min_region = .
replace maj_region = 1 if id==1
replace maj_region = 2 if id>=3 & id<=68
replace maj_region = 3 if id>=69 & id<=121
replace maj_region = 4 if id>=122 & id<=171
replace maj_region = 5 if id>=172 & id<=193
replace maj_region = 6 if id>=194 & id<=251
replace maj_region = 1 if maj_region==.

label define maj_region 1 "world"			///
						2 "africa"			///
						3 "asia"			///
						4 "lac"				///
						5 "oceania"			///
						6 "developed", modify
label values maj_region maj_region
order maj_region, after(id)



** ---------------------------------------------------------------------------
** GRAPHICS
** Equiplot for each Stratifier
** ---------------------------------------------------------------------------
** ColorBrewer blue and green range (x9 classes)

	** BLUES			** GREENS
	** LIGHT			** LIGHT
	** 247 251 255		** 247 252 245  <--
	** 222 235 247		** 229 245 224
	** 198 219 239		** 199 233 192  <--
	** 158 202 225		** 161 217 155
	** 107 174 214		** 116 196 118	<--
	** 66 146 198		** 65 171 93
	** 33 113 181		** 35 139 69	<--
	** 8 81 156			** 0 109 44
	** 8 48 107			** 0 68 27		<--
    ** DARK             ** DARK
** ---------------------------------------------------------------------------

** Reshape to long
reshape long est, i(id) j(year)

** Country Grouping 1
** 144 	Saint Vincent 
** 175 Fiji
gen group01 = 0
replace group01 = 1 if id==144 | id==175

** Country Grouping 2
** 144 	Saint Vincent 
** 175 Fiji
** 254 all SIDS
gen group02 = 0
replace group02 = 1 if id==144 | id==175 | id==254

** Country Grouping 3
** 2 	all developing
** 194 	all developed
** 144 	Saint Vincent 
** 175 	Fiji
** 254 	all SIDS
** 123 	Caribbean
** 172 	South Pacific
gen group03 = 0
replace group03 = 1 if id==144 | id==175 | id==254 | id==123 | id==172 | id==2 | id==194

gen group = group03

keep if group==1
gen cid = .
replace cid = 1 if id==194
replace cid = 2 if id==2
replace cid = 3 if id==254
replace cid = 4 if id==172
replace cid = 5 if id==175
replace cid = 6 if id==123
replace cid = 7 if id==144


** Keeping selected time points
keep if year==1991 | year==2001 | year==2011

** Minimum / Maximum values for -equiplot- horizontal line connector
bysort id : egen min = min(est) if group==1
bysort id : egen max = max(est) if group==1

** ---------------------------------------------------------------------------
** X-axis
local tick1 = "0(20)150"
local tick2 = "0(10)150"

* y-axis range
local range "0.5(0.5)7.5"
** ---------------------------------------------------------------------------

#delimit ;
	gr twoway 
		/// Line between min and max
		(rspike min max cid if group==1, hor lc(gs10) lw(0.35))
		/// year 1994
		(sc cid est if group==1 & year==1991, msize(7) m(o) mlc(gs0) mfc("247 252 245") mlw(0.1))
		/// year 2004
		(sc cid est if group==1 & year==2001, msize(7) m(o) mlc(gs0) mfc("116 196 118") mlw(0.1))
		/// year 2014
		(sc cid est if group==1 & year==2011, msize(7) m(o) mlc(gs0) mfc("0 68 27") mlw(0.1))
		
		,
			graphregion(color(gs16)) ysize(5) xsize(9.5)
			bgcolor(gs16)
			
			xlab(`tick1', labs(5) nogrid glc(gs16))
			xscale(fill ) 
			xtitle("", size(5) margin(l=2 r=2 t=5 b=2)) 
			xmtick(`tick2')
			
			ylab(1 "Developed" 2 "Developing" 3 "SIDS" 4 "Oceania" 5 "Fiji" 6 "Caribbean" 7 "St Vincent"
					,
			valuelabel labs(5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(reverse noline lw(vthin) range(`range')) 
			ytitle("", size(3) margin(l=2 r=5 t=2 b=2)) 

			legend(size(4) position(2) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(1)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
			order(2 3 4 5 6 7) 
			lab(2 "1991") lab(3 "2001") lab(4 "2011")
			)
			name(figure1, replace)
			;
	#delimit cr	

