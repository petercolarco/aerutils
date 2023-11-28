;goto, jump
  expid = 'C90c_HTerupV02a'
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
  so2t = fltarr(17)
  for it = 0, 16 do begin
   av = mean(so2[*,*,it*24:it*24+23],dim=3)
   so2t[it] = total(av*area)/1e9
  endfor
  so2t0 = so2t[0]
  so2t = so2t-so2t0

; Get the GMI SO2
  filetemplate = expid+'.dac_Nv.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename = filename[2:50]
  nc4readvar, filename, 'so2', so2g, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
  nc4readvar, filename, 'delp', delp, $
   lon=lon, lat=lat, lev=lev, time=time, wantlat=[-40,10]
  so2g = total(so2g*delp/9.81*64/29.,3)
  so2tg = fltarr(49)
  for it = 0, 48 do begin
   so2tg[it] = total((so2g[*,*,it]-so2g[*,*,0])*area)/1e9
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
   /color, /helvetica, font_size=16, $
   xoff=.5, yoff=.5, xsize=24, ysize=20
  !p.font=0

  loadct, 39
  plot, indgen(10), /nodata, thick=3, $
   xrange=[14,31], yrange=[0,.5], xstyle=9, ystyle=9, $
   xticks=17
  oplot, findgen(16)+15, so2t[1:16], thick=12, color=84
  oplot, findgen(16)+15, so2tg[1:16], thick=12, color=144
  loadct, 0
  oplot, 21+findgen(6), so2tg5, thick=12, lin=2, color=100


  device, /close

end
