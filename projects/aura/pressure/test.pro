  result = hist_2d(aidiff,pdiff,min1=-3.,min2=-200.,max1=3.,max2=200.,bin1=.05,bin2=2.)

  plotfile = 'aidiff_hist2d.pomi.L2.ps'

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  plot, findgen(10), /nodata, $
   position=[.15,.25,.9,.95], $
   xrange=[-2,2], yrange=[-150,150], $
   xtitle='OMAERUV - MERRAero AI Difference', $
        ytitle='OMAERUV - MERRAero!CSurface Pressure Difference [hPa]', $
        charsize=.75

  x = -3 + findgen(121)*.05
  y = -200. + findgen(201)*2.
  dx = .05
  dy = 2.
  loadct, 74
  level = [10,20,50,100,200,500,1000,2000,5000,10000,20000,50000]
  color = findgen(12)*23
  plotgrid, result, level, color, x, y, dx, dy
;  contour, /overplot, result, x, y, lev=level, /fill
  
a = where(abs(aidiff) gt 0.2)
print, n_elements(aidiff), n_elements(a), float(n_elements(a))/float(n_elements(aidiff))
  loadct, 0
  labels = ['10','20','50','100','200','500','1000','2000','5000','10000','20000','50000']
  makekey, .2, .08, .65, .05, 0, -0.035, $
           charsize=.5, align=0, colors=make_array(12,val=0), $
           labels=labels, /noborder
  xyouts, .525, .015, /normal, 'Frequency', $
   charsize=.75, align=.5

  loadct, 74
  labels = make_array(12,val=' ')
  makekey, .2, .08, .65, .05, 0, -0.035, $
           charsize=.75, align=0, colors=color, $
           labels=labels, /noborder

  device, /close
  

end
