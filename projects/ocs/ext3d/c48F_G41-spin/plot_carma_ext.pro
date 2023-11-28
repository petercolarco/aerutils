  expid = 'c48F_G41-pin'
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suextcoef', su, $
    lon=lon, lat=lat, lev=lev, wantlat=[-10,0]

; zonal mean and transpose
  su = transpose(total(total(su,1)/n_elements(lon),1)/n_elements(lat))

  a = where(lev le 100 and lev ge 5)
  su = su[*,a]
  lev = lev[a]


; Now make a plot
  set_plot, 'ps'
  device, file='plot_carma_ext.'+expid+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  red   = [246,208,166,103,54,2,1]
  blue  = [239,209,189,169,144,129]
  green = [247,230,219,207,192,138,80]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  loadct, 0
  levels = 75+findgen(7)*15
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xyrs = n_elements(x)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
;  xtickname[1:xyrs-1:2] = ' '
  contour, su*1e9, x, lev, /nodata, $
   position=[.1,.2,.95,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[100,5],  yticks=4, ytickv=[100,50,20,10,5], $
   ytitle = 'pressure [hPa]', /ylog

  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  contour, su*1e9, indgen(n_elements(nymd)), lev, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, su*1e9, x, lev, /nodata, noerase=1, $
   position=[.1,.2,.95,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[100,5], yticks=4, ytickv=[100,50,20,10,5], $
   ytitle = 'pressure [hPa]', /ylog

  makekey, .1, .08, .85, .04, 0., -0.04, color=findgen(7), $
           labels=string([levels],format='(i3)'), align=.5
  xyouts, .525, .01, 'CARMA OCS Produced Sulfate Extinction [10!E-6!N km]', align=.5, /normal
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  makekey, .1, .08, .85, .04, 0., -0.04, color=dcolors, $
           labels=make_array(12,val=''), align=.5

  device, /close

end

