  filetemplate = 'c48_aG40-gcocs-spin.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suexttau', su, lon=lon, lat=lat

; zonal mean and transpose
  su = transpose(total(su,1)/n_elements(lon))


; Now make a plot
  set_plot, 'ps'
  device, file='plot_zonal_gocart.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  red   = [246,208,166,103,54,2,1]
  blue  = [239,209,189,169,144,129]
  green = [247,230,219,207,192,138,80]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  loadct, 0
  levels = [1,1.5,2,2.5,3,4,5]*1e-3
  contour, su, indgen(n_elements(nymd)), lat, /nodata, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xticks=11, $
   xtickname=[string(nymd[0:131:12]/10000L,format='(i4)'),' '], $
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'

  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  contour, su, indgen(n_elements(nymd)), lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, su, indgen(n_elements(nymd)), lat, /nodata, noerase=1, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xticks=11, $
   xtickname=[string(nymd[0:131:12]/10000L,format='(i4)'),' '], $
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'
  xyouts, .1, .92, 'SU/OCS AOT [550 nm] (GOCART, c48_aG40-gcocs-spin)', /normal

  makekey, .1, .08, .85, .04, 0., -0.04, color=findgen(7), $
           labels=['1','1.5','2','2.5','3','3','5'], align=0
  xyouts, .95, .04, 'x10!E-3!N', align=1, /normal
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  makekey, .1, .08, .85, .04, 0., -0.04, color=dcolors, $
           labels=['','','','','','',''], align=0

  device, /close

end

