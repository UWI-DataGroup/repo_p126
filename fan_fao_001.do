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

** Europe
** 3 Albania
** 6 Andorra
** 11 Austria
** 57 Belarus
** 255 Belgium
** 80 Bosnia and Herzegovina
** 27 Bulgaria
** 98 Croatia
** 167 Czech Republic
** 54 Denmark
** 63 Estonia
** 67 Finland
** 68 France
** 84 Greece
** 79 Germany
** 97 Hungary
** 99 Iceland
** 104 Ireland
** 106 Italy
** 119 Latvia
** 126 Lithuania
** 256 Luxembourg
** 134 Malta
** xxx Monaco
** 273 Montenegro
** 150 Netherlands
** 162 Norway
** 173 Poland
** 174 Portugal
** 146 Republic of Moldova
** 183 Romania
** 185 Russian Federation
** 192 San Marino
** 272 Serbia
** 199 Slovakia
** 198 Slovenia
** 210 Sweden
** 203 Spain
** 211 Switzerland
** 154 The former Yugoslav Republic of Macedonia
** 230 Ukraine
** 229 United Kingdom
gen europe = 0
#delimit ;
    replace europe = 1 if cid==3 | cid==6 | cid==11 | cid==57 |
                          cid==255 | cid==80 | cid==27 | cid==98 |
                          cid==167 | cid==54 | cid==63 | cid==67 |
                          cid==68 | cid==79 | cid==84 | cid==97 |
                          cid==99 | cid==104 | cid==106 | cid==119 |
                          cid==126 | cid==256 | cid==134 | cid==273 |
                          cid==150 | cid==162 | cid==173 | cid==174 |
                          cid==146 | cid==183 | cid==185 | cid==192 |
                          cid==272 | cid==199 | cid==198 | cid==203 |
                          cid==210 | cid==211 | cid==154 | cid==230 |
                          cid==229;
 #delimit cr
 label var europe "Europe"

order sids, after(rid)
order europe, after(sids)
keep if europe==1 | sids==1 | rid<. | cid==5803 | cid==5502 | cid==5503 | cid==5504 | cid==5206 | cid==5400
label data "Country and region land use data - from FAOSTAT (Oct-2018)"
save "`datapath'/version01/2-working/landuse_01", replace


** ------------------------------------------------------------
** FULL FAO DATASET - NOT USED
** FILE 3 - PEOPLE WORKING IN AGRICULTURE
** For now, we look at Labour force surveys AND Employment in Agriculture
** ------------------------------------------------------------
** Employment_Indicators_E_All_Data_(Norm).xlsx
import excel using "`datapath'/version01/1-input/Employment_Indicators_E_All_Data_(Norm).xlsx", first

** Source - Labour Force surveys
keep if SourceCode==3023
drop SourceCode Source

** Keep Employment in Agriculture
keep if IndicatorCode==21066
drop IndicatorCode

rename CountryCode cid
label var cid "Country ID"
labmask cid, values(Country)
order cid

rename Year year
label var year "Year of metric estimate"
order year, after(cid)

rename Value value
label var value "Metric value"
order value, after(year)
rename Unit unit
order unit, after(value)
drop YearCode Indicator

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

** Europe
** 3 Albania
** 6 Andorra
** 11 Austria
** 57 Belarus
** 255 Belgium
** 80 Bosnia and Herzegovina
** 27 Bulgaria
** 98 Croatia
** 167 Czech Republic
** 54 Denmark
** 63 Estonia
** 67 Finland
** 68 France
** 84 Greece
** 79 Germany
** 97 Hungary
** 99 Iceland
** 104 Ireland
** 106 Italy
** 119 Latvia
** 126 Lithuania
** 256 Luxembourg
** 134 Malta
** xxx Monaco
** 273 Montenegro
** 150 Netherlands
** 162 Norway
** 173 Poland
** 174 Portugal
** 146 Republic of Moldova
** 183 Romania
** 185 Russian Federation
** 192 San Marino
** 272 Serbia
** 199 Slovakia
** 198 Slovenia
** 210 Sweden
** 203 Spain
** 211 Switzerland
** 154 The former Yugoslav Republic of Macedonia
** 230 Ukraine
** 229 United Kingdom
gen europe = 0
#delimit ;
    replace europe = 1 if cid==3 | cid==6 | cid==11 | cid==57 |
                          cid==255 | cid==80 | cid==27 | cid==98 |
                          cid==167 | cid==54 | cid==63 | cid==67 |
                          cid==68 | cid==79 | cid==84 | cid==97 |
                          cid==99 | cid==104 | cid==106 | cid==119 |
                          cid==126 | cid==256 | cid==134 | cid==273 |
                          cid==150 | cid==162 | cid==173 | cid==174 |
                          cid==146 | cid==183 | cid==185 | cid==192 |
                          cid==272 | cid==199 | cid==198 | cid==203 |
                          cid==210 | cid==211 | cid==154 | cid==230 |
                          cid==229;
 #delimit cr
 label var europe "Europe"

