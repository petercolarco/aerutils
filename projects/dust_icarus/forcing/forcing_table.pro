  new    = 'c180F_pI20p1-acma_spher'
  gocart = 'c180F_pI20p1-acma_gocart'
  old    = 'c180F_pI20p1-acma'
  none   = 'c180F_pI20p1-acma_nodu'

  fn_new    = '/misc/prc18/colarco/'+new+'/geosgcm_surf/'+new+ $
              '.geosgcm_surf.monthly.clim.ANN.nc4'
  fn_gocart = '/misc/prc18/colarco/'+gocart+'/geosgcm_surf/'+gocart+ $
              '.geosgcm_surf.monthly.clim.ANN.nc4'
  fn_old    = '/misc/prc18/colarco/'+old+'/geosgcm_surf/'+old+ $
              '.geosgcm_surf.monthly.clim.ANN.nc4'
  fn_none   = '/misc/prc18/colarco/'+none+'/geosgcm_surf/'+none+ $
              '.geosgcm_surf.monthly.clim.ANN.nc4'


; Get LW
  nc4readvar, fn_new, 'olr', olr_new, lon=lon, lat=lat
  nc4readvar, fn_new, 'olrna', olrna_new, lon=lon, lat=lat
  nc4readvar, fn_gocart, 'olr', olr_gocart, lon=lon, lat=lat
  nc4readvar, fn_gocart, 'olrna', olrna_gocart, lon=lon, lat=lat
  nc4readvar, fn_old, 'olr', olr_old, lon=lon, lat=lat
  nc4readvar, fn_old, 'olrna', olrna_old, lon=lon, lat=lat
  nc4readvar, fn_none, 'olr', olr_none, lon=lon, lat=lat
  nc4readvar, fn_none, 'olrna', olrna_none, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  lw_new    = aave(-( (olr_new-olrna_new) - (olr_none-olrna_none)),area)
  lw_gocart = aave(-( (olr_gocart-olrna_gocart) - (olr_none-olrna_none)),area)
  lw_old    = aave(-( (olr_old-olrna_old) - (olr_none-olrna_none)),area)

; Get SW
  nc4readvar, fn_new, 'swtnet', swtnet_new, lon=lon, lat=lat
  nc4readvar, fn_new, 'swtnetna', swtnetna_new, lon=lon, lat=lat
  nc4readvar, fn_gocart, 'swtnet', swtnet_gocart, lon=lon, lat=lat
  nc4readvar, fn_gocart, 'swtnetna', swtnetna_gocart, lon=lon, lat=lat
  nc4readvar, fn_old, 'swtnet', swtnet_old, lon=lon, lat=lat
  nc4readvar, fn_old, 'swtnetna', swtnetna_old, lon=lon, lat=lat
  nc4readvar, fn_none, 'swtnet', swtnet_none, lon=lon, lat=lat
  nc4readvar, fn_none, 'swtnetna', swtnetna_none, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
  sw_new    = aave(( (swtnet_new-swtnetna_new) - (swtnet_none-swtnetna_none)),area)
  sw_gocart = aave(( (swtnet_gocart-swtnetna_gocart) - (swtnet_none-swtnetna_none)),area)
  sw_old    = aave(( (swtnet_old-swtnetna_old) - (swtnet_none-swtnetna_none)),area)

  print, sw_gocart, sw_new, sw_old
  print, lw_gocart, lw_new, lw_old
  print, sw_gocart+lw_gocart, sw_new+lw_new, sw_old+lw_old


  set_plot, 'ps'
  device, file='forcing_table.ps', /helvetica, font_size=12, /color, $
   xoff=.5, yoff=.5, xsize=16, ysize=7
  !p.font=0

  loadct, 39

  plot, indgen(10), /nodata, $
   xrange=[0,12], xticks=1, xtickn=[' ',' '], xstyle=1, $
   yrange=[-.6,.4], yticks=5, ytitle='Global dust DRE at TOA [W m!E-2!N]', $
   ystyle=1

; SW
  loadct, 68
  x = 1
  y = sw_gocart
  polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=10
  plots, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], thick=6, color=0

  x = 2
  y = sw_new
  polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=40
  plots, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], thick=6, color=0

  x = 3
  y = sw_old
  polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=70
  plots, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], thick=6, color=0

; LW
  loadct, 68
  x = 5
  y = lw_gocart
  polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=245
  plots, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], thick=6, color=255

  x = 6
  y = lw_new
  polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=215
  plots, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], thick=6, color=255

  x = 7
  y = lw_old
  polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=185
  plots, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], thick=6, color=255


; SW+LW
  loadct, 70
  x = 9
  y = sw_gocart+lw_gocart
  polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=10
  plots, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], thick=6, color=0

  x = 10
  y = sw_new+lw_new
  polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=40
  plots, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], thick=6, color=0

  x = 11
  y = sw_old+lw_old
  polyfill, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], color=70
  plots, x+[-.5,.5,.5,-.5,-.5], [0,0,y,y,0], thick=6, color=0

  loadct, 0
  plots, [0,12], [0,0], thick=3
  plots, [4,4], [.4,-.6], thick=3, lin=2
  plots, [8,8], [.4,-.6], thick=3, lin=2
  xyouts, 2, .05, 'SW', align=.5
  xyouts, 6, -.1, 'LW', align=.5
  xyouts, 10, .05, 'Total', align=.5

  device, /close

end
