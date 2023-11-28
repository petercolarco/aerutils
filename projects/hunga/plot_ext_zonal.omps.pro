  expid = 'omps'
  filetemplate = expid+'.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)

  for it = 0, n_elements(nymd)-1 do begin

  nc4readvar, filename[it], 'ext869', ext, lon=lon, lat=lat, lev=lev
  alt = reverse(findgen(41)+.5)
  a = where(ext gt 1e14)
  if(a[0] ne -1) then ext[a] = !values.f_nan
  ext = mean(ext,dim=1,/nan)
  ext = (reform(ext))*1e7

  ctab = 39

; Now make a plot
  set_plot, 'ps'
  device, file='plot_ext_zonal.'+expid+'.'+nymd[it]+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=20, ysize=16, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x = indgen(n_elements(nymd))
  xmax = max(x)
  contour, ext, lat, alt, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[-50,10], $
;   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[16,36],  $
   ytitle = 'altitude [km]'

  loadct, ctab
  dcolors = findgen(11)*20+25
  levels = [0.0001,0.0002,0.0005,0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2]*1000
  contour, ext, lat, alt, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, ext, lat, alt, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[-50,10], $
;   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[16,36], $
   ytitle = 'altitude [km]'

  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string(levels,format='(f5.1)'), align=0
  xyouts, .525, .01, 'OMPS-LP v20 Extinction @ '+$
    nymd[it]+', [10!E4!N km!E-1!N, 869 nm]', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(11,val=''), align=.5

  device, /close

endfor

end
