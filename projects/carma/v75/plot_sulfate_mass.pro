  expid = 'c90F_pI33p4_ocs'
; Get the sulfate mass loading and AOD
  filetemplate = expid+'.tavg2d_carma_x.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'sucmass', sucmass, lon=lon
  nc4readvar, filename, 'suexttau', suexttau
  nx = n_elements(lon)
  case nx of
   144: grid='b'
   288: grid='c'
   576: grid='d'
  endcase
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  sucm    = aave(sucmass,area)*total(area)/1.e9  ; Tg
  suext   = aave(suexttau,area)


; zonal mean and transpose
  su = transpose(total(sucmass,1)/n_elements(lon))*1.e6


; Now make a plot
  set_plot, 'ps'
  device, file='plot_sulfate_mass.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  if(strpos(expid,'ocs') gt -1) then begin
   levels = findgen(11)*.05
  endif else begin
   levels = findgen(11)*.01
  endelse
  x = indgen(n_elements(nymd))
  xmax = max(x)
  xyrs = n_elements(x)/12
  xtickname = string(nymd[0:xmax:12]/10000L,format='(i4)')
  xtickname[1:xyrs-1:2] = ' '
  contour, su, x, lat, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[-60,60],  yticks=6,  $
   ytitle = 'latitude'

  loadct, 57
  dcolors=indgen(11)*25
  contour, su, x, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, su,x,lat, /nodata, noerase=1, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[0,xmax+1], $
   xtickname=[xtickname,' '], $
   ystyle=9, yrange=[-60,60],  yticks=6, $
   ytitle = 'latitude'

  if(strpos(expid,'ocs') gt -1) then begin
   makekey, .1, .08, .8, .04, 0., -0.04, color=findgen(11), $
            labels=string([levels],format='(f6.4)'), align=0
  endif else begin
   makekey, .1, .08, .8, .04, 0., -0.04, color=findgen(11), $
            labels=string([levels],format='(f4.2)'), align=0
  endelse
  xyouts, .525, .005, 'Zonal Mean Sulfate Mass Loading [mg m!E-2!N]', align=.5, /normal

  loadct, 57
  dcolors=indgen(11)*25
  makekey, .1, .08, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(12,val=''), align=.5

  if(strpos(expid,'ocs') gt -1) then begin
   loadct, 39
   axis, yaxis=1, yrange=[0.14,0.2], ylog=0, ytitle='Sulfate Mass Loading [Tg] / AOD (x 100)', /save
   oplot, x, sucm, thick=6
   oplot, x, 100*suext, thick=6, color=254
;  polyfill, [156,198,198,156,156], [.1425,.1425,.15,.15,.1425], color=255
   xyouts, 158, .1475, '!4Sulfate Mass [Tg]'
   xyouts, 158, .1435, '!4Sulfate AOD (x100)', color=254
  endif else begin
   loadct, 39
   axis, yaxis=1, yrange=[0,10], ylog=0, ytitle='Sulfate Mass Loading [Tg] / AOD (x 100)', /save
   oplot, x, sucm, thick=6
   oplot, x, 100*suext, thick=6, color=254
;  polyfill, [156,198,198,156,156], [.1425,.1425,.15,.15,.1425], color=255
   xyouts, 158, 1, '!4Sulfate Mass [Tg]'
   xyouts, 158, .29, '!4Sulfate AOD (x100)', color=254
  endelse



  device, /close

end

