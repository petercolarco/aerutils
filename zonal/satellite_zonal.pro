; Colarco, Feb. 2008
; Hovmuller style plot of TOMS AI zonal mean

; Get the data (monthly data)
  ga_getvar, 'TOMS.b.ctl', 'aeridx', aeridx, wanttime=['197901','199212'], $
             lon=lon, lat=lat, time=time

; Form the dates for the output
  nyears = 28
  xtime = indgen(nyears)*12+6
  xtickn = string(indgen(nyears)+1979,format='(i4)')

; Find where the longitude is between 240 and 360
  b = where(lon ge 240 and lon lt 360)

; Form a zonal average
  nx = n_elements(lon)
  ny = n_elements(lat)
  nt = n_elements(time)
  aeridx_ = make_array(nt,ny,val=!values.f_nan)
  for iy = 0, ny-1 do begin
   for it = 0, nt -1 do begin
    a = where(aeridx[b,iy,it] lt 1e12)  ; count only non-fill values
    if(a[0] ne -1) then aeridx_[it,iy] = total(aeridx[b[a],iy,it])/n_elements(b[a])
   endfor
  endfor

; Set plot
  set_plot, 'ps'
  device, file='satellite.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=30, ysize=12
  !P.font=0

  loadct, 39
  colorarray = 50+20*indgen(10)
  levelarray = [.1,.2,.3,.4,.5,.6,.8,1.,1.5,2]
  x = findgen(nt)+1
  y = lat
  dx = 1.
  dy = 2.

  plot, indgen(nyears*12+1), /nodata, $
   xrange=[0,nyears*12+1], xstyle=9, xthick=3, $
   yrange=[-90,90], ystyle=9, ythick=3, $
   xticks=nyears, xtickv=[0,xtime], xtickname=[' ',xtickn], $
   ytickv=indgen(7)*30-90, yticks=8, $
   position=[.05, .2, .95, .9], $
   ytitle='latitude', charsize=.65
  xyouts, 0, 95, 'Nimbus-7 TOMS aerosol index (zonal/monthly mean)'
  plotgrid, aeridx_, levelarray, colorarray, x, y, dx, dy, /map
  makekey, .05, .1, .45, .035, 0, -.025, color=colorarray, $
   label=string(levelarray, format='(f3.1)'), align=0, charsize=.6
  xyouts, .275, .05, 'TOMS AI', /normal, charsize=.6, align=.5





; Get the data (monthly data)
  ga_getvar, 'MOD04_L2_005.ocn.ctl', 'aodtau', aeridx, wanttime=['200001','200612'], $
             lon=lon, lat=lat, time=time, wantlev=[550]
  ga_getvar, 'MOD04_L2_005.ocnqa.ctl', 'finerat', finerat, wanttime=['200001','200612'], $
             lon=lon, lat=lat, time=time, wantlev=[550]
  a = where(finerat lt 1.e12)
  aeridx[a] = aeridx[a]*(1.-finerat[a])

; Find where the longitude is between 240 and 360
  b = where(lon ge 240 and lon lt 360)

; Form a zonal average
  nx = n_elements(lon)
  ny = n_elements(lat)
  nt = n_elements(time)
  aeridx_ = make_array(nt,ny,val=!values.f_nan)
  for iy = 0, ny-1 do begin
   for it = 0, nt -1 do begin
    a = where(aeridx[b,iy,it] lt 1e12)  ; count only non-fill values
    if(a[0] ne -1) then aeridx_[it,iy] = total(aeridx[b[a],iy,it])/n_elements(b[a])
   endfor
  endfor

  x = findgen(nt)+252
  y = lat
  dx = 1.
  dy = 1.
  levelarray = .02+indgen(10)*0.02
  plotgrid, aeridx_, levelarray, colorarray, x, y, dx, dy, /map
  makekey, .55, .1, .4, .035, 0, -.025, color=colorarray, $
   label=string(levelarray, format='(f4.2)'), align=0, charsize=.6
  xyouts, .75, .05, 'MODIS Coarse AOT [550 nm]', /normal, charsize=.6, align=.5
  xyouts, 252, 95, 'MODIS Ocean Coarse AOT'

  device, /close

end
