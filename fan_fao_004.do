** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    fan_fao_004.do
    //  project:				        Food and Nutrition (FaN)
    //  analysts:				       	Ian HAMBLETON
    // 	date last modified	    18-OCT-2018
    //  algorithm task			    Employment in Agriculture graphics

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
    log using "`logpath'\fan_fao_004", replace
** HEADER -----------------------------------------------------
use "`datapath'/version01/2-working/landuse_modelled_01", clear
drop IndicatorName

** Rehspae to LONG
reshape long y, i(CountryCode subregion Region) j(year)


** FIGURE A --> World
#delimit ;
	gr twoway
		  /// World
			(line y year if subregion==1000 & CountryName=="World",  lw(0.5) lc(gs10%100) )
			(sc y year if subregion==1000 & CountryName=="World",  msize(*1) mfc(gs10%100) mlc(gs0) )
			,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(8.5)

			xlab(1995(10)2015,
			labs(7) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(1990(1)2030) noline)

		 	ylab(0(20)60,
			labs(7) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(0(5)65) noline)

			text(26 2018 "World", place(e) size(5.5) color(gs0))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure4A)
            ;
#delimit cr

** FIGURE B --> World + Pacific
#delimit ;
	gr twoway
		  /// World
			(line y year if subregion==1000 & CountryName=="World",  lw(0.5) lc(gs10%15) )
			(sc y year if subregion==1000 & CountryName=="World",  msize(*1) mfc(gs10%15) mlc(gs12) )
		  /// Pacific SIDS
			(line y year if subregion==1000 & CountryName=="Pacific island small states",  lw(0.5) lc("35 139 69%100") )
			(sc y year if subregion==1000 & CountryName=="Pacific island small states",  msize(*1) mfc("35 139 69%100") mlc(gs0) )
			,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(8.5)

			xlab(1995(10)2015,
			labs(7) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(1990(1)2030) noline)

		 	ylab(0(20)60,
			labs(7) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(0(5)65) noline)

			text(26 2018 "World", place(e) size(5.5) color(gs12))
			text(53 2018 "Pacific SIDS", place(e) size(5.5) color(gs0))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure4B)
            ;
#delimit cr


** FIGURE B --> World + Pacific + Caribbean
#delimit ;
	gr twoway
		  /// World
			(line y year if subregion==1000 & CountryName=="World",  lw(0.5) lc(gs10%15) )
			(sc y year if subregion==1000 & CountryName=="World",  msize(*1) mfc(gs10%15) mlc(gs12) )
		  /// Pacific SIDS
			(line y year if subregion==1000 & CountryName=="Pacific island small states",  lw(0.5) lc("35 139 69%15") )
			(sc y year if subregion==1000 & CountryName=="Pacific island small states",  msize(*1) mfc("35 139 69%15") mlc(gs12) )
			/// Caribbean SIDS
			(line y year if subregion==1000 & CountryName=="Caribbean small states",  lw(0.5) lc("33 113 181%100") )
			(sc y year if subregion==1000 & CountryName=="Caribbean small states",  msize(*1) mfc("33 113 181%100") mlc(gs0) )
			,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(8.5)

			xlab(1995(10)2015,
			labs(7) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(1990(1)2030) noline)

		 	ylab(0(20)60,
			labs(7) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(0(5)65) noline)


			text(26 2018 "World", place(e) size(5.5) color(gs12))
			text(53 2018 "Pacific SIDS", place(e) size(5.5) color(gs12))
			text(13 2018 "Caribbean SIDS", place(e) size(5.5) color(gs0))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure4C)
            ;
#delimit cr

