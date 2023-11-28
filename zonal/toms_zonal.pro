; Colarco, Feb. 2008
; Hovmuller style plot of TOMS AI zonal mean

; Get the data (monthly data)
  ga_getvar, 'TOMS.b.ctl', 'aeridx', aeridx, wanttime=['197901','199212'], $
             lon=lon, lat=lat, time=time

; Form the dates for the output
  nyears = 14
  xtime = indgen(nyears)*12+6
  xtickn = string(indgen(nyears)+1979,format='(i4)')

; Form a zonal average
  nx = n_elements(lon)
  ny = n_elements(lat)
  nt = n_elements(time)
  aeridx_ = make_array(nt,ny,val=!values.f_nan)
  for iy = 0, ny-1 do begin
   for it = 0, nt -1 do begin
    a = where(aeridx[*,iy,it] lt 1e12)  ; count only non-fill values
    if(a[0] ne -1) then aeridx_[it,iy] = total(aeridx[a,iy,it])/n_elements(a)
   endfor
  endfor

; Set plot
  set_plot, 'ps'
  device, file='tomsai.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=12
  !P.font=0

  loadct, 39
  colorarray = 50+20*indgen(10)
  levelarray = .1+indgen(10)*0.1
  x = findgen(nt)+1
  y = lat
  dx = 1.
  dy = 2.

  plot, indgen(nt+1), /nodata, $
   xrange=[0,nt+1], xstyle=9, xthick=3, $
   yrange=[-90,90], ystyle=9, ythick=3, $
   xticks=nyears, xtickv=[0,xtime], xtickname=[' ',xtickn], $
   ytickv=indgen(7)*30-90, yticks=8, $
   position=[.15, .2, .95, .9], $
   ytitle='latitude', $
   title='Nimbus-7 TOMS aerosol index (zonal/monthly mean)', charsize=.65
  plotgrid, aeridx_, levelarray, colorarray, x, y, dx, dy, /map
  makekey, .15, .1, .8, .035, 0, -.025, color=colorarray, $
   label=string(levelarray, format='(f3.1)'), align=0, charsize=.6
  xyouts, .55, .05, 'TOMS AI', /normal, charsize=.6, align=.5

  device, /close

end
