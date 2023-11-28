; Get and read Patricia's files to aggregate PDF of angles

; Get the filenames to probe...
  filen = file_search('/misc/prc19/colarco/OBS/A-CCP/GPM/LevelB','*nc4')

  filen = filen[where(strpos(filen,'M01') ne -1)]

  for ii = 0, n_elements(filen) do begin

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

  a = where(sza_ le 80.)

  lon_  = reform(lon_[a])
  lat_  = reform(lat_[a])
  vza_  = reform(vza_[a])
  sza_  = reform(sza_[a])
  saa_  = reform(saa_[a])
  scat_ = reform(scat_[a])

  if(ii eq 0) then begin
   psza = histogram(sza_,min=0.,max=80.,location=lsza)
   pvza = histogram(vza_,min=0.,max=90., location=lvza)
   psaa = histogram(saa_,min=0.,max=360., location=lsaa)
   psca = histogram(scat_,min=0.,max=180., location=lsca)
  endif else begin
   psza = histogram(sza_,min=0.,max=80.,location=lsza, input=psza)
   pvza = histogram(vza_,min=0.,max=90., location=lvza, input=pvza)
   psaa = histogram(saa_,min=0.,max=360., location=lsaa, input=psaa)
   psca = histogram(scat_,min=0.,max=180., location=lsca, input=psca)
  endelse

  endfor

; Make some plots
  set_plot, 'ps'
  device, file='gpm.jan.pdf.ps', /helvetica, font_size=14, /color, $
   xsize=24, ysize=24
  !p.font=0
  !p.multi=[0,2,2]

  plot, indgen(81), psza*1.d/max(psza), yrange=[0,1.1], ystyle=1, /nodata, $
   xtitle='Solar Zenith Angle', ytitle='Relative Frequency', title='SZA', $
   xrange=[0,80], xstyle=1
  oplot, indgen(81), psza*1.d/max(psza), thick=6

  plot, indgen(91), pvza*1.d/max(pvza), yrange=[0,1.1], ystyle=1, /nodata, $
   xtitle='Viewing Zenith Angle', ytitle='Relative Frequency', title='VZA', $
   xrange=[0,90], xstyle=1
  oplot, indgen(91), pvza*1.d/max(pvza), thick=6

  plot, indgen(361), psaa*1.d/max(psaa), yrange=[0,1.1], ystyle=1, /nodata, $
   xtitle='Solar Azimuth Angle', ytitle='Relative Frequency', title='SAA', $
   xrange=[0,360], xstyle=1
  oplot, indgen(361), psaa*1.d/max(psaa), thick=6

  plot, indgen(181), psca*1.d/max(psca), yrange=[0,1.1], ystyle=1, /nodata, $
   xtitle='Scattering Angle', ytitle='Relative Frequency', title='Scattering Angle', $
   xrange=[0,180], xstyle=1
  oplot, indgen(181), psca*1.d/max(psca), thick=6

  device, /close

end
