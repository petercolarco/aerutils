  expid = 'c48F_G41-nopin'
; Plot the zonal mixing ratio of sulfate over time
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nt = n_elements(nymd)
  nc4readvar, filename, 'suconc', su, lon=lon, lat=lat, lev=lev
  filetemplate = expid+'.geosgcm_surf.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'troppb', tropp

; Form into a zonal mean
  su = reform(total(su,1)/n_elements(lon))*1e12  ; ng m-3
  tropp = reform(total(tropp,1)/n_elements(lon))/100. ; hPa

; Loop and plot
  for i = 0, n_elements(filename)-1 do begin

  set_plot, 'ps'
  device, file='plot_zonal_vertical_carma.clim.'+expid+'.'+strmid(nymd[i],0,6)+'.ps', /color, $
   /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=8
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        xtitle=' ', ytitle=' ', $
        title=' ', $
        xrange=[-90,90], yrange=[400,10], $
        yticks=5, ytickv=[400,200,100,50,20,10], $
        xstyle=9, ystyle=9, /ylog, $
        xticks=6, xtickv=findgen(7)*30-90

  loadct, 56
  colors = 25. + findgen(10)*25
  levels = [10,20,40,80,150,200,500,1000,2000,5000]
  contour, /over, su[*,*,i], lat, lev, levels=levels, /cell
  loadct, 0
  plot, indgen(100), /nodata, /noerase, $
        position=[.15,.25,.95,.9], $
        xtitle='latitude', ytitle='pressure [hPa]', $
        title=strmid(nymd[i],0,6), $
        xrange=[-90,90], yrange=[400,10], $
        xstyle=9, ystyle=9, /ylog, $
        yticks=5, ytickv=[400,200,100,50,20,10], $
        xticks=6, xtickv=findgen(7)*30-90
  oplot, lat, tropp[*,i], thick=3

  xyouts, .15, .12, 'sulfate concentration [ng m-3]', /normal
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=string(levels,format='(i4)')
  loadct, 56
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(9,val='')

  device, /close

  endfor

end
