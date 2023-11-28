  expid = 'c48Fc_H43_stratv2'
  filetemplate = expid+'.tavg3d_aer_v.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'pso2_ocs', ocs, lon=lon,lat=lat
  nc4readvar, filename, 'pso2_ocs_oh', poh, lon=lon,lat=lat
  nc4readvar, filename, 'pso2_ocs_o3p', po3p, lon=lon,lat=lat
  nc4readvar, filename, 'pso2_ocs_jocs', pjocs, lon=lon,lat=lat
  nc4readvar, filename, 'delp', delp, lon=lon,lat=lat

  ocscol = total(ocs*delp/9.81,3)
  pohcol = total(poh*delp/9.81,3)
  po3pcol = total(po3p*delp/9.81,3)
  pjocscol = total(pjocs*delp/9.81,3)

  area, lon, lat, nx, ny, dx, dy, area, grid='b', lat2=lat2

  nt = n_elements(nymd)
  ocstot = fltarr(nt)
  pohtot = fltarr(nt)
  po3ptot = fltarr(nt)
  pjocstot = fltarr(nt)
  for it = 0, nt-1 do begin
   ocstot[it] = total(ocscol[*,*,it]*area)
   pohtot[it] = total(pohcol[*,*,it]*area)
   po3ptot[it] = total(po3pcol[*,*,it]*area)
   pjocstot[it] = total(pjocscol[*,*,it]*area)
  endfor

  set_plot, 'ps'
  device, file='pso2_ocs.'+expid+'.ps', /color

  loadct, 39
  plot, ocstot, yrange=[0,3], thick=6
  oplot, pohtot, thick=6, col=254
  oplot, po3ptot, thick=6, col=208
  oplot, pjocstot, thick=6, col=84

  device, /close

end

