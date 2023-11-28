  expid = 'c48F_G41-pin'
  filetemplate = expid+'.p.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910500' and nymd le '19931000')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, ['totexttau','suexttauvolc'], su, lon=lon, lat=lat, /sum

  x = indgen(n_elements(nymd))
  xmax = max(x)
  xtickname = ['May','Jul','Sep','Nov','1992','Mar',$
               'May','Jul','Sep','Nov','1993','Mar','May','Jul','Sep']

; zonal mean and transpose
  su = transpose(total(su,1)/n_elements(lon))

; Now make a plot
  set_plot, 'ps'
  device, file='plot_zonal_gocart.pinatubo_valentina.all.'+expid+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=18, ysize=7.2, xoff=.5, yoff=.5
  !p.font=0

  loadct, 3
  levels = [0,3,6,9,12,15,18,21,25,30,40]/100.
  colors = 255-findgen(11)*15
  contour, su, x, lat, /nodata, $
   position=[.15,.2,.95,.9], $
   xstyle=9, xminor=2, xrange=[0,xmax], $
   xtickname=make_array(n_elements(xtickname),val=' '), xticks=14,$
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'

  contour, su, x, lat, /over, $
   levels=levels, c_color=colors, /cell
  contour, su, x, lat, /over, $
   levels=levels

  contour, su, x, lat, /nodata, noerase=1, $
   position=[.15,.2,.95,.9], $
   xstyle=9, xminor=2, xrange=[0,xmax], $
   xtickname=xtickname, xticks=14,$
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'
;  xyouts, .15, .92, 'Sulfate AOT (Pinatubo)', /normal

  makekey, .15, .06, .8, .04, 0., -0.05, color=colors, $
           labels=string(levels,format='(f4.2)'), align=0

  device, /close

end

