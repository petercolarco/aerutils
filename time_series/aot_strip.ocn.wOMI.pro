; Header of output filenames
  plottitlehead = 't003_c32.'

; Date range (monthly mean) you want
  datewant=['200001','200512']

; Template control files for the experiments/datasets to look at.
  ctlfile  = ['OMI.ctl', 'MOD04_L2_005.ocn.ctl', 'MYD04_L2_005.ocn.ctl', 'MISR.ctl', $
              't003_c32.tau.MOD04_L2_005.ocn.ctl']
;  ctlfile  = ['OMI.ctl', 'MOD04_L2_005.ocn.ctl', 'MYD04_L2_005.ocn.ctl', 'MISR.ctl']
  typefile = ['OMI', 'MOD04', 'MYD04', 'MISR', 'tau']
  colorarray = [48, 254, 84, 176, 0]
  linarray   = [2,  0,   0,  0,   0]
  resolution = ['c', 'c', 'c', 'c', 'c']

  ga_getvar, 'MOD04_L2_005.ocn.ctl', '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint
  nt = n_elements(time)

  ytitle = 'AOT [550 nm]'

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
 
   

  plottitle = './output/plots/' + plottitlehead + plottitle




; Loop over the number of control files
  nctl = n_elements(ctlfile)
  regional_val = fltarr(nt, nreg, nctl)
  for ictl = 0, nctl-1 do begin
    case typefile[ictl] of
     'tau'   : begin
               var = ['du001','du002','du003','du004','du005', $
                      'ss001','ss002','ss003','ss004','ss005', $
                      'ocphilic', 'ocphobic', 'bcphilic', 'bcphobic', 'so4']
               wantlev=5.5e-7
               end
     'diag'  : begin
               var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', 'suexttau']
               wantlev=-9999
               end
     'MOD04' : begin
               var = ['aodtau']
               wantlev=550.
               end
     'MYD04' : begin
               var = ['aodtau']
               wantlev=550.
               end
     'MISR'  : begin
               var = ['aodtau']
               wantlev=550.
               end
     'OMI'   : begin
               var = ['aeridx']
               wantlev=-9999
               end
    endcase

    spawn, 'echo ${BASEDIRAER}', basedir
    case resolution[ictl] of
     'c' : begin
           nx = 288
           ny = 181
           maskfile = basedir+'/data/c/colarco.regions_co.sfc.clm.hdf'
           end
     'b' : begin
           nx = 144
           ny = 91
           maskfile = basedir+'/data/b/colarco.regions_co.sfc.clm.hdf'
           end
    endcase

;   Read the regional mask
    ga_getvar, maskfile, 'COMASK', mask, lon=lon, lat=lat
    nvars = n_elements(var)
    inp = fltarr(nx,ny,nt)
    date = strarr(nt)
    q = fltarr(nx,ny,nreg)
    print, ctlfile[ictl]
    datewant_ = datewant
;   Possibly fix datewant for MYD04 data set since it begins less early
    if(typefile[ictl] eq 'MYD04') then begin
     if(datewant[0] lt '200301') then begin
      datewant_[0] = '200301'
      ga_getvar, ctlfile[ictl], '', varout, lon=lon, lat=lat, lev=lev, time=time_, /noprint
      nt_ = n_elements(time_)
      inp = fltarr(nx,ny,nt_)
     endif
    endif

;   Possibly fix datewant for OMI data set since it begins less early
    if(typefile[ictl] eq 'OMI') then begin
     if(datewant[0] lt '200410') then begin
      datewant_[0] = '200410'
      ga_getvar, ctlfile[ictl], '', varout, lon=lon, lat=lat, lev=lev, time=time_, /noprint
      nt_ = n_elements(time_)
      inp = fltarr(nx,ny,nt_)
     endif
    endif

    for ivar = 0, nvars-1 do begin
      print, 'Reading var: '+var[ivar]+', '+string(ivar+1)+'/'+string(nvars)
      ga_getvar, ctlfile[ictl], var[ivar], varout, lon=lon, lat=lat, $
       wanttime=datewant_, wantlev=wantlev
      inp = inp + varout
    endfor

;   If doing the MYD04 dataset, it doesn't begin as early as the MOD04/MISR dataset
;   Check dates, and slap on at end
    if(typefile[ictl] eq 'MYD04' and datewant[0] lt '200301') then begin
     inp_ = make_array(nx,ny,nt,val=1.5e16)
     inp_[*,*,nt-nt_:nt-1] = reform(inp)
     inp = inp_
    endif

;   If doing the OMI dataset, it doesn't begin as early as the MOD04/MISR dataset
;   Check dates, and slap on at end
    if(typefile[ictl] eq 'OMI' and datewant[0] lt '200410') then begin
     inp_ = make_array(nx,ny,nt,val=1.5e16)
     inp_[*,*,nt-nt_:nt-1] = reform(inp)
     inp = inp_
    endif

    for it = 0, nt-1 do begin
     for ireg = 0, nreg-1 do begin
      integrate_region, inp[*,*,it], lon, lat, mask, $
                        maskwant[ireg], lon0want[ireg], lon1want[ireg], $
                        lat0want[ireg], lat1want[ireg], intreg, /avg, q=qback
      q[*,*,ireg] = qback
      regional_val[it,ireg,ictl] = intreg
     endfor
    endfor
    lonsave = lon
    latsave = lat
    date = strmid(time,0,4)+strmid(time,5,2)

  endfor
; all
  for ireg = 0, nreg-1 do begin

  p0lon=0.
  if(lon0want[ireg] gt 180 or lon1want[ireg] gt 180) then p0lon=180.

  val=reform(regional_val[*,ireg,*])
  plot_strip, date, val, ymaxwant[ireg], plottitle[ireg], '', ytitle, ctlfile, $
              q=q[*,*,ireg], lon=lonsave, lat=latsave, colors=colorarray, $
              p0lon=p0lon, linestyle=linarray, typefile=typefile
  plot_strip, date, val, 0.6, plottitle[ireg]+'.red_y', '', ytitle, ctlfile, $
              q=q[*,*,ireg], lon=lonsave, lat=latsave, colors=colorarray, $
              p0lon=p0lon, linestyle=linarray, typefile=typefile
  plot_strip, date, val, 0.5, plottitle[ireg]+'.nomap', '', ytitle, ctlfile, $
              lon=lonsave, lat=latsave, colors=colorarray, linestyle=linarray, $
              typefile=typefile

  endfor


end


