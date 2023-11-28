; Get and read Patricia's files to pluck out the zonal mean
; scattering angles per day, daylight only

; Outputs
  nyo  = 181
  lato = -90.+findgen(nyo)
  szamxo  = make_array(365,nyo,val=!values.f_nan)
  saamxo  = make_array(365,nyo,val=!values.f_nan)
  


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
       id = ncdf_varid(cdfid,'saa_ss')
       ncdf_varget, cdfid, id, saa_
      ncdf_close, cdfid

      ny = n_elements(lat_)
      for iy = 0, ny-1 do begin

;      For every pixel where all views of the pixel have sza < 80
       if(sza_[6,iy] lt 80.) then begin
;       First time this day?
        if(jj eq 0) then begin
         lat  = lat_[iy]
         szamx  = max(sza_[6,iy])
         szamn  = min(sza_[6,iy])
         saamx  = max(saa_[6,iy])
         saamn  = min(saa_[6,iy])
         jj = 1
        endif else begin
         lat    = [lat,lat_[iy]]
         szamx  = [szamx,max(sza_[6,iy])]
         szamn  = [szamn,min(sza_[6,iy])]
         saamx  = [saamx,max(saa_[6,iy])]
         saamn  = [saamn,min(saa_[6,iy])]
        endelse
       endif
      endfor
     endfor  ; day files

;    Now collect the scattering angles for the day on the regular grid
     iy = fix(interpol(findgen(nyo),lato,lat)+0.5d)
     szamx  = szamx[sort(iy)]
     szamn  = szamn[sort(iy)]
     saamx  = saamx[sort(iy)]
     saamn  = saamn[sort(iy)]
     lat    = lat[sort(iy)]
     iy     = iy[sort(iy)]
;  plot, indgen(10), /nodata, yrange=[0,200], xrange=[-90,90]
;  plots, lat, scatmx, psym=3
;  plots, lat, szamx, psym=3
;  plots, lat, vzamx, psym=3

     for j = 0, nyo-1 do begin
      a = where(iy eq j)
      if(a[0] ne -1) then begin
       szamxo[iday,j]  = max(szamx[a])
       saamxo[iday,j]  = max(saamx[a])
      endif
     endfor
     iday = iday + 1
    endif    ; day exists

   endfor    ; day
  endfor     ; month

; Make a plot
  set_plot, 'ps'
  device, file='ss450.nadir.saa.max=6.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-90,90], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   title='Sunsynchronous, Solar Azimuth Angle', $
   xtitle='Day of Year', ytitle='Latitude', yticks=6
  levels = findgen(11)*20+120
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
;  levels = findgen(10)*10.+30.
  colors = 225-findgen(11)*20
  dx = 1.
  dy = 1.
  loadct, 72
  plotgrid, saamxo, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close

end
