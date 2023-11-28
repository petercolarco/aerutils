; Make a plot of the time varying zonal mean effective radius versus
; height at a given latitude
  wantlat = -80.
  expid = 'c48F_H43_strat'
  filetemplate = expid+'.tavg3d_carma_v.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  a = where(nymd ge '19910100' and nymd le '20010100')
  nymd = nymd[a]
  filename = filename[a]
  nc4readvar, filename, 'su0', su, /template, wantlat=wantlat, lat=lat, /sum
  nc4readvar, filename, 'rh', rh, wantlat=wantlat
  nc4readvar, filename, 'delp', delp, wantlat=wantlat
  nc4readvar, filename, 'suextcoef', suext, wantlat=wantlat
  nc4readvar, filename, 'airdens', rhoa, wantlat=wantlat
  nt = n_elements(filename)

; Zonal mean
  sucmass = reform(total(total(su*delp/9.81,1)/144.,1))
  aot     = reform(total(total(suext*delp/9.81,1)/144.,1))
  su      = reform(total(su*rhoa,1))/144.
  rh      = reform(total(rh,1))/144.
  suext   = reform(total(suext,1))/144.
  rhoa    = reform(total(rhoa,1))/144.

  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa_
  z = z/1000.
  delz = delz/1000.

  su    = transpose(su*1e9) ; ug kg-1
  suext = transpose(suext)
  rh    = transpose(rh)

  x = findgen(nt)*(1./12.)
  colors = 25. + findgen(9)*25
  set_plot, 'ps'
  device, file='plot_zonal_vertical_carma.'+expid+'.ps', /color, /helvetica, font_size=11, $
   xoff=.5, yoff=.5, xsize=16, ysize=8
  !p.font=0
  loadct, 0
  plot, indgen(100), /nodata, $
        position=[.15,.25,.95,.9], $
        ytitle='Altitude [km]', $
        xrange=1991+[0,nt/12], yrange=[00,30], xstyle=9, ystyle=9, $
        xticks=nt/12, xminor=2
  loadct, 56
  levels = findgen(9)*.01+0.01
;  plotgrid, su, levels, colors, 1991+x, z, 1./12., delz
  contour, su, 1991+x, z, lev=levels, /cell, /over, c_col=colors
  loadct, 0
  contour, rh, 1991+x, z, /over, levels=[0.6], c_col=160, c_thick=3
;  contour, suext*1e6, 1991+x, z, /over, levels=findgen(10)*.1, c_col=40, c_thick=3
  contour, suext*1e6, 1991+x, z, /over, levels=.6, c_col=40, c_thick=3
  plot, indgen(100), /nodata, noerase=1, $
        position=[.15,.25,.95,.9], $
        xrange=1991+[0,nt/12], yrange=[00,30], xstyle=9, ystyle=9, $
        xticks=nt/12, xminor=2
  axis, yaxis=1, yrange=[0,2], /save
  oplot, 1991+x, sucmass*1e6
  oplot, 1991+x, aot*1e3, lin=2

  xyouts, .15, .12, 'Sulfate Mass Concentration [!9m!3g m!E-3!N]', /normal
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=string(levels,format='(f5.2)')
  loadct, 56
  makekey, .15, .06, .8, .05, 0., -.05, align=0, $
           color=colors, labels=make_array(9,val='')

  device, /close

end
