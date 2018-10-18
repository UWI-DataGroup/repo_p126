** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    fan_fao_001.do
    //  project:				        Food and Nutrition (FaN)
    //  analysts:				       	Ian HAMBLETON
    // 	date last modified	    17-OCT-2018
    //  algorithm task			    Reading the FAO population dataset

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
    log using "`logpath'\fan_fao_001", replace
** HEADER -----------------------------------------------------

/*

** ------------------------------------------------------------
** FILE 1 - POPULATION and URBANISATION
** ------------------------------------------------------------
** Population_E_All_Data_(Normalized).csv
import excel using "`datapath'/version01/1-input/Population_E_All_Data_(Normalized).xlsx", first

drop Item ItemCode

rename AreaCode cid
label var cid "Country ID"
labmask cid, values(Area)
order cid

rename ElementCode type
label var type "Metric type"
labmask type, values(Element)
order type, after(cid)

rename Year year
label var year "Year of metric estimate"
order year, after(type)

rename Value value
label var value "Metric value"
order value, after(year)

drop Element Area YearCode Unit

** Keep selected countries and regions

** Caribbean (5206)
** 5206	Caribbean	258	Anguilla
** 5206	Caribbean	8	Antigua and Barbuda
** 5206	Caribbean	22	Aruba
** 5206	Caribbean	12	Bahamas
** 5206	Caribbean	14	Barbados
** 5206	Caribbean	239	British Virgin Islands
** 5206	Caribbean	36	Cayman Islands
** 5206	Caribbean	49	Cuba
** 5206	Caribbean	279	CuraÃ§ao
** 5206	Caribbean	55	Dominica
** 5206	Caribbean	56	Dominican Republic
** 5206	Caribbean	86	Grenada
** 5206	Caribbean	87	Guadeloupe
** 5206	Caribbean	93	Haiti
** 5206	Caribbean	109	Jamaica
** 5206	Caribbean	135	Martinique
** 5206	Caribbean	142	Montserrat
** 5206	Caribbean	151	Netherlands Antilles (former)
** 5206	Caribbean	177	Puerto Rico
** 5206	Caribbean	188	Saint Kitts and Nevis
** 5206	Caribbean	189	Saint Lucia
** 5206	Caribbean	191	Saint Vincent and the Grenadines
** 5206	Caribbean	281	Saint-Martin (French Part)
** 5206	Caribbean	280	Sint Maarten (Dutch Part)
** 5206	Caribbean	220	Trinidad and Tobago
** 5206	Caribbean	224	Turks and Caicos Islands
** 5206	Caribbean	240	United States Virgin Islands
gen rid = .
#delimit ;
    replace rid = 1 if  cid==258 | cid==8  |
                        cid==22  | cid==12 |
                        cid==14  | cid==239|
                        cid==36  | cid==49 |
                        cid==279 | cid==55 |
                        cid==56  | cid==86 |
                        cid==87  | cid==93 |
                        cid==109 | cid==135|
                        cid==142 | cid==151|
                        cid==177 | cid==188 |
                        cid==189 | cid==191 |
                        cid==281 | cid==280 |
                        cid==220 | cid==224 |
                        cid==240;
#delimit cr
order rid, after(cid)


** MELANESIA (5502)
** 5502	Melanesia	66	Fiji
** 5502	Melanesia	153	New Caledonia
** 5502	Melanesia	168	Papua New Guinea
** 5502	Melanesia	25	Solomon Islands
** 5502	Melanesia	155	Vanuatu
#delimit ;
    replace rid = 2 if  cid==66  | cid==153|
                        cid==168  | cid==25 |
                        cid==155;
#delimit cr

** MICRONESIA (5503)
** 5503	Micronesia	88	Guam
** 5503	Micronesia	83	Kiribati
** 5503	Micronesia	127	Marshall Islands
** 5503	Micronesia	145	Micronesia (Federated States of)
** 5503	Micronesia	148	Nauru
** 5503	Micronesia	163	Northern Mariana Islands
** 5503	Micronesia	164	Pacific Islands Trust Territory
** 5503	Micronesia	180	Palau
#delimit ;
    replace rid = 3 if  cid==88  | cid==83 |
                        cid==127 | cid==145|
                        cid==148 | cid==163|
                        cid==164 | cid==180;
#delimit cr

** POLYNESIA (5504)
** 5504	Polynesia	5	American Samoa	16	AS	ASM
** 5504	Polynesia	47	Cook Islands	184	CK	COK
** 5504	Polynesia	70	French Polynesia	258	PF	PYF
** 5504	Polynesia	160	Niue	570	NU	NIU
** 5504	Polynesia	172	Pitcairn Islands	612	PN	PCN
** 5504	Polynesia	244	Samoa	882	WS	WSM
** 5504	Polynesia	218	Tokelau	772	TK	TKL
** 5504	Polynesia	219	Tonga	776	TO	TON
** 5504	Polynesia	227	Tuvalu	798	TV	TUV
** 5504	Polynesia	242	Wake Island		WK	WAK
** 5504	Polynesia	243	Wallis and Futuna Islands	876	WF	WLF
#delimit ;
    replace rid = 4 if  cid==5   | cid==47 |
                        cid==70  | cid==160|
                        cid==172 | cid==244|
                        cid==218 | cid==219|
                        cid==227 | cid==242|
                        cid==243;
#delimit cr
label var rid "Region ID"
order rid, after(cid)
label define rid_ 1 "caribbean" 2 "melanesia" 3 "micronesia" 4 "polynesia"
label values rid rid_

** SIDS (5803)
** 5803	Small Island Developing States	5	American Samoa
** 5803	Small Island Developing States	258	Anguilla
** 5803	Small Island Developing States	8	Antigua and Barbuda
** 5803	Small Island Developing States	22	Aruba
** 5803	Small Island Developing States	12	Bahamas
** 5803	Small Island Developing States	13	Bahrain
** 5803	Small Island Developing States	14	Barbados
** 5803	Small Island Developing States	23	Belize
** 5803	Small Island Developing States	17	Bermuda
** 5803	Small Island Developing States	239	British Virgin Islands
** 5803	Small Island Developing States	35	Cabo Verde
** 5803	Small Island Developing States	36	Cayman Islands
** 5803	Small Island Developing States	45	Comoros
** 5803	Small Island Developing States	47	Cook Islands
** 5803	Small Island Developing States	49	Cuba
** 5803	Small Island Developing States	279	CuraÃ§ao
** 5803	Small Island Developing States	55	Dominica
** 5803	Small Island Developing States	56	Dominican Republic
** 5803	Small Island Developing States	66	Fiji
** 5803	Small Island Developing States	70	French Polynesia
** 5803	Small Island Developing States	86	Grenada
** 5803	Small Island Developing States	87	Guadeloupe
** 5803	Small Island Developing States	88	Guam
** 5803	Small Island Developing States	175	Guinea-Bissau
** 5803	Small Island Developing States	91	Guyana
** 5803	Small Island Developing States	93	Haiti
** 5803	Small Island Developing States	109	Jamaica
** 5803	Small Island Developing States	83	Kiribati
** 5803	Small Island Developing States	132	Maldives
** 5803	Small Island Developing States	127	Marshall Islands
** 5803	Small Island Developing States	135	Martinique
** 5803	Small Island Developing States	137	Mauritius
** 5803	Small Island Developing States	145	Micronesia (Federated States of)
** 5803	Small Island Developing States	142	Montserrat
** 5803	Small Island Developing States	148	Nauru
** 5803	Small Island Developing States	153	New Caledonia
** 5803	Small Island Developing States	160	Niue
** 5803	Small Island Developing States	163	Northern Mariana Islands
** 5803	Small Island Developing States	180	Palau
** 5803	Small Island Developing States	168	Papua New Guinea
** 5803	Small Island Developing States	177	Puerto Rico
** 5803	Small Island Developing States	188	Saint Kitts and Nevis
** 5803	Small Island Developing States	189	Saint Lucia
** 5803	Small Island Developing States	191	Saint Vincent and the Grenadines
** 5803	Small Island Developing States	244	Samoa
** 5803	Small Island Developing States	193	Sao Tome and Principe
** 5803	Small Island Developing States	196	Seychelles
** 5803	Small Island Developing States	200	Singapore
** 5803	Small Island Developing States	280	Sint Maarten (Dutch Part)
** 5803	Small Island Developing States	25	Solomon Islands
** 5803	Small Island Developing States	207	Suriname
** 5803	Small Island Developing States	176	Timor-Leste
** 5803	Small Island Developing States	219	Tonga
** 5803	Small Island Developing States	220	Trinidad and Tobago
** 5803	Small Island Developing States	224	Turks and Caicos Islands
** 5803	Small Island Developing States	227	Tuvalu
** 5803	Small Island Developing States	240	United States Virgin Islands
** 5803	Small Island Developing States	155	Vanuatu
gen sids = 0
#delimit ;
    replace sids = 1 if  cid==5   | cid==258 |
                        cid==8  | cid==22|
                        cid==12 | cid==13|
                        cid==14 | cid==23|
                        cid==17 | cid==239|
                        cid==35 | cid==36 |
                        cid==45 | cid==47 |
                        cid==49 | cid==279 |
                        cid==55 | cid==56 |
                        cid==66 | cid==70 |
                        cid==86 | cid==87 |
                        cid==88 | cid==175 |
                        cid==91 | cid==93 |
                        cid==109 | cid==83 |
                        cid==132 | cid==127 |
                        cid==135 | cid==137 |
                        cid==145 | cid==142 |
                        cid==148 | cid==153 |
                        cid==160 | cid==163 |
                        cid==180 | cid==168 |
                        cid==177 | cid==188 |
                        cid==189 | cid==191 |
                        cid==244 | cid==193 |
                        cid==196 | cid==200 |
                        cid==280 | cid==25 |
                        cid==207 | cid==176 |
                        cid==219 | cid==220 |
                        cid==224 | cid==227 |
                        cid==240 | cid==155;
#delimit cr
label var sids "Small Island Developing State"
order sids, after(rid)
keep if sids==1 | rid<. | cid==5803 | cid==5502 | cid==5503 | cid==5504 | cid==5206
label data "Country and region population data - from FAOSTAT (Oct-2018)"
save "`datapath'/version01/2-working/population_01", replace

*/

