  expid = 'c90F_pI33p9_ocs'
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sureff', reff, lon=lon, lat=lat, lev=lev, wantlat=[-10,10]
; zonal mean and transpose
  reff = transpose(total(total(reff,1)/n_elements(lon),1)/n_elements(lat))
  a = where(lev le 100 and lev ge 10)
  reff = reff[*,a]*1e6 ; microns
  lev = lev[a]

  expid = 'c90F_pI33p9_volc'
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sureff', reff2, lon=lon, lat=lat, lev=lev, wantlat=[-10,10]
; zonal mean and transpose
  reff2 = transpose(total(total(reff2,1)/n_elements(lon),1)/n_elements(lat))
  a = where(lev le 100 and lev ge 10)
  reff2 = reff2[*,a]*1e6 ; microns
  lev = lev[a]

  expid = 'c90F_pI33p9_sulf'
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sureff', reff3, lon=lon, lat=lat, lev=lev, wantlat=[-10,10]
; zonal mean and transpose
  reff3 = transpose(total(total(reff3,1)/n_elements(lon),1)/n_elements(lat))
  a = where(lev le 100 and lev ge 10)
  reff3 = reff3[*,a]*1e6 ; microns
  lev = lev[a]


; Now make a plot
  set_plot, 'ps'
  device, file='plot_reff_sulfate_compare.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xmax = max(x)
;xmax = 131 ; end of 1990
  xyrs = n_elements(x)/12
;xyrs = (xmax+1)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
;  xtickname[1:xyrs-1:2] = ' '
  !p.multi=[0,1,3]
  plot, x, reff, /nodata, $
   xstyle=9, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[0.1,0.5]
  oplot, x, reff2[*,0], thick=6
  oplot, x, reff3[*,0], thick=6, lin=2
  oplot, x, reff[*,0], thick=6, color=180


  plot, x, reff, /nodata, $
   xstyle=9, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[0.1,0.3]
  oplot, x, reff2[*,2], thick=6
  oplot, x, reff3[*,2], thick=6, lin=2
  oplot, x, reff[*,2], thick=6, color=180


  plot, x, reff, /nodata, $
   xstyle=9, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[0.1,0.3]
  oplot, x, reff2[*,4], thick=6
  oplot, x, reff3[*,4], thick=6, lin=2
  oplot, x, reff[*,4], thick=6, color=180


  device, /close

end

