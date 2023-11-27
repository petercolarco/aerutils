  expid = 'u000_c32_c'
  ctlfile = expid+'.ctl'
  res = 'c'
  yyyy = '2000'
  wanttime = yyyy + ['01', '12']
  nday = 365
  if(yyyy eq '2000' or yyyy eq '2004') then nday = 366

; 1) Dust
  ga_getvar, ctlfile, 'duem001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'duem002', var2, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'duem003', var3, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'duem004', var4, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'duem005', var5, lon=lon, lat=lat, wanttime=wanttime
  duem = var1+var2+var3+var4+var5
  duem25 = var1 + 0.38*var2

  ga_getvar, ctlfile, 'dusd001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dusd002', var2, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dusd003', var3, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dusd004', var4, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dusd005', var5, lon=lon, lat=lat, wanttime=wanttime
  dusd = var1+var2+var3+var4+var5
  dusd25 = var1 + 0.38*var2

  ga_getvar, ctlfile, 'dudp001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dudp002', var2, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dudp003', var3, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dudp004', var4, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dudp005', var5, lon=lon, lat=lat, wanttime=wanttime
  dudp = var1+var2+var3+var4+var5
  dudp25 = var1 + 0.38*var2

  ga_getvar, ctlfile, 'duwt001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'duwt002', var2, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'duwt003', var3, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'duwt004', var4, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'duwt005', var5, lon=lon, lat=lat, wanttime=wanttime
  duwt = var1+var2+var3+var4+var5
  duwt25 = var1 + 0.38*var2

  ga_getvar, ctlfile, 'dusv001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dusv002', var2, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dusv003', var3, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dusv004', var4, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dusv005', var5, lon=lon, lat=lat, wanttime=wanttime
  dusv = var1+var2+var3+var4+var5
  dusv25 = var1 + 0.38*var2

  area, lon, lat, nx, ny, dxx, dyy,area

  duem = total(reform(total(duem,4)/12.) * area) * nday * 86400. / 1.e9
  dusd = total(reform(total(dusd,4)/12.) * area) * nday * 86400. / 1.e9
  dudp = total(reform(total(dudp,4)/12.) * area) * nday * 86400. / 1.e9
  duwt = total(reform(total(duwt,4)/12.) * area) * nday * 86400. / 1.e9
  dusv = total(reform(total(dusv,4)/12.) * area) * nday * 86400. / 1.e9

  duem25 = total(reform(total(duem25,4)/12.) * area) * nday * 86400. / 1.e9
  dusd25 = total(reform(total(dusd25,4)/12.) * area) * nday * 86400. / 1.e9
  dudp25 = total(reform(total(dudp25,4)/12.) * area) * nday * 86400. / 1.e9
  duwt25 = total(reform(total(duwt25,4)/12.) * area) * nday * 86400. / 1.e9
  dusv25 = total(reform(total(dusv25,4)/12.) * area) * nday * 86400. / 1.e9

  ga_getvar, ctlfile, 'ducmass', ducmass, lon=lon, lat=lat, wanttime=wanttime
  ducmass = total(reform(total(ducmass,4)/12.) * area) / 1.e9
  ga_getvar, ctlfile, 'ducm25', ducmass25, lon=lon, lat=lat, wanttime=wanttime
  ducmass25 = total(reform(total(ducmass25,4)/12.) * area) / 1.e9

  dutau = ducmass/(dudp+dusd+duwt+dusv) * nday
  dutau25 = ducmass25/(dudp25+dusd25+duwt25+dusv25) * nday


