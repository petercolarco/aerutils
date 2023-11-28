; Header information
;  plottitlehead = tag that names output files
;  datewant = two-element array of begin and end YYYYMM
;  ctlfile = n-element array of control file names to read
;  typefile = n-element array of type of each control file (tau, diag, MOD04, etc.)
;  colorarray = n_element array of rainbow pallette colors
;  linarray = n-element linestyle array
;  resolution = n-element array of resolution of each data set (b, c)
;  scolorarray = n_element array of grey pallette background colors for std-dev

draft=0

; MODIS MYD04
  plottitlehead = 'MYD04.b'
  datewant=['200301','200912']
  ctlfile  = ['MYD04_L2_051.mm.qawt.ocn.b.ctl','MYD04_L2_051.mm.qawt3.ocn.b.ctl', $
              'MYD04_L2_051.mm.noqawt.ocn.b.ctl']
;              'MYD04_L2_051.monthly.qawt.ocn.b.ctl','MYD04_L2_051.monthly.qawt3.ocn.b.ctl', $
;              'MYD04_L2_051.monthly.noqawt.ocn.b.ctl']
  typefile = ['MODIS','MODIS','MODIS','MODIS','MODIS','MODIS']
  colortable = 39
  colorarray = [76,254,208,76,254,208]
  linarray = [0,0,0,2,2,2]
  resolution = ['b','b','b','b','b','b']
  scolorarray = [0,0,0,0,0,0]

; Rp_control MYD04
  plottitlehead = 'bR_sulfate'
  datewant=['200801','200812']
  ctlfile  = ['MOD04_l3a.ocn.nnr.ctl','bR_sulfate.MOD04_l3a.ocn.nnr.ctl']
  typefile = ['MODNNR','hwl','MODIS','MODIS','MODIS','MODIS']
  colortable = 39
  colorarray = [76,254,208,76,254,208]
  linarray = [0,0,0,2,2,2]
  resolution = ['b','b','b','b','b','b']
  scolorarray = [0,0,0,0,0,0]
  draft = 1

  ga_getvar, ctlfile[0], '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint
  nt = n_elements(time)

  ytitle = 'AOT [550 nm]'

; Pick regions based on the mask file
  nreg = 11
  ymaxwant = fltarr(nreg)
  maskwant = intarr(nreg)
  lon0want = fltarr(nreg)
  lon1want = fltarr(nreg)
  lat0want = fltarr(nreg)
  lat1want = fltarr(nreg)
  title    = strarr(nreg)
  plottitle= strarr(nreg)

; whole world
  i = 0
  ymaxwant[i] =   1. &  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 360.
  lat0want[i] = -89. &  lat1want[i] = 89.
  title[i] = 'Global (Ocean)'
 
; tropical north atlantic
  i = 1
  ymaxwant[i] =   1. &  maskwant[i] = 0
  lon0want[i] = -50. &  lon1want[i] = 0.
  lat0want[i] =  10. &  lat1want[i] = 30.
  title[i] = 'Tropical North Atlantic'
 
; caribbean
  i = 2
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] = -100. &  lon1want[i] = -50.
  lat0want[i] =   10. &  lat1want[i] = 30.
  title[i] = 'Caribbean'
 
; satlantic
  i = 3
  ymaxwant[i] =   1. &  maskwant[i] = 0
  lon0want[i] = -70. &  lon1want[i] = 20.
  lat0want[i] = -30. &  lat1want[i] = 10.
  title[i] = 'Tropical South Atlantic'
 
   
; natlantic
  i = 4
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =  -80. &  lon1want[i] = 0.
  lat0want[i] =   30. &  lat1want[i] = 60.
  title[i] = 'North Atlantic'
 
; north
  i = 5
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =    0. &  lon1want[i] = 360.
  lat0want[i] =   60. &  lat1want[i] = 89.
  title[i] = 'Northern Ocean'
 
; south
  i = 6
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =    0. &  lon1want[i] = 360.
  lat0want[i] =  -60. &  lat1want[i] = -30.
  title[i] = 'Southern Ocean'
 
; indian
  i = 7
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =   20. &  lon1want[i] = 120.
  lat0want[i] =  -30. &  lat1want[i] = 30.
  title[i] = 'Indian Ocean'
 
; pacific
  i = 8
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =  120. &  lon1want[i] = 250.
  lat0want[i] =  10. &  lat1want[i] = 60.
  title[i] = 'Northern Pacific'
 
; spacific
  i = 9
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =  250. &  lon1want[i] = 290.
  lat0want[i] =  -30. &  lat1want[i] = 10.
  title[i] = 'Southeastern Pacific'
 
; wpacific
  i = 10
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =  120. &  lon1want[i] = 250.
  lat0want[i] =  -30. &  lat1want[i] = 10.
  title[i] = 'Southwestern Pacific'
 
