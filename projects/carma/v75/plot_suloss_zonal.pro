  expid = 'c90F_pI33p9_sulf'
  filetemplate = expid+'.tavg2d_aer_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
;  nc4readvar, filename, ['susv','suwt','sudp','susd'], ext, lon=lon, lat=lat, /sum
  nc4readvar, filename, ['susv003','suwt003','sudp003','susd003'], ext, lon=lon, lat=lat, /sum
;  nc4readvar, filename, 'suexttau', suext, lon=lon, lat=lat
; Compute global mean
  area, lon, lat, nx, ny, dx, dy, area
  sucm    = aave(ext,area)*total(area)/1.e9 * 30 *86400  ; Tg mon-1
;  suext   = aave(suext,area)
  ext = transpose(mean(ext,dim=1,/nan)) * 1e6 * 30*86400.

; Now make a plot
  set_plot, 'ps'
  device, file='plot_suloss_zonal.'+filetemplate+'.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  levels = [.1,.2,.5,1,2,5,10]
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xyrs = n_elements(x)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
;  xtickname[1:xyrs-1:2] = ' '
  contour, ext, x, lat, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

  loadct, 52
  dcolors = findgen(7)*40
  contour, ext, x, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, ext, x, lat, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[-90,90],  yticks=6, $
   ytitle = 'latitude'

   loadct, 39
   axis, yaxis=1, yrange=[0,6], ylog=0, $
    ytitle='Sulfate Mass Loss [Tg mon!E-1!N]', /save
   oplot, x, sucm, thick=6
 


  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(7), $
           labels=string(levels,format='(f5.2)'), align=0
  xyouts, .525, .01, 'Sulfate Column Loss [mg m!E-2!N mon!E-1!N]', align=.5, /normal
  loadct, 52
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(8,val=''), align=.5

  device, /close

end
