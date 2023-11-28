  pro plot_aot, filename, str

  print, filename

  nc4readvar, filename, 'carma_suexttau', suF, lon=lon, lat=lat, time=time
  nc4readvar, filename, 'carma_duexttau', duF, lon=lon, lat=lat, time=time

  set_plot, 'ps'
  device, file='plot_aot.'+str+'.ps', /color, /helvetica, font_size=14, $
   xsize=48, ysize=16, xoff=.5, yoff=.5
  !p.font=0
  loadct, 0
  map_set, /cont, position=[.025,.2,.475,.95], limit=[-30,-60,60,180]
  polyfill, [0,.5,.5,0,0], [0,0,.05,.05,0], color=254, /normal
  xyouts, .025, .025, str, /normal
  loadct, 50
  levels = [.1,.2,.3,.4,.5,.6,.7,.8,.9,1]
  colors = findgen(10)*25
  contour, /over, suf[*,*], lon, lat, /cell, lev=levels, c_colors=colors
  loadct, 0
  map_continents, thick=3
  map_grid, /box, thick=1
  makekey, .075, .1, .4, .05, 0, -0.035, colors=colors, $
    labels=string(levels,format='(f4.1)')
  loadct, 50
  makekey, .075, .1, .4, .05, 0, -0.035, colors=colors, labels=[' ',' ']
  

  loadct, 0
  map_set, /cont, position=[.525,.2,.975,.95], limit=[-30,-60,60,180], /noerase
  levels = [.1,.2,.3,.4,.5,.6,.7,.8,.9,1]
  colors = findgen(10)*25
  loadct, 56
  contour, /over, duf[*,*], lon, lat, /cell, lev=levels, c_colors=colors
  loadct, 0
  map_continents, thick=3
  map_grid, /box, thick=1
  makekey, .575, .1, .4, .05, 0, -0.035, colors=colors, $
    labels=string(levels,format='(f4.1)')
  loadct, 56
  makekey, .575, .1, .4, .05, 0, -0.035, colors=colors, labels=[' ',' ']

  device, /close


end
