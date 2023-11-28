; Colarco, April 2017
; Attempt to make nice plot of dust surface mass over land

; Roosevelt Roads, San Jose, Key West locations
  wantlon = [-65.648,-84.091,-81.780]
  wantlat = [ 18.237,  9.928, 24,555]

; MPLNET sites
  mpllat = [ 36.215, 38.993, 13.17, 28.47,  25.732]
  mpllon = [-81.694,-76.84, -59.43,-16.247,-80.163]

; Get the MERRA2 file template (monthly means)
  filetemplate = 'MERRA2.tavg1_2d_aer_Nx.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
; Pick off the "Junes"
  a = where(long(nymd)/10000L ge 2001 and long(nymd)/10000L le 2016 and $
            long(nymd-long(nymd)/10000L*10000L)/100L eq 6)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)
; I'm not doing this very smartly because there are 24
; filenames for each day, but they are the same.  Reduce to unique
; filenames
  filename = filename[uniq(filename)]
  nymd     = nymd[uniq(nymd)]
; Now grab noon of each
  nf = n_elements(filename)
  for i = 0, nf-1 do begin
   print, i
   nc4readvar, filename[i], 'dusmass25', duext_, time=time, lon=lon, lat=lat, wantnymd=nymd[i]
   if(i eq 0) then begin
    duext = duext_
   endif else begin
    duext = [duext,duext_]
   endelse
  endfor
  duext = reform(duext,n_elements(lon),nf,n_elements(lat))
  duext = transpose(duext,[0,2,1])

; Convert units from kg m-3 to ug m-3
  duext = duext*1.e9

; Form the mean
  duext_mean = mean(duext,dimension=3)

; Find the grid boxes where all mean AOT > 0.05
  thresh = 8.75
  nx = n_elements(lon)
  ny = n_elements(lat)
  dufreq = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    a = where(duext[ix,iy,*] gt thresh)
    if(a[0] ne -1) then dufreq[ix,iy] = 1.*n_elements(a)/nf
   endfor
  endfor

; Make a plot
  set_plot, 'ps'
  device, file='tropatl_dusmass.freq.ps', /helvetica, font_size=12, $
   /color, xoff=.5, yoff=.5, xsize=18, ysize=16
  !p.font=0

  map_set, limit=[8,-100,40,-50], $
   position=[.05,.2,.95,.95]
  contour, dufreq, lon, lat, /nodata, /overplot, $
   xrange=[-100,-10], yrange=[-12,40]
  loadct, 3
  levels = findgen(11)*.05
  colors = 255-findgen(11)*20
  contour, dufreq, lon, lat, /overplot, $
   levels=levels, c_color=colors, /cell
  map_continents, /hires
  map_grid, /box

  makekey, .05, .1, .9, .05, 0, -.025, $
   color=colors, align=0, label=string(levels*100,format='(i2)')+'%'

; AERONET sites
  loadct, 39
  aeronet_valid, '2015', loc, lon, lat
  plots, lon, lat, psym=sym(4), color=176, symsize=1.5, noclip=0
  plots, lon, lat, psym=sym(9), color=0, symsize=1.5, noclip=0

; MPLNET sites
  plots, mpllon, mpllat, psym=sym(3), color=84, symsize=1.25
  plots, mpllon, mpllat, psym=sym(8), color=5, symsize=1.25



; Notes on range ring
; ER-2 has airspeed of 410 knots; range = ~3000 nm for 7 hour flight
; loiter for three hours is estimated out distance of 850 nm
; conversion of nm to km is 1.852
  loadct, 0
  for i = 0, n_elements(wantlon)-1 do begin
   plots, wantlon[i], wantlat[i], psym=sym(1)
   range_ring, wantlat[i], wantlon[i], 850.*1.852, 36, nearing, latp, lonp
   latp = [latp,latp[0]]
   lonp = [lonp,lonp[0]]
   color=0
   plots, lonp, latp, thick=6, color=color
  endfor

  device, /close


end

