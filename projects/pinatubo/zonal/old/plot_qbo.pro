  filetemplate = 'c48F_G41-spin.geosgcm_prog.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'u', u, lon=lon, lat=lat, lev=lev, wantlat=[-2,2]

; zonal mean and transpose
  u = transpose(total(total(u,1)/n_elements(lon),1)/n_elements(lat))

  a = where(lev le 100 and lev ge 5)
  u = u[*,a]
  lev = lev[a]


; Now make a plot
  set_plot, 'ps'
  device, file='plot_qbo.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  red   = [5,33,67,146,209,247,253,244,214,178,103]
  green = [48,102,147,197,229,247,219,165,96,24,0]
  blue  = [97,172,195,222,240,247,199,130,77,43,31]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  loadct, 0
  levels = [-50,-40,-30,-20,-10,-5,5,10,20,30,40]
  contour, u, indgen(n_elements(nymd)), lev, /nodata, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xminor=2, xticks=8, $
   xtickname=[string(nymd[0:191:24]/10000L,format='(i4)'),' '], $
   ystyle=9, yrange=[100,5],  yticks=4, ytickv=[100,50,20,10,5], $
   ytitle = 'pressure [hPa]', /ylog

  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  contour, u, indgen(n_elements(nymd)), lev, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, u, indgen(n_elements(nymd)), lev, /nodata, noerase=1, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xminor=2, xticks=8, $
   xtickname=[string(nymd[0:191:24]/10000L,format='(i4)'),' '], $
   ystyle=9, yrange=[100,5], yticks=4, ytickv=[100,50,20,10,5], $
   ytitle = 'pressure [hPa]', /ylog

  makekey, .1, .08, .85, .04, 0., -0.04, color=findgen(11), $
           labels=string([levels,50],format='(i3)'), align=.5
  xyouts, .525, .01, 'u-wind component [m s!E-1!N]', align=.5, /normal
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  makekey, .1, .08, .85, .04, 0., -0.04, color=dcolors, $
           labels=make_array(12,val=''), align=.5

  device, /close

end

