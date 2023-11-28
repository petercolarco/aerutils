  datewant=['200001','200412']
  ctlfilemod = ['t003_c32.ctl','t003_c32.ctl','t003_c32.MOD04_L2_005.lnd.ctl','t003_c32.MISR.ctl']
  ctlfilesat = ['MOD04_L2_004.lnd.ctl','MOD04_L2_005.lnd.ctl','MOD04_L2_005.lnd.ctl','MISR.ctl']
  plottitlehead = 't003_c32.correlate.'
  ga_getvar, ctlfilemod[0], '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint
  nt = n_elements(time)

  ytitle = 'correlation r'

; Pick regions based on the mask file
  nreg = 11
  ymaxwant = intarr(nreg)
  maskwant = intarr(nreg)
  lon0want = fltarr(nreg)
  lon1want = fltarr(nreg)
  lat0want = fltarr(nreg)
  lat1want = fltarr(nreg)
  title    = strarr(nreg)
  plottitle= strarr(nreg)

; whole world
  i = 0
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 360.
  lat0want[i] = -89. &  lat1want[i] = 89.
  title[i] = 'Whole World'
  plottitle[i] = 'aot.ocn.ps'
 
; tropical atlantic
  i = 1
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] = -50. &  lon1want[i] = 0.
  lat0want[i] =   0. &  lat1want[i] = 40.
  title[i] = 'Tropical North Atlantic'
  plottitle[i] = 'aot_tatl.ocn.ps'
 
; satlantic
  i = 2
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] = -70. &  lon1want[i] = 20.
  lat0want[i] = -60. &  lat1want[i] = 0.
  title[i] = 'South Atlantic'
  plottitle[i] = 'aot_satl.ocn.ps'
 
; caribbean
  i = 3
  ymaxwant[i] =    1  &  maskwant[i] = 0
  lon0want[i] = -100. &  lon1want[i] = -50.
  lat0want[i] =   10. &  lat1want[i] = 30.
  title[i] = 'Caribbean'
  plottitle[i] = 'aot_carib.ocn.ps'
 
   
; natlantic
  i = 4
  ymaxwant[i] =    1  &  maskwant[i] = 0
  lon0want[i] =  -80. &  lon1want[i] = 0.
  lat0want[i] =   30. &  lat1want[i] = 60.
  title[i] = 'North Atlantic'
  plottitle[i] = 'aot_natl.ocn.ps'
 
; north
  i = 5
  ymaxwant[i] =    1  &  maskwant[i] = 0
  lon0want[i] =    0. &  lon1want[i] = 360.
  lat0want[i] =   60. &  lat1want[i] = 89.
  title[i] = 'North'
  plottitle[i] = 'aot_north.ocn.ps'
 
; south
  i = 6
  ymaxwant[i] =    1  &  maskwant[i] = 0
  lon0want[i] =    0. &  lon1want[i] = 360.
  lat0want[i] =  -60. &  lat1want[i] = -30.
  title[i] = 'South'
  plottitle[i] = 'aot_south.ocn.ps'
 
; indian
  i = 7
  ymaxwant[i] =    1  &  maskwant[i] = 0
  lon0want[i] =   20. &  lon1want[i] = 120.
  lat0want[i] =  -30. &  lat1want[i] = 30.
  title[i] = 'Indian'
  plottitle[i] = 'aot_indian.ocn.ps'
 
; pacific
  i = 8
  ymaxwant[i] =    1  &  maskwant[i] = 0
  lon0want[i] =  120. &  lon1want[i] = 250.
  lat0want[i] =  10. &  lat1want[i] = 60.
  title[i] = 'Pacific'
  plottitle[i] = 'aot_pacific.ocn.ps'
 
; spacific
  i = 9
  ymaxwant[i] =    1  &  maskwant[i] = 0
  lon0want[i] =  250. &  lon1want[i] = 290.
  lat0want[i] =  -60. &  lat1want[i] = 10.
  title[i] = 'South Pacific'
  plottitle[i] = 'aot_spacific.ocn.ps'
 
; wpacific
  i = 10
  ymaxwant[i] =    1  &  maskwant[i] = 0
  lon0want[i] =  120. &  lon1want[i] = 250.
  lat0want[i] =  -60. &  lat1want[i] = 10.
  title[i] = 'West Pacific'
  plottitle[i] = 'aot_wpacific.ocn.ps'
 
   

  plottitle = './plots/' + plottitlehead + plottitle
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


