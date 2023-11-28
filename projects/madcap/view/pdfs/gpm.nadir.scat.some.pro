; Get and read Patricia's files to pluck out the zonal mean
; scattering angles per day, daylight only

; Outputs
  nyo  = 181
  lato = -90.+findgen(nyo)
  scatmxo = make_array(365,nyo,val=!values.f_nan)
  scatmno = make_array(365,nyo,val=!values.f_nan)
  


; Get the filenames to probe...
  iday = 0
  for imm = 1, 12 do begin
   for idd = 1, 31 do begin
    mm = strpad(imm,10)
    dd = strpad(idd,10)
    filen = file_search('/misc/prc19/colarco/OBS/A-CCP/GPM/LevelB/Y2006/M'+mm+'/D'+dd+'/',$
                        '*2006'+mm+dd+'*nc4')
    if(filen[0] ne '') then begin
     jj = 0
;     for ii = 0, n_elements(filen)-1 do begin
     for ii = 12,13 do begin
print, filen[ii]

      cdfid = ncdf_open(filen[ii])
       id = ncdf_varid(cdfid,'trjLon')
       ncdf_varget, cdfid, id, lon_
       id = ncdf_varid(cdfid,'trjLat')
       ncdf_varget, cdfid, id, lat_
       id = ncdf_varid(cdfid,'sza_ss')
       ncdf_varget, cdfid, id, sza_
       id = ncdf_varid(cdfid,'scatAngle_ss')
       ncdf_varget, cdfid, id, scat_
      ncdf_close, cdfid

      ny = n_elements(lat_)
      for iy = 0, ny-1 do begin

;      For every pixel where all views of the pixel have sza < 80
       a = where(sza_[*,iy] le 80.)
       if(n_elements(a) eq 10) then begin
;       First time this day?
        if(jj eq 0) then begin
         lon  = lon_[iy]
         lat  = lat_[iy]
         scatmx = max(scat_[*,iy])
         scatmn = min(scat_[*,iy])
         jj = 1
        endif else begin
         lon    = [lon,lon_[iy]]
         lat    = [lat,lat_[iy]]
         scatmx = [scatmx,max(scat_[*,iy])]
         scatmn = [scatmn,min(scat_[*,iy])]
        endelse
       endif
      endfor
     endfor  ; day files

;    Now collect the scattering angles for the day on the regular grid
     iy = fix(interpol(findgen(nyo),lato,lat)+0.5d)
     scatmx = scatmx[sort(iy)]
     scatmn = scatmn[sort(iy)]
     iy     = iy[sort(iy)]
     for j = 0, nyo-1 do begin
      a = where(iy eq j)
      if(a[0] ne -1) then begin
       scatmxo[iday,j] = max(scatmx[a])
       scatmno[iday,j] = min(scatmn[a])
      endif
     endfor
     iday = iday + 1
    endif    ; day exists

   endfor    ; day
  endfor     ; month

; Make a plot
  set_plot, 'ps'
  device, file='gpm.nadir.scat.some=12_13.max.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-90,90], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   title='Precessing, Maximum Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude', yticks=6
  levels = [80,findgen(9)*5+135]
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
;  levels = findgen(10)*10.+30.
  colors = 250-findgen(10)*25
  dx = 1.
  dy = 1.
  loadct, 72
  plotgrid, scatmxo, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close


; Make a plot
  set_plot, 'ps'
  device, file='gpm.nadir.scat.some=12_13.min.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-90,90], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   title='Precessing, Minimum Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude', yticks=6
  levels = findgen(18)*5.+30.
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = 225-findgen(18)*12
  dx = 1.
  dy = 1.
  loadct, 72
  plotgrid, scatmno, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close



; Make a plot
  set_plot, 'ps'
  device, file='gpm.nadir.scat.some=12_13.diff.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-90,90], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   title='Precessing, Range in Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude', yticks=6
  levels = findgen(18)*5.+30.
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = 225-findgen(18)*12
  dx = 1.
  dy = 1.
  loadct, 72
  plotgrid, scatmxo-scatmno, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close

end
