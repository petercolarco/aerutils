  pro incline_lat_x_time, inc
  sinc = '0'+inc

; Get and read Patricia's files to pluck out the local equator
; crossing time in daylight for 1st orbit of a day

; Outputs
  eqt = make_array(26,365,val=!values.f_nan)
  szo = make_array(26,365,val=!values.f_nan)
  sct = make_array(26,365,val=!values.f_nan)
  loo = make_array(26,365,val=!values.f_nan)
  lao = make_array(26,365,val=!values.f_nan)
  fdy = fltarr(365)

  nj = 26
  latg = 62.5-indgen(nj)*5

; Get the filenames to probe...
  iday = 0
  for imm = 1, 12 do begin
   for idd = 1, 31 do begin
;  for imm = 1, 1 do begin
;   for idd = 1, 2 do begin
    mm = strpad(imm,10)
    dd = strpad(idd,10)
    if(inc eq '65') then begin
     filen = file_search('/misc/prc19/colarco/OBS/A-CCP/GPM/LevelB/Y2006/M'+mm+'/',$
                         '*2006'+mm+dd+'_0[0,1,2]*nc4')
    endif else begin
     filen = file_search('/misc/prc19/colarco/OBS/A-CCP/GPM'+sinc+'/LevelB/Y2019/M'+mm+'/',$
                         '*2019'+mm+dd+'_0000z.nc4')
    endelse
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

;    Use information from single orbit cases to guess at number of
;    points needed for single orbit in GPM 65 inc case
     if(inc eq '65') then begin
      sza  = sza[0:5555]
      lon  = lon[0:5555]
      lat  = lat[0:5555]
      scat = scat[0:5555]
      time = time[0:5555]
     endif

;    Reduce to daylight
     a = where(sza le 80)
     fdy[iday] = n_elements(a)*1./n_elements(sza)
     lat = lat[a]
     lon = lon[a]
     sza = sza[a]
     scat = scat[a]
     time = time[a]
if(a[0] eq -1) then begin
  print, filen[0]
  goto, jump
endif

; reduce to nearest points in a 5 degree latitude grid
  for j = 0, nj-1 do begin
  a = where(abs(lat-latg[j]) eq min(abs(lat-latg[j])))
  if(min(abs(lat-latg[j])) gt 2.4) then goto, jump

sct[j,iday] = scat[a[0]]
szo[j,iday] = sza[a[0]]
loo[j,iday] = lon[a[0]]
lao[j,iday] = lat[a[0]]
lhrs = (loo[j,iday]/15.)
eqt[j,iday] = lhrs + time[a[0]]
if(eqt[j,iday] lt 0) then eqt[j,iday] =eqt[j,iday]+24.
jump:
   endfor
     iday = iday + 1
    endif    ; day exists
   endfor    ; day
  endfor     ; month

  set_plot, 'ps'
  device, file='gpm'+sinc+'.nadir.lat_x_time.fday.ps', /color, /helvetica, font_size=14, $
   xsize=24, ysize=14
  !p.font=0
  loadct, 0
  plot, indgen(10), /nodata, $
   xtitle='day of year', ytitle='fraction', $
   xrange=[0,366], yrange=[0,.5], xstyle=1, ystyle=1, $
   position=[.1,.15,.8,.9]
  oplot, indgen(365)+1, fdy, thick=3
  device, /close

  set_plot, 'ps'
  device, file='gpm'+sinc+'.nadir.lat_x_time.ps', /color, /helvetica, font_size=14, $
   xsize=24, ysize=14
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xtitle='day of year', ytitle='latitude', $
   xrange=[0,366], yrange=[-65,65], xstyle=1, ystyle=1, $
   position=[.1,.15,.8,.9]
  loadct, 72
  levels = 4+indgen(16)
  colors = findgen(16)*16
  plotgrid, transpose(eqt), levels, colors, indgen(365)+1, latg, 1, 5
  loadct, 0
  makekey, .82, .15, .05, .75, .07, .01, /orient, $
   labels=string(levels,format='(i2)'), colors=make_array(n_elements(colors),val=255)
  loadct, 72
  makekey, .82, .15, .05, .75, .07, .01, /orient, $
   labels=make_array(n_elements(levels), val=' '), colors=colors

  device, /close

; histogram
  set_plot, 'ps'
  device, file='gpm'+sinc+'.nadir.lat_x_time_hist.ps', /color, /helvetica, font_size=14, $
   xsize=24, ysize=14
  !p.font=0

  hlev = [levels,24]
  hist = fltarr(n_elements(hlev),nj)
; count
  for ij = 0, nj-1 do begin
;   a = where(finite(eqt[ij,*]) eq 1)
;   if(a[0] ne -1) then hist[0,ij] = n_elements(a)
   for ilev = 0, n_elements(hlev)-2 do begin
    a = where(eqt[ij,*] ge hlev[ilev] and eqt[ij,*] lt hlev[ilev+1])
    if(a[0] ne -1) then hist[ilev,ij] = n_elements(a)
   endfor
  endfor

  loadct, 0
  plot, indgen(10), /nodata, $
   xtitle='local hour', ytitle='latitude', $
   xrange=[0,n_elements(hlev)], yrange=[-65,65], xstyle=1, ystyle=1, $
   xticks=n_elements(hlev), xtickn=[' ',string(levels,format='(i2)'),' '], $
   position=[.1,.15,.8,.9]
  loadct, 39
  clevels = [0,1,10,20,30,40,50,100]
  clevels = [0,1,5,10,15,20,25,30]
  colors = [255,48,84,120,176,192,208,254]
  plotgrid, hist[0:n_elements(levels),*], clevels, colors, $
   indgen(n_elements(levels)+1)+1, latg, 1, 5
  makekey, .82, .15, .05, .75, .07, .01, /orient, $
   labels=string(clevels,format='(i3)'), colors=colors

  device, /close

end