** ------------------------------------------------------------
** FILE 2 - LAND USE
** ------------------------------------------------------------
** Inputs_LandUse_E_All_Data_(Normalized).xlsx
import excel using "`datapath'/version01/1-input/Inputs_LandUse_E_All_Data_(Normalized).xlsx", first

** Keep selected metrics (6601=LandArea, 6602=Agriculture)
keep if ItemCode==6601 | ItemCode==6602
rename ItemCode metric
label var metric "Metric type"
labmask metric, values(Item)
drop Item
order metric

rename AreaCode cid
label var cid "Country ID"
labmask cid, values(Area)
order cid, before(metric)

rename Year year
label var year "Year of metric estimate"
order year, after(metric)

rename Value value
label var value "Metric value"
order value, after(year)
rename Unit unit
order unit, after(value)
drop Element ElementCode YearCode

** Keep selected countries and regions

** Caribbean (5206)
** 5206	Caribbean	258	Anguilla
** 5206	Caribbean	8	Antigua and Barbuda
** 5206	Caribbean	22	Aruba
** 5206	Caribbean	12	Bahamas
** 5206	Caribbean	14	Barbados
** 5206	Caribbean	239	British Virgin Islands
** 5206	Caribbean	36	Cayman Islands
** 5206	Caribbean	49	Cuba
** 5206	Caribbean	279	CuraÃ§ao
** 5206	Caribbean	55	Dominica
** 5206	Caribbean	56	Dominican Republic
** 5206	Caribbean	86	Grenada
** 5206	Caribbean	87	Guadeloupe
** 5206	Caribbean	93	Haiti
** 5206	Caribbean	109	Jamaica
** 5206	Caribbean	135	Martinique
** 5206	Caribbean	142	Montserrat
** 5206	Caribbean	151	Netherlands Antilles (former)
** 5206	Caribbean	177	Puerto Rico
** 5206	Caribbean	188	Saint Kitts and Nevis
** 5206	Caribbean	189	Saint Lucia
** 5206	Caribbean	191	Saint Vincent and the Grenadines
** 5206	Caribbean	281	Saint-Martin (French Part)
** 5206	Caribbean	280	Sint Maarten (Dutch Part)
** 5206	Caribbean	220	Trinidad and Tobago
** 5206	Caribbean	224	Turks and Caicos Islands
** 5206	Caribbean	240	United States Virgin Islands
gen rid = .
#delimit ;
    replace rid = 1 if  cid==258 | cid==8  |
                        cid==22  | cid==12 |
                        cid==14  | cid==239|
                        cid==36  | cid==49 |
                        cid==279 | cid==55 |
                        cid==56  | cid==86 |
                        cid==87  | cid==93 |
                        cid==109 | cid==135|
                        cid==142 | cid==151|
                        cid==177 | cid==188 |
                        cid==189 | cid==191 |
                        cid==281 | cid==280 |
                        cid==220 | cid==224 |
                        cid==240;
