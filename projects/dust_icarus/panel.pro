; Colarco, April 2011
; IDL version of grads xycomp function

  pro panel,  var1, var2, var3, var4, var5, var6, x, y, lon, lat, dx, dy, $
              colortable=colortable, colors=colors, levels=levels, $
              labelarray=labelarray, $
              dcolortable=dcolortable, dcolors=dcolors, dlevels=dlevels, $
              dlabelarray=dlabelarray, du_src=du_src, $
              geolimits=geolimits, diff=diff, position=position, $
              title0 = title0, title1 = title1, title2=title2, title3=title3

  if(not(keyword_set(colortable))) then colortable=39
  if(not(keyword_set(dcolortable))) then dcolortable=39
  if(not(keyword_set(geolimits))) then geolimits=[-90,-180,90,180]
  if(not(keyword_set(levels))) then levels=findgen(11)*.05
;  levels[0] = 0.001
  if(not(keyword_set(colors))) then $
                     colors = [30,64,80,96,144,176,192,199,208,254,10]
  if(not(keyword_set(dlevels))) then $
                     dlevels = [-5,-.25,-.2,-.15,-.1,-.05,.05,.1,.15,.2,.25]
  if(not(keyword_set(dcolors))) then $
                     dcolors = [64,80,96,144,176,255,192,199,208,254,10]

  p0 = 0
  p1 = 0
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.

;  Create a cool - warm color table
   ncolor = n_elements(dlevels)
   red    = fltarr(ncolor)
   green  = fltarr(ncolor)
   blue   = fltarr(ncolor)
;  find levels lt 0
   a = where(dlevels lt 0)
   n = n_elements(a)
   blue[0:n-1] = 255
   green[0:n-1] = findgen(n)/(n)*255
   green[n-1] = 255
   red[n-1] = 255
   nt = ncolor-n
   red[n:ncolor-1] = 255
   green[n:ncolor-1] = reverse(findgen(nt)/(nt)*255)
   red = [0,red]
   blue = [0,blue]
   green = [0,green]
   tvlct, red, green, blue
   dcolors=indgen(ncolor)+1


; Plot var1-var2
  position1 = [.05,.68,.95,.93]
  if(keyword_set(position)) then position1=position[*,0]
  map_set, p0, p1, position=position1, /noborder, limit=geolimits, /noerase
; plot missing data as light shade
  loadct, 0
  plotgrid, var6, [1000], [200], lon, lat, dx, dy, /map, /missing
;  Create a cool - warm color table
   ncolor = n_elements(dlevels)
   red    = fltarr(ncolor)
   green  = fltarr(ncolor)
   blue   = fltarr(ncolor)
;  find levels lt 0
   a = where(dlevels lt 0)
   n = n_elements(a)
   blue[0:n-1] = 255
   green[0:n-1] = findgen(n)/(n)*255
   green[n-1] = 255
   red[n-1] = 255
   nt = ncolor-n
   red[n:ncolor-1] = 255
   green[n:ncolor-1] = reverse(findgen(nt)/(nt)*255)
   red = [0,red]
   blue = [0,blue]
   green = [0,green]
   tvlct, red, green, blue
   dcolors=indgen(ncolor)+1
  plotgrid, var1-var2, dlevels, dcolors, lon, lat, dx, dy, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position1, limit=geolimits
  map_grid, /box
  if(keyword_set(title1)) then xyouts, position1[0], .95, title1, /normal

  if(keyword_set(title0)) then xyouts, position1[0], 0.98, title0, /normal, charsize=1.2

  if(keyword_set(du_src)) then begin
   filen = '/share/colarco/fvInput/AeroCom/sfc/gocart.dust_source.v5a_1x1inp.x360_y181.nc'
   nc4readvar, filen, 'du_src', du_src, lon=lon_s, lat=lat_s
   contour, /overplot, du_src, lon_s, lat_s, thick=2, lev=findgen(8)*.1, color=160
  endif
  if(x[0] ne -1) then begin
   nx = n_elements(lon)
   ny = n_elements(lat)
   x_ = x
   y_ = y
   lon_ = lon
   lat_ = lat
