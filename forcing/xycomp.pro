; Colarco, April 2011
; IDL version of grads xycomp function

  pro xycomp, var1, var2, lon, lat, dx, dy, $
              colortable=colortable, colors=colors, levels=levels, $
              labelarray=labelarray, $
              dcolortable=dcolortable, dcolors=dcolors, dlevels=dlevels, $
              dlabelarray=dlabelarray, $
              geolimits=geolimits, diff=diff, $
              title1 = title1, title2=title2, difftitle=difftitle

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

; Plot var1
  position1 = [.05,.7,.85,.95]
  map_set, p0, p1, position=position1, /noborder, limit=geolimits
; plot missing data as light shade
  loadct, 0
  plotgrid, var1, [1000.], [200], lon, lat, dx, dy, /map, /missing
; plot data
  loadct, colortable
  plotgrid, var1, levels, colors, lon, lat, dx, dy, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position1, limit=geolimits
  map_grid, /box
  if(keyword_set(title1)) then xyouts, .05, .98, title1, /normal

; Plot var2
  position2 = [.05,.38,.85,.63]
  map_set, p0, p1, position=position2, /noborder, limit=geolimits, /noerase
; plot missing data as light shade
  loadct, 0
  plotgrid, var2, [1000.], [200], lon, lat, dx, dy, /map, /missing
; plot data
  loadct, colortable
  plotgrid, var2, levels, colors, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position2, limit=geolimits
  map_grid, /box
  if(keyword_set(title2)) then xyouts, .05, .65, title2, /normal

  makekey, .9, .4, .035, .5, 0.038, 0, color=colors, label=labelarray, $
   align=0, /orient

; Difference
  loadct, 0
  position3 = [.05,.06,.85,.31]
  if(not(keyword_set(diff))) then diff = var1-var2
  diff_ = diff
  diff_[*] = 0.
  map_set, p0, p1, position=position3, /noborder, limit=geolimits, /noerase
; plot missing data as light shade
  loadct, 0
  plotgrid, diff_, [-1000], [200], lon, lat, dx, dy, /map

; plot data
  if(n_elements(dlevels) eq 1) then begin
   loadct, 39
   nokey = 1
   dcolors=[75,255,254]
   dlevels=[-100.,-0.01,dlevels[0]]
  endif else begin
;  Create a cool - warm color table
   ncolor = n_elements(dlevels)
   red    = fltarr(ncolor)
   green  = fltarr(ncolor)
   blue   = fltarr(ncolor)
;  find levels lt 0
   a = where(dlevels lt 0)
   n = n_elements(a)
   blue[0:n] = 255
   green[0:n-1] = findgen(n)/(n)*255
   green[n] = 255
   red[n] = 255
   nt = ncolor-n-1
   red[n+1:ncolor-1] = 255
   green[n+1:ncolor-1] = reverse(findgen(nt)/(nt-1)*255)
   red = [0,red]
   blue = [0,blue]
   green = [0,green]
   tvlct, red, green, blue
   dcolors=indgen(ncolor)+1
  endelse

  plotgrid, diff, dlevels, dcolors, lon, lat, dx, dy, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position3, limit=geolimits
  map_grid, /box
  if(keyword_set(difftitle)) then xyouts, .05, .33, difftitle, /normal

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
   makekey, .05, .025, .8, .015, 0, -.02, color=dcolors, label=dlabelarray, $
    align=.5
  endif

  loadct, colortable

end
