; Colarco, Feb. 2008
; Hovmuller style plot of TOMS AI zonal mean

  model = 'b32dust'

; Get the data (monthly data)
  ga_getvar, model+'.chem_diag.sfc.ctl', 'duexttau', aeridx, wanttime=['197901','200612'], $
             lon=lon, lat=lat, time=time
  ga_getvar, model+'.chem_diag.sfc.ctl', 'ssexttau', ssexttau, wanttime=['197901','200612'], $
             lon=lon, lat=lat, time=time
  ga_getvar, model+'.chem_diag.sfc.ctl', 'oro', oro, wanttime=['197901','200612'], $
             lon=lon, lat=lat, time=time
  aeridx = aeridx+ssexttau
  a = where(oro ne 0)
  aeridx[a] = 1.e15

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
  device, file=model+'.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=30, ysize=12
  !P.font=0

  loadct, 39
  colorarray = 50+20*indgen(10)
  levelarray = .02+indgen(10)*0.02
  x = findgen(nt)+1
  y = lat
  dx = 1.
  dy = 2.

  plot, indgen(nt+1), /nodata, $
   xrange=[0,nt+1], xstyle=9, xthick=3, $
   yrange=[-90,90], ystyle=9, ythick=3, $
   xticks=nyears, xtickv=[0,xtime], xtickname=[' ',xtickn], $
   ytickv=indgen(7)*30-90, yticks=8, $
   position=[.05, .2, .95, .9], $
   ytitle='latitude',  charsize=.65
  plotgrid, aeridx_, levelarray, colorarray, x, y, dx, dy, /map
  makekey, .55, .1, .4, .035, 0, -.025, color=colorarray, $
   label=string(levelarray, format='(f4.2)'), align=0, charsize=.6
  xyouts, .75, .05, 'Model Ocean AOT [550 nm]', /normal, charsize=.6, align=.5
  xyouts, 0, 95, 'GEOS-4 ocean dust+seasalt model (zonal/monthly mean)'
  device, /close

end
