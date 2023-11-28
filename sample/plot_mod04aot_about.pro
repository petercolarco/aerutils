; Colarco, Sept. 2006
; Plot AOT from model diag files


  sample = ['modis', 'shift_misr', 'shift_subpoint']
  titlestr_ = ['', '(MISR Sampled) ', '(Subpoint Sampled) ']
  str = ['.modis', '.shift_misr', '.shift_subpoint']
  datestr = [ ['20020707','20020707'], $
              ['20020706','20020708'], $
              ['20020705','20020709'], $
              ['20020703','20020711'], $
              ['20020630','20020714'], $
              ['20020622','20020722'], $
              ['20020607','20020807'] $
            ]
  days = [1,3,5,9,15,31,61]

  months = ['January','February','March','April','May','June', $
            'July','August','September','October','November','December']

  regionalmean = fltarr(n_elements(datestr[0,*]),3)

  for idate = 0, n_elements(datestr[0,*])-1 do begin
  for isample = 0, 2 do begin

  datewant=['-9999']
  qawtfile = 'MOD04_L2_ocn.aero_tc8_005.qawt.d.'+sample[isample]+'.ctl'
  qaflfile = 'MOD04_L2_ocn.aero_tc8_005.qafl.d.'+sample[isample]+'.ctl'
  plotstr  = 'MOD04_L2_005.qawt'+str[isample]
  datewant = [datestr[0,idate]+'00',datestr[1,idate]+'21']

  varwant = ['aodtau']
  wantlev = '550'
  wantlat = ['30', '60']
  wantlon = ['-90', '-40']

  mm = strmid(datestr[0,idate],4,2)
  dd = strmid(datestr[0,idate],6,2)
  dstr0 = months[fix(mm)-1]+' '+strcompress(fix(dd),/rem)
  mm = strmid(datestr[1,idate],4,2)
  dd = strmid(datestr[1,idate],6,2)
  dstr1 = months[fix(mm)-1]+' '+strcompress(fix(dd),/rem)

  titleStr = 'MODIS Terra '+titlestr_[isample]+'AOT '+dstr0+' - '+dstr1+', 2002'
  timestr  = datestr[0,idate]+'_'+datestr[1,idate]


  ga_getvar, qaflfile, 'qasum', qasum, lon=lon, lat=lat, lev=lev, time=time, $
                        wanttime=datewant, wantlev=wantlev, $
                        wantlon=wantlon, wantlat=wantlat,/noprint
  a = where(qasum gt 1.e14)
  if(a[0] ne -1) then qasum[a] = !values.f_nan
  nt = n_elements(time)
  nx = n_elements(lon)
  ny = n_elements(lat)

; Get the satellite
  nvars = n_elements(varwant)
  aot = fltarr(nx,ny,nt)
  for ivar = 0, nvars-1 do begin
    ga_getvar, qawtfile, varwant[ivar], varout, lon=lon, lat=lat, $
     wanttime=datewant, wantlev=wantlev, wantlon=wantlon, wantlat=wantlat
    aot = aot + varout
  endfor

; Now average results together
  nx = n_elements(lon)
  ny = n_elements(lat)
  dx = lon[2] - lon[1]
  dy = lat[2] - lat[1]

  a = where(aot gt 1.e14)
  if(a[0] ne -1) then aot[a] = !values.f_nan

; Now do a mean in time
  aot_ = reform(aot,nx*ny,nt)
  qasum_ = reform(qasum,nx*ny,nt)
  a = where(finite(aot_) ne 1)
  qasum_[a] = !values.f_nan
  aot = fltarr(nx,ny)
  for i = 0L, nx*ny-1 do begin
   aot[i] = total(aot_[i,*]*qasum_[i,*],/nan)/total(qasum_[i,*],/nan)
  endfor


;  Now make the plots
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
   plotgrid, aot[*,*], levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, p0lat, p0lon, rot, /noerase, position = [.05,.2,.95,.9], limit=geolimits
   xyouts, .05, .96, titleStr, /normal
   regionalmean[idate,isample] = mean(aot,/nan)
   xyouts, .95, .96, align=1, '<tau> = '+strcompress(string(mean(aot,/nan),format='(f5.3)')), /normal
;   xyouts, .05, .96, titleStr + ' ('+timestr+')', /normal
   map_grid, /box, charsize=.8



   makekey, .05, .1, .9, .025, 0, -.02, color=colorarray, label=labelarray, $
    align=0

   device, /close


  endfor
  endfor

; Plot the results of the regional averaging
   set_plot, 'ps'
   plotstr  = 'MOD04_L2_005.qawt
   device, file='./output/plots/'+plotstr+'.ps', /color, /helvetica, font_size=14, $
           xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
   !p.font=0
   plot, days, regionalmean[*,0], /nodata, $
   xthick=3, xrange=[0,100], xstyle=9, xtitle= 'Days of averaging', $
   ythick=3, yrange=[0,0.5], ystyle=9, ytitle= 'Regional AOT', $
   title = 'Regional AOT versus days of averaging about July 7, 2002'
   loadct, 39
   oplot, days, regionalmean[*,0], thick=9, color=254
   oplot, days, regionalmean[*,1], thick=9, color=176
   oplot, days, regionalmean[*,2], thick=9, color=84
   xyouts, 80, .45, 'MODIS', color=254
   xyouts, 80, .42, 'MISR', color=176
   xyouts, 80, .39, 'Subpoint', color=84
   device, /close


end