; 2) sea salt
  ga_getvar, ctlfile, 'ssem001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ssem002', var2, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ssem003', var3, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ssem004', var4, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ssem005', var5, lon=lon, lat=lat, wanttime=wanttime
  ssem = var1+var2+var3+var4+var5
  ssem25 = var1 + var2 + 0.83*var3

  ga_getvar, ctlfile, 'sssd001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sssd002', var2, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sssd003', var3, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sssd004', var4, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sssd005', var5, lon=lon, lat=lat, wanttime=wanttime
  sssd = var1+var2+var3+var4+var5
  sssd25 = var1 + var2 + 0.83*var3

  ga_getvar, ctlfile, 'ssdp001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ssdp002', var2, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ssdp003', var3, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ssdp004', var4, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ssdp005', var5, lon=lon, lat=lat, wanttime=wanttime
  ssdp = var1+var2+var3+var4+var5
  ssdp25 = var1 + var2 + 0.83*var3

  ga_getvar, ctlfile, 'sswt001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sswt002', var2, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sswt003', var3, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sswt004', var4, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sswt005', var5, lon=lon, lat=lat, wanttime=wanttime
  sswt = var1+var2+var3+var4+var5
  sswt25 = var1 + var2 + 0.83*var3

  ga_getvar, ctlfile, 'sssv001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sssv002', var2, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sssv003', var3, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sssv004', var4, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sssv005', var5, lon=lon, lat=lat, wanttime=wanttime
  sssv = var1+var2+var3+var4+var5
  sssv25 = var1 + var2 + 0.83*var3

  ssem = total(reform(total(ssem,4)/12.) * area) * nday * 86400. / 1.e9
  sssd = total(reform(total(sssd,4)/12.) * area) * nday * 86400. / 1.e9
  ssdp = total(reform(total(ssdp,4)/12.) * area) * nday * 86400. / 1.e9
  sswt = total(reform(total(sswt,4)/12.) * area) * nday * 86400. / 1.e9
  sssv = total(reform(total(sssv,4)/12.) * area) * nday * 86400. / 1.e9

  ssem25 = total(reform(total(ssem25,4)/12.) * area) * nday * 86400. / 1.e9
  sssd25 = total(reform(total(sssd25,4)/12.) * area) * nday * 86400. / 1.e9
  ssdp25 = total(reform(total(ssdp25,4)/12.) * area) * nday * 86400. / 1.e9
  sswt25 = total(reform(total(sswt25,4)/12.) * area) * nday * 86400. / 1.e9
  sssv25 = total(reform(total(sssv25,4)/12.) * area) * nday * 86400. / 1.e9

  ga_getvar, ctlfile, 'sscmass', sscmass, lon=lon, lat=lat, wanttime=wanttime
  sscmass = total(reform(total(sscmass,4)/12.) * area) / 1.e9
  ga_getvar, ctlfile, 'sscm25', sscmass25, lon=lon, lat=lat, wanttime=wanttime
  sscmass25 = total(reform(total(sscmass25,4)/12.) * area) / 1.e9

  sstau = sscmass/(ssdp+sssd+sswt+sssv) * nday
  sstau25 = ducmass25/(ssdp25+sssd25+sswt25+sssv25) * nday




; 3) black carbon
  ga_getvar, ctlfile, 'bcem001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'bcem002', var2, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'bcembb', bcembb, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'bcembf', bcembf, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'bceman', bceman, lon=lon, lat=lat, wanttime=wanttime
  bcem = var1+var2

  ga_getvar, ctlfile, 'bcdp001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'bcdp002', var2, lon=lon, lat=lat, wanttime=wanttime
  bcdp = var1+var2

  ga_getvar, ctlfile, 'bcwt002', bcwt, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'bcsv002', bcsv, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'bccmass', bccmass, lon=lon, lat=lat, wanttime=wanttime

  bcem = total(reform(total(bcem,4)/12.) * area) * nday * 86400. / 1.e9
  bcembb = total(reform(total(bcembb,4)/12.) * area) * nday * 86400. / 1.e9
  bcembf = total(reform(total(bcembf,4)/12.) * area) * nday * 86400. / 1.e9
  bceman = total(reform(total(bceman,4)/12.) * area) * nday * 86400. / 1.e9
  bcdp = total(reform(total(bcdp,4)/12.) * area) * nday * 86400. / 1.e9
  bcwt = total(reform(total(bcwt,4)/12.) * area) * nday * 86400. / 1.e9
  bcsv = total(reform(total(bcsv,4)/12.) * area) * nday * 86400. / 1.e9
  bccmass = total(reform(total(bccmass,4)/12.) * area) / 1.e9
  bctau = bccmass / (bcdp+bcwt+bcsv) * nday


