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
  plotfilehead = 't003_c32_regions.diff'
  datewant=['200001','200612']
  ctlfile  = ['t003_c32.tau2d.v2.modis.ctl', $
              't003_c32.tau2d.v2.misr.ctl']
  typefile = ['tau_tot','tau_tot']
  resolution = ['c','c']

  ga_getvar, ctlfile[0], '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint
  nt = n_elements(time)

  plottitle = 'Land regions -- Boreal NA (black), China (blue), Indonesia (red)'
  ytitle = '!MD!3AOT [550 nm]!C(MODIS - SubPoint Sampled GEOS-4)'
  colorarray = [0,60,254]
  linarray = [0,0,0]

; Pick regions based on the mask file
  nreg = 3
  ymaxwant = fltarr(nreg)
  maskwant = intarr(nreg)
  lon0want = fltarr(nreg)
  lon1want = fltarr(nreg)
  lat0want = fltarr(nreg)
  lat1want = fltarr(nreg)
  title    = strarr(nreg)

; boreal (ocean)
  i = 0
  ymaxwant[i] =   1. &  maskwant[i] = 1
  lon0want[i] = 200. &  lon1want[i] = 260.
  lat0want[i] =  50. &  lat1want[i] = 70.
  title[i] = 'Boreal (Ocean)'
 
; china (ocean)
  i = 1
  ymaxwant[i] =   1. &  maskwant[i] = 4
  lon0want[i] =  95. &  lon1want[i] = 125.
  lat0want[i] =  20. &  lat1want[i] = 45.
  title[i] = 'China (Ocean)'
 
; Indonesia (ocean)
  i = 2
  ymaxwant[i] =  0.5 &  maskwant[i] = 4
  lon0want[i] =  95. &  lon1want[i] = 150.
  lat0want[i] = -10. &  lat1want[i] = 5.
  title[i] = 'Indonesia (Ocean)'
 
 
   

  plotfile = './output/plots/'+plotfilehead+'.lnd.ps'



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
    datewant_ = datewant
    for ivar = 0, nvars-1 do begin
      print, 'Reading var: '+var[ivar]+', '+string(ivar+1)+'/'+string(nvars)
      ga_getvar, ctlfile[ictl], var[ivar], varout, lon=lon, lat=lat, $
       wanttime=datewant_, wantlev=wantlev, template=template
      varout = reform(varout)
      inp = inp + varout
    endfor

;   possibly shift the result
    if(min(lon) lt 0) then begin
     lon = lon + 180.
     inp = shift(inp,nx/2,0,0)
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
  device, file=plotfile, font_size=12, /helvetica, $
   xsize=20, ysize=10, xoff=.5, yoff=26, /landscape, /color
  !P.font=0

  val = fltarr(n_elements(date),nreg)
  for ireg = 0, nreg-1 do begin
   val[*,ireg] = regional_val[*,ireg,0] - regional_val[*,ireg,1]
  endfor

  plot_strip, date, val, .3, plottitle, ytitle, title, $
              colors=colorarray, $
              linestyle=linarray, colortable=39, ymin = -.2

  device, /close



end