;  coarsen up the winds if resolution is too high
   if(n_elements(lon) eq 576) then begin
    lon_ = lon_[0:nx-1:4]
    lat_ = lat_[0:ny-1:4]
    x_   = x_[0:nx-1:4,0:ny-1:4]
    y_   = y_[0:nx-1:4,0:ny-1:4]
   endif
   velovect, x_, y_, lon_, lat_, /over, length=3, thick=3
  endif
; Plot var3-var4
  position2 = [.05,.37,.95,.62]
  if(keyword_set(position)) then position2=position[*,1]
  map_set, p0, p1, position=position2, /noborder, limit=geolimits, /noerase
; plot missing data as light shade
  loadct, 0
  plotgrid, var6, [1000], [200], lon, lat, dx, dy, /map, /missing
;  Create a cool - warm color table
   ncolor = n_elements(dlevels)
   red    = fltarr(ncolor)
   green  = fltarr(ncolor)
   blue   = fltarr(ncolor)
;  find levels lt 0
   a = where(dlevels lt 0)
   n = n_elements(a)
   blue[0:n-1] = 255
   green[0:n-1] = findgen(n)/(n)*255
   green[n-1] = 255
   red[n-1] = 255
   nt = ncolor-n
   red[n:ncolor-1] = 255
   green[n:ncolor-1] = reverse(findgen(nt)/(nt)*255)
   red = [0,red]
   blue = [0,blue]
   green = [0,green]
   tvlct, red, green, blue
   dcolors=indgen(ncolor)+1
  plotgrid, var3-var4, dlevels, dcolors, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position2, limit=geolimits
  map_grid, /box
  if(keyword_set(title2)) then xyouts, position1[0], .64, title2, /normal

  if(keyword_set(du_src)) then begin
   contour, /overplot, du_src, lon_s, lat_s, thick=2, lev=findgen(8)*.1, color=160
  endif

;  makekey, .9, .4, .035, .5, 0.038, 0, color=colors, label=labelarray, $
;   align=0, /orient

; Plot var5-var6
  position3 = [.05,.06,.95,.31]
  if(keyword_set(position)) then position3=position[*,2]
  map_set, p0, p1, position=position3, /noborder, limit=geolimits, /noerase
; plot missing data as light shade
  loadct, 0
  plotgrid, var6, [1000], [200], lon, lat, dx, dy, /map, /missing
;  Create a cool - warm color table
   ncolor = n_elements(dlevels)
   red    = fltarr(ncolor)
   green  = fltarr(ncolor)
   blue   = fltarr(ncolor)
;  find levels lt 0
   a = where(dlevels lt 0)
   n = n_elements(a)
   blue[0:n-1] = 255
   green[0:n-1] = findgen(n)/(n)*255
   green[n-1] = 255
   red[n-1] = 255
   nt = ncolor-n
   red[n:ncolor-1] = 255
   green[n:ncolor-1] = reverse(findgen(nt)/(nt)*255)
   red = [0,red]
   blue = [0,blue]
   green = [0,green]
   tvlct, red, green, blue
   dcolors=indgen(ncolor)+1
  plotgrid, var5-var6, dlevels, dcolors, lon, lat, dx, dy, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position3, limit=geolimits
  map_grid, /box
  if(keyword_set(title3)) then xyouts, position1[0], .33, title3, /normal

  if(keyword_set(du_src)) then begin
   contour, /overplot, du_src, lon_s, lat_s, thick=2, lev=findgen(8)*.1, color=160
  endif

  if(not(keyword_set(dlabelarray))) then begin
   dlabelarray = string(dlevels,format='(f5.2)')
   dlabelarray[0] = ''
  endif

  if(not(keyword_set(labelarray))) then begin
   labelarray = string(levels,format='(f5.2)')
   labelarray[0] = ''
  endif
nokey = 0

  if(not(nokey)) then begin
   ix = 0.05
   dx = 0.8
   if(keyword_set(position)) then ix = position[0,0]
   if(keyword_set(position)) then dx = position[2,0]-position[0,0]
   makekey, ix, .025, dx, .015, 0, -.02, color=dcolors, label=dlabelarray, $
    align=.5
  endif

  loadct, colortable

end
