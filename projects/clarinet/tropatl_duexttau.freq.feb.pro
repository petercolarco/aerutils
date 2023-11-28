; Roosevelt Roads, Barbados location
  wantlon = [-65.648,-59.5,-81.780]
  wantlat = [ 18.237,  13., 24,555]

; Get the MERRA2 file template (monthly means)
  filetemplate = 'MERRA2.tavg1_2d_aer_Nx.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
; Pick off the "Junes"
  a = where(long(nymd)/10000L ge 2001 and long(nymd)/10000L le 2016 and $
            long(nymd-long(nymd)/10000L*10000L)/100L eq 2)
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
   nc4readvar, filename[i], 'duexttau', duext_, time=time, lon=lon, lat=lat, wantnymd=nymd[i]
   if(i eq 0) then begin
    duext = duext_
   endif else begin
    duext = [duext,duext_]
   endelse
  endfor
  duext = reform(duext,n_elements(lon),nf,n_elements(lat))
  duext = transpose(duext,[0,2,1])

; Form the mean
  duext_mean = mean(duext,dimension=3)

; Find the grid boxes where all mean AOT > 0.05
  thresh = 0.05
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
  device, file='tropatl_duexttau.freq.feb.ps', /helvetica, font_size=12, $
   /color, xoff=.5, yoff=.5, xsize=18, ysize=16
  !p.font=0

  map_set, limit=[-12,-100,40,-10], $
   position=[.05,.2,.95,.95]
  contour, dufreq, lon, lat, /nodata, /overplot, $
   xrange=[-100,-10], yrange=[-12,40]
  loadct, 3
  levels = findgen(11)*.1
  colors = 255-findgen(11)*20
  contour, dufreq, lon, lat, /overplot, $
   levels=levels, c_color=colors, /cell
  map_continents, /hires
  map_grid, /box

  makekey, .05, .1, .9, .05, 0, -.025, $
   color=colors, align=0, label=string(levels,format='(f4.1)')

; Notes on range ring
; ER-2 has airspeed of 410 knots; range = ~3000 nm for 7 hour flight
; loiter for three hours is estimated out distance of 850 nm
; conversion of nm to km is 1.852
  for i = 0, n_elements(wantlon)-1 do begin
   plots, wantlon[i], wantlat[i], psym=sym(1)
   range_ring, wantlat[i], wantlon[i], 850.*1.852, 36, nearing, latp, lonp
   latp = [latp,latp[0]]
   lonp = [lonp,lonp[0]]
   plots, lonp, latp, thick=6
  endfor

  device, /close

end