order sids, after(rid)
order europe, after(sids)
keep if europe==1 | sids==1 | rid<. | cid==5803 | cid==5502 | cid==5503 | cid==5504 | cid==5206 | cid==5400
label data "People in agriculture data - from FAOSTAT (Oct-2018)"
save "`datapath'/version01/2-working/humanresources_01", replace




** ------------------------------------------------------------
** PARTIAL FAO DATASETS - NOT USED
** FILE 3 - PEOPLE WORKING IN AGRICULTURE
** We look at Labour force surveys AND Employment in Agriculture
** ------------------------------------------------------------

** OCEANIA
insheet using "`datapath'/version01/1-input/Employment_Indicators_E_Oceania_1.csv", names comma
** Keep Labour Force Surveys
** keep if sourcecode==3023
** Keep Employment in Agriculture
** keep if indicatorcode==21066
** Drop Australia and New Zealand
drop if countrycode==10 | countrycode==156
** Number of Oceania Countries = 14
tab country
drop *f
drop y1952-y1989
reshape long y, i(countrycode) j(year)
count if y<.
gen TOT = _N
gen a1 = 0
replace a1 = 1 if y<.
egen a2 = sum(a1)
gen pavail = (a2/TOT)*100

** CARIBBEAN
insheet using "`datapath'/version01/1-input/Employment_Indicators_E_Americas_1.csv", names comma clear
** Keep Labour Force Surveys
** keep if sourcecode==3023
** Keep Employment in Agriculture
** keep if indicatorcode==21066
** Drop Australia and New Zealand
drop if countrycode==9 | countrycode==19 |countrycode==21 |countrycode==33 |        ///
        countrycode==40 |countrycode==44 |countrycode==48 |countrycode==58 |        ///
        countrycode==60 |countrycode==65 |countrycode==85 |countrycode==89 |        ///
        countrycode==95 |countrycode==138 |countrycode==157 |countrycode==166 |     ///
        countrycode==69 |countrycode==170 |countrycode==231 |countrycode==234 |     ///
        countrycode==236|countrycode==169
** Number of CARIBBEAN Countries = XX
tab country
drop *f
drop y1952-y1989
reshape long y, i(countrycode) j(year)
count if y<.
gen TOT = _N
gen a1 = 0
replace a1 = 1 if y<.
egen a2 = sum(a1)
gen pavail = (a2/TOT)*100


** EUROPE
insheet using "`datapath'/version01/1-input/Employment_Indicators_E_Europe_1.csv", names comma clear
** Keep Labour Force Surveys
** keep if sourcecode==3023
** Keep Employment in Agriculture
** keep if indicatorcode==21066
** Number of CARIBBEAN Countries = XX
tab country
drop *f
drop y1952-y1989
reshape long y, i(countrycode) j(year)
count if y<.
gen TOT = _N
gen a1 = 0
replace a1 = 1 if y<.
egen a2 = sum(a1)
gen pavail = (a2/TOT)*100


** ------------------------------------------------------------
** WORLD BANK MODELLED DATA - USED
** FILE 3 - PEOPLE WORKING IN AGRICULTURE
** ------------------------------------------------------------
tempfile t1 t2 t3
import excel using "`datapath'/version01/1-input/API_SL.AGR.EMPL.ZS_DS2_en_excel_v2_10181286 hambleton.xls", clear first sheet("Data") cellrange(A4:BK268)
drop F-AJ
rename AK y1991
rename AL y1992
rename AM y1993
rename AN y1994
rename AO y1995
rename AP y1996
rename AQ y1997
rename AR y1998
rename AS y1999
rename AT y2000
rename AU y2001
rename AV y2002
rename AW y2003
rename AX y2004
rename AY y2005
rename AZ y2006
rename BA y2007
rename BB y2008
rename BC y2009
rename BD y2010
rename BE y2011
rename BF y2012
rename BG y2013
rename BH y2014
rename BI y2015
rename BJ y2016
rename BK y2017
save `t1', replace

import excel using "`datapath'/version01/1-input/API_SL.AGR.EMPL.ZS_DS2_en_excel_v2_10181286.xls", clear first sheet("Metadata - Countries") cellrange(A1:B264)
save `t2', replace

merge 1:1 CountryCode using `t1'
keep if subregion<.
save "`datapath'/version01/2-working/landuse_modelled_01", replace


*/

** ------------------------------------------------------------
** FAO DATASETS
** FILE 4 -
** We look at Labour force surveys AND Employment in Agriculture
** ------------------------------------------------------------

** OCEANIA
insheet using "`datapath'/version01/1-input/Employment_Indicators_E_Oceania_1.csv", names comma
