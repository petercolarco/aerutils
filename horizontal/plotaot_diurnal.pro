; Colarco, May 21, 2008
; Plot a 550 nm global AOT, from model or from satellite

   dx = 1.25
   dy = 1.

; Model from monthly mean chem_diag.sfc.inst
  varwant = ['duexttau','ssexttau','ocexttau','bcexttau','suexttau']  ; if from diag
  wantlev = ['-9999']
  ctlfilelnd = 't003_c32.chem_diag.sfc.inst.00Z.200305.hdf'
  ctlfileocn = ctlfilelnd
  titlestr = 'Model (chem_diag.sfc.inst, 00Z, 200305)'
  plotstr = './output/plots/t003_c32.chem_diag.sfc.inst.00Z.200305.ps'


;  varwant = ['duexttau','ssexttau','ocexttau','bcexttau','suexttau']  ; if from diag
;  wantlev = ['-9999']
;  ctlfilelnd = 't003_c32.chem_diag.sfc.inst.06Z.200305.hdf'
;  ctlfileocn = ctlfilelnd
;  titlestr = 'Model (chem_diag.sfc.inst, 06Z, 200305)'
;  plotstr = './output/plots/t003_c32.chem_diag.sfc.inst.06Z.200305.ps'


;  varwant = ['duexttau','ssexttau','ocexttau','bcexttau','suexttau']  ; if from diag
;  wantlev = ['-9999']
;  ctlfilelnd = 't003_c32.chem_diag.sfc.inst.12Z.200305.hdf'
;  ctlfileocn = ctlfilelnd
;  titlestr = 'Model (chem_diag.sfc.inst, 12Z, 200305)'
;  plotstr = './output/plots/t003_c32.chem_diag.sfc.inst.12Z.200305.ps'


;  varwant = ['duexttau','ssexttau','ocexttau','bcexttau','suexttau']  ; if from diag
;  wantlev = ['-9999']
;  ctlfilelnd = 't003_c32.chem_diag.sfc.inst.18Z.200305.hdf'
;  ctlfileocn = ctlfilelnd
;  titlestr = 'Model (chem_diag.sfc.inst, 18Z, 200305)'
;  plotstr = './output/plots/t003_c32.chem_diag.sfc.inst.18Z.200305.ps'



;  ctlfilelnd = '
;  datewant=['200507']
;  ctlfilelnd = 'myd04_lnd.ctl'
;  ctlfileocn = 'myd04_ocn.ctl'
;  ga_getvar, ctlfilelnd, '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint
;  nt = n_elements(time)


; Get the data
; First find the number of times
;  ga_getvar, ctlfilelnd, '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=wanttime,/noprint
;  nt = n_elements(time)

; Next get the land
  ga_getvar, ctlfilelnd, varwant, aotlnd, wantlev=wantlev, $
   time=time, lon=lon, lat=lat, lev=lev, /sum, /template

; Next get the ocean
; To save time, if ctlfilelnd = ctlfileocn then assign same values
  if(ctlfilelnd eq ctlfileocn) then begin
   aotocn = aotlnd
  endif else begin
   ga_getvar, ctlfileocn, varwant, aotocn, wantlev=wantlev, $
    time=time, lon=lon, lat=lat, lev=lev, /sum, /template
  endelse

; Now average the results together
  a = where(aotocn gt 1.e14)
  if(a[0] ne -1) then aotocn[a] = !values.f_nan
  a = where(aotlnd gt 1.e14)
  if(a[0] ne -1) then aotlnd[a] = !values.f_nan
  aot = aotocn
  for i = 0L, n_elements(aot)-1 do begin
   aot[i] = mean([aotlnd[i],aotocn[i]],/nan)
  endfor

; Now make the plots
;  for it = 0, nt-1 do begin

   set_plot, 'ps'
   device, file=plotstr, /color, /helvetica, font_size=14, $
           xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
   !p.font=0


   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, position=[.05,.2,.95,.9], /noborder, limit=[-20,-160,80,160]
   plotgrid, aot, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan,/map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position = [.05,.2,.95,.9], limit=[-20,-160,80,160]
   xyouts, .05, .96, titlestr, /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0

   device, /close

;  endfor



end
