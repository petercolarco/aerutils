; Get and read Patricia's files to pluck out the local equator
; crossing time in daylight for 1st orbit of a day

; Outputs
  eqt = make_array(365,val=!values.f_nan)
  szo = make_array(365,val=!values.f_nan)
  sct = make_array(365,val=!values.f_nan)
  loo = make_array(365,val=!values.f_nan)
  lao = make_array(365,val=!values.f_nan)

; Get the filenames to probe...
  iday = 0
  for imm = 1, 12 do begin
   for idd = 1, 31 do begin
    mm = strpad(imm,10)
    dd = strpad(idd,10)
    filen = file_search('/misc/prc19/colarco/OBS/A-CCP/GPM045/LevelB/Y2019/M'+mm+'/',$
                        '*2019'+mm+dd+'_0000z.nc4')
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
       id = ncdf_varid(cdfid,'time')
       ncdf_varget, cdfid, id, time_
       id = ncdf_varid(cdfid,'sza')
       ncdf_varget, cdfid, id, sza_, offset=[498,4,0], count=[1,1,n_elements(time_)]
       id = ncdf_varid(cdfid,'scatAngle')
       ncdf_varget, cdfid, id, scat_, offset=[498,4,0], count=[1,1,n_elements(time_)]
      ncdf_close, cdfid

;     Reduce to near-nadir view
      sza_  = reform(sza_)
      scat_ = reform(scat_)

      if(ii eq 0) then begin
         lat  = lat_
         lon  = lon_
         time = it+time_/3600.
         sza  = sza_
         scat = scat_
        endif else begin
         lat    = [lat,lat_]
         lon    = [lon,lon_]
         time   = [time,it+time_/3600.]
         scat   = [scat,scat_]
         sza    = [sza,sza_]
      endelse

     endfor  ; day files

;    Reduce to daylight
     a = where(sza le 90)
     lat = lat[a]
     lon = lon[a]
     sza = sza[a]
     scat = scat[a]
     time = time[a]
if(a[0] eq -1) then begin
  print, filen[0]
  goto, jump
endif


; reduce to nearest point to equator
  lata = abs(lat)
  a = where(lata eq min(lata))
  if(lata[a[0]] gt 0.2) then goto, jump

sct[iday] = scat[a[0]]
szo[iday] = sza[a[0]]
loo[iday] = lon[a[0]]
lao[iday] = lat[a[0]]
lhrs = (loo[iday]/15.)
eqt[iday] = lhrs + time[a[0]]
if(eqt[iday] lt 0) then eqt[iday] =eqt[iday]+24.
jump:
     iday = iday + 1
    endif    ; day exists

   endfor    ; day
  endfor     ; month

  set_plot, 'ps'
  device, file='gpm045.nadir.eq_x_time.ps', /color, /helvetica, font_size=14, $
   xsize=20, ysize=12
  !p.font=0

  plot, indgen(10), /nodata, $
   xtitle='day of year', ytitle='local equator x-ing time', $
   xrange=[0,366], yrange=[0,20], xstyle=1, ystyle=1, $
   position=[.1,.1,.85,.9]
  oplot, findgen(365)+1, eqt, thick=6
;  loadct, 39
;  axis, yaxis=1, yrange=[0,90], color=254, /save, ytitle='sza', ystyle=1
;  oplot, findgen(365)+1, szo, thick=1, color=254
;  axis, 400,0, yaxis=1, yrange=[0,180], color=84, /save, ytitle='scat', ystyle=1
;  oplot, findgen(365)+1, sct, thick=4, color=84
  device, /close

  set_plot, 'ps'
  device, file='gpm045.nadir.eq_x_time.sza.ps', /color, /helvetica, font_size=14, $
   xsize=20, ysize=12
  !p.font=0

  plot, indgen(10), /nodata, $
   xtitle='day of year', ytitle='local equator x-ing time', $
   xrange=[0,366], yrange=[0,20], xstyle=1, ystyle=9, $
   position=[.1,.1,.85,.9]
  oplot, findgen(365)+1, eqt, thick=6
  loadct, 39
  axis, yaxis=1, yrange=[0,90], color=254, /save, ytitle='sza', ystyle=1
  oplot, findgen(365)+1, szo, thick=6, color=254
;  axis, 400,0, yaxis=1, yrange=[0,180], color=84, /save, ytitle='scat', ystyle=1
;  oplot, findgen(365)+1, sct, thick=4, color=84
  device, /close

  set_plot, 'ps'
  device, file='gpm045.nadir.eq_x_time.scat.ps', /color, /helvetica, font_size=14, $
   xsize=20, ysize=12
  !p.font=0

  plot, indgen(10), /nodata, $
   xtitle='day of year', ytitle='local equator x-ing time', $
   xrange=[0,366], yrange=[0,20], xstyle=1, ystyle=9, $
   position=[.1,.1,.85,.9]
  oplot, findgen(365)+1, eqt, thick=6
  loadct, 39
  axis, yaxis=1, yrange=[0,90], color=254, /save, ytitle='sza', ystyle=1
  oplot, findgen(365)+1, szo, thick=1, color=254
  axis, 400,0, yaxis=1, yrange=[0,180], color=84, /save, ytitle='scat', ystyle=1
  oplot, findgen(365)+1, sct, thick=4, color=84
  device, /close


end