; 4) organic carbon
  ga_getvar, ctlfile, 'ocem001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ocem002', var2, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ocembb', ocembb, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ocembf', ocembf, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'oceman', oceman, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ocembg', ocembg, lon=lon, lat=lat, wanttime=wanttime
  ocem = var1+var2

  ga_getvar, ctlfile, 'ocdp001', var1, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ocdp002', var2, lon=lon, lat=lat, wanttime=wanttime
  ocdp = var1+var2

  ga_getvar, ctlfile, 'ocwt002', ocwt, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'ocsv002', ocsv, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'occmass', occmass, lon=lon, lat=lat, wanttime=wanttime

  ocem = total(reform(total(ocem,4)/12.) * area) * nday * 86400. / 1.e9
  ocembb = total(reform(total(ocembb,4)/12.) * area) * nday * 86400. / 1.e9
  ocembf = total(reform(total(ocembf,4)/12.) * area) * nday * 86400. / 1.e9
  oceman = total(reform(total(oceman,4)/12.) * area) * nday * 86400. / 1.e9
  ocembg = total(reform(total(ocembg,4)/12.) * area) * nday * 86400. / 1.e9
  ocdp = total(reform(total(ocdp,4)/12.) * area) * nday * 86400. / 1.e9
  ocwt = total(reform(total(ocwt,4)/12.) * area) * nday * 86400. / 1.e9
  ocsv = total(reform(total(ocsv,4)/12.) * area) * nday * 86400. / 1.e9
  occmass = total(reform(total(occmass,4)/12.) * area) / 1.e9

  octau = occmass / (ocdp+ocwt+ocsv) * nday



; 5) sulfate
  ga_getvar, ctlfile, 'suem001', dmsem, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'suem002', so2em, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'suem003', so4em, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'so4eman', so4eman, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'so2eman', so2eman, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'so2embb', so2embb, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'so2emvn', so2emvn, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'so2emve', so2emve, lon=lon, lat=lat, wanttime=wanttime

  ga_getvar, ctlfile, 'sudp002', so2dp, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'sudp003', so4dp, lon=lon, lat=lat, wanttime=wanttime

  ga_getvar, ctlfile, 'suwt003', so4wt, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'susv003', so4sv, lon=lon, lat=lat, wanttime=wanttime

  ga_getvar, ctlfile, 'supso4g', so4pg, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'supso4aq', so4paq, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'supso4wt', so4pwt, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'supso2', so2pg, lon=lon, lat=lat, wanttime=wanttime

; convert everything to equivalent sulfur mass
  fdms = 32./62.
  fso2 = 32./64.
  fso4 = 32./96.

  dmsem = total(reform(total(dmsem,4)/12.) * area) * nday * 86400. / 1.e9 * fdms
  so2em = total(reform(total(so2em,4)/12.) * area) * nday * 86400. / 1.e9 * fso2
  so4em = total(reform(total(so4em,4)/12.) * area) * nday * 86400. / 1.e9 * fso4
  so4eman = total(reform(total(so4eman,4)/12.) * area) * nday * 86400. / 1.e9 * fso4
  so2eman = total(reform(total(so2eman,4)/12.) * area) * nday * 86400. / 1.e9 * fso2
  so2embb = total(reform(total(so2embb,4)/12.) * area) * nday * 86400. / 1.e9 * fso2
  so2emvn = total(reform(total(so2emvn,4)/12.) * area) * nday * 86400. / 1.e9 * fso2
  so2emve = total(reform(total(so2emve,4)/12.) * area) * nday * 86400. / 1.e9 * fso2

  so2dp = total(reform(total(so2dp,4)/12.) * area) * nday * 86400. / 1.e9 * fso2
  so4dp = total(reform(total(so4dp,4)/12.) * area) * nday * 86400. / 1.e9 * fso4

  so4wt = total(reform(total(so4wt,4)/12.) * area) * nday * 86400. / 1.e9 * fso4
  so4sv = total(reform(total(so4sv,4)/12.) * area) * nday * 86400. / 1.e9 * fso4

  so4pg = total(reform(total(so4pg,4)/12.) * area) * nday * 86400. / 1.e9 * fso4
  so2pg = total(reform(total(so2pg,4)/12.) * area) * nday * 86400. / 1.e9 * fso2
  so4pwt = total(reform(total(so4pwt,4)/12.) * area) * nday * 86400. / 1.e9 * fso4
  so4paq = total(reform(total(so4paq,4)/12.) * area) * nday * 86400. / 1.e9

  ga_getvar, ctlfile, 'so4cmass', so4cm, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'so2cmass', so2cm, lon=lon, lat=lat, wanttime=wanttime
  ga_getvar, ctlfile, 'dmscmass', dmscm, lon=lon, lat=lat, wanttime=wanttime

  so4cm = total(reform(total(so4cm,4)/12.) * area) / 1.e9 * fso4
  so2cm = total(reform(total(so2cm,4)/12.) * area) / 1.e9 * fso2
  dmscm = total(reform(total(dmscm,4)/12.) * area) / 1.e9 * fdms

  so4tau = so4cm / (so4dp + so4wt + so4sv) * nday
  so2tau = so2cm / (so2dp + so4pg + so4pwt + so4paq) * nday
  dmstau = dmscm / (so2pg) * nday

