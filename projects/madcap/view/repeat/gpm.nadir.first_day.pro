  pro make_plot, filename, var, vfirst, lono, lato, dx, dy, levels, colors
; Make a plot
  set_plot, 'ps'
  device, file=filename, /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  map_set, position=[.05,.15,.95,.95]
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i2)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  plotgrid, vfirst, [0.1], [180], lono, lato, dx, dy
  loadct, 72
  plotgrid, var, levels, colors, lono, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  loadct, 0
  map_continents, thick=3
  map_grid, /box
  device, /close
end



; Calculate the first day of the year that the nadir track polarimeter
; and lidar (in daylight) visit a grid box

; Outputs
  nxo  = 180
  nyo  = 91
  dx = 2.
  dy = 2.
  lono = -180.+dx/2.+findgen(nxo)*dx
  lato = -90.+findgen(nyo)*dy

  vfirst = make_array(nxo,nyo,val=!values.f_nan)
  vsecnd = make_array(nxo,nyo,val=!values.f_nan)
  vthird = make_array(nxo,nyo,val=!values.f_nan)
  vforth = make_array(nxo,nyo,val=!values.f_nan)

; Get the filenames to probe...
  iday = 1
;  for imm = 1, 12 do begin
  for imm = 1, 1 do begin
   for idd = 1, 31 do begin
    mm = strpad(imm,10)
    dd = strpad(idd,10)
    filen = file_search('/misc/prc19/colarco/OBS/A-CCP/GPM/LevelB/Y2006/M'$
                         +mm+'/D'+dd+'/', '*2006'+mm+dd+'*nc4')
    if(filen[0] ne '') then begin
print, filen
     jj = 0
     for ii = 0, n_elements(filen)-1 do begin

;     get offset hour from the filename
      it = fix(strmid(filen[ii],8,2,/reverse))

      cdfid = ncdf_open(filen[ii])
       id = ncdf_varid(cdfid,'trjLat')
       ncdf_varget, cdfid, id, lat_
       id = ncdf_varid(cdfid,'trjLon')
       ncdf_varget, cdfid, id, lon_
       id = ncdf_varid(cdfid,'sza_ss')
       ncdf_varget, cdfid, id, sza_
      ncdf_close, cdfid

      ny = n_elements(lat_)
      for iy = 0, ny-1 do begin
         
;      For every pixel where all views of the pixel have sza < 80
;      accumulate the latitudes and longitudes
       a = where(sza_[*,iy] le 80.)
       if(n_elements(a) eq 10) then begin
;       First time this day?
        if(jj eq 0) then begin
         lat  = lat_[iy]
         lon  = lon_[iy]
         jj = 1
        endif else begin
         lat    = [lat,lat_[iy]]
         lon    = [lon,lon_[iy]]
        endelse
       endif
      endfor
     endfor  ; day files

;    Now collect the scattering angles for the day on the regular grid
     ix = fix(interpol(findgen(nxo),lono,lon)+0.5d)
     iy = fix(interpol(findgen(nyo),lato,lat)+0.5d)
     for j = 0, nyo-1 do begin
      a = where(iy eq j)
      if(a[0] ne -1) then begin
       b = where(finite(vforth[ix[a],j]) ne 1 and $
                 finite(vthird[ix[a],j]) eq 1)
       if(b[0] ne -1) then vforth[ix[a[b]],j] = iday
       b = where(finite(vthird[ix[a],j]) ne 1 and $
                 finite(vsecnd[ix[a],j]) eq 1)
       if(b[0] ne -1) then vthird[ix[a[b]],j] = iday
       b = where(finite(vsecnd[ix[a],j]) ne 1 and $
                 finite(vfirst[ix[a],j]) eq 1)
       if(b[0] ne -1) then vsecnd[ix[a[b]],j] = iday
       b = where(finite(vfirst[ix[a],j]) ne 1)
       if(b[0] ne -1) then vfirst[ix[a[b]],j] = iday
      endif
     endfor
    endif    ; day exists

    iday = iday + 1

   endfor    ; day
  endfor     ; month

; Make a plot
  levels = findgen(31)+1
  colors = 250-findgen(31)*8
  make_plot, 'gpm.nadir.first_day.vfirst.ps', vfirst, vfirst, lono, lato, dx, dy, levels, colors
  make_plot, 'gpm.nadir.first_day.vsecnd.ps', vsecnd, vfirst, lono, lato, dx, dy, levels, colors
  make_plot, 'gpm.nadir.first_day.vthird.ps', vthird, vfirst, lono, lato, dx, dy, levels, colors
  make_plot, 'gpm.nadir.first_day.vforth.ps', vforth, vfirst, lono, lato, dx, dy, levels, colors

  levels = findgen(10)+1
  colors = 250-findgen(10)*25
  make_plot, 'gpm.nadir.first_day.diffr.2_1.ps', vsecnd-vfirst, vfirst, lono, lato, dx, dy, levels, colors
  make_plot, 'gpm.nadir.first_day.diffr.3_2.ps', vthird-vsecnd, vfirst, lono, lato, dx, dy, levels, colors
  make_plot, 'gpm.nadir.first_day.diffr.4_3.ps', vforth-vthird, vfirst, lono, lato, dx, dy, levels, colors

end
