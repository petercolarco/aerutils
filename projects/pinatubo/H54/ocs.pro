  expid = 'scspinv7c'
  filetemplate = expid+'.tavg3d_aer_v.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'ocs', ocs, lon=lon,lat=lat
  nc4readvar, filename, 'delp', delp, lon=lon,lat=lat

  ocscol = total(ocs*delp/9.81,3)

  area, lon, lat, nx, ny, dx, dy, area, grid='c', lat2=lat2

  nt = n_elements(nymd)
  ocstot = fltarr(nt)
  for it = 0, nt-1 do begin
   ocstot[it] = total(ocscol[*,*,it]*area)
  endfor

  set_plot, 'ps'
  device, file='ocs.scspinv7c.ps', /color

  plot, ocstot/1e9, yrange=[0,3]

  device, /close


end

