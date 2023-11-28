; Pull the model output and make a plot of the extinction (integrated)
; and height of top (n%) of plume

  wantlon = [-180,-60]
  wantlat = [40,90]

  for wanttime = 2, 47 do begin
;  for wanttime = 25, 25 do begin

  ddf = 'aer.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename=filename[wanttime]
  nc4readvar, filename, ['TOTBRCEC'], brc, /sum, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nc4readvar, filename, 'h', z, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nc4readvar, filename, 'troppb', troppb, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nc4readvar, filename, 'troppt', troppt, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nc4readvar, filename, 'troppv', troppv, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  nt = n_elements(filename)

  ddf = 'ze.ddf'
  ga_times, ddf, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  filename=filename[wanttime]
  nc4readvar, filename, 'he', ze, $
   wantlat=wantlat, wantlon=wantlon, lon=lon, lat=lat
  dz = ze[*,*,0:71]-ze[*,*,1:72]

; Integrate the extinction at heights above 6 km
  aot = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    a = where(ze[ix,iy,*]/1000. gt 6.)
    a = a[0:n_elements(a)-2]
    aot[ix,iy] = total(brc[ix,iy,a]*dz[ix,iy,a])
   endfor
  endfor

; Now find the altitude at which the integrated extinction (top down)
; exceeds n% of the total
  nfrac = 0.1
  alt = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    aot_ = 0.
    for iz = 0, 71 do begin
     aot_ = aot_ + brc[ix,iy,iz]*dz[ix,iy,iz]
     if(aot_ gt nfrac*aot[ix,iy]) then alt[ix,iy] = ze[ix,iy,iz-1]/1000.
     if(aot_ gt nfrac*aot[ix,iy]) then break
    endfor
   endfor
  endfor
; discard points where aot too low
  a = where(aot lt 0.1)
  if(a[0] ne -1) then alt[a] = !values.f_nan

  set_plot, 'ps'
  device, file='plot_height.'+strmid(strmid(filename,17,/rev),0,14)+'.ps', $
   /color, /helvetica, font_size=14, xsize=24, ysize=12
  !p.font=0
  
  position1 = [.05,.2,.45,.9]
  geolimits=[40,-160,90,-40]
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  map_set, 0,0, position=position1, /noborder, limit=geolimits
  loadct, 56
  levels = [0.1,0.2,0.4,0.8,1.6,2.4,3.2,4,4.8,5.6]
  colors = findgen(10)*25
  plotgrid, aot, levels, colors, lon, lat, dx, dy, /map
  loadct, 39
  map_continents, /hires
  map_grid, /box
  makekey, 0.05, 0.08, 0.4, 0.05, 0, -0.03, align=0, chars=0.75, $
           colors=colors, labels=string(levels,format='(f3.1)')
  loadct, 56
  makekey, 0.05, 0.08, 0.4, 0.05, 0, -0.03, align=0, chars=0.75, $
           colors=colors, labels=make_array(n_elements(levels),val=' ')

  
  position2 = [.55,.2,.95,.9]
  geolimits=[40,-160,90,-40]
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  map_set, 0,0, position=position2, /noborder, limit=geolimits, /noerase
  loadct, 39
  levels = [6,8,10,11,12,12.5,13,13.5,14,15]
  colors = [0,32,48,80,112,128,176,192,208,254]
  plotgrid, alt, levels, colors, lon, lat, dx, dy, /map
  loadct, 0
  map_continents, /hires
  map_grid, /box
  makekey, 0.55, 0.08, 0.4, 0.05, 0, -0.03, align=0, chars=0.75, $
           colors=colors, labels=string(levels,format='(f4.1)')
  loadct, 39
  makekey, 0.55, 0.08, 0.4, 0.05, 0, -0.03, align=0, chars=0.75, $
           colors=colors, labels=make_array(n_elements(levels),val=' ')
  device, /close

  endfor
  
end
