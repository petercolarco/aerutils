; Plot the monthly frequency of occurrence for each of the samples,
; including also the random samples, as the zonal mean

  set_plot, 'ps'
  device, file='gpm.zonal_frequency.monthly.ps', /helvetica, $
   font_size=14, xsize=30, ysize=18, /color
  !p.font=0
  !p.multi=[0,4,3]
  loadct, 39

  mon = ['January','February','March','April','May','June',$
         'July','August','September','October','November','December']

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']

  for im = 0, 11 do begin

; Get GPM
  filen = file_search('gpm/','*polar*txt')

  filen = filen[where(strpos(filen,'2006'+mm[im]) ne -1)]

  for i = 0, n_elements(filen)-1 do begin

   print, filen[i]
   read_pdf, filen[i], n_, lon_, lat_, psza_, pvza_, psaa_, pvaa_, psca_

   if(i eq 0) then begin
    n = n_
    lon = lon_
    lat = lat_
    psza = psza_
    pvza = pvza_
    psaa = psaa_
    pvaa = pvaa_
    psca = psca_
   endif else begin
    n = n + n_
    lon = [lon,lon_]
    lat = [lat,lat_]
    psza = psza+psza_
    pvza = pvza+pvza_
    psaa = psaa+psaa_
    pvaa = pvaa+pvaa_
    psca = psca+psca_
   endelse 
  endfor

; Make a grid
  ny = 37
  dy = 5.
  lat_ = -90. + findgen(ny)*dy

; Interpolate
  iy = fix(interpol(findgen(ny),lat_,lat)+0.5d)
  a = where(iy eq ny)
  if(a[0] ne -1) then iy[a] = ny-1

  num = lonarr(ny)
  for j = 0, ny-1 do begin
   a = where(iy eq j)
   if(a[0] ne -1) then begin
    num[j] = n_elements(a)
   endif
  endfor

; Now get the random sample
  filen = 'gpm/gpm.random.2006'+mm[im]+'.txt'
  read_random, filen, lon, lat, $
               vza, sza, vaa, saa, scat, $
               date, time, time_ss
  iy = fix(interpol(findgen(ny),lat_,lat)+0.5d)
  a = where(iy eq ny)
  if(a[0] ne -1) then iy[a] = ny-1
  numr = lonarr(ny)
  for j = 0, ny-1 do begin
   a = where(iy eq j)
   if(a[0] ne -1) then begin
    numr[j] = n_elements(a)
   endif
  endfor

  plot, indgen(10), /nodata, $
   xrange=[0,1.2], xticks=6, xtickn=['0','0.2','0.4','0.6','0.8','1.0',' '], $
   yrange=[-90,90], yticks=6, ytitle='latitude', xtitle='frequency', $
   xstyle=9, ystyle=9, title=mon[im]
  oplot, (num*1./total(num))/max(num*1./total(num)), lat_, thick=4
  oplot, (numr*1./total(numr))/max(numr*1./total(numr)), lat_, $
   thick=4, lin=2, color=254

  endfor

  device, /close

end
