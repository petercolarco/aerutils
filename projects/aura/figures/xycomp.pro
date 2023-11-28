; Colarco, April 2011
; IDL version of grads xycomp function

  pro xycomp, var1, var2, lon, lat, dx, dy, $
              colortable=colortable, colors=colors, levels=levels, $
              dcolortable=dcolortable, dcolors=dcolors, dlevels=dlevels, $
              labelarray=labelarray, $
              dlabelarray=dlabelarray, $
              geolimits=geolimits, diff=diff

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
  loadct, 0
  position1 = [.05,.7,.85,.95]
  map_set, p0, p1, position=position1, /noborder, limit=geolimits, e_horizon={fill:1,color:200}
; plot data
  loadct, colortable
  plotgrid, var1, levels, colors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, color=0, thick=2

; Plot var2
  loadct, 0
  position2 = [.05,.38,.85,.63]
  map_set, p0, p1, position=position2, /noborder, limit=geolimits, e_horizon={fill:1,color:200}, /noerase
; plot data
  loadct, colortable
  plotgrid, var2, levels, colors, lon, lat, dx, dy, undef=!values.f_nan, /map
  loadct, 0
  map_continents, color=0, thick=3

; Difference
  loadct, 0
  position3 = [.05,.06,.85,.31]
  if(not(keyword_set(diff))) then diff = var1-var2
  diff_ = diff
  diff_[*] = 0.
  map_set, p0, p1, position=position3, /noborder, limit=geolimits, e_horizon={fill:1,color:200}, /noerase
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
  map_continents, color=0, thick=3

; Difference key
  loadct, 0
  makekey, .05, .025, .8, .015, 0, -.02, $
   color=make_array(n_elements(dlevels),val=255), label=dlabelarray, $
   align=.5, charsize=.75
  loadct, dcolortable
  makekey, .05, .025, .8, .015, 0, -.02, $
   color=dcolors, label=make_array(n_elements(dlevels),val=' '), $
   align=.5, charsize=.75


; Main key
  loadct, 0
  makekey, .9, .4, .035, .5, 0.038, 0, $
   color=make_array(n_elements(levels),val=255), label=labelarray, $
   align=0, charsize=.75, /orient
  loadct, colortable
  makekey, .9, .4, .035, .5, 0.038, 0, $
   color=colors, label=make_array(n_elements(levels),val=' '), $
   align=0, charsize=.75, /orient




;  makekey, .9, .4, .035, .5, 0.038, 0, color=colors, label=labelarray, $
;   align=0, /orient

end
