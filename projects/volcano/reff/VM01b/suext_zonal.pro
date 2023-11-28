; Make a plot of the time varying zonal mean effective radius versus
; height at a given latitude
  wantlat = [-30,30]
  expid = 'VMSTRjul05'
  filetemplate = expid+'.tavg3d_carma_v.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suextcoef', suext, wantlat=wantlat, lat=lat, lon=lon, lev=lev
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  nt = n_elements(filename)
  b = where(suext gt 1e14)
  suext[b] = !values.f_nan

  suext = mean(suext,dim=1,/nan)
  suext = transpose(mean(suext,dim=1,/nan))

  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa_
  z = z/1000.
  delz = delz/1000.

  x = findgen(nt)*(1./12.)
  colors = 25. + findgen(10)*25
  set_plot, 'ps'
  device, file='suext_zonal.'+expid+'.ps', /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=8
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        ytitle='pressure [hPa]', /ylog, $
        xrange=[0,nt/12.], yrange=[500,10], xstyle=9, ystyle=9, $
        xticks=nt/12, xminor=2
  contour, /overplot, suext*1000., x, p/100., lev=findgen(5)*.01+.01

  device, /close

end
