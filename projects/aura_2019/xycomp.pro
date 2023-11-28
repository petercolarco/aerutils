; Colarco, April 2011
; IDL version of grads xycomp function

  pro xycomp, var1, var2, lon, lat, dx, dy, $
              colortable=colortable, colors=colors, levels=levels, $
              labels=labels, $
              dcolortable=dcolortable, dcolors=dcolors, dlevels=dlevels, $
              dlabelarray=dlabelarray, $
              geolimits=geolimits, diff=diff, nomap=nomap, contour=contour, $
              plon=plon, plat=plat, experimentstr1=experimentstr1, $
              experimentstr2=experimentstr2, diffstr=diffstr, titlestr=titlestr, $
              conta=conta, contb=contb

  if(not(keyword_set(colortable))) then colortable=39
  if(not(keyword_set(dcolortable))) then dcolortable=72
  if(not(keyword_set(geolimits))) then geolimits=[-90,-180,90,180]
  if(not(keyword_set(levels))) then levels=findgen(11)*.05
;  levels[0] = 0.001
  if(not(keyword_set(colors))) then $
                     colors = [30,64,80,96,144,176,192,199,208,254,10]
  if(not(keyword_set(dlevels))) then $
                     dlevels = [-5,-.25,-.2,-.15,-.1,-.05,.05,.1,.15,.2,.25]
  if(not(keyword_set(dcolors))) then $                     dcolors = reverse(indgen(11)*25)
  if(not(keyword_set(nomap))) then nomap = 0

  p0 = 0
  p1 = 0
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.

; Plot var1
  position1 = [.1,.69,.82,.94]
  map_set, p0, p1, position=position1, /noborder, limit=geolimits
; plot missing data as light shade
  loadct, 0
  plotgrid, var1, [-.1], [200], lon, lat, dx, dy, /map, /missing
; plot data
  loadct, colortable
  if(keyword_set(contour)) then begin
   contour, /overplot, var1, lon, lat, levels=levels, c_colors=colors, /cell
  endif else begin
   plotgrid, var1, levels, colors, lon, lat, dx, dy, /map
  endelse
  loadct, 0
  if(not(nomap)) then begin
   map_continents, color=80, thick=5
   map_continents, color=80, thick=1, /countries
   map_set, p0, p1, /noerase, position = position1, limit=geolimits
   map_grid, /box
  endif
  if(keyword_set(conta)) then begin
   contour, /overplot, conta, lon, lat, levels=findgen(4)*.2+.2, color=255, thick=4, c_label=[1,1,1,1]
  endif
  if(keyword_set(experimentstr1)) then begin
    polyfill, [.13,.5,.5,.13,.13], [.695,.695,.717,.717,.695] , color=255, /normal
    xyouts, -16,-38, experimentstr1
  endif
  


  if(keyword_set(plon) and keyword_set(plat)) then plots, plon, plat, psym=sym(1), noclip=0, symsize=1.5

; Plot var2
  position2 = [.1,.38,.82,.63]
  map_set, p0, p1, position=position2, /noborder, limit=geolimits, /noerase
; plot missing data as light shade
  loadct, 0
  plotgrid, var2, [-.1], [200], lon, lat, dx, dy, /map, /missing
; plot data
  loadct, colortable
  if(keyword_set(contour)) then begin
   contour, /overplot, var2, lon, lat, levels=levels, c_colors=colors, /cell
  endif else begin
   plotgrid, var2, levels, colors, lon, lat, dx, dy, /map
  endelse
  loadct, 0
  if(not(nomap)) then begin
   map_continents, color=80, thick=5
   map_continents, color=80, thick=1, /countries
   map_set, p0, p1, /noerase, position = position2, limit=geolimits
   map_grid, /box
  endif
  if(keyword_set(contb)) then begin
   contour, /overplot, contb, lon, lat, levels=findgen(4)*.2+.2, color=255, thick=4, c_label=[1,1,1,1]
  endif
  if(keyword_set(experimentstr2)) then begin
    polyfill, [.13,.5,.5,.13,.13], [.695,.695,.717,.717,.695]-.31 , color=255, /normal
    xyouts, -16,-38, experimentstr2
  endif else begin
 
    polyfill, [.13,.2,.2,.13,.13], [.695,.695,.717,.717,.695]-.31 , color=255, /normal
    xyouts, -16,-38, 'OMI'
  endelse
  if(keyword_set(plon) and keyword_set(plat)) then plots, plon, plat, psym=sym(1), noclip=0, symsize=1.5

; Difference
  loadct, 0
  position3 = [.1,.07,.82,.32]
  if(not(keyword_set(diff))) then diff = var1-var2
  diff_ = diff
  diff_[*] = 0.
  map_set, p0, p1, position=position3, /noborder, limit=geolimits, /noerase
; plot missing data as light shade
  loadct, 0
  plotgrid, diff_, [-.1], [200], lon, lat, dx, dy, /map
; plot data
  loadct, dcolortable
  nokey = 0
  if(n_elements(dlevels) eq 1) then begin
   nokey = 1
   dcolors=[75,255,254]
   dlevels=[-100.,-0.01,dlevels[0]]
  endif
  if(keyword_set(contour)) then begin
   contour, /overplot, diff, lon, lat, levels=dlevels, c_colors=dcolors, /cell
  endif else begin
   plotgrid, diff, dlevels, dcolors, lon, lat, dx, dy, /map
  endelse
  loadct, 0
  if(not(nomap)) then begin
   map_continents, color=80, thick=5
   map_continents, color=80, thick=1, /countries
   map_set, p0, p1, /noerase, position = position3, limit=geolimits
   map_grid, /box
  endif
 if(keyword_set(diffstr)) then begin
    polyfill, [.13,.5,.5,.13,.13], [.695,.695,.717,.717,.695]-.62 , color=255, /normal
    xyouts, -16,-38, diffstr
 endif else begin
    polyfill, [.13,.28,.28,.13,.13], [.695,.695,.717,.717,.695]-.62 , color=255, /normal
    xyouts, -16,-38, 'Model - OMI'
  endelse
  if(keyword_set(plon) and keyword_set(plat)) then plots, plon, plat, psym=sym(1), noclip=0, symsize=1.5

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
   makekey, .1, .025, .72, .015, 0, -.02, color=dcolors, label=labelarray, $
    align=.5
   loadct, dcolortable
   makekey, .1, .025, .72, .015, 0, -.02, color=dcolors, $
    label=make_array(n_elements(dcolors),val=' '), $
    align=.5
  endif

  format = '(f5.2)'
  if(isa(levels,/integer)) then format='(i3)'
  labelarray = string(levels,format=format)
  if(keyword_set(labels)) then labelarray = labels
  align=0
;  if(labelarray[0] eq ' ') then align=0.5
  loadct, 0
  makekey, .9, .4, .035, .5, 0.038, 0, $
   color=make_array(n_elements(levels),val=255), label=labelarray, $
   align=align, /orient
  loadct, colortable
  makekey, .9, .4, .035, .5, 0.038, 0, color=colors, $
   label=make_array(n_elements(levels),val=' '), $
   align=align, /orient


  loadct, 0
  if(keyword_set(titlestr)) then xyouts, .1, .97, titlestr, charsize=1.5, /normal

end