#delimit cr
order rid, after(cid)


** MELANESIA (5502)
** 5502	Melanesia	66	Fiji
** 5502	Melanesia	153	New Caledonia
** 5502	Melanesia	168	Papua New Guinea
** 5502	Melanesia	25	Solomon Islands
** 5502	Melanesia	155	Vanuatu
#delimit ;
    replace rid = 2 if  cid==66  | cid==153|
                        cid==168  | cid==25 |
                        cid==155;
#delimit cr

** MICRONESIA (5503)
** 5503	Micronesia	88	Guam
** 5503	Micronesia	83	Kiribati
** 5503	Micronesia	127	Marshall Islands
** 5503	Micronesia	145	Micronesia (Federated States of)
** 5503	Micronesia	148	Nauru
** 5503	Micronesia	163	Northern Mariana Islands
** 5503	Micronesia	164	Pacific Islands Trust Territory
** 5503	Micronesia	180	Palau
#delimit ;
    replace rid = 3 if  cid==88  | cid==83 |
                        cid==127 | cid==145|
                        cid==148 | cid==163|
                        cid==164 | cid==180;
#delimit cr

** POLYNESIA (5504)
** 5504	Polynesia	5	American Samoa	16	AS	ASM
** 5504	Polynesia	47	Cook Islands	184	CK	COK
** 5504	Polynesia	70	French Polynesia	258	PF	PYF
** 5504	Polynesia	160	Niue	570	NU	NIU
** 5504	Polynesia	172	Pitcairn Islands	612	PN	PCN
** 5504	Polynesia	244	Samoa	882	WS	WSM
** 5504	Polynesia	218	Tokelau	772	TK	TKL
** 5504	Polynesia	219	Tonga	776	TO	TON
** 5504	Polynesia	227	Tuvalu	798	TV	TUV
** 5504	Polynesia	242	Wake Island		WK	WAK
** 5504	Polynesia	243	Wallis and Futuna Islands	876	WF	WLF
#delimit ;
    replace rid = 4 if  cid==5   | cid==47 |
                        cid==70  | cid==160|
                        cid==172 | cid==244|
                        cid==218 | cid==219|
                        cid==227 | cid==242|
                        cid==243;
