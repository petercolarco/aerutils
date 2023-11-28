; Header information
;  plottitlehead = tag that names output files
;  datewant = two-element array of begin and end YYYYMM
;  ctlfile = n-element array of control file names to read
;  typefile = n-element array of type of each control file (tau, diag, MOD04, etc.)
;  colorarray = n_element array of rainbow pallette colors
;  linarray = n-element linestyle array
;  resolution = n-element array of resolution of each data set (b, c)
;  scolorarray = n_element array of grey pallette background colors for std-dev

; final
  plottitlehead = 'Rp_control.summary'
  datewant=['200301','200312']
  ctlfile  = ['MYD04_L2_051.mm.qawt3.lnd.b.ctl','Rp_control.MYD04_lnd.qawt.ctl']
  typefile = ['MODIS','tau','MODIS','MODIS','MODIS','MODIS']
  colortable = 39
  colorarray = [76,254,208,76,254,208]
  linarray = [0,0,0,2,2,2]
  resolution = ['b','b','b','b','b','b']
  scolorarray = [0,0,0,0,0,0]
  draft = 1

  ga_getvar, ctlfile[0], '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint
  nt = n_elements(time)

; Pick regions based on the mask file
  nreg = 4
  ymaxwant = fltarr(nreg)
  maskwant = intarr(nreg)
  lon0want = fltarr(nreg)
  lon1want = fltarr(nreg)
  lat0want = fltarr(nreg)
  lat1want = fltarr(nreg)
  title    = strarr(nreg)
  plottitle= strarr(nreg)

; whole world
  i = 3
  ymaxwant[i] =   .5 &  maskwant[i] = -2
  lon0want[i] =   0. &  lon1want[i] = 359.
  lat0want[i] = -89. &  lat1want[i] = 89.
  title[i] = 'Global (Land)'

; South America
  i = 2
  ymaxwant[i] =  0.8 &  maskwant[i] = 2
  lon0want[i] =   0. &  lon1want[i] = 359.
  lat0want[i] = -89. &  lat1want[i] = 89.
  title[i] = 'South America'

; Western United States
  i = 1
  ymaxwant[i] =   0.5 &  maskwant[i] = 1
  lon0want[i] = -130. &  lon1want[i] = -100.
  lat0want[i] =   28. &  lat1want[i] = 50.
  title[i] = 'Western United States'

; Southeastern Asia
  i = 0
  ymaxwant[i] =   1.0 &  maskwant[i] = 4
  lon0want[i] =  100. &  lon1want[i] = 360.
  lat0want[i] =   0. &  lat1want[i] = 45.
  title[i] = 'Southeastern Asia'

  plottitle = './output/plots/'+plottitlehead+'.ps'
  nreg = n_elements(maskwant)



; Loop over the number of control files
  nctl = n_elements(ctlfile)
  regional_val = fltarr(nt, nreg, nctl)
  regional_std = fltarr(nt, nreg, nctl)
  for ictl = 0, nctl-1 do begin
    template = 0
    case typefile[ictl] of
     'tau'   : begin
               var = ['du', 'ss', 'ocphilic', 'ocphobic', 'bcphilic', 'bcphobic', 'so4']
               wantlev=5.5e-7
               template = 1
               end
     'tau_tot': begin
               var = ['aodtau']
               wantlev=5.5e-7
               end
     'diag'  : begin
               var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', 'suexttau']
               wantlev=-9999
               end
     'MODIS' : begin
               var = ['aodtau']
               wantlev=550.
               end
     'MISR'  : begin
               var = ['aodtau']
               wantlev=550.
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
    a = where(mask gt 100)
    if(a[0] ne -1) then mask[a] = 0
    nvars = n_elements(var)
    inp = fltarr(nx,ny,nt)
    date = strarr(nt)
    q = fltarr(nx,ny,nreg)
    print, ctlfile[ictl]
    for ivar = 0, nvars-1 do begin
      print, 'Reading var: '+var[ivar]+', '+string(ivar+1)+'/'+string(nvars)
      ga_getvar, ctlfile[ictl], var[ivar], varout, lon=lon, lat=lat, $
       wanttime=datewant, wantlev=wantlev, template=template
      inp = inp + varout
    endfor

;   possibly shift the result
    if(min(lon) lt 0) then begin
     lon = lon + 180.
     inp = shift(inp,nx/2,0,0)
    endif

    for it = 0, nt-1 do begin
     for ireg = 0, nreg-1 do begin
      stdreg = 1.
      integrate_region, inp[*,*,it], lon, lat, mask, $
                        maskwant[ireg], lon0want[ireg], lon1want[ireg], $
                        lat0want[ireg], lat1want[ireg], intreg, /avg, q=qback, std=stdreg
      q[*,*,ireg] = qback
      regional_val[it,ireg,ictl] = intreg
      regional_std[it,ireg,ictl] = stdreg
     endfor
    endfor
    lonsave = lon
    latsave = lat
    date = strmid(time,0,4)+strmid(time,5,2)

  endfor

; Plot
  set_plot, 'ps'
  courier=0
  helvetica=1
  if(draft) then begin
   courier=1
   helvetica=0
  endif
  device, file=plottitle, font_size=12, courier=courier, helvetica=helvetica, $
   xsize=40, ysize=40, xoff=.5, yoff=.5, /color
  !P.font=0

  for ireg = 0, nreg-1 do begin

  print, title[ireg]

  position = [.05,.025+.25*ireg,.475,.25*(ireg+1)-.025]

  val=reform(regional_val[*,ireg,*])
  std=reform(regional_std[*,ireg,*])
  plot_strip, date, val, ymaxwant[ireg], title[ireg], ytitle, ctlfile, $
              q=q[*,*,ireg], lon=lonsave, lat=latsave, colors=colorarray, $
              std=std, scolorarray=scolorarray, thick=thick, draft=draft, $
              linestyle=linarray, position=position, /noerase, colortable=39

  endfor



