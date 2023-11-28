; Plot depol along some orbit track
  lambda = '532'
  version = 'v11'
  filename = './output/data/dR_MERRA-AA-r2.calipso_'+lambda+'nm-'+version+'.20090715.nc'

; Read
  depol = 1
  extinction = 1
  aback = 1
  read_curtain, filename, lon, lat, time, z, dz, extinction_tot = depol

; select
  a = where(lon lt 2.08 and lon gt -12.9 and $
            lat lt 57.30 and lat gt 8.88 and $
            time-time[0] lt .5)

  lon = lon[a]
  lat = lat[a]
  time = time[a]
  z  = z[*,a]
  dz = dz[*,a]
  depol = depol[*,a]

  datestr = strcompress(string(time[0],format='(i8)'),/rem)

  plotfile = 'extinction.'+lambda+'nm-'+version+'.ps'

  nt = n_elements(time)

  z  = transpose(z) /  1000. ; km
  dz = transpose(dz) / 1000. ; km
    
    

; Transpose arrays to be (time,hght)
  depol = transpose(depol)

; Put time into hour of day
  time = (time - long(time))*24.

  set_plot, 'ps'
  device, file=plotfile, /helvetica, font_size=14, /color, xsize=24, ysize=12
  !p.font=0

  position = [.1,.2,.95,.9]
  b = where(time lt time[0])
  if(b[0] ne -1) then time[b] = time[b]+24.
  plot, indgen(n_elements(time)), /nodata, $
;   xrange=[time[0],time[nt-1]], xtitle='Hour of Day', xstyle=1, $
   xrange=[time[0],time[nt-1]], xstyle=1, xticks=1, xtickname = [' ', ' '], $
   yrange=[0,30], ytitle='altitude [km]', $
   position=position, $
   title = 'Extinction ('+version+') [km-1]', charsize=.75
  nlon = n_elements(lon)
  for ilon = 0, nlon-1, 10 do begin
   str = string(lat[ilon],format='(f6.2)')
   xyouts, time[ilon], -1.5, str, align=.5, charsize=.75
   str = string(lon[ilon],format='(f6.2)')
   xyouts, time[ilon], -3, str, align=.5, charsize=.75
   str = string(time[ilon],format='(f5.2)')
   xyouts, time[ilon], -4.5, str, align=.5, charsize=.75
  endfor
  xyouts, 2.51, -1.5, 'Lat', charsize=.75
  xyouts, 2.51, -3.0, 'Lon', charsize=.75
  xyouts, 2.51, -4.5, 'Hour', charsize=.75
  loadct, 39
  levelarray = findgen(60)*.005
  colorarray = findgen(60)*4+16
  plotgrid, depol, levelarray, colorarray, $
            time, z, time[1]-time[0], dz
  labelarray = strarr(60)
  labels = [0., 0.05,0.1,0.15,0.2,0.25]
  for il = 0, n_elements(labels)-1 do begin
   for ia = n_elements(levelarray)-1, 0, -1 do begin
    if(levelarray[ia] ge labels[il]) then a = ia
   endfor
   labelarray[a] = string(labels[il],format='(f5.3)')
  endfor
  polyfill, [.13,.47,.47,.13,.13],[.75,.75,.85,.85,.75], color=255, /normal  
  makekey, .15, .8, .3, .035, 0, -.035, color=colorarray, $
   label=labelarray, $
   align=.5, /no, charsize=.75

   loadct, 0
   dxplot = position[2]-position[0]
   dyplot = position[3]-position[1]
   x0 = position[0]+.75*dxplot
   x1 = position[0]+.95*dxplot
   y0 = position[1]+.65*dyplot
   y1 = position[1]+.95*dyplot
   polyfill, [x0,x1,x1,x0,x0], [y0,y0,y1,y1,y0], color=255, /normal
   map_set, /noerase, position=[x0,y0,x1,y1], limit=[0,-25,60,40]
   map_continents, thick=.5
   oplot, lon, lat, thick=6
 
  device, /close


end
