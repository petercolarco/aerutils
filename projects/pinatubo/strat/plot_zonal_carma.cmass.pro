  expid = 'c48F_H43_strat'
  filetemplate = expid+'.tavg2d_carma.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sucmass', su, lon=lon, lat=lat

; zonal mean and transpose
  su = transpose(total(su,1)/n_elements(lon))*1e6


; Now make a plot
  set_plot, 'ps'
  device, file='plot_zonal_carma.cmass.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  red   = [246,208,166,103,54,2,1]
  blue  = [239,209,189,169,144,129]
  green = [247,230,219,207,192,138,80]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  loadct, 0
  levels = findgen(7)*.15+.15
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xyrs = n_elements(x)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
  xtickname[1:xyrs-1:2] = ' '
  contour, su, x, lat, /nodata, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xminor=2, xticks=nt/12., xrange=1991.+[0,nt/12], $
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'

  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  contour, su, indgen(n_elements(nymd)), lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, su, 1991.+x, lat, /nodata, noerase=1, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xminor=2, xticks=nt/12., xrange=1991.+[0,nt/12], $
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'
  xyouts, .1, .92, 'SU/OCS Sulfate Column mass [mg m!E-2!N]', /normal

  makekey, .1, .08, .85, .04, 0., -0.04, color=findgen(7), $
           labels=['0.15','0.3','0.45','0.6','0.75','0.9','1.05'], align=0
;  xyouts, .95, .04, 'x10!E-3!N', align=1, /normal
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  makekey, .1, .08, .85, .04, 0., -0.04, color=dcolors, $
           labels=['','','','','','',''], align=0

  device, /close

end

