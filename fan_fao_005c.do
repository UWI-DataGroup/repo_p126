* HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    fan_fao_005c.do
    //  project:				    Food and Nutrition (FaN)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	        22-OCT-2018
    //  algorithm task			    Value of food imports over total merchandise exports

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
    log using "`logpath'\fan_fao_005c", replace
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
import excel using "`datapath'/version01/2-working/Food_Security_Indicators_11SEP2018 Hambleton", sheet("I_3.3") cellra(c3:p251) first clear

** Country name
rename RegionsSubregionsCountries cname
label var cname "Country name"

** Internal Country, Region ID
gen id = _n
order id, before(cname)
label var id "Country or Region Internal ID"

** Assign string to labels
labmask id, values(cname)
**drop cname

** We convert these numeric values to alphanumeric variable names
local yr = 2000
foreach var in D E F G H I J K L M N O P {
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

** Save dataset for later merge with land use
save "`datapath'/version01/2-working/import_01", replace
drop cname

** ---------------------------------------------------------------------------
** GRAPHICS
** Equiplot for each Stratifier
** ---------------------------------------------------------------------------
** ColorBrewer orange range (x9 classes)
** LIGHT
** 255,245,235
** 254,230,206
** 253,208,162
** 253,141,60
** 241,105,19
** 217,72,1
** 166,54,3
** 127,39,4
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
** ALSO ADD
** 136 Antigua
** 142 Grenada
** 140 Dominica
gen group03 = 0
replace group03 = 1 if id==148 | id==178 | id==4 | id==135 | id==176 | id==2 | id==198|id==136|id==142|id==140

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
replace cid = 8 if id==136
replace cid = 9 if id==140
replace cid = 10 if id==142

label define cid_  1 "NA / Europe" 2 "Least Developed" 3 "SIDS" 4 "Oceania" 5 "Fiji"  6 "Caribbean" 7 "St Vincent" 8 "Antigua" 9 "Dominica" 10 "Grenada"
label values cid cid_

** Keeping selected time points
keep if year==2000 | year==2012

** Minimum / Maximum values for -equiplot- horizontal line connector
bysort id : egen min = min(est) if group==1
bysort id : egen max = max(est) if group==1


/*
** GRAPHIC 2 - without SVG
** ---------------------------------------------------------------------------
** X-axis
local tick1 = "0(5)30"
local tick2 = "0(1)30"
///local tick3 = "80(5)140"
* y-axis range
local range "0.5(0.5)7.5"
** ---------------------------------------------------------------------------
preserve
drop if cid>=7
#delimit ;
	gr twoway
		/// Line between min and max
		(rspike min max cid if group==1, hor lc(gs10) lw(0.35))
		/// year 2000
		(sc cid est if group==1 & year==2000, msize(6) m(o) mlc(gs0) mfc("253 208 162") mlw(0.1))
		/// year 2015
		(sc cid est if group==1 & year==2012, msize(6) m(o) mlc(gs0) mfc("166 54 3") mlw(0.1))
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
restore


** GRAPHIC 2 - HIGH VALUE Caribbean Islands
** ---------------------------------------------------------------------------
** X-axis
local tick1 = "0(50)200"
local tick2 = "0(10)200"
///local tick3 = "80(5)140"
* y-axis range
local range "0.5(0.5)4.5"
** ---------------------------------------------------------------------------
preserve
keep if cid>=7
recode cid 7=1 8=2 9=3 10=4
#delimit ;
	gr twoway
		/// Line between min and max
		(rspike min max cid if group==1, hor lc(gs10) lw(0.35))
		/// year 2000
		(sc cid est if group==1 & year==2000, msize(6) m(o) mlc(gs0) mfc("253 208 162") mlw(0.1))
		/// year 2015
		(sc cid est if group==1 & year==2012, msize(6) m(o) mlc(gs0) mfc("166 54 3") mlw(0.1))
		,
			graphregion(color(gs16)) ysize(7.5) xsize(15)
			bgcolor(gs16)

			xlab(`tick1', labs(5) nogrid glc(gs16))
			xscale(fill )
			xtitle("", size(5) margin(l=2 r=2 t=5 b=2))
			xtick(`tick2') xmtick(`tick3')

			ylab(1 "St Vincent" 2 "Antigua" 3 "Dominica" 4 "Grenada"
					,
			valuelabel labs(5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(reverse noline lw(vthin) range(`range'))
			ytitle("", size(3) margin(l=2 r=5 t=2 b=2))

			legend(size(4) position(2) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(1)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 3)
			lab(2 "2000") lab(3 "2015")
			)
			name(figure3, replace)
			;
	#delimit cr
restore
*/

** -----------------------------------
** For the last graphic, plot the FOOD IMPORT METRIC AGAINST LAND AREA...
** FOR ALL SIDS
tempfile t1 t2 t3
** -----------------------------------
** Bring in the Land Size dataset
use "`datapath'/version01/2-working/landuse_01", clear
drop Flag
reshape wide value, i(cid year rid sids Area) j(metric)
drop value6602
** X-AXIS indicator
gen region = 1 if cid==5803
replace region = 2 if cid==5504
replace region = 3 if cid==5503
replace region = 4 if cid==5502
replace region = 5 if cid==5206
replace region = 6 if cid==5400
label define region_ 1 "SIDS" 2 "Polynesia" 3 "Micronesia" 4 "Melanesia" 5 "Caribbean" 6 "Europe"
label values region region_
keep if year==2015
rename Area cname
save `t1' , replace

** Import dataset
use "`datapath'/version01/2-working/import_01", clear
merge 1:1 cname using `t1'
drop est2000 est2001 est2002 est2003 est2004 est2005 est2006 est2007 est2008 est2009 est2010 est2011
keep if _merge==3
drop _merge
keep if maj_region==4 | maj_region==5
gen log_size = ln(value6601)
gen log_import = ln(est2012)

** SCATTERPLOT of land area against FOOD IMPORTS
#delimit ;
   gr twoway
        (sc log_import log_size if rid>=2 & rid<=4 ,    msize(*4) mfc("35 139 69%50") mlc(gs0) )
        (sc log_import log_size if rid==1 ,             msize(*4) mfc("33 113 181%50") mlc(gs0) )
         ,
           plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
           graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
           ysize(6) xsize(15)

           xlab(0 " ",
               labs(7.5) labc(gs6) nogrid angle(0) notick)
           xtitle("Land Area", margin(r=5) size(7.5) color(gs10))
           xscale(range(0(1)12) noline)

           ylab(1 " ",
           labs(7.5) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
           ytitle("Food Imports", margin(t=5) size(7.5) color(gs10))
           yscale(noline)

           ///yline(150, lc(gs10))

           legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
           region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
           lab(1 "Central America")
           lab(2 "Southern America")
           lab(3 "Caribbean")
            )
      name(figure1)
            ;
#delimit cr


** SCATTERPLOT of land area against FOOD IMPORTS
** ADD regression Line
#delimit ;
   gr twoway
        (sc log_import log_size if rid>=2 & rid<=4 ,    msize(*4) mfc("35 139 69%15") mlc(gs12) )
        (sc log_import log_size if rid==1 ,             msize(*4) mfc("33 113 181%15") mlc(gs12) )
        (lfit log_import log_size, lc(gs0%75) lp("##-") lw(0.5))
         ,
           plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
           graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
           ysize(6) xsize(15)

           xlab(0 " ",
               labs(7.5) labc(gs6) nogrid angle(0) notick)
           xtitle("Land Area", margin(r=5) size(7.5) color(gs10))
           xscale(range(0(1)12) noline)

           ylab(1 " ",
           labs(7.5) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
           ytitle("Food Imports", margin(t=5) size(7.5) color(gs10))
           yscale(noline)

           ///yline(150, lc(gs10))

           legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
           region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
           lab(1 "Central America")
           lab(2 "Southern America")
           lab(3 "Caribbean")
            )
      name(figure2)
            ;
#delimit cr


** SCATTERPLOT of land area against FOOD IMPORTS
** ADD regression Line
** HIGHLIGHT LOW points
#delimit ;
   gr twoway
        (sc log_import log_size if rid>=2 & rid<=4 ,    msize(*4) mfc("35 139 69%15") mlc(gs12) )
        (sc log_import log_size if rid==1 ,             msize(*4) mfc("33 113 181%15") mlc(gs12) )
        (lfit log_import log_size, lc(gs0%75) lp("##-") lw(0.5))
        (sc log_import log_size if cid==5 | cid==220 | cid==148, msize(*4) mfc("white") mlc(gs16) )
        (sc log_import log_size if cid==5 | cid==220 | cid==148, msize(*4) mfc("orange%75") mlc(gs0) )

         ,
           plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
           graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
           ysize(6) xsize(15)

           xlab(0 " ",
               labs(7.5) labc(gs6) nogrid angle(0) notick)
           xtitle("Land Area", margin(r=5) size(7.5) color(gs10))
           xscale(range(0(1)12) noline)

           ylab(1 " ",
           labs(7.5) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
           ytitle("Food Imports", margin(t=5) size(7.5) color(gs10))
           yscale(noline)

           ///yline(150, lc(gs10))

           legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
           region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
           lab(1 "Central America")
           lab(2 "Southern America")
           lab(3 "Caribbean")
            )
      name(figure3)
            ;
#delimit cr



** SCATTERPLOT of land area against FOOD IMPORTS
** ADD regression Line
** HIGHLIGHT LOW points
#delimit ;
   gr twoway
        (sc log_import log_size if rid>=2 & rid<=4 ,    msize(*4) mfc("35 139 69%15") mlc(gs12) )
        (sc log_import log_size if rid==1 ,             msize(*4) mfc("33 113 181%15") mlc(gs12) )
        (lfit log_import log_size, lc(gs0%75) lp("##-") lw(0.5))
        (sc log_import log_size if cid==5 | cid==220 | cid==148, msize(*4) mfc("white") mlc(gs16) )
        (sc log_import log_size if cid==5 | cid==220 | cid==148, msize(*4) mfc("orange%75") mlc(gs0) )

         ,
           plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
           graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
           ysize(6) xsize(15)

           xlab(0 " ",
               labs(7.5) labc(gs6) nogrid angle(0) notick)
           xtitle("Land Area", margin(r=5) size(7.5) color(gs10))
           xscale(range(0(1)12) noline)

           ylab(1 " ",
           labs(7.5) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
           ytitle("Food Imports", margin(t=5) size(7.5) color(gs10))
           yscale(noline)

           text(1.8 6.5 "Trinidad", size(6) color(gs0) place(east))
           text(1.6 3.25 "Am Samoa", size(6) color(gs0) place(east))
           text(1.8 0.95 "Nauru", size(6) color(gs0) place(east))

           legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
           region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
           lab(1 "Central America")
           lab(2 "Southern America")
           lab(3 "Caribbean")
            )
      name(figure4)
            ;
#delimit cr