** FIGURE D --> World + Pacific + Caribbean + FJI
#delimit ;
	gr twoway
		  /// World
			(line y year if subregion==1000 & CountryName=="World",  lw(0.5) lc(gs10%15) )
			(sc y year if subregion==1000 & CountryName=="World",  msize(*1) mfc(gs10%15) mlc(gs12) )
		  /// Pacific SIDS
			(line y year if subregion==1000 & CountryName=="Pacific island small states",  lw(0.5) lc("35 139 69%15") )
			(sc y year if subregion==1000 & CountryName=="Pacific island small states",  msize(*1) mfc("35 139 69%15") mlc(gs12) )
			/// Caribbean SIDS
			(line y year if subregion==1000 & CountryName=="Caribbean small states",  lw(0.5) lc("33 113 181%15") )
			(sc y year if subregion==1000 & CountryName=="Caribbean small states",  msize(*1) mfc("33 113 181%15") mlc(gs12) )
			/// FIJI
			(line y year if subregion==2 & CountryName=="Fiji",  lw(0.5) lc(purple%50) )
			(sc y year if subregion==2 & CountryName=="Fiji",  msize(*1) mfc(purple%50) mlc(gs0) )
			,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(8.5)

			xlab(1995(10)2015,
			labs(7) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(1990(1)2030) noline)

		 	ylab(0(20)60,
			labs(7) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(0(5)65) noline)

			text(26 2018 "World", place(e) size(5.5) color(gs12))
			text(53 2018 "Pacific SIDS", place(e) size(5.5) color(gs12))
			text(13 2018 "Caribbean SIDS", place(e) size(5.5) color(gs12))
			text(40 2018 "Fiji", place(e) size(5.5) color(gs0))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure4D)
            ;
#delimit cr


** FIGURE E --> World + Pacific + Caribbean + FJI + SVG
#delimit ;
	gr twoway
		  /// World
			(line y year if subregion==1000 & CountryName=="World",  lw(0.5) lc(gs10%15) )
			(sc y year if subregion==1000 & CountryName=="World",  msize(*1) mfc(gs10%15) mlc(gs12) )
		  /// Pacific SIDS
			(line y year if subregion==1000 & CountryName=="Pacific island small states",  lw(0.5) lc("35 139 69%15") )
			(sc y year if subregion==1000 & CountryName=="Pacific island small states",  msize(*1) mfc("35 139 69%15") mlc(gs12) )
			/// Caribbean SIDS
			(line y year if subregion==1000 & CountryName=="Caribbean small states",  lw(0.5) lc("33 113 181%15") )
			(sc y year if subregion==1000 & CountryName=="Caribbean small states",  msize(*1) mfc("33 113 181%15") mlc(gs12) )
			/// FIJI
			(line y year if subregion==2 & CountryName=="Fiji",  lw(0.5) lc(purple%15) )
			(sc y year if subregion==2 & CountryName=="Fiji",  msize(*1) mfc(purple%15) mlc(gs12) )
			/// SVG
			(line y year if subregion==1 & CountryName=="St. Vincent and the Grenadines",  lw(0.5) lc(purple%50) )
			(sc y year if subregion==1 & CountryName=="St. Vincent and the Grenadines",  msize(*1) mfc(purple%50) mlc(gs0) )			,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(5) xsize(8.5)

			xlab(1995(10)2015,
			labs(7) labc(gs6) nogrid angle(0) notick)
			xtitle("", margin(r=3) size(3.5))
			xscale(range(1990(1)2030) noline)

		 	ylab(0(20)60,
			labs(7) labc(gs6) nogrid notick glc(gs14) angle(0) format(%9.0f) labgap(10))
			ytitle("", margin(r=3) size(3.5))
			yscale(range(0(5)65) noline)

			text(26 2018 "World", place(e) size(5.5) color(gs12))
			text(53 2018 "Pacific SIDS", place(e) size(5.5) color(gs12))
			text(13 2018 "Caribbean SIDS", place(e) size(5.5) color(gs12))
			text(40 2018 "Fiji", place(e) size(5.5) color(gs12))
			text(6 2018 "St.Vincent", place(e) size(5.5) color(gs0))

			legend(off size(3) position(12) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(0.1) margin(l=2 r=2 t=2 b=2))
            order(3 1 2)
			lab(1 "Central America")
			lab(2 "Southern America")
			lab(3 "Caribbean")
            )
      name(figure4E)
            ;
#delimit cr
