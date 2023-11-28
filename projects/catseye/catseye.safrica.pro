  cdfid = ncdf_open('GEOS5.nc')
   id = ncdf_varid(cdfid,'time')
   ncdf_varget, cdfid, id, time
   id = ncdf_varid(cdfid,'trjLat')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,'trjLon')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid,'TOTEXTTAU')
   ncdf_varget, cdfid, id, aot
   id = ncdf_varid(cdfid,'PLS')
   ncdf_varget, cdfid, id, pls
   id = ncdf_varid(cdfid,'PCU')
   ncdf_varget, cdfid, id, pcu
  ncdf_close, cdfid

; Select on region
; Southern Africa
  a = where(lat lt 0 and lat gt -12 and $
            lon gt 12 and lon lt 24 )

  time = time[a]
  lat  = lat[a]
  lon  = lon[a]
  aot  = aot[a]
  pls  = pls[a]
  pcu  = pcu[a]

; time now in hours (simple)
  time = time/3600

; Now bin things by hour
  nt = 8
  aot_ = fltarr(nt)
  pls_ = fltarr(nt)
  pcu_ = fltarr(nt)
  n    = intarr(nt)

  for i = 0, nt-1 do begin
   a = where(time mod 24 ge i*24/nt and time mod 24 lt ((i+1)*24/nt) )
   if(a[0] ne -1) then begin
    n[i] = n_elements(a)
    aot_[i] = mean(aot[a])
    pls_[i] = mean(pls[a])
    pcu_[i] = mean(pcu[a])
   endif
  endfor

; Make a plot
  set_plot, 'ps'
  device, file='catseye.safrica.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=16
  !p.font=0
  loadct, 39
  x = findgen(nt)*24/nt+24/nt/2.
  plot, x, /nodata, $
        xrange=[0,24], xtitle='Hour [UTC]', xstyle=1, $
        yrange=[0,1], ytitle='AOT', ystyle=9, $
        position=[.15,.4,.9,.95]
  oplot, x, aot_, thick=6
  axis, yaxis=1, yrange=[0,5], ytitle='Precipitation [mm day!E-1!N]', /save
  oplot, x, (pls_+pcu_)*86400, thick=6, color=84
;  oplot, findgen(24), pcu_*86400, thick=6, color=84, lin=2

  plot, x, /nodata, /noerase, $
        xrange=[0,24], xtitle='Hour [UTC]', xstyle=9, $
        yrange=[500,1500], ytitle='Number', ystyle=9, $
        position=[.15,.1,.9,.35], yminor=1
  oplot, x, n, thick=6



  device, /close


end
