; Get some GOCART fields and plot the global mass size fraction by bin
  filename = 'c180R_pI33p7.taod_Nc.20160701_0900z.nc4'
  nc4readvar, filename, 'du', du, /template, lon=lon, lat=lat
  nc4readvar, filename, 'ss', ss, /template, lon=lon, lat=lat
  filename = 'c180R_pI33p7.taod_Nc.20170101_0900z.nc4'
  nc4readvar, filename, 'du', du_, /template, lon=lon, lat=lat
  nc4readvar, filename, 'ss', ss_, /template, lon=lon, lat=lat, lev=lev

; Get the area
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

; Do the global average
  dubin = fltarr(8,5,2)
  ssbin = fltarr(8,5,2)
  for iz = 0, 7 do begin
   for ibin = 0, 4 do begin
    dubin[iz,ibin,0] = total(du[*,*,iz,ibin]*area)/total(area)
    ssbin[iz,ibin,0] = total(ss[*,*,iz,ibin]*area)/total(area)
    dubin[iz,ibin,1] = total(du_[*,*,iz,ibin]*area)/total(area)
    ssbin[iz,ibin,1] = total(ss_[*,*,iz,ibin]*area)/total(area)
   endfor
   dubin[iz,*,0] = dubin[iz,*,0]/total(dubin[iz,*,0])
   dubin[iz,*,1] = dubin[iz,*,1]/total(dubin[iz,*,1])
   ssbin[iz,*,0] = ssbin[iz,*,0]/total(ssbin[iz,*,0])
   ssbin[iz,*,1] = ssbin[iz,*,1]/total(ssbin[iz,*,1])
  endfor


; Make a plot
  set_plot, 'ps'
  device, file='aod_size_dust.ps', /color, font_size=12
  !p.font=0

  plot, findgen(7), /nodata, $
   xrange=[0,6], xtitle='bin #', xticks=6, xstyle=1, $
   xtickn=[' ','1','2','3','4','5',' '], $
   yrange=[0,0.5], ytitle='aod fraction', yticks=5, ystyle=1, $
   title='dust'

  loadct, 39
  for iz = 0, 7 do begin
   oplot, indgen(5)+1, dubin[iz,*,0], thick=6, color=254-iz*30
   oplot, indgen(5)+1, dubin[iz,*,1], thick=6, color=254-iz*30, lin=2
  endfor

  device, /close

; Make a plot
  set_plot, 'ps'
  device, file='aod_size_seasalt.ps', /color, font_size=12
  !p.font=0

  plot, findgen(7), /nodata, $
   xrange=[0,6], xtitle='bin #', xticks=6, xstyle=1, $
   xtickn=[' ','1','2','3','4','5',' '], $
   yrange=[0,0.5], ytitle='aod fraction', yticks=5, ystyle=1, $
   title='seasalt'

  loadct, 39
  for iz = 0, 7 do begin
   oplot, indgen(5)+1, ssbin[iz,*,0], thick=6, color=254-iz*30
   oplot, indgen(5)+1, ssbin[iz,*,1], thick=6, color=254-iz*30, lin=2
  endfor

  device, /close

end
