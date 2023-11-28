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
            lon gt 12 and lon lt 24 and $
            time gt (31+31)*24.*3600)     ; after Sep. 1

  time = time[a]
  lat  = lat[a]
  lon  = lon[a]
  aot  = aot[a]
  pls  = pls[a]
  pcu  = pcu[a]

; time now in hours (simple)
  time = time/3600

; Get the perfect sampled results
  expctl = 'inst2d_hwl_x.ddf'
  ga_times, expctl, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
; pick off first period
  nymd = nymd[where(nymd gt 20080831)]
  nhms = nhms[where(nymd gt 20080831)]
  filename = strtemplate(parsectl_dset(expctl),nymd,nhms)
  nc4readvar, filename, 'totexttau', tau, lon=lon_, lat=lat_, time=time_, $
              wantlat=[-12,0], wantlon=[12,24]
  nc4readvar, filename, ['pls','pcu'], precip, lon=lon_, lat=lat_, time=time_, $
              wantlat=[-12,0], wantlon=[12,24], /sum
  area, lon_, lat_, nx, ny, dx, dy, area, grid='d'
  a = where(lon_ ge 12 and lon_ le 24)
  b = where(lat_ ge -12 and lat_ le 0)
  area_ = area[a,*]
  area_ = area_[*,b]
  nt = n_elements(time_)
  tau_ = fltarr(nt)
  precip_ = fltarr(nt)
  for it = 0, nt-1 do begin
   tau_[it] = total(tau[*,*,it]*area_)/total(area_)
   precip_[it] = total(precip[*,*,it]*area_)/total(area_)*86400.  ; mm day-1
  endfor
  time_ = findgen(nt)

; Now bin things by hour
  nt = 8
  aot_ = fltarr(nt)
  pls_ = fltarr(nt)
  pcu_ = fltarr(nt)
  n    = intarr(nt)
  tau__ = fltarr(nt)
  precip__ = fltarr(nt)

  for i = 0, nt-1 do begin
   a = where(time mod 24 ge i*24/nt and time mod 24 lt ((i+1)*24/nt) )
   if(a[0] ne -1) then begin
    n[i] = n_elements(a)
    aot_[i] = mean(aot[a])
    pls_[i] = mean(pls[a])
    pcu_[i] = mean(pcu[a])
   endif
   a = where(time_ mod 24 ge i*24/nt and time_ mod 24 lt ((i+1)*24/nt) )
   if(a[0] ne -1) then begin
    tau__[i] = mean(tau_[a])
    precip__[i] = mean(precip_[a])
   endif
  endfor

; Make a plot
  set_plot, 'ps'
  device, file='catseye.safrica.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=16
  !p.font=0
  loadct, 0
  x = findgen(nt)*24/nt+24/nt/2.
  xmax = .6
  plot, x, /nodata, $
        xrange=[0,24], xtitle='Hour [UTC]', xstyle=1, $
        yrange=[0,xmax], ytitle='AOT', ystyle=9, $
        position=[.15,.4,.9,.95]
  oplot, x, aot_, thick=6
  oplot, x, tau__, thick=6, lin=2
  xyouts, 1.5, .92*xmax, 'AOT'
  plots, [9,11], .93*xmax, thick=6
  plots, [9,11], .86*xmax, thick=6, lin=2
  xyouts, 11.5, .92*xmax, 'Sampled along ISS track'
  xyouts, 11.5, .85*xmax, 'Full sampling'
  loadct, 39
  xyouts, 1.5, .85*xmax, 'Precipitation', color=84
  axis, yaxis=1, yrange=[0,5], ytitle='Precipitation [mm day!E-1!N]', /save
  oplot, x, (pls_+pcu_)*86400, thick=6, color=84
  oplot, x, precip__, thick=6, lin=2, color=84
;  oplot, findgen(24), pcu_*86400, thick=6, color=84, lin=2

  plot, x, /nodata, /noerase, $
        xrange=[0,24], xtitle='Hour [UTC]', xstyle=9, $
        yrange=[1500,2500], ytitle='Number', ystyle=9, $
        position=[.15,.1,.9,.35], yminor=1
  oplot, x, n, thick=6



  device, /close


end
