  filetemplate = 'c48F_G41-spin.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suconc', suconc, lon=lon, lat=lat, lev=lev, wantlat=[-2,2]

; zonal mean and transpose [ng m-3]
  suconc = transpose(total(total(suconc,1)/n_elements(lon),1)/n_elements(lat))*1e12

  a = where(lev le 100 and lev ge 5)
  suconc = suconc[*,a]
  lev = lev[a]


; Now make a plot
  set_plot, 'ps'
  device, file='plot_suconc.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  red   = [246,208,166,103,54,2,1]
  blue  = [239,209,189,169,144,129]
  green = [247,230,219,207,192,138,80]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  loadct, 0
  levels = [10,15,20,25,30,35,40]
  contour, suconc, indgen(n_elements(nymd)), lev, /nodata, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xminor=2, xticks=8, $
   xtickname=[string(nymd[0:191:24]/10000L,format='(i4)'),' '], $
   ystyle=9, yrange=[100,5],  yticks=4, ytickv=[100,50,20,10,5], $
   ytitle = 'pressure [hPa]', /ylog

  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  contour, suconc, indgen(n_elements(nymd)), lev, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, suconc, indgen(n_elements(nymd)), lev, /nodata, noerase=1, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xminor=2, xticks=8, $
   xtickname=[string(nymd[0:191:24]/10000L,format='(i4)'),' '], $
   ystyle=9, yrange=[100,5], yticks=4, ytickv=[100,50,20,10,5], $
   ytitle = 'pressure [hPa]', /ylog

  makekey, .1, .08, .85, .04, 0., -0.04, color=findgen(7), $
           labels=string([levels],format='(i3)'), align=.5
  xyouts, .525, .01, 'Sulfate Concentration [ng m!E-3!N]', align=.5, /normal
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  makekey, .1, .08, .85, .04, 0., -0.04, color=dcolors, $
           labels=make_array(7,val=''), align=.5

  device, /close

end

