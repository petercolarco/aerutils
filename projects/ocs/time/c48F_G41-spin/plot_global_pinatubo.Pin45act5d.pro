; Make a plot of the Pinatubo resulting AOD using Valentina's
; paper as a template

; Valentina's member plot
  expid = 'Pin45act5d'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, 'suexttau', suexttau_pin45, lon=lon, lat=lat


; Global area average
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  suext_pin45  = aave(suexttau_pin45,area)

  set_plot, 'ps'
  device, file='plot_global_pinatubo.'+expid+'.ps', $
    /helvetica, font_size=12, /color, $
    xsize=18, ysize=7.2, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xtickname = ['May','Jul','Sep','Nov','1992','Mar',$
               'May','Jul','Sep','Nov','1993','Mar','May','Jul','Sep']
  plot, x, suext_pin45, /nodata, $
   position=[.15,.2,.85,.9], $
   xstyle=1, xminor=2, xrange=[0,xmax], $
   xtickname=[xtickname], xticks=14,$
   ystyle=1, yrange=[0,0.25], $
   yticks=5, ytitle = 'AOT'

  red   = [0,228,55,77,152]
  green = [0,26,126,175,78]
  blue  = [0,28,184,74,163]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  oplot, x, suext_pin45, thick=6, color=0

  device, /close

end
