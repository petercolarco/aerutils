; Read the ICAP MME dust aod from all the Junes like Peng made before

; Target lat lon (Cape San Juna Puerto Rico)
  latwant = 18.4
  lonwant = -65.6

  nyrs = 6
  ndys = 30
  yyyy = ['2015','2016','2017','2018','2019','2020']

  aod = fltarr(ndys,nyrs)

; Get the ICAP MME t = 0
  i = 0
  index = 0

  for iyrs = 0, nyrs-1 do begin
   yyyymmddhh = yyyy[iyrs]+'060100'
   yyyymmdd   = strmid(yyyymmddhh,0,8)

   idy = 0

   while(yyyymmdd lt yyyy[iyrs]+'0631') do begin

    print, yyyymmdd
    rc = 0
    if(yyyy[iyrs] ne '2020') then begin
     read_icapmme, yyyymmdd, 'dust_aod_stdv', index, lon, lat, aod_, rc=rc
     if(i eq 0) then begin
      if(rc eq 1) then stop
      ix = interpol(indgen(n_elements(lon)),lon,lonwant)
      iy = interpol(indgen(n_elements(lat)),lat,latwant)
      aod[idy,iyrs] = interpolate(aod_,ix,iy)
      i = 1
     endif else begin
      if(rc eq 0) then aod[idy,iyrs] = interpolate(aod_,ix,iy)
      if(rc eq 1) then aod[idy,iyrs] = !values.f_nan
     endelse
    endif else begin
     nmem = 6
     mems = [0,1,2,3,5,6]
     aod__ = fltarr(nmem)
     for imem = 0, nmem-1 do begin
      read_icap, yyyymmdd, 'dust_aod', index, mems[imem], lon, lat, aod___, rc=rc
      ix_ = interpol(indgen(n_elements(lon)),lon,lonwant)
      iy_ = interpol(indgen(n_elements(lat)),lat,latwant)
      aod__[imem] = interpolate(aod___,ix_,iy_)
     endfor
     aod[idy,iyrs] = stddev(aod__)
    endelse
    yyyymmddhh = incstrdate(yyyymmddhh,24)
    yyyymmdd = strmid(yyyymmddhh,0,8)
    idy = idy + 1
   endwhile
  endfor


; Make a timeseries of the AOD colored for each year

  set_plot, 'ps'
  device, file='icap_junes.stddev.nongac.ps', /color, /helvetica, font_size=14, $
   xsize=24, ysize=12
  !p.font=0

  loadct, 39

  plot, indgen(32), /nodata, $
   xrange=[0,31], xticks=31, xtitle='day of June', xminor=1, $
   xtickn=[' ',string(indgen(30)+1,format='(i2)'),' '], $
   yrange=[0,0.7], yticks=7, ytitle='Standard Deviation of Dust AOD', $
   xstyle=9, ystyle=9
  for iyrs = 0, nyrs-2 do begin
   oplot, indgen(30)+1, aod[*,iyrs], thick=12, color=254
  endfor
  oplot, indgen(30)+1, aod[*,nyrs-1], thick=16, color=80


  device, /close



end
