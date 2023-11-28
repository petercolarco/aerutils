;goto, jump
  expid = 'C90c_HTerupV02a'
  print, expid
  filetemplate = expid+'.aer.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[0:407:24]
  nc4readvar, filename, 'so2cmass', so2, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
  expid = 'C90c_HTcntl'
  print, expid
  filetemplate = expid+'.aer.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[0:407:24]
  nc4readvar, filename, 'so2cmass', so2_, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
  nx = 360
  ny = 181
  dx = 1.
  dy = 1.
  area, lon_, lat_, nx, ny, dx, dy, area, grid='one'
  b = where(lat_ ge -40 and lat_ le 10)
  area = area[*,b]
  so2t = fltarr(17)
  for it = 0, 16 do begin
   av = mean(so2[*,*,it*24:it*24+23]-so2_[*,*,it*24:it*24+23],dim=3)
   so2t[it] = total(av*area)/1e9
  endfor
  so2t0 = so2t[0]
;  so2t = so2t-so2t0

; Get the SO2 only run GOCART
  expid = 'C90c_HTerupSO2only'
  print, expid
  filetemplate = expid+'.aer.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[0:407:24]
  nc4readvar, filename, 'so2cmass', so2, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
  nx = 360
   ny = 181
  dx = 1.
  dy = 1.
  area, lon_, lat_, nx, ny, dx, dy, area, grid='one'
  b = where(lat_ ge -40 and lat_ le 10)
  area = area[*,b]
  so2t_ = fltarr(17)
  for it = 0, 16 do begin
   av = mean(so2[*,*,it*24:it*24+23]-so2_[*,*,it*24:it*24+23],dim=3)
   so2t_[it] = total(av*area)/1e9
  endfor
  so2t0_ = so2t_[0]
;  so2t_ = so2t_-so2t0_


;goto, jump
; Get the GMI SO2
  expid = 'C90c_HTerupV02a'
  print, expid
  filetemplate = expid+'.dac_Nv.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[2:50]
  nc4readvar, filename, 'so2', so2g, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
  nc4readvar, filename, 'delp', delp, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
  so2g = total(so2g*delp/9.81*64/29.,3)
  expid = 'C90c_HTcntl'
  print, expid
  filetemplate = expid+'.dac_Nv.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[2:50]
  nc4readvar, filename, 'so2', so2g_, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
  nc4readvar, filename, 'delp', delp, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
  so2g_ = total(so2g_*delp/9.81*64/29.,3)
  so2tg = fltarr(49)
  for it = 0, 48 do begin
   so2tg[it] = total((so2g[*,*,it]-so2g_[*,*,it])*area)/1e9
  endfor

; Get the GMI SO2 - SO2 only run
  expid = 'C90c_HTerupSO2only'
  print, expid
  filetemplate = expid+'.dac_Nv.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[2:50]
  nc4readvar, filename, 'so2', so2g, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
  nc4readvar, filename, 'delp', delp, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
  so2g = total(so2g*delp/9.81*64/29.,3)
  so2tg_ = fltarr(49)
  for it = 0, 48 do begin
   so2tg_[it] = total((so2g[*,*,it]-so2g_[*,*,it])*area)/1e9
  endfor

; Get the GMAO run
;goto, jump2
jump:
  filetemplate = 'G5GMAO.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so2cmass', so2g5, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
  nx = 5760
  ny = 2881
  dx = 0.0625
  dy = 0.0625
  lon_ = -180+findgen(nx)*dx
  lat_ = -90 +findgen(ny)*dy
  area, lon_, lat_, nx, ny, dx, dy, area
  a = where(lat_ ge min(lat) and lat_ le max(lat))
  area = area[*,a]
  a = where(lon_ ge -60.1 and lon_ le 180.)
  area =area[a,*]
  so2tg5 = fltarr(6)
  for it = 0, 5 do begin
   av = mean(so2g5[*,*,it*24:it*24+23],dim=3)
   so2tg5[it] = total(av*area)/1e9-so2t0
  endfor
jump2:
  set_plot, 'ps'
  device, file='so2_load.'+expid+'.ps', $
   /color, /helvetica, font_size=24, $
   xoff=.5, yoff=.5, xsize=24, ysize=20
  !p.font=0

  loadct, 39
  plot, indgen(10), /nodata, xthick=6, ythick=6, $
   xrange=[-1,11], yrange=[11,13.5], xstyle=9, ystyle=9, $
   xticks=12
  oplot, findgen(16)-1, alog(so2t[0:15]*1e6), thick=18, color=84
  plots, findgen(16)-1, alog(so2t[0:15]*1e6), psym=sym(5), color=84, noclip=0
  oplot, findgen(16)-1, alog(so2t_[0:15]*1e6), thick=18, color=84, lin=2
  plots, findgen(16)-1, alog(so2t_[0:15]*1e6), psym=sym(5), color=84, noclip=0
  oplot, findgen(16)-1, alog(so2tg[0:15]*1e6), thick=12, color=144
  oplot, findgen(16)-1, alog(so2tg_[0:15]*1e6), thick=12, color=144, lin=2
  loadct, 0
  oplot, findgen(6)+6, alog(so2tg5*1e6), thick=18, lin=2, color=100
  plots, findgen(6)+6, alog(so2tg5*1e6), psym=sym(5), color=100, noclip=0

; Add the OMI data from Can Li
; Units of tons of SO2, dates start 1/13/22 - 1/25/22
  so2 = [18853.6, 76897.4, 78759.0, 402269.0, 379073.4, $
         337095.0, 286178.2, 258815.4, 213468.0, 177557.1, $
         161287.8, 121095.5, 92094.2]
  x = findgen(13)-2.
  oplot, x[3:12], alog(so2[3:12]), lin=1, thick=18
  plots, x[3:12], alog(so2[3:12]), psym=sym(5), noclip=0

  device, /close

end
