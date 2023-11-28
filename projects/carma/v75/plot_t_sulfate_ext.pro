  expid = 'c90F_pI33p4_ocs'
  filetemplate = expid+'.geosgcm_prog.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'u', u, lon=lon, lat=lat, lev=lev, wantlat=[-2,2]

; zonal mean and transpose
  u = transpose(total(total(u,1)/n_elements(lon),1)/n_elements(lat))

  a = where(lev le 100 and lev ge 10)
  u = u[*,a]
  lev = lev[a]


; Now make a plot
  set_plot, 'ps'
  device, file='plot_qbo_sulfate_ext.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  red   = [5,33,67,146,209,247,253,244,214,178,103]
  green = [48,102,147,197,229,247,219,165,96,24,0]
  blue  = [97,172,195,222,240,247,199,130,77,43,31]
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))

  loadct, 0
  levels = [-50,-40,-30,-20,-10,-5,5,10,20,30,40]
  x = indgen(n_elements(nymd))
  xmax = max(x)
;xmax = 131 ; end of 1990
  xyrs = n_elements(x)/12
;xyrs = (xmax+1)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
  xtickname[1:xyrs-1:2] = ' '
  contour, u, x, lev, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[100,10],  yticks=7, ytickv=[100,70,50,40,30,20,15,10], $
   ytitle = 'pressure [hPa]', /ylog

  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  contour, u, indgen(n_elements(nymd)), lev, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, u, x, lev, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[100,10],  yticks=7, ytickv=[100,70,50,40,30,20,15,10], $
   ytitle = 'pressure [hPa]', /ylog

  makekey, .1, .08, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string([levels,50],format='(i3)'), align=.5
  xyouts, .525, .01, 'u-wind component [m s!E-1!N]', align=.5, /normal
  tvlct, red, green, blue
  dcolors=indgen(n_elements(red))
  makekey, .1, .08, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(12,val=''), align=.5

; Get the sulfate mass loading and AOD
  filetemplate = expid+'.tavg3d_carma_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'suextcoef', suext, lon=lon, lat=lat, lev=lev, wantlat=[5,10], wantlev=[10.]
  nc4readvar, filename, 'suconc', suconc, lon=lon, lat=lat, lev=lev, wantlat=[5,10], wantlev=[10.]
; zonal mean and transpose and units to km-1
  suext = transpose(total(total(suext,1)/n_elements(lon),1)/n_elements(lat))*1000.
  suconc = transpose(total(total(suconc,1)/n_elements(lon),1)/n_elements(lat))

  filetemplate = expid+'.tavg3d_aer_p.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
;  nc4readvar, filename, 'suextcoef', suext_, lon=lon, lat=lat, lev=lev, wantlat=[5,10], wantlev=[10.]
; zonal mean and transpose and units to km-1
;  suext_ = transpose(total(total(suext_,1)/n_elements(lon),1)/n_elements(lat))*1000.

  if(strpos(expid,'ocs') gt -1) then begin
   loadct, 39
   axis, yaxis=1, yrange=[0,1], ylog=0, $
    ytitle='Sulfate Extinction Coefficient [10!E4!N km!E-1!N]!CSulfate Concentration [10!E11!N kg m!E-3!N]', /save
   oplot, x, suext*1e4, thick=6, color=254
   oplot, x, suconc*1e11, thick=6, color=0
;   oplot, x, suext_*1e4, thick=6, color=0
;  polyfill, [156,198,198,156,156], [.1425,.1425,.15,.15,.1425], color=255
;   xyouts, 200, .1475, '!4Sulfate Mass [Tg]'
   xyouts, 200, 0.85, '!4Sulfate Concentration (CARMA)'
   xyouts, 200, 0.79, '!4Sulfate Extinction (CARMA)', color=254
  endif else begin
   loadct, 39
   axis, yaxis=1, yrange=[0,10], ylog=0, ytitle='Sulfate Extinction Coefficient [km!E-1!N]', /save
;   oplot, x, sucm, thick=6
   oplot, x, suext, thick=6, color=254
;  polyfill, [156,198,198,156,156], [.1425,.1425,.15,.15,.1425], color=255
;   xyouts, 200, 2, '!4Sulfate Mass [Tg]'
   xyouts, 200, 1.29, '!4Sulfate AOD (x100)', color=254
  endelse

  device, /close

; make a second plot of the mass extinction efficiency
  set_plot, 'ps'
  device, file='plot_qbo_sulfate_ext.mee.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0
  loadct, 39
  plot, x, suext/suconc/1000., /nodata, $
   position=[.1,.2,.9,.9], $
   title = 'Sulfate Mass Extinction Efficiency (CARMA) [m!E2!N kg!E-1!N]', $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[0,5000],  yticks=10
  oplot, x, suext/suconc/1000., thick=6
  axis, yaxis=1, yrange=[0,1], ylog=0, $
   ytitle='Sulfate Extinction Coefficient [10!E4!N km!E-1!N]!CSulfate Concentration [10!E11!N kg m!E-3!N]', /save
  oplot, x, suext*1e4, thick=6, color=254
  oplot, x, suconc*1e11, thick=6, color=84
  xyouts, 150, 0.9, '!4Sulfate Concentration (CARMA)', color=84
  xyouts, 150, 0.84, '!4Sulfate Extinction (CARMA)', color=254

  device, /close

end

