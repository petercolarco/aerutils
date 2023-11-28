; Barbados location
  wantlon = [-59.5,-35]
  wantlat = [13.,-8]

; Get the MERRA2 file template (monthly means)
  filetemplate = 'd5124_m2_jan79.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
; Pick off the "Junes"
  a = where(long(nymd)/10000L ge 2001 and long(nymd)/10000L le 2016 and $
            long(nymd-long(nymd)/10000L*10000L)/100L eq 3)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, 'duexttau', duext, time=time, lon=lon, lat=lat

; Form the mean
  duext_mean = mean(duext,dimension=3)

; Find the grid boxes where all mean AOT > 0.1
  thresh = 0.1
  nx = n_elements(lon)
  ny = n_elements(lat)
  duall = fltarr(nx,ny)
  duhalf = fltarr(nx,ny)
  dumost = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    if(n_elements(where(duext[ix,iy,*] gt thresh)) eq n_elements(a)) then $
     duall[ix,iy] = 1.
    if(n_elements(where(duext[ix,iy,*] gt thresh)) gt n_elements(a)/2) then $
     duhalf[ix,iy] = 1.
    if(n_elements(where(duext[ix,iy,*] gt thresh)) gt n_elements(a)*.75) then $
     dumost[ix,iy] = 1.
   endfor
  endfor

; Make a plot
  set_plot, 'ps'
  device, file='tropatl_duexttau.march.ps', /helvetica, font_size=12, $
   /color, xoff=.5, yoff=.5, xsize=18, ysize=16
  !p.font=0

  map_set, limit=[-10,-100,30,0], $
   position=[.05,.2,.95,.95]
  contour, duext_mean, lon, lat, /nodata, /overplot, $
   xrange=[-100,0], yrange=[-10,30]
  loadct, 3
  levels = findgen(11)*.05
  colors = 255-findgen(11)*20
  contour, duext_mean, lon, lat, /overplot, $
   levels=levels, c_color=colors, /cell
  map_continents, /hires
  map_grid, /box

  makekey, .05, .1, .9, .05, 0, -.025, $
   color=colors, align=0, label=string(levels,format='(f4.2)')

  plots, wantlon, wantlat, psym=sym(1)

  device, /close


  device, file='tropatl_duexttau.thresh.march.ps', /helvetica, font_size=12, $
   /color, xoff=.5, yoff=.5, xsize=18, ysize=16
  !p.font=0

  map_set, limit=[-10,-100,30,0], $
   position=[.05,.2,.95,.95]
  contour, duext_mean, lon, lat, /nodata, /overplot, $
   xrange=[-100,0], yrange=[-10,30]
  loadct, 3
  levels = findgen(11)*.05
  colors = 255-findgen(11)*20
  contour, duext_mean, lon, lat, /overplot, $
   levels=levels, c_color=colors, /cell
  makekey, .05, .1, .9, .05, 0, -.025, $
   color=colors, align=0, label=string(levels,format='(f4.2)')

  loadct, 0
  contour, duhalf, lon, lat, /over, $
   level=[1], c_color=[180], /cell
  contour, dumost, lon, lat, /over, $
   level=[1], c_color=[130], /cell
  contour, duall, lon, lat, /over, $
   level=[1], c_color=[80], /cell

  map_continents, /hires
  map_grid, /box

  plots, wantlon, wantlat, psym=sym(1)

  device, /close


end

