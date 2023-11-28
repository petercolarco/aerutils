; Get and read Patricia's files to pluck out the zonal mean
; scattering angles per day, daylight only

; Here sort on local time

; Outputs
  nyo  = 181
  lato = -90.+findgen(nyo)
  scatmxo = make_array(365,nyo,val=!values.f_nan)
  scatmno = make_array(365,nyo,val=!values.f_nan)
  scatmxlhr = make_array(365,nyo,val=!values.f_nan)
  scatmxlhr155 = make_array(365,nyo,val=!values.f_nan)
  scatmnlhr = make_array(365,nyo,val=!values.f_nan)
  


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
     for ii = 0,1 do begin
print, filen[ii]

;     get offset hour from the filename
      it = fix(strmid(filen[ii],8,2,/reverse))

      cdfid = ncdf_open(filen[ii])
       id = ncdf_varid(cdfid,'trjLat')
       ncdf_varget, cdfid, id, lat_
       id = ncdf_varid(cdfid,'trjLon')
       ncdf_varget, cdfid, id, lon_
       id = ncdf_varid(cdfid,'time')
       ncdf_varget, cdfid, id, time_
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
         lat  = lat_[iy]
         lon  = lon_[iy]
         time = it+time_[iy]/3600.
         scatmx = max(scat_[*,iy])
         scatmn = min(scat_[*,iy])
         jj = 1
        endif else begin
         lat    = [lat,lat_[iy]]
         lon    = [lon,lon_[iy]]
         time   = [time,it+time_[iy]/3600.]
         scatmx = [scatmx,max(scat_[*,iy])]
         scatmn = [scatmn,min(scat_[*,iy])]
        endelse
       endif
      endfor
     endfor  ; day files

;    Turn the time into the local hour (integer)
     lhrs = (lon/15)   ; every 15 degrees is 1 hour, what is offset?
     ilhrs = lhrs + time
     a = where(ilhrs lt 0)
     ilhrs[a] = fix(ilhrs[a]-.5)  ; bunch it as integer hours to offset
     a = where(lhrs ge 0)
     ilhrs[a] = fix(ilhrs[a]+.5)
     lhr      = fix(ilhrs)
     a = where(lhr lt 0)
     if(a[0] ne -1) then lhr[a] = lhr[a]+24
     a = where(lhr gt 23)
     if(a[0] ne -1) then lhr[a] = lhr[a]-24

;    Now collect the scattering angles for the day on the regular grid
     iy = fix(interpol(findgen(nyo),lato,lat)+0.5d)
     scatmx = scatmx[sort(iy)]
     scatmn = scatmn[sort(iy)]
     lhr    = lhr[sort(iy)]
     iy     = iy[sort(iy)]
     for j = 0, nyo-1 do begin
      a = where(iy eq j)
      if(a[0] ne -1) then begin
       b = where(scatmx[a] eq max(scatmx[a]))
       scatmxlhr[iday,j] = lhr[a[b[0]]]
       b = where(scatmn[a] eq min(scatmn[a]))
       scatmnlhr[iday,j] = lhr[a[b[0]]]
       b = where(scatmx[a] eq max(scatmx[a]) and max(scatmx[a] ge 155.))
       if(b[0] ne -1) then scatmxlhr155[iday,j] = lhr[a[b[0]]]
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
  device, file='gpm.nadir.scat_ltr.some=00_01.max.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-90,90], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   title='Precessing, Local Hour of Maximum Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude', yticks=6
  levels = [0,findgen(12)+6,18]
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i2)'), $
   colors=make_array(n_elements(levels),val=0), align=0
;  levels = findgen(10)*10.+30.
  colors = [250,200-findgen(12)*15,0]
  dx = 1.
  dy = 1.
  loadct, 72
  plotgrid, scatmxlhr, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close


  set_plot, 'ps'
  device, file='gpm.nadir.scat_ltr.some=00_01.min.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0
  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-90,90], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   title='Precessing, Local Hour of Minimum Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude', yticks=6
  levels = [0,findgen(12)+6,18]
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i2)'), $
   colors=make_array(n_elements(levels),val=0), align=0
;  levels = findgen(10)*10.+30.
  colors = [250,200-findgen(12)*15,0]
  dx = 1.
  dy = 1.
  loadct, 72
  plotgrid, scatmnlhr, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close


  set_plot, 'ps'
  device, file='gpm.nadir.scat_ltr.some=00_01.max155.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0
  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-90,90], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   title='Precessing, Local Hour of Maximum Scattering Angle (inly scat > 155!Eo!N)', $
   xtitle='Day of Year', ytitle='Latitude', yticks=6
  levels = [0,findgen(12)+6,18]
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i2)'), $
   colors=make_array(n_elements(levels),val=0), align=0
;  levels = findgen(10)*10.+30.
  colors = [250,200-findgen(12)*15,0]
  dx = 1.
  dy = 1.
  loadct, 72
  plotgrid, scatmxlhr155, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close

end
