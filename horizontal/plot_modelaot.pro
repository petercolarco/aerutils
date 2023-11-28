; Colarco, Sept. 2006
; Plot AOT from model diag files

  datewant=['-9999']
  modisdir = '/output/colarco/tc4/d5_tc4_01/das/tau/Y2007/M07/'
  ctlfilelnd = modisdir + 'd5_tc4_01.inst2d_ext_x.total.noqawt.MYD04_005.lnd.200707.hdf'
  ctlfileocn = modisdir + 'd5_tc4_01.inst2d_ext_x.total.noqawt.MYD04_005.ocn.200707.hdf'

  varwant = ['aodtau']
  wantlev = '550'
  wantlat = ['-60', '80']
  wantlon = ['-180', '180']
  titleStr = 'GEOS-5 AOT July 13 - 31, 2007'
  plotstr  = 'GEOS-5.noqawt'
  timestr  = '20070713_20070731'


  ga_getvar, ctlfilelnd, '', varout, lon=lon, lat=lat, lev=lev, time=time, $
                             wanttime=datewant, wantlev=wantlev, $
                             wantlon=wantlon, wantlat=wantlat,/noprint

  nt = n_elements(time)
  nx = n_elements(lon)
  ny = n_elements(lat)


; Get the satellite
  nvars = n_elements(varwant)
  inp = fltarr(nx,ny,nt)
  for ivar = 0, nvars-1 do begin
    ga_getvar, ctlfilelnd, varwant[ivar], varout, lon=lon, lat=lat, $
     wanttime=datewant, wantlev=wantlev, wantlon=wantlon, wantlat=wantlat
    inp = inp + varout
  endfor
  aot_lnd = inp
  inp = fltarr(nx,ny,nt)
  for ivar = 0, nvars-1 do begin
    ga_getvar, ctlfileocn, varwant[ivar], varout, lon=lon, lat=lat, $
     wanttime=datewant, wantlev=wantlev, wantlon=wantlon, wantlat=wantlat
    inp = inp + varout
  endfor
  aot_ocn = inp

; Now average results together
  nx = n_elements(lon)
  ny = n_elements(lat)
  dx = lon[2] - lon[1]
  dy = lat[2] - lat[1]

  a = where(aot_ocn gt 1.e14)
  if(a[0] ne -1) then aot_ocn[a] = !values.f_nan
  a = where(aot_lnd gt 1.e14)
  if(a[0] ne -1) then aot_lnd[a] = !values.f_nan

  aot = fltarr(nx,ny,nt)
  for i = 0L, nx*ny*nt-1 do begin
   aot[i] = mean([aot_ocn[i],aot_lnd[i]],/nan)
  endfor




; Now make the plots
  for it = 0, nt-1 do begin

;  Some sophistication in the checking
;   if(strlen(datewant[0]) eq 6) then begin
;    timestr = strmid(time[it],0,4)+strmid(time[it],5,2)
;   endif else begin
;    timestr = time[it]
;   endelse
   set_plot, 'ps'
   device, file='./output/plots/'+plotstr+'.'+timestr+'.ps', /color, /helvetica, font_size=14, $
           xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
   !p.font=0


   loadct, 39
   levelArray = [.0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   geolimits = [-90,-180,90,180]
   p0lat = 0.
   p0lon = 180.
   rot = 0.
   if(wantlat[0] ne '-9999') then begin
    geolimits[0] = float(wantlat[0])
    geolimits[2] = float(wantlat[1])
   endif
   if(wantlon[0] ne '-9999') then begin
    geolimits[1] = float(wantlon[0])
    geolimits[3] = float(wantlon[1])
    if(wantlon[0] ge 180 or wantlon[1] gt 180) then p0lon=180.
   endif
p0lon = 0.
   map_set, p0lat, p0lon, rot, position=[.05,.2,.95,.9], /noborder, limit=geolimits
   plotgrid, aot[*,*,it], levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, p0lat, p0lon, rot, /noerase, position = [.05,.2,.95,.9], limit=geolimits
;   xyouts, .05, .96, titleStr + ' ('+timestr+')', /normal
   xyouts, .05, .96, titleStr, /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0

   device, /close


  endfor



end
