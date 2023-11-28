; Get and read one of Patricia's files to plot the orbit on a map

; Let's read only the "nadir" portion...
  ix = 498
  iy = 0

; Get the filenames to probe...
  filen = file_search('/misc/prc19/colarco/OBS/A-CCP/GPM/LevelB','*nc4')

  for ii = 0, 23 do begin

  print, filen[ii]

  cdfid = ncdf_open(filen[ii])
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon_
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat_
  id = ncdf_varid(cdfid,'vza')
  ncdf_varget, cdfid, id, vza_
  id = ncdf_varid(cdfid,'sza')
  ncdf_varget, cdfid, id, sza_
  id = ncdf_varid(cdfid,'saa')
  ncdf_varget, cdfid, id, saa_
  id = ncdf_varid(cdfid,'scatAngle')
  ncdf_varget, cdfid, id, scat_
  ncdf_close, cdfid

; Reduce to swath edges and center
  lon_  = transpose(reform(lon_[ix,[0,5,9],*]))
  lat_  = transpose(reform(lat_[ix,[0,5,9],*]))
  vza_  = transpose(reform(vza_[ix,[0,5,9],*]))
  sza_  = transpose(reform(sza_[ix,[0,5,9],*]))
  saa_  = transpose(reform(saa_[ix,[0,5,9],*]))
  scat_ = transpose(reform(scat_[ix,[0,5,9],*]))

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
  ncdf_varget, cdfid, id, lon_
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat_
  id = ncdf_varid(cdfid,'vza')
  ncdf_varget, cdfid, id, vza_
  id = ncdf_varid(cdfid,'sza')
  ncdf_varget, cdfid, id, sza_
  id = ncdf_varid(cdfid,'saa')
  ncdf_varget, cdfid, id, saa_
  id = ncdf_varid(cdfid,'scatAngle')
  ncdf_varget, cdfid, id, scat_
  ncdf_close, cdfid

; Reduce to swath edges and center
  lon_  = transpose(reform(lon_[ix,[0,5,9],*]))
  lat_  = transpose(reform(lat_[ix,[0,5,9],*]))
  vza_  = transpose(reform(vza_[ix,[0,5,9],*]))
  sza_  = transpose(reform(sza_[ix,[0,5,9],*]))
  saa_  = transpose(reform(saa_[ix,[0,5,9],*]))
  scat_ = transpose(reform(scat_[ix,[0,5,9],*]))

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
  device, file='gpm.orbit.view.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=16
  !p.font=0
  map_set, /cont, title='Precessing Platform, January 1, 2006'
  for j = 0, 2 do begin
   plots, lon[*,j], lat[*,j]
   a = where(sza[*,j] lt 90.)
   plots, lon[a,j], lat[a,j], psym=4
  endfor
  device, /close

  device, file='gpm.orbit2.view.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=16, /color
  !p.font=0
  loadct, 39
  map_set, /cont, title='Precessing Platform, May 15, 2006'
  for j = 0, 2 do begin
   plots, lon2[*,j], lat2[*,j], color=80
   a = where(sza2[*,j] lt 90.)
   plots, lon2[a,j], lat2[a,j], psym=4, color=80
  endfor
  device, /close

  device, file='gpm.sza.view.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=16, /color
  loadct, 39
  !p.font=0
  plot, indgen(100), /nodata, $
   xrange=[0,90], xtitle='SZA', xstyle=1, xticks=9, $
   yrange=[-90,90], ytitle='latitude', ystyle=1, yticks=6, $
   title='Precessing Platform (sza)'
   for j = 0, 2 do begin
    lin=1
    if(j eq 1) then lin = 0
    a = where(sza[*,j] lt 90)
    b = where(sza2[*,j] lt 90)
    plots, sza[a,j], lat[a,j], psym=3
    plots, sza2[b,j], lat2[b,j], psym=3, color=84
   endfor
  device, /close

  device, file='gpm.vza.view.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=16, /color
  loadct, 39
  !p.font=0
  plot, indgen(100), /nodata, $
   xrange=[0,90], xtitle='VZA', xstyle=1, xticks=9, $
   yrange=[-90,90], ytitle='latitude', ystyle=1, yticks=6, $
   title='Precessing Platform (vza)'
   for j = 0, 2 do begin
    lin=1
    if(j eq 1) then lin = 0
    a = where(sza[*,j] lt 90)
    b = where(sza2[*,j] lt 90)
    plots, vza[a,j], lat[a,j], psym=3
    plots, vza2[b,j], lat2[b,j], psym=3, color=84
   endfor
  device, /close

  device, file='gpm.scat.view.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=16, ysize=16, /color
  loadct, 39
  !p.font=0
  plot, indgen(100), /nodata, $
   xrange=[60,180], xtitle='scattering angle', xstyle=1, xticks=9, $
   yrange=[-90,90], ytitle='latitude', ystyle=1, yticks=6, $
   title='Precessing Platform (scat)'
   for j = 0, 2 do begin
    lin=1
    if(j eq 1) then lin = 0
    a = where(sza[*,j] lt 90)
    b = where(sza2[*,j] lt 90)
    plots, scat[a,j], lat[a,j], psym=3
    plots, scat2[b,j], lat2[b,j], psym=3, color=84
   endfor
  device, /close

end
