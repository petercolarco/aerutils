; Get MERRA-2
  ddf = 'c180R_J10p17p6_v2_ceds_2019_gaas.tavg2d_aer_x.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20181301L and nymd lt 20200000L)
  filename = filename[a]
  nc4readvar, filename, 'totexttau002', m2, lon=lon, lat=lat

; Get Jason
  ddf = 'c180R_J10p17p6_v2r1_ceds_2019.tavg2d_aer_x.ctl'
;  ddf = 'c180R_f525_fp.tavg2d_aer_x.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20181301L and nymd lt 20200000L)
  filename = filename[a]
  nc4readvar, filename, 'totexttau001', j2_, lon=lon_, lat=lat_
; Interpolate to M2 resolution
  ix = interpol(indgen(n_elements(lon_)),lon_,lon)
  j2 = fltarr(n_elements(lon),n_elements(lat),12)
  for it = 0, 11 do begin
   for iy = 0, n_elements(lat)-1 do begin
    j2[*,iy,it] = interpolate(j2_[*,iy,it],ix)
   endfor
  endfor

  for i = 0, 11 do begin

  set_plot, 'ps'
  device, file='ceds2_gaas.'+strpad(i+1,10)+'.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=24
  !p.font=0

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  xycomp, j2[*,*,i], m2[*,*,i], lon, lat, dx, dy, levels=findgen(11)*0.1
  device, /close

  endfor

end

