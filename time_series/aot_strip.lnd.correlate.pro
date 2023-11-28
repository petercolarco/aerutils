  datewant=['200001','200412']
  ctlfilemod = ['t003_c32.ctl','t003_c32.ctl','t003_c32.MOD04_L2_005.lnd.ctl','t003_c32.MISR.ctl']
  ctlfilesat = ['MOD04_L2_004.lnd.ctl','MOD04_L2_005.lnd.ctl','MOD04_L2_005.lnd.ctl','MISR.ctl']
  plottitlehead = 't003_c32.correlate.'
  ga_getvar, ctlfilemod[0], '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint
  nt = n_elements(time)

; Pick regions based on the mask file
  ymaxwant = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
  ytitle = 'correlation r'
  maskwant = [2,   -2,  1,   1,   1,  1,  -2,  5,  5,  4,  4,  4,  3,  3,  5,  5]
  lon0want = [0,    0,  0,-100,-130,  0,-179,  0,  0,  0,100,  0,  0,-15,-20,  0]
  lon1want = [359,359,359, -10,-100,360, -10,360,360,360,360,100,360, 30, 10,360]
  lat0want = [-89,-89,  0,  23,  28,  0,  50,-30,  0, 45,  0,-89,-89,  0, 10,-10]
  lat1want = [89,  89, 89,  50,  50, 32,  89,  0, 45, 89, 45, 89, 89, 60, 30,  0]

  title = ['South America', 'Whole World', 'North America', $
           'E. NAM', 'W. NAM', 'CENTAM', 'CAN', $
           'South Africa', 'North Africa', 'North Asia', 'South Asia', $
           'Indian Ocean', 'Europe', 'Europe2', 'NAfr2', 'SAfr2']
  plottitle = ['aot_south.lnd.ps', 'aot.lnd.ps', 'aot_nam.lnd.ps', $
               'aot_enam.lnd.ps', 'aot_wnam.lnd.ps', $
               'aot_centam.lnd.ps', $
               'aot_canada.lnd.ps', $
               'aot_safr.lnd.ps', 'aot_nafr.lnd.ps', $
               'aot_nasia.lnd.ps', $
               'aot_sasia.lnd.ps', 'aot_india.lnd.ps', $
               'aot_europe.lnd.ps', $
               'aot_europe2.lnd.ps', 'aot_nafr2.lnd.ps', $
               'aot_safr2.lnd.ps']

  plottitle = './plots/'+plottitlehead+plottitle
  nreg = n_elements(maskwant)

  var = ['du001','du002','du003','du004','du005', $
         'ss001','ss002','ss003','ss004','ss005', $
         'ocphilic', 'ocphobic', 'bcphilic', 'bcphobic', 'so4']

; number of pairs to compute
  np1 = n_elements(ctlfilemod)
  np2 = n_elements(ctlfilesat)
  if(np1 ne np2) then stop
  np = np1

  outvar = fltarr(nt,nreg,np)
  q = fltarr(288,181,nreg)

  for ip = 0, np-1 do begin

; Read in the model
  ga_get_mask, mask, lon, lat, res='c'
  nvars = n_elements(var)
  inp1 = fltarr(288,181,nt)
  inp2 = fltarr(288,181,nt)
  date = strarr(nt)
  for ivar = 0, nvars-1 do begin
    ga_getvar, ctlfilemod[ip], var[ivar], varout, lon=lon, lat=lat, $
     wanttime=datewant, wantlev=5.5e-7
    inp1 = inp1 + varout
  endfor
  for ivar = 0, 0 do begin
    ga_getvar, ctlfilesat[ip], 'aodtau', varout, lon=lon, lat=lat, $
     wanttime=datewant, wantlev=550.
    inp2 = inp2 + varout
  endfor
  for it = 0, nt-1 do begin
   for ireg = 0, nreg-1 do begin
    correlate_region, inp1[*,*,it], inp2[*,*,it], lon, lat, mask, $
                      maskwant[ireg], lon0want[ireg], lon1want[ireg], $
                      lat0want[ireg], lat1want[ireg], intreg,  q=qback
    q[*,*,ireg] = qback
    outvar[it,ireg,ip] = intreg
   endfor
  endfor
  lonsave = lon
  latsave = lat

  endfor

  date = strmid(time,0,4)+strmid(time,5,2)

; all
  for ireg = 0, nreg-1 do begin

  val = reform(outvar[*,ireg,*],nt,np)
  plot_strip, date, val, ymaxwant[ireg], plottitle[ireg], '', ytitle, ctlfilesat, $
              q=q[*,*,ireg], lon=lonsave, lat=latsave

  endfor

end


