; Get MERRA-2
  ddf = 'd5124_m2_jan79.ddf'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20191301L and nymd lt 20210000L)
  filename = filename[a]
  nc4readvar, filename, 'totexttau', m2, lon=lon, lat=lat

; Get Jason
  ddf = 'c180R_J10p17p6_ops.tavg2d_aer_x.ctl'
  ddf = 'c180R_f525_fp.tavg2d_aer_x.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20191301L and nymd lt 20210000L)
  filename = filename[a]
  nc4readvar, filename, 'totexttau', j2_, lon=lon_, lat=lat_
; Interpolate to M2 resolution
  ix = interpol(indgen(n_elements(lon_)),lon_,lon)
  j2 = fltarr(n_elements(lon),n_elements(lat),12)
  for it = 0, 11 do begin
   for iy = 0, n_elements(lat)-1 do begin
    j2[*,iy,it] = interpolate(j2_[*,iy,it],ix)
   endfor
  endfor

  set_plot, 'ps'
  device, file='test.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=24
  !p.font=0

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  xycomp, j2[*,*,5], m2[*,*,5], lon, lat, dx, dy, levels=findgen(11)*0.1
  device, /close

end

