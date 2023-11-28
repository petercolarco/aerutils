  loadct, 39
  colors = findgen(8)*35

  set_plot, 'ps'
  device, file='plot_argos.2.ps', /color, /helvetica, font_size=14, $
   xsize=16, ysize=12
  !p.font=0
  map_set, /cont

  for i = 0,7 do begin

   filename = 'argos'+string(i+1,format='(i1)')+'.csv'
   read_argos, filename, lon_, lat_, time, sza_
   a = where(sza_ gt 88.)
   if(a[0] ne -1) then lon_[a] = !values.f_nan
   if(a[0] ne -1) then lat_[a] = !values.f_nan
   if(i eq 0) then begin
    lon = fltarr(n_elements(lon_),8)
    lat = fltarr(n_elements(lon_),8)
    sza = fltarr(n_elements(lon_),8)
   endif
   lon[*,i] = lon_
   lat[*,i] = lat_
   sza[*,i] = sza_

  endfor

  flag = intarr(n_elements(time))
  for i = 0, n_elements(time)-1 do begin
   a = where(sza[i,*] gt 88.)
   if(a[0] eq -1) then flag[i] = 1
  endfor

  a = where(flag eq 1)
  b = indgen(16)
  for i = 0, 7 do begin

   plots, lon[a[b],i], lat[a[b],i], thick=3, color=colors[i]
  endfor

  device, /close
end
