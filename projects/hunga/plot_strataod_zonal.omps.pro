  expid = 'omps'
  filetemplate = expid+'.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)

  nc4readvar, filename, 'ext869', ext_, lon=lon, lat=lat, lev=lev
  nc4readvar, filename, 'troph', troph, lon=lon, lat=lat, lev=lev
  alt = reverse(findgen(41)+.5)
  a = where(ext_ gt 1e14)
  if(a[0] ne -1) then ext_[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)
  nt = n_elements(nymd)
  saod_ = make_array(nx,ny,nt,val=!values.f_nan)

  for it = 0, nt-1 do begin
   for iy = 0, ny-1 do begin
    for ix = 0, nx-1 do begin
     a = where(alt-.5 ge troph[ix,iy,it])
     if(a[0] ne -1) then saod_[ix,iy,it] = total(ext_[ix,iy,a,it],/nan)*1000.
    endfor
   endfor
  endfor

  saod = mean(saod_,dim=1,/nan)
  saod = transpose(reform(saod[*,*]))*1000 ; scaled

  ctab = 39

; Now make a plot
  set_plot, 'ps'
  device, file='plot_strataod_zonal.'+expid+'.ps', $
   /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  x0 = 12
  x = indgen(n_elements(nymd))+1
  xmax = max(x)
  contour, saod, x, lat, /nodata, $
   position=[.1,.25,.9,.95], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[x0,xmax+1], $
;   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-80,40],  yticks=6, $
   ytitle = 'latitude'

  loadct, ctab
  dcolors = findgen(11)*20+25
  levels = findgen(11)*3.
  contour, saod, x, lat, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, saod, x, lat, /nodata, noerase=1, $
   position=[.1,.25,.9,.95], $
   xstyle=1, xminor=2, xticks=xyrs, xrange=[x0,xmax+1], $
;   xtickname=[xtickname,' '], $
   ystyle=1, yrange=[-80,40],  yticks=6, $
   ytitle = 'latitude', xtitle='Day of Year'

  makekey, .1, .09, .8, .04, 0., -0.04, color=findgen(11), $
           labels=string(levels,format='(f5.1)'), align=0
  xyouts, .525, .01, 'OMPS-LP v20 Stratospheric AOD'+$
    ' [x10!E3!N, 869 nm]', align=.5, /normal
  loadct, ctab
  makekey, .1, .09, .8, .04, 0., -0.04, color=dcolors, $
           labels=make_array(11,val=''), align=.5

  device, /close


end
