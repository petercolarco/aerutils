  expid = 'c48F_H43_pinatubo15+sulfate'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', su, lon=lon, lat=lat
  nt = n_elements(filename)

; zonal mean and transpose
  su = transpose(total(su,1)/n_elements(lon))


; Now make a plot
  set_plot, 'ps'
  device, file='plot_zonal_carma.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  red   = [246,208,166,103,54,2,1]
  blue  = [239,209,189,169,144,129]
  green = [247,230,219,207,192,138,80]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  loadct, 0
  levels = [.01,.02,.05,.1,.15,.2,.25]
  x = findgen(nt)/12.
  xmax = max(x)
  xyrs = n_elements(x)/12
  contour, su,  1991.+x, lat, /nodata, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xminor=2, xticks=nt/12., xrange=1991.+[0,nt/12], $
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'

  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  contour, su, 1991.+x, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, su, 1991.+x, lat, /nodata, noerase=1, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xminor=2, xticks=nt/12., xrange=1991.+[0,nt/12], $
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'
  xyouts, .1, .92, 'SU AOT [550 nm]', /normal

  makekey, .1, .08, .85, .04, 0., -0.04, color=findgen(7), $
           align=0, $
           labels=['0.01','0.02','0.5','0.1','0.15','0.2','0.25']
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  makekey, .1, .08, .85, .04, 0., -0.04, color=dcolors, $
           labels=['','','','','','',''], align=0

  device, /close

end

