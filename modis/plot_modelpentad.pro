; Colarco, October 8, 2008
; Read in a MODIS "ocn" and "lnd" file and merge to plot a monthly mean AOT
  modid = 'd5_arctas_02'
  satid = 'MYD04'
  filehead = '/output/colarco/arctas/d5_arctas_02/ARCTAS_REPLAY/tau/'

  yyyy = '2008'
  jday0 = julday(4,1,yyyy)
  jday1 = julday(7,28,yyyy)

  for jday = jday0, jday1, 5L do begin
   caldat, jday, mm, dd, year
   mm = strcompress(string(mm),/rem)
   if(fix(mm) lt 10) then mm = '0'+mm
   dd = strcompress(string(dd),/rem)
   if(fix(dd) lt 10) then dd = '0'+dd
   caldat, julday(mm,dd,yyyy)+4, mm_, dd_, yyyy_
   dd_   = strcompress(string(dd_),/rem)
   if(fix(dd_) lt 10) then dd_ = '0'+dd_
   mm_   = strcompress(string(mm_),/rem)
   if(fix(mm_) lt 10) then mm_ = '0'+mm_
   yyyy_ = strcompress(string(yyyy_),/rem)


   fileland = filehead+'/Y'+yyyy+'/M'+mm+'/' $
              +modid+'.inst2d_ext_x.total.pentad.qawt.'+satid+'_005.lnd.'+yyyy+mm+dd+'.hdf'
   fileocn  = filehead+'/Y'+yyyy+'/M'+mm+'/' $
              +modid+'.inst2d_ext_x.total.pentad.qawt.'+satid+'_005.ocn.'+yyyy+mm+dd+'.hdf'

; Get the satellite
  ga_getvar, fileland, 'aodtau', aotlnd, lon=lon, lat=lat, time=time, wantlev=550.
  ga_getvar, fileocn,  'aodtau', aotocn, lon=lon, lat=lat, time=time, wantlev=550.

; Now average results together
  a = where(aotocn gt 1.e14)
  aotocn[a] = !values.f_nan
  a = where(aotlnd gt 1.e14)
  aotlnd[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)
  aotsat = fltarr(nx,ny)
  for i = 0L, nx*ny-1 do begin
   aotsat[i] = mean([aotocn[i],aotlnd[i]],/nan)
  endfor


  set_plot, 'ps'
  device, file='./output/plots/'+modid+'_'+satId+'.pentad.aodtau550.'+yyyy+mm+dd+'.ps', $
           /color, /helvetica, font_size=14, $
           xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
  !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   loadct, 39
   levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
   labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
   colorArray = [30,64,80,96,144,176,192,199,208,254,10]

   map_set, 90, -110, 0, position=[.05,.2,.95,.9], /noborder, $
    limit=[40,140,90,360], /stereo, /iso
   plotgrid, aotsat, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan 
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, 90, -110, 0, position=[.05,.2,.95,.9], /noborder, $
    limit=[40,140,90,360], /stereo, /iso, /noerase
   if(satid eq 'MYD04') then satstr = 'Aqua'
   if(satid eq 'MOD04') then satstr = 'Terra'
   titlestr = 'GEOS-5 (MODIS '+satstr+' sampled) AOT [550 nm] (' $
                   +yyyy+'/'+mm+'/'+dd+' - '+yyyy_+'/'+mm_+'/'+dd_+')'
   xyouts, .05, .96, titlestr, /normal
   map_grid, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0

   device, /close


end


end
