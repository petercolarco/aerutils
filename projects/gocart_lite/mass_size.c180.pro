; Get some GOCART fields and plot the global mass size fraction by bin
  filename = 'c180R_pI33p7.tavg3d_aer_v.monthly.201606.nc4'
  nc4readvar, filename, 'du', du, /template, lon=lon, lat=lat
  nc4readvar, filename, 'ss', ss, /template, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp
  filename = 'c180R_pI33p7.tavg3d_aer_v.monthly.201612.nc4'
  nc4readvar, filename, 'du', du_, /template, lon=lon, lat=lat
  nc4readvar, filename, 'ss', ss_, /template, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp_

; Get the area
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

; Do vertical integration
  grav = 9.81
  ducmass = fltarr(nx,ny,5,2)
  sscmass = fltarr(nx,ny,5,2)
  for ibin = 0, 4 do begin
   ducmass[*,*,ibin,0] = total(du[*,*,*,ibin]*delp/grav,3)
   sscmass[*,*,ibin,0] = total(ss[*,*,*,ibin]*delp/grav,3)
   ducmass[*,*,ibin,1] = total(du_[*,*,*,ibin]*delp/grav,3)
   sscmass[*,*,ibin,1] = total(ss_[*,*,*,ibin]*delp/grav,3)
  endfor

; Do the global average
  dubin = fltarr(5,2)
  ssbin = fltarr(5,2)
  for ibin = 0, 4 do begin
   dubin[ibin,0] = total(ducmass[*,*,ibin,0]*area)/total(area)
   ssbin[ibin,0] = total(sscmass[*,*,ibin,0]*area)/total(area)
   dubin[ibin,1] = total(ducmass[*,*,ibin,1]*area)/total(area)
   ssbin[ibin,1] = total(sscmass[*,*,ibin,1]*area)/total(area)
  endfor
  dubin[*,0] = dubin[*,0]/total(dubin[*,0])
  dubin[*,1] = dubin[*,1]/total(dubin[*,1])
  ssbin[*,0] = ssbin[*,0]/total(ssbin[*,0])
  ssbin[*,1] = ssbin[*,1]/total(ssbin[*,1])

; Make a plot
  set_plot, 'ps'
  device, file='mass_size.c180.ps', /color, font_size=12
  !p.font=0

  plot, findgen(7), /nodata, $
   xrange=[0,6], xtitle='bin #', xticks=6, xstyle=1, $
   xtickn=[' ','1','2','3','4','5',' '], $
   yrange=[0,0.8], ytitle='mass fraction', yticks=8, ystyle=1

  loadct, 39
  oplot, indgen(5)+1, dubin[*,0], thick=6, color=208
  oplot, indgen(5)+1, dubin[*,1], thick=6, color=208, lin=2
  oplot, indgen(5)+1, ssbin[*,0], thick=6, color=74
  oplot, indgen(5)+1, ssbin[*,1], thick=6, color=74, lin=2

  device, /close

end
