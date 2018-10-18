** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    fan_fao_003.do
    //  project:				        Food and Nutrition (FaN)
    //  analysts:				       	Ian HAMBLETON
    // 	date last modified	    18-OCT-2018
    //  algorithm task			    Land Use graphics

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
    log using "`logpath'\fan_fao_003", replace
** HEADER -----------------------------------------------------

use "`datapath'/version01/2-working/landuse_01", clear
drop Flag
reshape wide value, i(cid year rid sids Area) j(metric)

** % agricultural land
gen pag = (value6602 / value6601) * 100
label var pag "Percentage agricultural land"

** X-AXIS indicator
gen region = 1 if cid==5803
replace region = 2 if cid==5504
replace region = 3 if cid==5503
replace region = 4 if cid==5502
replace region = 5 if cid==5206
label define region_ 1 "SIDS" 2 "Polynesia" 3 "Micronesia" 4 "Melanesia" 5 "Caribbean"
label values region region_

** FIRST and LAST value for EACH PARTICIPANT COUNTRY
keep if rid>=1 & rid<=4
keep if year>=1990
sort cid year
gen ykeep = 0
replace ykeep = 1 if cid!=cid[_n-1]
replace ykeep = 1 if cid!=cid[_n+1]
keep if ykeep==1
sort rid cid year
by rid cid: gen order = _n
drop value6601 value6602 year
reshape wide pag, i(cid rid Area) j(order)

** Order by agricultural Land size at last measurement
** Running COUNTRY number from 1 upwards
preserve
	keep if rid==2 | rid==3 | rid==4
	sort pag1
	gen cid2 = _n
	order cid2, after(cid)
	labmask cid2, values(Area)
	drop if pag1==.

	** GRAPHIC. SOUTH PACIFIC
	#delimit ;
	gr twoway
			/// Colours use RGB system
			(sc cid2 pag1 , msize(3) m(o) mlc(gs10) mfc("35 139 69%50") mlw(0.1) )
			,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(15) xsize(15)

			xlab(0(20)80, labs(4) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(0(10)80) noline)

			ylab(1(1)22, value
			labs(2) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(1))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(0(1)23) noline)

			legend(off)
			name(figure2A)
						;
		#delimit cr

	** GRAPHIC. SOUTH PACIFIC
	#delimit ;
	gr twoway
		  /// Colours use RGB system
			/// Polynesia
			(rspike pag1 pag2 cid2, horiz lc(gs12) lw(0.25))
			(sc cid2 pag1 , msize(3) m(o) mlc(gs10) mfc("35 139 69%50") mlw(0.1) )
			(sc cid2 pag2 , msize(3) m(o) mlc(gs0) mfc("orange%50") mlw(0.1) )
		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(15) xsize(15)

			xlab(0(20)80, labs(4) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(0(10)80) noline)

		 	ylab(1(1)22, value
			labs(2) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(1))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(0(1)23) noline)

			legend(off)
      name(figure2B)
            ;
		#delimit cr
restore



** GRAPHIC. CARIBBEAN
preserve
	keep if rid==1
	drop if pag2==.
	sort pag1
	gen cid2 = _n
	order cid2, after(cid)
	labmask cid2, values(Area)

	#delimit ;
	gr twoway
			/// Colours use RGB system
			(sc cid2 pag1 , msize(3) m(o) mlc(gs10) mfc("107 174 214%50") mlw(0.1) )
			,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(15) xsize(15)

			xlab(0(20)80, labs(4) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(0(10)80) noline)

			ylab(1(1)23, value
			labs(2) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(1))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(0(1)24) noline)

			legend(off)
			name(figure2C)
						;
		#delimit cr

	#delimit ;
	gr twoway
		  /// Colours use RGB system
			/// Polynesia
			(rspike pag1 pag2 cid2, horiz lc(gs12) lw(0.25))
			(sc cid2 pag1 , msize(3) m(o) mlc(gs10) mfc("107 174 214%50") mlw(0.1) )
			(sc cid2 pag2 , msize(3) m(o) mlc(gs0) mfc("orange%50") mlw(0.1) )
		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(15) xsize(15)

			xlab(0(20)80, labs(4) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(0(10)80) noline)

		 	ylab(1(1)23, value
			labs(2) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(1))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(0(1)24) noline)

			legend(off)
      name(figure2D)
            ;
		#delimit cr
restore
