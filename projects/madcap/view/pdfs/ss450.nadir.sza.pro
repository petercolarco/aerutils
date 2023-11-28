; Get and read Patricia's files to pluck out the zonal mean
; scattering angles per day, daylight only

; Outputs
  nyo  = 181
  lato = -90.+findgen(nyo)
  szamxo  = make_array(365,nyo,val=!values.f_nan)
  vzamxo  = make_array(365,nyo,val=!values.f_nan)
  scatmxo = make_array(365,nyo,val=!values.f_nan)
  scatmno = make_array(365,nyo,val=!values.f_nan)
  


; Get the filenames to probe...
  iday = 0
  for imm = 1, 12 do begin
   for idd = 1, 31 do begin
    mm = strpad(imm,10)
    dd = strpad(idd,10)
    filen = file_search('/misc/prc19/colarco/OBS/A-CCP/SS450/LevelB/Y2006/M'+mm+'/D'+dd+'/',$
                        '*2006'+mm+dd+'*nc4')
    if(filen[0] ne '') then begin
print, filen
     jj = 0
     for ii = 0, n_elements(filen)-1 do begin

      cdfid = ncdf_open(filen[ii])
       id = ncdf_varid(cdfid,'trjLat')
       ncdf_varget, cdfid, id, lat_
       id = ncdf_varid(cdfid,'sza_ss')
       ncdf_varget, cdfid, id, sza_
       id = ncdf_varid(cdfid,'vza_ss')
       ncdf_varget, cdfid, id, vza_
       id = ncdf_varid(cdfid,'vaa_ss')
       ncdf_varget, cdfid, id, vaa_
       id = ncdf_varid(cdfid,'saa_ss')
       ncdf_varget, cdfid, id, saa_
       id = ncdf_varid(cdfid,'scatAngle_ss')
       ncdf_varget, cdfid, id, scat_
      ncdf_close, cdfid
stop
      ny = n_elements(lat_)
      for iy = 0, ny-1 do begin

;      For every pixel where all views of the pixel have sza < 80
       if(sza_[6,iy] lt 80.) then begin
;       First time this day?
        if(jj eq 0) then begin
         lat  = lat_[iy]
         szamx  = max(sza_[6,iy])
         szamn  = min(sza_[6,iy])
         vzamx  = max(vza_[6,iy])
         vzamn  = min(vza_[6,iy])
         scatmx = max(scat_[6,iy])
         scatmn = min(scat_[6,iy])
         jj = 1
        endif else begin
         lat    = [lat,lat_[iy]]
         scatmx = [scatmx,max(scat_[6,iy])]
         scatmn = [scatmn,min(scat_[6,iy])]
         szamx  = [szamx,max(sza_[6,iy])]
         szamn  = [szamn,min(sza_[6,iy])]
         vzamx  = [vzamx,max(vza_[6,iy])]
         vzamn  = [vzamn,min(vza_[6,iy])]
        endelse
       endif
      endfor
     endfor  ; day files

;    Now collect the scattering angles for the day on the regular grid
     iy = fix(interpol(findgen(nyo),lato,lat)+0.5d)
     scatmx = scatmx[sort(iy)]
     scatmn = scatmn[sort(iy)]
     szamx  = szamx[sort(iy)]
     szamn  = szamn[sort(iy)]
     vzamx  = vzamx[sort(iy)]
     vzamn  = vzamn[sort(iy)]
     lat    = lat[sort(iy)]
     iy     = iy[sort(iy)]
;  plot, indgen(10), /nodata, yrange=[0,200], xrange=[-90,90]
;  plots, lat, scatmx, psym=3
;  plots, lat, szamx, psym=3
;  plots, lat, vzamx, psym=3

     for j = 0, nyo-1 do begin
      a = where(iy eq j)
      if(a[0] ne -1) then begin
       scatmxo[iday,j] = max(scatmx[a])
       scatmno[iday,j] = min(scatmn[a])
       szamxo[iday,j]  = max(szamx[a])
       vzamxo[iday,j]  = max(vzamx[a])
      endif
     endfor
     iday = iday + 1
    endif    ; day exists

   endfor    ; day
  endfor     ; month

; Make a plot
  set_plot, 'ps'
  device, file='ss450.nadir.sza.max=6.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-90,90], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   title='Sunsynchronous, Maximum Solar Zenith Angle', $
   xtitle='Day of Year', ytitle='Latitude', yticks=6
  levels = findgen(10)*8.
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
;  levels = findgen(10)*10.+30.
  colors = 225-findgen(10)*25
  dx = 1.
  dy = 1.
  loadct, 72
  plotgrid, szamxo, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close

; Make a plot
  set_plot, 'ps'
  device, file='ss450.nadir.scat.max=6.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-90,90], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   title='Sunsynchronous, Maximum Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude', yticks=6
  levels = findgen(10)*10.+80.
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = 225-findgen(10)*25
  dx = 1.
  dy = 1.
  loadct, 72
  plotgrid, scatmxo, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close


; Make a plot
  set_plot, 'ps'
  device, file='ss450.nadir.scat.min=6.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-90,90], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   title='Sunsynchronous, Maximum Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude', yticks=6
  levels = findgen(10)*10.+30.
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = 225-findgen(10)*25
  dx = 1.
  dy = 1.
  loadct, 72
  plotgrid, scatmno, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close



; Make a plot
  set_plot, 'ps'
  device, file='ss450.nadir.scat.diff=6.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-90,90], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   title='Sunsynchronous, Range in Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude', yticks=6
  levels = findgen(13)*10.
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = 254-findgen(13)*20
  dx = 1.
  dy = 1.
  loadct, 72
  plotgrid, scatmxo-scatmno, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close

end
