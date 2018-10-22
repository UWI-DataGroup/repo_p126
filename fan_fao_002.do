** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    fan_fao_002.do
    //  project:				        Food and Nutrition (FaN)
    //  analysts:				       	Ian HAMBLETON
    // 	date last modified	    17-OCT-2018
    //  algorithm task			    Urbanisation graphics

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
    log using "`logpath'\fan_fao_002", replace
** HEADER -----------------------------------------------------

use "`datapath'/version01/2-working/population_01", clear
drop Flag

** GRAPHIC 1.
** Population scatterplot. Population Size by % urban
** 107 174 214		** 116 196 118	<--
reshape wide value, i(cid year rid sids) j(type)

** % urban
** Noting that some SIDS cluster at 100% after a time
** Look into this - probably means that Population and Urbanisation
** estimates use different algorithms
gen purban = (value561/value511)*100
replace purban = 100 if purban>100
gen constant1 = 100
gen constant2 = 200
gen constant3 = 300
gen constant4 = 400

** Guyana, Suriname, Belize in caribbean
replace rid = 1 if cid==91
replace rid = 1 if cid==207
replace rid = 1 if cid==23

** List the Countries
gsort -value511
list cid rid value511 purban if year==2000


** GRAPHIC 1A. Countries in 2000
#delimit ;
	gr twoway
		  /// lw=line width, msize=symbol size, mc=symbol colour, lc=line color
		  /// Colours use RGB system
		  (sc constant1 purban if rid==1 & year==2000 [w=value511],  msize(*0.85) mfc("107 174 214%50") mlc(gs0) )
			(sc constant2 purban if rid==2 & year==2000 [w=value511],  msize(*0.85) mfc("199 233 192%50") mlc(gs0) )
			(sc constant3 purban if rid==3 & year==2000 [w=value511],  msize(*0.85) mfc("116 196 118%50") mlc(gs0))
			(sc constant4 purban if rid==4 & year==2000 [w=value511],  msize(*0.85) mfc("35 139 69%50") mlc(gs0))
		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(15)

			xlab(0(20)100, labs(7.5) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(0(5)105) noline)

		 	ylab(100 "Caribbean" 200 "Melanesia" 300 "Micronesia" 400 "Polynesia",
				labs(7.5) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(50(50)450) noline)

			yline(150, lc(gs10))
			yline(250, lc(gs10))
			yline(350, lc(gs10))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure1A)
            ;
#delimit cr


** GRAPHIC 1B. Countries in 2000 with Regional Overlay
#delimit ;
	gr twoway
		  /// lw=line width, msize=symbol size, mc=symbol colour, lc=line color
		  /// Colours use RGB system
		  (sc constant1 purban if rid==1 & year==2000 [w=value511],  msize(*0.85) mfc("107 174 214%10") mlc(gs10) )
			(sc constant2 purban if rid==2 & year==2000 [w=value511],  msize(*0.85) mfc("199 233 192%10") mlc(gs10) )
			(sc constant3 purban if rid==3 & year==2000 [w=value511],  msize(*0.85) mfc("116 196 118%10") mlc(gs10))
			(sc constant4 purban if rid==4 & year==2000 [w=value511],  msize(*0.85) mfc("35 139 69%10") mlc(gs10))
			/// Regional averages (Caribbean, Melanesia, Micronesia, Polynesia)
			///Caribbean
			(sc constant1 purban if cid==5206 & year==2000 [w=value511],  msize(*3) mfc(orange%50) mlc(gs0))
			/// Melanesia
			(sc constant2 purban if cid==5502 & year==2000 [w=value511],  msize(*3) mfc(orange%50) mlc(gs0))
			/// Polynesia
			(sc constant3 purban if cid==5504 & year==2000 [w=value511],  msize(*3) mfc(orange%50) mlc(gs0))
			/// Micronesia
			(sc constant4 purban if cid==5503 & year==2000 [w=value511],  msize(*3) mfc(orange%50) mlc(gs0))

		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(15)

			xlab(0(20)100, labs(7.5) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(0(5)105) noline)

		 	ylab(100 "Caribbean" 200 "Melanesia" 300 "Micronesia" 400 "Polynesia",
				labs(7.5) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(50(50)450) noline)

			yline(150, lc(gs10))
			yline(250, lc(gs10))
			yline(350, lc(gs10))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure1B)
            ;
