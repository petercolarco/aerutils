  loadct, 39
  colors = findgen(8)*35

  set_plot, 'ps'
  device, file='plot_argos.ps', /color, /helvetica, font_size=14, $
   xsize=16, ysize=24
  !p.font=0

  for i = 0,7 do begin
   if(i eq 0) then begin
    !p.multi=[0,2,4]
    map_set, /cont, title=i
   endif else begin
    !p.multi = [8-i,2,4]
    map_set, /cont, /noerase, title=i
   endelse

   filename = 'argos'+string(i+1,format='(i1)')+'.csv'
   read_argos, filename, lon, lat, time, sza
   a = where(sza gt 88.)
   if(a[0] ne -1) then lon[a] = !values.f_nan
   if(a[0] ne -1) then lat[a] = !values.f_nan
   plots, lon, lat, thick=3, color=colors[i]
endfor

  device, /close
end