; Ocean -------------------------------------------------------------------
  datewant=['200301','200312']
  ctlfile  = ['MYD04_L2_051.mm.qawt.ocn.b.ctl','Rp_control.MYD04_ocn.qawt.ctl']
  typefile = ['MODIS','tau','MODIS','MODIS','MODIS','MODIS']
  colortable = 39
  colorarray = [76,254,208,76,254,208]
  linarray = [0,0,0,2,2,2]
  resolution = ['b','b','b','b','b','b']
  scolorarray = [0,0,0,0,0,0]
  draft = 1

  ga_getvar, ctlfile[0], '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint
  nt = n_elements(time)

; Pick regions based on the mask file
  nreg = 4
  ymaxwant = fltarr(nreg)
  maskwant = intarr(nreg)
  lon0want = fltarr(nreg)
  lon1want = fltarr(nreg)
  lat0want = fltarr(nreg)
  lat1want = fltarr(nreg)
  title    = strarr(nreg)
  plottitle= strarr(nreg)

; whole world
  i = 3
  ymaxwant[i] =  0.4 &  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 360.
  lat0want[i] = -89. &  lat1want[i] = 89.
  title[i] = 'Global (Ocean)'

; tropical north atlantic
  i = 2
  ymaxwant[i] =  0.8 &  maskwant[i] = 0
  lon0want[i] = -50. &  lon1want[i] = 0.
  lat0want[i] =  10. &  lat1want[i] = 30.
  title[i] = 'Tropical North Atlantic'

; caribbean
  i = 1
  ymaxwant[i] =   0.5 &  maskwant[i] = 0
  lon0want[i] = -100. &  lon1want[i] = -50.
  lat0want[i] =   10. &  lat1want[i] = 30.
  title[i] = 'Caribbean'

; south
  i = 0
  ymaxwant[i] =   0.5 &  maskwant[i] = 0
  lon0want[i] =    0. &  lon1want[i] = 360.
  lat0want[i] =  -60. &  lat1want[i] = -30.
  title[i] = 'Southern Ocean'

  plottitle = './output/plots/'+plottitlehead+'.lnd.ps'
  nreg = n_elements(maskwant)



; Loop over the number of control files
  nctl = n_elements(ctlfile)
  regional_val = fltarr(nt, nreg, nctl)
  regional_std = fltarr(nt, nreg, nctl)
  for ictl = 0, nctl-1 do begin
    template = 0
    case typefile[ictl] of
     'tau'   : begin
               var = ['du', 'ss', 'ocphilic', 'ocphobic', 'bcphilic', 'bcphobic', 'so4']
               wantlev=5.5e-7
               template = 1
               end
     'tau_tot': begin
               var = ['aodtau']
               wantlev=5.5e-7
               end
     'diag'  : begin
               var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', 'suexttau']
               wantlev=-9999
               end
     'MODIS' : begin
               var = ['aodtau']
               wantlev=550.
               end
     'MISR'  : begin
               var = ['aodtau']
               wantlev=550.
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
    a = where(mask gt 100)
    if(a[0] ne -1) then mask[a] = 0
    nvars = n_elements(var)
    inp = fltarr(nx,ny,nt)
    date = strarr(nt)
    q = fltarr(nx,ny,nreg)
    print, ctlfile[ictl]
    for ivar = 0, nvars-1 do begin
      print, 'Reading var: '+var[ivar]+', '+string(ivar+1)+'/'+string(nvars)
      ga_getvar, ctlfile[ictl], var[ivar], varout, lon=lon, lat=lat, $
       wanttime=datewant, wantlev=wantlev, template=template
      inp = inp + varout
    endfor

;   possibly shift the result
    if(min(lon) lt 0) then begin
     lon = lon + 180.
     inp = shift(inp,nx/2,0,0)
    endif

    for it = 0, nt-1 do begin
     for ireg = 0, nreg-1 do begin
      stdreg = 1.
      integrate_region, inp[*,*,it], lon, lat, mask, $
                        maskwant[ireg], lon0want[ireg], lon1want[ireg], $
                        lat0want[ireg], lat1want[ireg], intreg, /avg, q=qback, std=stdreg
      q[*,*,ireg] = qback
      regional_val[it,ireg,ictl] = intreg
      regional_std[it,ireg,ictl] = stdreg
     endfor
    endfor
    lonsave = lon
    latsave = lat
    date = strmid(time,0,4)+strmid(time,5,2)

  endfor

  for ireg = 0, nreg-1 do begin

  print, title[ireg]

  position = [.55,.025+.25*ireg,.975,.25*(ireg+1)-.025]

  val=reform(regional_val[*,ireg,*])
  std=reform(regional_std[*,ireg,*])
  plot_strip, date, val, ymaxwant[ireg], title[ireg], ytitle, ctlfile, $
              q=q[*,*,ireg], lon=lonsave, lat=latsave, colors=colorarray, $
              std=std, scolorarray=scolorarray, thick=thick, draft=draft, $
              linestyle=linarray, position=position, /noerase, colortable=39

  endfor




  device, /close

end


