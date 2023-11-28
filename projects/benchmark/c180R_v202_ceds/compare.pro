  pro plotit, x, y, z, varn, ymax, dymax
  set_plot, 'ps'
  device, file=varn+'.ps', /color, /helvetica, font_size=12, $
   xsize=18, ysize=18
  !p.font=0
  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0,13], yrange=[0,ymax], xticks=13, $
   xtickname=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   ytitle='AOD', xstyle=9, ystyle=9, position=[.15,.55,.9,.95]
  loadct, 39
  oplot, indgen(12)+1, x, thick=8, color=0
  oplot, indgen(12)+1, y, thick=8, color=74
  oplot, indgen(12)+1, z, thick=8, color=254

  plot, indgen(10), /nodata, /noerase, $
   xrange=[0,13], yrange=[-dymax,dymax], xticks=13, $
   xtickname=[' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
   ytitle='AOD (model-MERRA-2)', xstyle=9, ystyle=9, position=[.15,.1,.9,.5]
  oplot, indgen(12)+1, y-x, thick=8, color=74
  oplot, indgen(12)+1, z-x, thick=8, color=254
  oplot, indgen(14), make_array(14,val=0), thick=1, lin=2
  
  device, /close
  end

; Get MERRA-2
  ddf = 'd5124_m2_jan79.ddf'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20181301L and nymd lt 20200000L)
  filename = filename[a]
  vars= ['totexttau','duexttau','ocexttau','suexttau','ssexttau','bcexttau']
  nc4readvar, filename, vars, m2_, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area
  nv = n_elements(vars)
  m2 = fltarr(12,nv)
  for iv = 0, nv-1 do begin
   for it = 0, 11 do begin
    m2[it,iv] = aave(m2_[*,*,it,iv],area)
   endfor
  endfor

  ddf = 'c180R_J10p17p6_v2_ops_2019.tavg2d_aer_x.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20181301L and nymd lt 20200000L)
  filename = filename[a]
  vars= ['totexttau002','duexttau','ocexttau','suexttau','ssexttau','bcexttau','brcexttau','niexttau']
  nc4readvar, filename, vars, g2_, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area
  nv = n_elements(vars)
  g2 = fltarr(12,nv)
  for iv = 0, nv-1 do begin
   for it = 0, 11 do begin
    g2[it,iv] = aave(g2_[*,*,it,iv],area)
   endfor
  endfor

  ddf = 'c180R_J10p17p6_v2_ceds_2019_gaas.tavg2d_aer_x.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20181301L and nymd lt 20200000L)
  filename = filename[a]
  vars= ['totexttau002','duexttau','ocexttau','suexttau','ssexttau','bcexttau','brcexttau','niexttau']
  nc4readvar, filename, vars, g2_, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area
  nv = n_elements(vars)
  c2gaas = fltarr(12,nv)
  for iv = 0, nv-1 do begin
   for it = 0, 11 do begin
    c2gaas[it,iv] = aave(g2_[*,*,it,iv],area)
   endfor
  endfor

  ddf = 'c180R_J10p17p6_v2_ceds_2019.tavg2d_aer_x.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20181301L and nymd lt 20200000L)
  filename = filename[a]
  vars= ['totexttau002','duexttau','ocexttau','suexttau','ssexttau','bcexttau','brcexttau','niexttau']
  nc4readvar, filename, vars, c2_, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area
  nv = n_elements(vars)
  c2 = fltarr(12,nv)
  for iv = 0, nv-1 do begin
   for it = 0, 11 do begin
    c2[it,iv] = aave(c2_[*,*,it,iv],area)
   endfor
  endfor

  ddf = 'c180R_J10p17p6_v2r1_ceds_2019.tavg2d_aer_x.ctl'
  ga_times, ddf, nymd, nhms, template=filetemplate, tdef=tdef, jday=jday, rc=rc
  filename = strtemplate(parsectl_dset(ddf),nymd,nhms)
  a = where(nymd gt 20181301L and nymd lt 20200000L)
  filename = filename[a]
  vars= ['totexttau001','duexttau','ocexttau','suexttau','ssexttau','bcexttau','brcexttau','niexttau']
  nc4readvar, filename, vars, c2_, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area
  nv = n_elements(vars)
  c2r1 = fltarr(12,nv)
  for iv = 0, nv-1 do begin
   for it = 0, 11 do begin
    c2r1[it,iv] = aave(c2_[*,*,it,iv],area)
   endfor
  endfor

; Plot total AOD
  plotit, m2[*,0], c2gaas[*,0], c2r1[*,0], 'totexttau', .2, .03
  plotit, m2[*,1], c2gaas[*,1], c2r1[*,1], 'duexttau', .05, .01
  plotit, m2[*,3], c2gaas[*,3], c2r1[*,3], 'suexttau', .1, .02
  plotit, m2[*,4], c2gaas[*,4], c2r1[*,4], 'ssexttau', .1, .02
  plotit, m2[*,5], c2gaas[*,5], c2r1[*,5], 'bcexttau', .01, .01
  c2gaas_ = c2gaas[*,2]+c2gaas[*,6]
  c2_ = c2[*,2]+c2[*,6]
  plotit, m2[*,2], c2gaas_, c2_, 'oaexttau', .06, .03
  plotit, make_array(12,val=0.), c2gaas[*,7], c2r1[*,7], 'niexttau', .02, .02

end
