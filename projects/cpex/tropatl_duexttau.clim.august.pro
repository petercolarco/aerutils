; Get the MERRA2 file template (monthly means)
  filetemplate = 'MERRA2.tavg1_2d_aer_Nx.ddf'
  ga_times, filetemplate, nymd, nhms, template=template

; Pick off the "Augusts"
  a = where(long(nymd)/10000L ge 2001 and long(nymd)/10000L le 2017 and $
            long(nymd-long(nymd)/10000L*10000L)/100L eq 8)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
; I'm not doing this very smartly because there are 24
; filenames for each day, but they are the same.  Reduce to unique
; filenames
  filename = filename[uniq(filename)]
  nymd     = nymd[uniq(nymd)]
; Now grab noon of each
  nf = n_elements(filename)
  for i = 0, nf-1 do begin
   print, i
   nc4readvar, filename[i], 'duexttau', duext_, time=time, lon=lon, lat=lat, wantnymd=nymd[i]
   if(i eq 0) then begin
    duext = duext_
   endif else begin
    duext = [duext,duext_]
   endelse
  endfor
  duext = reform(duext,n_elements(lon),nf,n_elements(lat))
  duext = transpose(duext,[0,2,1])

; Reduce to ROI
  a = where(lon ge -70 and lon le -50)
  b = where(lat ge 15 and lat le 30)
  nx = n_elements(a)
  ny = n_elements(b)

  duext = duext[a,*,*]
  duext = duext[*,b,*]

; Now break by day of month
  i = 0
  j = 0
  du = fltarr(nx,ny,15,31)
  for k = 0, 464 do begin
  du[*,*,j,i] = duext[*,*,j*31+i]
  i = i+1
  if(i gt 30) then begin
   i = 0
   j = j+1
  endif
 endfor

  set_plot, 'ps'
  device, file='tropatl_duexttau.clim.august.ps', /color, $
   /helvetica, font_size=14, xsize=28, ysize=18
  !p.font=0
  loadct, 0

  plot, indgen(30), /nodata, $
   xrange=[0,32], yrange=[0,1], xticks=32, xminor=1, $
   xtickn=[' ',strpad(indgen(31)+1,10),' ']

  for i = 0, 30 do begin
   boxwhisker, du[*,*,*,i], i+1, 0.8, 150, $
    medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
  endfor

; Find du90% and du95%
  du = du[sort(du)]
  a = n_elements(du)
  du90 = du[.9*a]
  du95 = du[.95*a]
  du99 = du[.99*a]


; Get FP
  filetemplate = 'fp.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', duext_, time=time, lon=lon, lat=lat, $
    wantlon=[-70,-50], wantlat=[15,30]
  loadct, 39
  for i = 0, 28 do begin
   boxwhisker, duext_[*,*,i], i+1, 0.4, 90, $
    medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
endfor


; Get FCST
  filetemplate = 'fcst.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', duext_, time=time, lon=lon, lat=lat, $
    wantlon=[-70,-50], wantlat=[15,30]
  loadct, 39
  for i = 0,1 do begin
   boxwhisker, duext_[*,*,i], i+30, 0.4, 176, $
    medval, qtr_25th, qtr_75th, minval, maxval, meanval, stddv
endfor

  plots, [0,32], du90, thick=12
  plots, [0,32], du95, thick=12, lin=2
  plots, [0,32], du99, thick=12, lin=1


  device, /close


end
