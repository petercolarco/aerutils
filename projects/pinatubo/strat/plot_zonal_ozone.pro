  expid = 'c48F_H43_strat'
  filetemplate = expid+'.geosgcm_diag.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'o3', o3, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat
  nt = n_elements(filename)

; Column integral to DU
  ratmolwght = 48./29.
  o3 = total(o3*delp,3)*ratmolwght/9.81   ; kg m-2
  o3du = o3/.048*6.02e23/2.69e20

; zonal mean and transpose
  o3du = transpose(total(o3du,1)/n_elements(lon))


; Now make a plot
  set_plot, 'ps'
  device, file='plot_zonal_ozone.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=16, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  red   = [246,208,166,103,54,2,1]
  blue  = [239,209,189,169,144,129]
  green = [247,230,219,207,192,138,80]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  loadct, 0
  levels = 150. + findgen(7)*50
  x = findgen(nt)/12.
  xmax = max(x)
  xyrs = n_elements(x)/12
  contour, o3du, 1991.+x, lat, /nodata, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xminor=2, xticks=nt/12., xrange=1991.+[0,nt/12], $
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'

  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  contour, o3du, 1991.+x, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, o3du, 1991.+x, lat, /nodata, noerase=1, $
   position=[.1,.2,.95,.9], $
   xstyle=9, xminor=2, xticks=nt/12., xrange=1991.+[0,nt/12], $
   ystyle=9, yrange=[-90,90], $
   yticks=9, ytitle = 'Latitude'
  xyouts, .1, .92, 'Column Ozone [du]', /normal

  makekey, .1, .08, .85, .04, 0., -0.04, color=findgen(7), $
           labels=['150','200','250','300','350','400','450'], align=0
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  makekey, .1, .08, .85, .04, 0., -0.04, color=dcolors, $
           labels=['','','','','','',''], align=0

  device, /close

end