; Indonesia
  i = 10
  ymaxwant[i] =    1. &  maskwant[i] = 0
  lon0want[i] =   90. &  lon1want[i] = 160.
  lat0want[i] =  -20. &  lat1want[i] = 20.
  title[i] = 'Indonesia'
 
   

  plottitle = './output/plots/'+plottitlehead+'.ocn.ps'
  ymaxwant[*] = 0.5
  ymaxwant[1] = 1.
  ymaxwant[10] = 0.3



; Loop over the number of control files
  nctl = n_elements(ctlfile)
  regional_val = fltarr(nt, nreg, nctl)
  regional_std = fltarr(nt, nreg, nctl)
  for ictl = 0, nctl-1 do begin
    doshift = 0  ; if 0, don't shift longitudes
    template = 0
    case typefile[ictl] of
     'tau'   : begin
               var = ['du', 'ss', 'ocphilic', 'ocphobic', 'bcphilic', 'bcphobic', 'so4']
               template = 1
               wantlev=5.5e-7
               end
     'tau_tot': begin
               var = ['aodtau']
               wantlev=5.5e-7
               end
     'hwl'   : begin
               var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', 'suexttau']
               wantlev=-9999
               end
     'diag'  : begin
               var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', 'suexttau']
               wantlev=-9999
               end
     'g5diag': begin
               doshift = 1
               var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', 'suexttau']
               wantlev=-9999
               end
     'MODIS' : begin
               var = ['aodtau']
               wantlev=550.
               end
     'MODNNR': begin
               var = ['tau_']
               wantlev=550.
               end
     'MISR'  : begin
               var = ['aodtau']
               wantlev=550.
               end
    endcase

    spawn, 'echo ${BASEDIRAER}', basedir
    case resolution[ictl] of
     'd' : begin
           nx = 576
           ny = 361
           maskfile = basedir+'/data/d/ARCTAS.region_mask.x576_y361.2008.nc'
           maskvar = 'region_mask'
           end
     'c' : begin
           nx = 288
           ny = 181
           maskfile = basedir+'/data/c/colarco.regions_co.sfc.clm.hdf'
           maskvar = 'COMASK'
           end
     'b' : begin
           nx = 144
           ny = 91
           maskfile = basedir+'/data/b/colarco.regions_co.sfc.clm.hdf'
           maskvar = 'COMASK'
           end
    endcase

;   Read the regional mask
    ga_getvar, maskfile, maskvar, mask, lon=lon, lat=lat

;   possibly shift the result
    if(min(lon) lt 0) then begin
     lon = lon + 180.
     mask = shift(mask,nx/2,0)
    endif

    a = where(mask gt 100)
    if(a[0] ne -1) then mask[a] = 0

    nvars = n_elements(var)
    inp = fltarr(nx,ny,nt)
    date = strarr(nt)
    q = fltarr(nx,ny,nreg)
    print, ctlfile[ictl]
    datewant_ = datewant
    for ivar = 0, nvars-1 do begin
      print, 'Reading var: '+var[ivar]+', '+string(ivar+1)+'/'+string(nvars)
      ga_getvar, ctlfile[ictl], var[ivar], varout, lon=lon, lat=lat, $
       wanttime=datewant_, wantlev=wantlev, template=template
      varout = reform(varout)
      inp = inp + varout
    endfor

;   for MODNNR throw out undef
    if(typefile[ictl] eq 'MODNNR') then begin
     a= where(inp gt 990.)
     if(a[0] ne -1) then inp[a] = !values.f_nan
    endif

;   possibly shift the result
    if(min(lon) lt 0) then begin
     lon = lon + 180.
     inp = shift(inp,nx/2,0,0)
    endif

; Mask on the monthly basis
if(ictl eq 0) then begin
maskmonth = inp
a=where(maskmonth lt 100.)
maskmonth[a] = 1.
a = where(maskmonth ge 100.)
maskmonth[a] = !values.f_nan
endif
if(ictl ge 2) then begin
inp = inp*maskmonth
endif

;   integrate over regions
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
   xsize=20, ysize=10, xoff=.5, yoff=26, /landscape, /color
  !P.font=0

  for ireg = 0, nreg-1 do begin

  print, title[ireg]

  val=reform(regional_val[*,ireg,*])
  std=reform(regional_std[*,ireg,*])
  plot_strip, date, val, ymaxwant[ireg], title[ireg], ytitle, ctlfile, $
              q=q[*,*,ireg], lon=lonsave, lat=latsave, colors=colorarray, $
              thick = thick, colortable=colortable, $
              std=std, scolorarray=scolorarray, $
              linestyle=linarray, draft=draft

  endfor

  device, /close



end


