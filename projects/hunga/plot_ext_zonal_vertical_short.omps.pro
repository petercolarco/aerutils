  expid = 'omps'
  filetemplate = expid+'.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)

  nc4readvar, filename, 'ext869', ext_, lon=lon, lat=lat, lev=lev
  alt = reverse(findgen(41)+.5)
  a = where(ext_ gt 1e14)
  if(a[0] ne -1) then ext_[a] = !values.f_nan

  z = [20,17,13,9]
  ztag = ['20_5','23_5','26_5','30_5']

  for iz = 0,3 do begin


  ext = mean(ext_,dim=1,/nan)
  ext = transpose(reform(ext[*,z[iz],*]))*1e7

  ctab = 39

; Now make a plot
  set_plot, 'ps'
  device, file='plot_ext_zonal_vertical_short.'+expid+'.'+ztag[iz]+'km.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x0 = 12
  x = indgen(n_elements(nymd))+1
  xmax = 30
  contour, ext, x, lat, /nodata, $
   position=[.1,.25,.9,.95], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[x0,xmax+1], $
;   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

  loadct, ctab
  dcolors = findgen(11)*20+25
  levels = [0.0001,0.0002,0.0005,0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2]*1000
  contour, ext, x, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, ext, x, lat, /nodata, noerase=1, $
   position=[.1,.25,.9,.95], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[x0,xmax+1], $
;   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude', xtitle='Day of Year'

  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string(levels,format='(f5.1)'), align=0
  xyouts, .525, .01, 'OMPS-LP v20 Extinction @ '+$
    ztag[iz]+' km [10!E4!N km!E-1!N, 869 nm]', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(11,val=''), align=.5

  device, /close


  endfor

end
