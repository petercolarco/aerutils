  expid = 'c90F_pI33p9_ocs'
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suextcoef', ext, lon=lon, lat=lat, lev=lev, wantlat=[-10,10]
  nc4readvar, filename, 'suconc', cnc, lon=lon, lat=lat, lev=lev, wantlat=[-10,10]
; zonal mean and transpose
  ext = transpose(total(total(ext,1)/n_elements(lon),1)/n_elements(lat))
  cnc = transpose(total(total(cnc,1)/n_elements(lon),1)/n_elements(lat))
  a = where(lev le 100 and lev ge 10)
  mee = ext[*,a]/cnc[*,a]/1000. ; m2 g-1
  lev = lev[a]

  expid = 'c90F_pI33p9_volc'
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suextcoef', ext2, lon=lon, lat=lat, lev=lev, wantlat=[-10,10]
  nc4readvar, filename, 'suconc', cnc2, lon=lon, lat=lat, lev=lev, wantlat=[-10,10]
; zonal mean and transpose
  ext2 = transpose(total(total(ext2,1)/n_elements(lon),1)/n_elements(lat))
  cnc2 = transpose(total(total(cnc2,1)/n_elements(lon),1)/n_elements(lat))
  a = where(lev le 100 and lev ge 10)
  mee2 = ext2[*,a]/cnc2[*,a]/1000. ; m2 g-1
  lev = lev[a]

  expid = 'c90F_pI33p9_sulf'
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suextcoef', ext3, lon=lon, lat=lat, lev=lev, wantlat=[-10,10]
  nc4readvar, filename, 'suconc', cnc3, lon=lon, lat=lat, lev=lev, wantlat=[-10,10]
; zonal mean and transpose
  ext3 = transpose(total(total(ext3,1)/n_elements(lon),1)/n_elements(lat))
  cnc3 = transpose(total(total(cnc3,1)/n_elements(lon),1)/n_elements(lat))
  a = where(lev le 100 and lev ge 10)
  mee3 = ext3[*,a]/cnc3[*,a]/1000. ; m2 g-1
  lev = lev[a]


; Now make a plot
  set_plot, 'ps'
  device, file='plot_mee_sulfate_compare.ps', /color, /helvetica, font_size=12, $
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
  plot, x, mee, /nodata, $
   xstyle=9, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[2,5]
  oplot, x, mee2[*,0], thick=6
  oplot, x, mee3[*,0], thick=6, lin=2
  oplot, x, mee[*,0], thick=6, color=180


  plot, x, mee, /nodata, $
   xstyle=9, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[2,5]
  oplot, x, mee2[*,2], thick=6
  oplot, x, mee3[*,2], thick=6, lin=2
  oplot, x, mee[*,2], thick=6, color=180


  plot, x, mee, /nodata, $
   xstyle=9, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[2,8]
  oplot, x, mee2[*,4], thick=6
  oplot, x, mee3[*,4], thick=6, lin=2
  oplot, x, mee[*,4], thick=6, color=180


  device, /close

end

