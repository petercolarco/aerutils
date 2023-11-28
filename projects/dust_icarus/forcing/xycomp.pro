; Colarco, April 2011
; IDL version of grads xycomp function

  pro xycomp, var1, var2, lon, lat, dx, dy, $
              colortable=colortable, colors=colors, levels=levels, $
              labelarray=labelarray, $
              dcolortable=dcolortable, dcolors=dcolors, dlevels=dlevels, $
              dlabelarray=dlabelarray, $
              geolimits=geolimits, diff=diff, $
              title0=title0, title1 = title1, title2=title2, difftitle=difftitle, $
              contour1=contour1, contour2=contour2, clevs=clevs, position=position

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
  position1 = [.05,.68,.85,.93]
  if(keyword_set(position)) then position1 = position[*,0]
  map_set, p0, p1, position=position1, /noborder, limit=geolimits
; plot missing data as light shade
  loadct, 0
  plotgrid, var1, [1000.], [200], lon, lat, dx, dy, /map, /missing
; plot data
  loadct, colortable
  plotgrid, var1, levels, colors, lon, lat, dx, dy, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  if(keyword_set(contour1)) then contour, /overplot, contour1, lon, lat, $
           thick=2, lev=findgen(8)*.1, color=0, c_label=make_array(8,val=1)
  map_set, p0, p1, /noerase, position = position1, limit=geolimits
  map_grid, /box
  if(keyword_set(title1)) then xyouts, position1[0], .95, title1, /normal
  if(keyword_set(title0)) then xyouts, position1[0], 0.98, title0, /normal, charsize=1.2

; Plot var2
  position2 = [.05,.37,.85,.62]
  if(keyword_set(position)) then position2 = position[*,1]
  map_set, p0, p1, position=position2, /noborder, limit=geolimits, /noerase
; plot missing data as light shade
  loadct, 0
  plotgrid, var2, [1000.], [200], lon, lat, dx, dy, /map, /missing
; plot data
  loadct, colortable
  plotgrid, var2, levels, colors, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  if(keyword_set(contour2)) then contour, /overplot, contour2, lon, lat, $
           thick=2, lev=findgen(8)*.1, color=0, c_label=make_array(8,val=1)
  map_set, p0, p1, /noerase, position = position2, limit=geolimits
  map_grid, /box
  if(keyword_set(title2)) then xyouts, position2[0], .64, title2, /normal

  ix_ = 0.9
  dx_ = 0.035
  if(keyword_set(position)) then ix_ = 1.05*position1[2]
  if(keyword_set(position)) then dx_ = .05*position1[2]
  makekey, ix_, .4, dx_, .5, 1.25*dx_, 0, color=colors, label=labelarray, $
   align=0, /orient

; Difference
  loadct, 0
  position3 = [.05,.06,.85,.31]
  if(keyword_set(position)) then position3 = position[*,2]
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
  endelse

  plotgrid, diff, dlevels, dcolors, lon, lat, dx, dy, /map
  map_continents, color=0, thick=5
;  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position3, limit=geolimits
  map_grid, /box
  if(keyword_set(difftitle)) then xyouts, position3[0], .33, difftitle, /normal

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
