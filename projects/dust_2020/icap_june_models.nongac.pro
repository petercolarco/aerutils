; Read the ICAP MME dust aod from all the Junes like Peng made before

; Target lat lon (Cape San Juna Puerto Rico)
  latwant = 18.4
  lonwant = -65.6

  nmem = 6
  ndys = 30

  mems = [0,1,2,3,5,6]

  aod = fltarr(ndys,nmem)

; Get the ICAP MME t = 0
  i = 0
  index = 0

  for imem = 0, nmem-1 do begin
   yyyymmddhh = '2020060100'
   yyyymmdd   = strmid(yyyymmddhh,0,8)

   idy = 0

   while(yyyymmdd lt '20200631') do begin

    print, yyyymmdd
    rc = 0
    read_icap, yyyymmdd, 'dust_aod', index, mems[imem], lon, lat, aod_, rc=rc
    if(i eq 0) then begin
     if(rc eq 1) then stop
     ix = interpol(indgen(n_elements(lon)),lon,lonwant)
     iy = interpol(indgen(n_elements(lat)),lat,latwant)
     aod[idy,imem] = interpolate(aod_,ix,iy)
     i = 1
    endif else begin
     if(rc eq 0) then aod[idy,imem] = interpolate(aod_,ix,iy)
     if(rc eq 1) then aod[idy,imem] = !values.f_nan
    endelse
    yyyymmddhh = incstrdate(yyyymmddhh,24)
    yyyymmdd = strmid(yyyymmddhh,0,8)
    idy = idy + 1
   endwhile
  endfor

  aodmme = mean(aod,dim=2)

; Make a timeseries of the AOD colored for each year

  set_plot, 'ps'
  device, file='icap_june_models.nongac.ps', /color, /helvetica, font_size=14, $
   xsize=24, ysize=12
  !p.font=0

  plot, indgen(32), /nodata, $
   xrange=[0,31], xticks=31, xtitle='day of June', xminor=1, $
   xtickn=[' ',string(indgen(30)+1,format='(i2)'),' '], $
   yrange=[0,2], yticks=4, ytitle='Dust AOD', $
   xstyle=9, ystyle=9

loadct, 39
colors = [84,84,84,84,254,84]
lines  = [1,0,2,3,0,4]

  for imem = 0, nmem-1 do begin
   oplot, indgen(30)+1, aod[*,imem], thick=12, color=colors[imem], lin=lines[imem]
  endfor

  loadct, 0
  oplot, indgen(30)+1, aodmme[*,0], thick=16


  device, /close



end
