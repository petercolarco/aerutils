; Colarco, April 2011
; IDL version of grads xycomp function

  pro xycomp, var1, var2, lon, lat, dx, dy, $
              colortable=colortable, colors=colors, levels=levels, $
              dcolortable=dcolortable, dcolors=dcolors, dlevels=dlevels, $
              dlabelarray=dlabelarray, $
              geolimits=geolimits, diff=diff, nomap=nomap, $
              p0 = p0, p1 = p1

  if(not(keyword_set(colortable))) then colortable=39
  if(not(keyword_set(dcolortable))) then dcolortable=72
  if(not(keyword_set(geolimits))) then geolimits=[-90,-180,90,180]
  if(not(keyword_set(levels))) then levels=findgen(11)*.05
;  levels[0] = 0.001
  if(not(keyword_set(colors))) then $
                     colors = [30,64,80,96,144,176,192,199,208,254,10]
  if(not(keyword_set(dlevels))) then $
                     dlevels = [-5,-.25,-.2,-.15,-.1,-.05,.05,.1,.15,.2,.25]
  if(not(keyword_set(dcolors))) then $
                     dcolors = reverse(indgen(11)*25)
  if(not(keyword_set(nomap))) then nomap = 0

  if(n_elements(p0) eq 0) then p0 = 0.
  if(n_elements(p1) eq 0) then p1 = 0.


; Plot var1
  position1 = [.05,.7,.85,.95]
  map_set, p0, p1, position=position1, /noborder, limit=geolimits, /iso, /stereo
; plot missing data as light shade
  loadct, 0
  plotgrid, var1, [-.1], [120], lon, lat, dx, dy, /map, /missing
; plot data
  loadct, colortable
  plotgrid, var1, levels, colors, lon, lat, dx, dy, /map
  loadct, 0
  if(not(nomap)) then begin
   map_continents, color=120, thick=3
   map_continents, color=120, thick=1, /countries
   map_set, p0, p1, /noerase, position = position1, limit=geolimits, $
    /iso, /stereo, londel=20,latdel=20
  endif

; Plot var2
  position2 = [.05,.38,.85,.63]
  map_set, p0, p1, position=position2, /noborder, limit=geolimits, /noerase, /iso, /stereo
; plot missing data as light shade
  loadct, 0
  plotgrid, var2, [-.1], [120], lon, lat, dx, dy, /map, /missing
; plot data
  loadct, colortable
  plotgrid, var2, levels, colors, lon, lat, dx, dy, undef=!values.f_nan, /map
  loadct, 0
  if(not(nomap)) then begin
   map_continents, color=120, thick=3
   map_continents, color=120, thick=1, /countries
   map_set, p0, p1, /noerase, position = position2, limit=geolimits, $
    /iso, /stereo, londel=20,latdel=20
  endif

; Difference
  loadct, 0
  position3 = [.05,.06,.85,.31]
  if(not(keyword_set(diff))) then diff = var1-var2
  diff_ = diff
  diff_[*] = 0.
  map_set, p0, p1, position=position3, /noborder, limit=geolimits, /noerase, /iso, /stereo
; plot missing data as light shade
  loadct, 0
  plotgrid, diff_, [-.1], [120], lon, lat, dx, dy, /map
; plot data
  loadct, dcolortable
  nokey = 0
  if(n_elements(dlevels) eq 1) then begin
   nokey = 1
   dcolors=[75,255,254]
   dlevels=[-100.,-0.01,dlevels[0]]
  endif
  plotgrid, diff, dlevels, dcolors, lon, lat, dx, dy, /map
  loadct, 0
  if(not(nomap)) then begin
   map_continents, color=120, thick=3
   map_continents, color=120, thick=1, /countries
   map_set, p0, p1, /noerase, position = position3, limit=geolimits, $
    /iso, /stereo, londel=20,latdel=20
  endif

  if(keyword_set(dlabelarray)) then begin
   labelarray = dlabelarray
  endif else begin
   format = '(f5.2)'
   if(isa(dlevels,/integer)) then format='(i3)'
   labelarray = string(dlevels,format=format)
   labelarray[0] = ''
  endelse
nokey = 0
  if(not(nokey)) then begin
   loadct, 0
   makekey, .05, .025, .8, .015, 0, -.02, color=dcolors, label=labelarray, $
    align=.5
   loadct, dcolortable
   makekey, .05, .025, .8, .015, 0, -.02, color=dcolors, $
    label=make_array(n_elements(dcolors),val=' '), $
    align=.5
  endif

  format = '(f5.2)'
  if(isa(levels,/integer)) then format='(i3)'
  labelarray = string(levels,format=format)
  loadct, 0
  makekey, .9, .4, .035, .5, 0.038, 0, $
   color=make_array(n_elements(levels),val=255), label=labelarray, $
   align=0, /orient
  loadct, colortable
  makekey, .9, .4, .035, .5, 0.038, 0, color=colors, $
   label=make_array(n_elements(levels),val=' '), $
   align=0, /orient

end