#delimit cr


** GRAPHIC 1C. Countries in 2000 with Regional Overlay AND SVG/FJI overlay
#delimit ;
	gr twoway
		  /// lw=line width, msize=symbol size, mc=symbol colour, lc=line color
		  /// Colours use RGB system
		  (sc constant1 purban if rid==1 & year==2000 [w=value511],  msize(*0.85) mfc("107 174 214%10") mlc(gs10) )
			(sc constant2 purban if rid==2 & year==2000 [w=value511],  msize(*0.85) mfc("199 233 192%10") mlc(gs10) )
			(sc constant3 purban if rid==3 & year==2000 [w=value511],  msize(*0.85) mfc("116 196 118%10") mlc(gs10))
			(sc constant4 purban if rid==4 & year==2000 [w=value511],  msize(*0.85) mfc("35 139 69%10") mlc(gs10))
			/// Regional averages (Caribbean, Melanesia, Micronesia, Polynesia)
			///Caribbean
			(sc constant1 purban if cid==5206 & year==2000 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Melanesia
			(sc constant2 purban if cid==5502 & year==2000 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Polynesia
			(sc constant3 purban if cid==5504 & year==2000 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Micronesia
			(sc constant4 purban if cid==5503 & year==2000 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// FJI (in Melanesia)
			(sc constant2 purban if cid==66 & year==2000 [w=value511],  msize(*3) mfc(purple%50) mlc(gs0))
			/// SVG (in Caribbean)
			(sc constant1 purban if cid==191 & year==2000 [w=value511],  msize(*3) mfc(purple%50) mlc(gs0))

		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(15)

			xlab(0(20)100, labs(7.5) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(0(5)105) noline)

		 	ylab(100 "Caribbean" 200 "Melanesia" 300 "Micronesia" 400 "Polynesia",
				labs(7.5) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(50(50)450) noline)

			yline(150, lc(gs10))
			yline(250, lc(gs10))
			yline(350, lc(gs10))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure1C)
            ;
#delimit cr


** GRAPHIC 1D. Countries in 2005 with Regional Overlay AND SVG/FJI overlay
#delimit ;
	gr twoway
		  /// lw=line width, msize=symbol size, mc=symbol colour, lc=line color
		  /// Colours use RGB system
		  (sc constant1 purban if rid==1 & year==2005 [w=value511],  msize(*0.85) mfc("107 174 214%10") mlc(gs10) )
			(sc constant2 purban if rid==2 & year==2005 [w=value511],  msize(*0.85) mfc("199 233 192%10") mlc(gs10) )
			(sc constant3 purban if rid==3 & year==2005 [w=value511],  msize(*0.85) mfc("116 196 118%10") mlc(gs10))
			(sc constant4 purban if rid==4 & year==2005 [w=value511],  msize(*0.85) mfc("35 139 69%10") mlc(gs10))
			/// Regional averages (Caribbean, Melanesia, Micronesia, Polynesia)
			///Caribbean
			(sc constant1 purban if cid==5206 & year==2005 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Melanesia
			(sc constant2 purban if cid==5502 & year==2005 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Polynesia
			(sc constant3 purban if cid==5504 & year==2005 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Micronesia
			(sc constant4 purban if cid==5503 & year==2005 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// FJI (in Melanesia)
			(sc constant2 purban if cid==66 & year==2005 [w=value511],  msize(*3) mfc(purple%50) mlc(gs0))
			/// SVG (in Caribbean)
			(sc constant1 purban if cid==191 & year==2005 [w=value511],  msize(*3) mfc(purple%50) mlc(gs0))

		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(15)

			xlab(0(20)100, labs(7.5) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(0(5)105) noline)

		 	ylab(100 "Caribbean" 200 "Melanesia" 300 "Micronesia" 400 "Polynesia",
				labs(7.5) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(50(50)450) noline)

			yline(150, lc(gs10))
			yline(250, lc(gs10))
			yline(350, lc(gs10))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure1D)
            ;
#delimit cr


** GRAPHIC 1E. Countries in 2010 with Regional Overlay AND SVG/FJI overlay
#delimit ;
	gr twoway
		  /// lw=line width, msize=symbol size, mc=symbol colour, lc=line color
		  /// Colours use RGB system
		  (sc constant1 purban if rid==1 & year==2010 [w=value511],  msize(*0.85) mfc("107 174 214%10") mlc(gs10) )
			(sc constant2 purban if rid==2 & year==2010 [w=value511],  msize(*0.85) mfc("199 233 192%10") mlc(gs10) )
			(sc constant3 purban if rid==3 & year==2010 [w=value511],  msize(*0.85) mfc("116 196 118%10") mlc(gs10))
			(sc constant4 purban if rid==4 & year==2010 [w=value511],  msize(*0.85) mfc("35 139 69%10") mlc(gs10))
			/// Regional averages (Caribbean, Melanesia, Micronesia, Polynesia)
			///Caribbean
			(sc constant1 purban if cid==5206 & year==2010 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Melanesia
			(sc constant2 purban if cid==5502 & year==2010 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Polynesia
			(sc constant3 purban if cid==5504 & year==2010 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Micronesia
			(sc constant4 purban if cid==5503 & year==2010 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// FJI (in Melanesia)
			(sc constant2 purban if cid==66 & year==2010 [w=value511],  msize(*3) mfc(purple%50) mlc(gs0))
			/// SVG (in Caribbean)
			(sc constant1 purban if cid==191 & year==2010 [w=value511],  msize(*3) mfc(purple%50) mlc(gs0))

		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(15)

			xlab(0(20)100, labs(7.5) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(0(5)105) noline)

		 	ylab(100 "Caribbean" 200 "Melanesia" 300 "Micronesia" 400 "Polynesia",
				labs(7.5) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(50(50)450) noline)

			yline(150, lc(gs10))
			yline(250, lc(gs10))
			yline(350, lc(gs10))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure1E)
            ;
#delimit cr



** GRAPHIC 1F. Countries in 2015 with Regional Overlay AND SVG/FJI overlay
#delimit ;
	gr twoway
		  /// lw=line width, msize=symbol size, mc=symbol colour, lc=line color
		  /// Colours use RGB system
		  (sc constant1 purban if rid==1 & year==2015 [w=value511],  msize(*0.85) mfc("107 174 214%10") mlc(gs10) )
			(sc constant2 purban if rid==2 & year==2015 [w=value511],  msize(*0.85) mfc("199 233 192%10") mlc(gs10) )
			(sc constant3 purban if rid==3 & year==2015 [w=value511],  msize(*0.85) mfc("116 196 118%10") mlc(gs10))
			(sc constant4 purban if rid==4 & year==2015 [w=value511],  msize(*0.85) mfc("35 139 69%10") mlc(gs10))
			/// Regional averages (Caribbean, Melanesia, Micronesia, Polynesia)
			///Caribbean
			(sc constant1 purban if cid==5206 & year==2015 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Melanesia
			(sc constant2 purban if cid==5502 & year==2015 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Polynesia
			(sc constant3 purban if cid==5504 & year==2015 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Micronesia
			(sc constant4 purban if cid==5503 & year==2015 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// FJI (in Melanesia)
			(sc constant2 purban if cid==66 & year==2015 [w=value511],  msize(*3) mfc(purple%50) mlc(gs0))
			/// SVG (in Caribbean)
			(sc constant1 purban if cid==191 & year==2015 [w=value511],  msize(*3) mfc(purple%50) mlc(gs0))

		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(15)

			xlab(0(20)100, labs(7.5) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(0(5)105) noline)

		 	ylab(100 "Caribbean" 200 "Melanesia" 300 "Micronesia" 400 "Polynesia",
				labs(7.5) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(50(50)450) noline)

			yline(150, lc(gs10))
			yline(250, lc(gs10))
			yline(350, lc(gs10))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure1F)
            ;
#delimit cr



** GRAPHIC 1G. Countries in 2020 with Regional Overlay AND SVG/FJI overlay
#delimit ;
	gr twoway
		  /// lw=line width, msize=symbol size, mc=symbol colour, lc=line color
		  /// Colours use RGB system
		  (sc constant1 purban if rid==1 & year==2020 [w=value511],  msize(*0.85) mfc("107 174 214%10") mlc(gs10) )
			(sc constant2 purban if rid==2 & year==2020 [w=value511],  msize(*0.85) mfc("199 233 192%10") mlc(gs10) )
			(sc constant3 purban if rid==3 & year==2020 [w=value511],  msize(*0.85) mfc("116 196 118%10") mlc(gs10))
			(sc constant4 purban if rid==4 & year==2020 [w=value511],  msize(*0.85) mfc("35 139 69%10") mlc(gs10))
			/// Regional averages (Caribbean, Melanesia, Micronesia, Polynesia)
			///Caribbean
			(sc constant1 purban if cid==5206 & year==2020 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Melanesia
			(sc constant2 purban if cid==5502 & year==2020 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Polynesia
			(sc constant3 purban if cid==5504 & year==2020 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Micronesia
			(sc constant4 purban if cid==5503 & year==2020 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// FJI (in Melanesia)
			(sc constant2 purban if cid==66 & year==2020 [w=value511],  msize(*3) mfc(purple%50) mlc(gs0))
			/// SVG (in Caribbean)
			(sc constant1 purban if cid==191 & year==2020 [w=value511],  msize(*3) mfc(purple%50) mlc(gs0))

		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(15)

			xlab(0(20)100, labs(7.5) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(0(5)105) noline)

		 	ylab(100 "Caribbean" 200 "Melanesia" 300 "Micronesia" 400 "Polynesia",
				labs(7.5) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(50(50)450) noline)

			yline(150, lc(gs10))
			yline(250, lc(gs10))
			yline(350, lc(gs10))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure1G)
            ;
#delimit cr



** GRAPHIC 1H. Countries in 2050 with Regional Overlay AND SVG/FJI overlay
#delimit ;
	gr twoway
		  /// lw=line width, msize=symbol size, mc=symbol colour, lc=line color
		  /// Colours use RGB system
		  (sc constant1 purban if rid==1 & year==2050 [w=value511],  msize(*0.85) mfc("107 174 214%10") mlc(gs10) )
			(sc constant2 purban if rid==2 & year==2050 [w=value511],  msize(*0.85) mfc("199 233 192%10") mlc(gs10) )
			(sc constant3 purban if rid==3 & year==2050 [w=value511],  msize(*0.85) mfc("116 196 118%10") mlc(gs10))
			(sc constant4 purban if rid==4 & year==2050 [w=value511],  msize(*0.85) mfc("35 139 69%10") mlc(gs10))
			/// Regional averages (Caribbean, Melanesia, Micronesia, Polynesia)
			///Caribbean
			(sc constant1 purban if cid==5206 & year==2050 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Melanesia
			(sc constant2 purban if cid==5502 & year==2050 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Polynesia
			(sc constant3 purban if cid==5504 & year==2050 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// Micronesia
			(sc constant4 purban if cid==5503 & year==2050 [w=value511],  msize(*3) mfc(orange%20) mlc(gs5))
			/// FJI (in Melanesia)
			(sc constant2 purban if cid==66 & year==2050 [w=value511],  msize(*3) mfc(purple%50) mlc(gs0))
			/// SVG (in Caribbean)
			(sc constant1 purban if cid==191 & year==2050 [w=value511],  msize(*3) mfc(purple%50) mlc(gs0))

		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(15)

			xlab(0(20)100, labs(7.5) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(0(5)105) noline)

		 	ylab(100 "Caribbean" 200 "Melanesia" 300 "Micronesia" 400 "Polynesia",
				labs(7.5) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(50(50)450) noline)

			yline(150, lc(gs10))
			yline(250, lc(gs10))
			yline(350, lc(gs10))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure1H)
            ;
#delimit cr
