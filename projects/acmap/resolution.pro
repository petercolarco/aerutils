  set_plot, 'ps'
  device, file='resolution.ps', xoff=.5, yoff=.5, xsize=20, ysize=10
  !p.multi=[0,3,1]

  limit=[29.99,-125,46.01,-109.99]

  map_set, limit=limit, /grid, $
           latdel=.5, londel=0.625, glinethick=1, glinestyle=0, $
           color=160, /noborder
  map_continents, /hires, thick=3
  map_continents, /hires, /usa

  map_set, limit=limit, /grid, $
           latdel=1, londel=1.25, glinethick=1, glinestyle=0, $
           color=160, /noborder, /noerase
  map_continents, /hires, thick=3
  map_continents, /hires, /usa

  !p.multi=[1,3,1]
  map_set, limit=limit, /grid, $
           latdel=2, londel=2.5, glinethick=1, glinestyle=0, $
           color=160, /noborder, /noerase
  map_continents, /hires, thick=3
  map_continents, /hires, /usa

  device, /close

end