#delimit cr
label var rid "Region ID"
order rid, after(cid)
label define rid_ 1 "caribbean" 2 "melanesia" 3 "micronesia" 4 "polynesia"
label values rid rid_

** SIDS (5803)
** 5803	Small Island Developing States	5	American Samoa
** 5803	Small Island Developing States	258	Anguilla
** 5803	Small Island Developing States	8	Antigua and Barbuda
** 5803	Small Island Developing States	22	Aruba
** 5803	Small Island Developing States	12	Bahamas
** 5803	Small Island Developing States	13	Bahrain
** 5803	Small Island Developing States	14	Barbados
** 5803	Small Island Developing States	23	Belize
** 5803	Small Island Developing States	17	Bermuda
** 5803	Small Island Developing States	239	British Virgin Islands
** 5803	Small Island Developing States	35	Cabo Verde
** 5803	Small Island Developing States	36	Cayman Islands
** 5803	Small Island Developing States	45	Comoros
** 5803	Small Island Developing States	47	Cook Islands
** 5803	Small Island Developing States	49	Cuba
** 5803	Small Island Developing States	279	CuraÃ§ao
** 5803	Small Island Developing States	55	Dominica
** 5803	Small Island Developing States	56	Dominican Republic
** 5803	Small Island Developing States	66	Fiji
** 5803	Small Island Developing States	70	French Polynesia
** 5803	Small Island Developing States	86	Grenada
** 5803	Small Island Developing States	87	Guadeloupe
** 5803	Small Island Developing States	88	Guam
** 5803	Small Island Developing States	175	Guinea-Bissau
** 5803	Small Island Developing States	91	Guyana
** 5803	Small Island Developing States	93	Haiti
** 5803	Small Island Developing States	109	Jamaica
** 5803	Small Island Developing States	83	Kiribati
** 5803	Small Island Developing States	132	Maldives
** 5803	Small Island Developing States	127	Marshall Islands
** 5803	Small Island Developing States	135	Martinique
** 5803	Small Island Developing States	137	Mauritius
** 5803	Small Island Developing States	145	Micronesia (Federated States of)
** 5803	Small Island Developing States	142	Montserrat
** 5803	Small Island Developing States	148	Nauru
** 5803	Small Island Developing States	153	New Caledonia
** 5803	Small Island Developing States	160	Niue
** 5803	Small Island Developing States	163	Northern Mariana Islands
** 5803	Small Island Developing States	180	Palau
** 5803	Small Island Developing States	168	Papua New Guinea
** 5803	Small Island Developing States	177	Puerto Rico
** 5803	Small Island Developing States	188	Saint Kitts and Nevis
** 5803	Small Island Developing States	189	Saint Lucia
** 5803	Small Island Developing States	191	Saint Vincent and the Grenadines
** 5803	Small Island Developing States	244	Samoa
** 5803	Small Island Developing States	193	Sao Tome and Principe
** 5803	Small Island Developing States	196	Seychelles
** 5803	Small Island Developing States	200	Singapore
** 5803	Small Island Developing States	280	Sint Maarten (Dutch Part)
** 5803	Small Island Developing States	25	Solomon Islands
** 5803	Small Island Developing States	207	Suriname
** 5803	Small Island Developing States	176	Timor-Leste
** 5803	Small Island Developing States	219	Tonga
** 5803	Small Island Developing States	220	Trinidad and Tobago
** 5803	Small Island Developing States	224	Turks and Caicos Islands
** 5803	Small Island Developing States	227	Tuvalu
** 5803	Small Island Developing States	240	United States Virgin Islands
** 5803	Small Island Developing States	155	Vanuatu
gen sids = 0
#delimit ;
    replace sids = 1 if  cid==5   | cid==258 |
                        cid==8  | cid==22|
                        cid==12 | cid==13|
                        cid==14 | cid==23|
                        cid==17 | cid==239|
                        cid==35 | cid==36 |
                        cid==45 | cid==47 |
                        cid==49 | cid==279 |
                        cid==55 | cid==56 |
                        cid==66 | cid==70 |
                        cid==86 | cid==87 |
                        cid==88 | cid==175 |
                        cid==91 | cid==93 |
                        cid==109 | cid==83 |
                        cid==132 | cid==127 |
                        cid==135 | cid==137 |
                        cid==145 | cid==142 |
                        cid==148 | cid==153 |
                        cid==160 | cid==163 |
                        cid==180 | cid==168 |
                        cid==177 | cid==188 |
                        cid==189 | cid==191 |
                        cid==244 | cid==193 |
                        cid==196 | cid==200 |
                        cid==280 | cid==25 |
                        cid==207 | cid==176 |
                        cid==219 | cid==220 |
                        cid==224 | cid==227 |
                        cid==240 | cid==155;
#delimit cr
label var sids "Small Island Developing State"
order sids, after(rid)
keep if sids==1 | rid<. | cid==5803 | cid==5502 | cid==5503 | cid==5504 | cid==5206
label data "Country and region land use data - from FAOSTAT (Oct-2018)"
save "`datapath'/version01/2-working/landuse_01", replace
