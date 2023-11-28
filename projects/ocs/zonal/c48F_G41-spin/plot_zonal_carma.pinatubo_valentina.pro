  expid = 'c48F_G41-pinc'
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xyrs = n_elements(x)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
  xtickname[1:xyrs-1:2] = ' '
  nc4readvar, filename, 'suexttau', su, lon=lon, lat=lat

; zonal mean and transpose
  su = transpose(total(su,1)/n_elements(lon))

  x = x[76:104]
  su = su[76:104,*]
  xm = strmid(nymd,4,2)
  xm = xm[76:104]
  xtickname = xm
  xtickname[1:n_elements(xm)-1:2] = ' '


; Now make a plot
  set_plot, 'ps'
  device, file='plot_zonal_carma.pinatubo_valentina.'+expid+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 3
  levels = [0,3,6,9,12,15,18,21,25,30,40]/100.
  colors = 255-findgen(11)*15
  contour, su, x, lat, /nodata, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xticks=n_elements(xm), $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'

  contour, su, x, lat, /over, $
   levels=levels, c_color=colors, /cell
  contour, su, x, lat, /over, $
   levels=levels

  contour, su, x, lat, /nodata, noerase=1, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xticks=n_elements(xm), $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'
  xyouts, .1, .92, 'Sulfate AOT (Pinatubo/CARMA)', /normal

  makekey, .1, .08, .85, .04, 0., -0.04, color=colors, $
           labels=string(levels,format='(f4.2)'), align=0

  device, /close

end

