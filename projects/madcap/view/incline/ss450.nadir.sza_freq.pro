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
    filen = file_search('/misc/prc19/colarco/OBS/A-CCP/SS450/LevelB/Y2006/M'+mm+'/D'+dd+'/',$
                        '*2006'+mm+dd+'_0[0,1,2]*nc4')
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
       id = ncdf_varid(cdfid,'sza_ss')
       ncdf_varget, cdfid, id, sza_
       id = ncdf_varid(cdfid,'scatAngle_ss')
       ncdf_varget, cdfid, id, scat_
      ncdf_close, cdfid

;     Reduce to near-nadir view
      sza_  = reform(sza_[4,*])
      scat_ = reform(scat_[4,*])

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
  device, file='ss450.nadir.sza_freq.ps', /color, /helvetica, font_size=14, $
   xsize=20, ysize=12
  !p.font=0

  plot, indgen(10), /nodata, $
   xtitle='SZA', ytitle='Frequency', $
   xrange=[0,90], yrange=[0,0.5], xstyle=9, ystyle=9, $
   position=[.1,.1,.85,.9]

  hist_sza = histogram(szo,min=0,max=90,nbins=18)
  oplot, findgen(18)*5+2.5, 1.*hist_sza/365., thick=8, color=160

  device, /close

end
