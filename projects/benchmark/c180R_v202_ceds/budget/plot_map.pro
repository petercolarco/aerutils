  pro plot_map, var, position, colort, title, lon, lat, $
                levelarray, colorarray, labelarray, noerase=noerase, align=align

  if(keyword_set(align)) then align=0.5 else align = 0
  area, lon, lat, nx, ny, dx, dy, area
  loadct, 0
  x0 = position[0]
  y0 = position[1]-0.025
  x1 = position[2]
  y1 = position[3]+0.008
  map_set, limit=[-80,0,80,360], position=position, noerase=noerase
  loadct, colort
  plotgrid, var, levelarray, colorarray, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, thick=1.5
  map_set, limit=[-80,0,80,360], position=position, /noerase
  makekey, x0, y0, .45, .02, 0, -0.02, align=align, $
   color=colorarray, label=labelarray
  loadct, colort
  makekey, x0, y0, .45, .02, 0, -0.02, align=align, $
   color=colorarray, label=[' ',' ',' ',' ',' ',' ',' ']
  totem = total(area*var)/1.e12
  totstr = string(totem,format='(i4)')+' Tg yr!E-1!N'
  if(totem lt 10) then totstr = string(totem,format='(f4.1)')+' Tg yr!E-1!N'
  loadct, 0
  xyouts, x0, y1, /normal, title
  xyouts, x1, y1, /normal, totstr, align=1

end