; Print
  openw, lun, './output/tables/summary_table.'+expid+'.'+yyyy+'.txt', /get_lun
  printf, lun, 'DU    ', duem, dusd, dudp, duwt, dusv, ducmass, dutau, format='(a6,7(",",f10.4))'
  printf, lun, 'DU25  ', duem25, dusd25, dudp25, duwt25, dusv25, ducmass25, dutau25, format='(a6,7(",",f10.4))'

  printf, lun, 'SS    ', ssem, sssd, ssdp, sswt, sssv, sscmass, sstau, format='(a6,7(",",f10.4))'
  printf, lun, 'SS25  ', ssem25, sssd25, ssdp25, sswt25, sssv25, sscmass25, sstau25, format='(a6,7(",",f10.4))'

  printf, lun, 'BC    ', bcem, 0., bcdp, bcwt, bcsv, bccmass, bctau, format='(a6,7(",",f10.4))'

  printf, lun, 'OC    ', ocem, 0., ocdp, ocwt, ocsv, occmass, octau, format='(a6,7(",",f10.4))'

  printf, lun, 'SO4   ', so4em, 0., so4dp, so4wt, so4sv, so4cm, so4tau, format='(a6,7(",",f10.4))'
  printf, lun, 'SO2   ', so2em, 0., so4dp, 0., 0., so2cm, so2tau, format='(a6,7(",",f10.4))'
  printf, lun, 'DMS   ', dmsem, 0., 0., 0., 0., dmscm, dmstau, format='(a6,7(",",f10.4))'

  printf, lun, 'BCEMBB', bcembb, format='(a6,(",",f10.4))'
  printf, lun, 'BCEMFF', bceman, format='(a6,(",",f10.4))'
  printf, lun, 'BCEMBF', bcembf, format='(a6,(",",f10.4))'
  printf, lun, 'OCEMBB', ocembb, format='(a6,(",",f10.4))'
  printf, lun, 'OCEMFF', oceman, format='(a6,(",",f10.4))'
  printf, lun, 'OCEMBF', ocembf, format='(a6,(",",f10.4))'
  printf, lun, 'OCEMBG', ocembg, format='(a6,(",",f10.4))'

  printf, lun, 'SO2AN ', so2eman, format='(a6,(",",f10.4))'
  printf, lun, 'SO2BB ', so2embb, format='(a6,(",",f10.4))'
  printf, lun, 'SO2VE ', so2emve, format='(a6,(",",f10.4))'
  printf, lun, 'SO2VN ', so2emvn, format='(a6,(",",f10.4))'
  printf, lun, 'SO4G  ', so4pg, format='(a6,(",",f10.4))'
  printf, lun, 'SO4WT ', so4pwt, format='(a6,(",",f10.4))'
  printf, lun, 'SO4AQ ', so4paq, format='(a6,(",",f10.4))'
  printf, lun, 'SOG   ', so2pg, format='(a6,(",",f10.4))'

  free_lun, lun

end
