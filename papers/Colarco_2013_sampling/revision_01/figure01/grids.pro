  set_plot, 'ps'
  device, file='grids.ps', /helvetica, font_size=12, xoff=.5, yoff=.5, xsize=20, ysize=10
  !p.font=0

  map_set, 0, 0, position=[.07,.075,.93,.925], /noborder
  map_grid, /box

  device, /close

end
