; Get GOCART
  expid = 'c90F_pI33p9_sulf'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'so4cmass', sucm_, lon=lon, lat=lat
  nc4readvar, filename, 'suexttau', suext_, lon=lon, lat=lat
  nc4readvar, filename, ['susd003','susv003','suwt003','sudp003'], suloss_, lon=lon, lat=lat, /sum
; Compute global mean
  area, lon, lat, nx, ny, dx, dy, area
  sucm_    = aave(sucm_,area)*total(area)
  suext_   = aave(suext_,area)
  suloss_  = aave(suloss_,area)*total(area)

; Get CARMA
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sucmass', sucm, lon=lon, lat=lat
  nc4readvar, filename, 'suexttau', suext, lon=lon, lat=lat
  nc4readvar, filename, ['susd','susv','suwt','sudp'], suloss, lon=lon, lat=lat, /sum
; Compute global mean
  area, lon, lat, nx, ny, dx, dy, area
  sucm    = aave(sucm,area)*total(area)
  suext   = aave(suext,area)
  suloss  = aave(suloss,area)*total(area)


; Now make a plot
  set_plot, 'ps'
  device, file='plot_gocart_carma_ratio.sulf.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  levels = [.1,.2,.5,1,2,5,10]
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xyrs = n_elements(x)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
;  xtickname[1:xyrs-1:2] = ' '
  plot, x, sucm, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[0,5],  yticks=10, $
   ytitle = 'ratio'

  oplot, x, suext_/suext, thick=6
  oplot, x, sucm_/sucm, thick=6, lin=2
  oplot, x, suloss_/suloss, thick=6, lin=1

  device, /close

end
