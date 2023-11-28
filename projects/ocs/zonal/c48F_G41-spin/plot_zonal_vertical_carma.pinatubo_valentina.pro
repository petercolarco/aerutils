  expid = 'c48F_G41-pinc'
; Plot the zonal mixing ratio of sulfate over time
  filename = '/misc/prc14/colarco/'+expid+'/tavg3d_carma_p/'+expid+'.tavg3d_carma_p.monthly.199112.nc4'
  nc4readvar, filename, 'su', su, lon=lon, lat=lat, lev=lev, nymd=nymd
  nc4readvar, filename, 'airdens', rhoa, lon=lon, lat=lat, lev=lev

; Form into a zonal mean
  su = reform(total(su,1)/n_elements(lon))*1e9  ; ug m-3

; Loop and plot
  set_plot, 'ps'
  device, file='plot_zonal_vertical_carma.pinatubo_valentina.'+expid+'.'+strmid(nymd,0,6)+'.ps', /color, $
   /helvetica, font_size=10, $
   xoff=.5, yoff=.5, xsize=10, ysize=8
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        xtitle=' ', ytitle=' ', $
        title=' ', $
        xrange=[-90,90], yrange=[1000,1], $
        xstyle=9, ystyle=9, /ylog, $
        yticks=9, ytickv=[1000,500,200,100,50,20,10,5,2,1], $
        xticks=6, xtickv=findgen(7)*30-90

  loadct, 56
  colors = 25. + findgen(9)*25
  levels = [0,1,2,5,10,20,50,100,200]
  contour, /over, su[*,*], lat, lev, levels=levels, /cell
  contour, /over, su[*,*], lat, lev, levels=levels, c_color=255
  loadct, 0
  plot, indgen(100), /nodata, /noerase, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='pressure [hPa]', $
        title=strmid(nymd,0,6)+' sulfate mixing ratio [ug kg!E-1!N]' , $
        xrange=[-90,90], yrange=[1000,1], $
        xstyle=9, ystyle=9, /ylog, $
        yticks=9, ytickv=[1000,500,200,100,50,20,10,5,2,1], $
        xticks=6, xtickv=findgen(7)*30-90

  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=string(levels,format='(i4)')
  loadct, 56
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(9,val='')

  device, /close

end
