; Read the post processed SO2 file and make a plot on a map
  openr, lun, 'out_so2.txt', /get_lun
  data = fltarr(7,126)
  readf, lun, data
  free_lun, lun
  lat = data[0,*]
  lon = data[1,*]
  so2 = data[2,*]*3.*3600.*2.  ; kg SO2
  h   = data[4,*]/1000.        ; m

  set_plot, 'ps'
  device, file='plot_so2.so2du.ps', /color, /helvetica, $
   font_size=14, xsize=16, ysize=14
  !p.font=0
  loadct, 0
  map_set, limit=[45,150,55,170], position=[.1,.2,.9,.9]
  map_continents, /hires, /coasts, fill_continents=1, color=200
  loadct, 39
;  levels = [1,2,5,10,20,50]
  levels = [5,10,20,50,100,200]
  colors = [64,112,160,192,208,254]
  for i = 0, 125 do begin
   so2_ = so2[i]/1.e6
   so2_ = so2[i]/(50.e3*50.e3)/0.064*6.022e23/2.6867e20
print, so2_
   a = where(levels lt so2_)
   if(a[0] ne -1) then begin
    color = colors[max(a)]
    polyfill, lon[i]+[-.25,.25,.25,-.25,-.25], $
              lat[i]+[-.25,-.25,.25,.25,-.25], color=color
   endif
  endfor
  loadct, 0
  map_continents, /hires, /coasts, fill_continents=1, color=200
  map_continents, /hires, color=120, thick=3
  map_grid, /box

  plots, 153.25, 48.2, psym=sym(13)

  loadct, 39
  makekey, .15, .08, .7, .05, 0, -0.05, colors=colors, $
   labels=[5,10,20,50,100,200], align=0

  device, /close



  set_plot, 'ps'
  device, file='plot_so2.h.ps', /color, /helvetica, $
   font_size=14, xsize=16, ysize=14
  !p.font=0
  loadct, 0
  map_set, limit=[45,150,55,170], position=[.1,.2,.9,.9]
  map_continents, /hires, /coasts, fill_continents=1, color=200
  loadct, 39
  levels = findgen(19)+1.-0.01
  colors = findgen(19)*14
  for i = 0, 125 do begin
   h_ = h[i]
   a = where(levels lt h_)
   if(a[0] ne -1) then begin
    color = colors[max(a)]
    polyfill, lon[i]+[-.25,.25,.25,-.25,-.25], $
              lat[i]+[-.25,-.25,.25,.25,-.25], color=color
   endif
  endfor
  loadct, 0
  map_continents, /hires, /coasts, fill_continents=1, color=200
  map_continents, /hires, color=120, thick=3
  map_grid, /box

  plots, 153.25, 48.2, psym=sym(13)

  loadct, 39
  makekey, .15, .08, .7, .05, 0, -0.025, colors=colors, $
   labels=string(indgen(19)+1,format='(i2)'), align=0, charsize=.5

  device, /close


end
