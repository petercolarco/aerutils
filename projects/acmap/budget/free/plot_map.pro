; caller for plotting a robinson projection map given colors, levels,
; variables, coordinates, etc.

  pro plot_map, varval, lon, lat, dx, dy, levels, colors, position, mapcolor, $
                p0=p0, p1=p1, limits=limits, title=title, $
                textcolor=textcolor, varunits=varunits, format=format, $
                varsum=varsum, varscale=varscale

  if(not(keyword_set(p0))) then p0 = 0
  if(not(keyword_set(p1))) then p1 = 0
  if(not(keyword_set(limits))) then limits = [-90,-180,90,180]

  map_set, p0, p1, position=position, /noborder, $
           limit=limits, /robinson, /iso, /noerase
  plotgrid, varval, levels, colors, lon, lat, dx, dy, /map
  map_continents, color=mapcolor, thick=3
  map_continents, color=mapcolor, thick=1, /countries
  map_set, p0, p1, position = position, /noborder, $
           limit=limits, /robinson, /iso, /noerase, $
           /horizon, /grid, glinestyle=0, color=mapcolor, glinethick=2

; If a title is provided write it and value at top of map
  if(keyword_set(title)) then begin
   if(not(keyword_set(varunits))) then varunits = ''
   if(not(keyword_set(format))) then format='(f5.3)'
   area, lon, lat, nx, ny, dx, dy, area
   if(not(keyword_set(varscale))) then varscale = 1.
   if(keyword_set(varsum)) then begin
    mval  = string(total(varval*area)*varscale,format=format)+varunits
   endif else begin
    mval  = string(aave(varval*varscale,area,/nan),format=format)+varunits
   endelse
   diff = position[2]-position[0]
   xyouts, position[0]+diff/10, position[3]-.075, title, color=textcolor, $
           /normal, align=0, charsize=.8
   xyouts, position[2]-diff/10, position[3]-.075, mval, color=textcolor, $
           /normal, charsize=.8, align=1
  endif


  end
