; Get and read one of Patricia's files to plot the orbit on a map

; Let's read only the "nadir" portion...
  ix = 498
  iy = 5

; Get the filenames to probe...
  filen = file_search('/misc/prc19/colarco/OBS/A-CCP/SS450/LevelB','*nc4')

  for ii = 0, 23 do begin

  print, filen[ii]

  cdfid = ncdf_open(filen[ii])
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon_, offset=[ix,iy,0], count=[1,1,3600]
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat_, offset=[ix,iy,0], count=[1,1,3600]
  id = ncdf_varid(cdfid,'vza')
  ncdf_varget, cdfid, id, vza_, offset=[ix,iy,0], count=[1,1,3600]
  id = ncdf_varid(cdfid,'sza')
  ncdf_varget, cdfid, id, sza_, offset=[ix,iy,0], count=[1,1,3600]
  id = ncdf_varid(cdfid,'saa')
  ncdf_varget, cdfid, id, saa_, offset=[ix,iy,0], count=[1,1,3600]
  id = ncdf_varid(cdfid,'scatAngle')
  ncdf_varget, cdfid, id, scat_, offset=[ix,iy,0], count=[1,1,3600]
  ncdf_close, cdfid

  a = where(sza_ lt 1e6)

  lon_  = reform(lon_[a])
  lat_  = reform(lat_[a])
  vza_  = reform(vza_[a])
  sza_  = reform(sza_[a])
  saa_  = reform(saa_[a])
  scat_ = reform(scat_[a])

  if(ii eq 0) then begin
   lon  = lon_
   lat  = lat_
   sza  = sza_
   saa  = saa_
   vza  = vza_
   scat = scat_
  endif else begin
   lon  = [lon,lon_]
   lat  = [lat,lat_]
   sza  = [sza,sza_]
   vza  = [vza,vza_]
   saa  = [saa,saa_]
   scat = [scat,scat_]
  endelse

  endfor

; Get the filenames to probe...
  filen = filen[where(strpos(filen,'20060515') ne -1)]
  for ii = 0, 23 do begin

  print, filen[ii]

  cdfid = ncdf_open(filen[ii])
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon_, offset=[ix,iy,0], count=[1,1,3600]
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat_, offset=[ix,iy,0], count=[1,1,3600]
  id = ncdf_varid(cdfid,'vza')
  ncdf_varget, cdfid, id, vza_, offset=[ix,iy,0], count=[1,1,3600]
  id = ncdf_varid(cdfid,'sza')
  ncdf_varget, cdfid, id, sza_, offset=[ix,iy,0], count=[1,1,3600]
  id = ncdf_varid(cdfid,'saa')
  ncdf_varget, cdfid, id, saa_, offset=[ix,iy,0], count=[1,1,3600]
  id = ncdf_varid(cdfid,'scatAngle')
  ncdf_varget, cdfid, id, scat_, offset=[ix,iy,0], count=[1,1,3600]
  ncdf_close, cdfid

  a = where(sza_ lt 1e6)

  lon_  = reform(lon_[a])
  lat_  = reform(lat_[a])
  vza_  = reform(vza_[a])
  sza_  = reform(sza_[a])
  saa_  = reform(saa_[a])
  scat_ = reform(scat_[a])

  if(ii eq 0) then begin
   lon2  = lon_
   lat2  = lat_
   sza2  = sza_
   saa2  = saa_
   vza2  = vza_
   scat2 = scat_
  endif else begin
   lon2  = [lon2,lon_]
   lat2  = [lat2,lat_]
   sza2  = [sza2,sza_]
   vza2  = [vza2,vza_]
   saa2  = [saa2,saa_]
   scat2 = [scat2,scat_]
  endelse

  endfor

; plot the nadir track for the nadir view, and overplot only sunlit
; parts
  set_plot, 'ps'
  device, file='sunsynch.orbit.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=16
  !p.font=0
  map_set, /cont, title='Sun-synchronous Platform, January 1, 2006'
  plots, lon, lat
  a = where(sza lt 90.)
  plots, lon[a], lat[a], psym=4
  device, /close

  device, file='sunsynch.orbit2.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=16, /color
  !p.font=0
  map_set, /cont, title='Sun-synchronous Platform, May 15, 2006'
  plots, lon, lat, color=80
  b = where(sza2 lt 90.)
  plots, lon2[b], lat2[b], psym=4, color=80
  device, /close

  device, file='sunsynch.sza.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=16, /color
  loadct, 39
  !p.font=0
  plot, indgen(100), /nodata, $
   xrange=[0,90], xtitle='SZA', xstyle=1, xticks=9, $
   yrange=[-90,90], ytitle='latitude', ystyle=1, yticks=6, $
   title='Sun-synchronous Platform (sza)'
  plots, sza[a], lat[a], psym=3
  plots, sza2[b], lat2[b], psym=3, color=84
  device, /close

  device, file='sunsynch.vza.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=16, /color
  !p.font=0
  plot, indgen(100), /nodata, $
   xrange=[0,90], xtitle='VZA', xstyle=1, xticks=9, $
   yrange=[-90,90], ytitle='latitude', ystyle=1, yticks=6, $
   title='Sun-synchronous Platform (vza)'
  plots, vza[a], lat[a], psym=3
  plots, vza2[b], lat2[b], psym=3, color=80
  device, /close

  device, file='sunsynch.scat.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=16, /color
  !p.font=0
  plot, indgen(100), /nodata, $
   xrange=[60,180], xtitle='Scattering Angle', xstyle=1, xticks=12, $
   yrange=[-90,90], ytitle='latitude', ystyle=1, yticks=6, $
   title='Sun-synchronous Platform (scat)'
  plots, scat[a], lat[a], psym=3
  plots, scat2[b], lat2[b], psym=3, color=80
  device, /close


end
