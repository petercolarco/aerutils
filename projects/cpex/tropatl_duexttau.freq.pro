  thresh = 0.5
  imon = 7

  month = ['January','February','March','April','May','June',$
           'July','August','September','October','November','December']


; Get the MERRA2 file template (monthly means)
  filetemplate = 'MERRA2.tavg1_2d_aer_Nx.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
; Pick off the "Julys"
  a = where(long(nymd)/10000L ge 2010 and long(nymd)/10000L le 2016 and $
            long(nymd-long(nymd)/10000L*10000L)/100L eq imon)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)

; I'm not doing this very smartly because there are 24
; filenames for each day, but they are the same.  Reduce to unique
; filenames
  filename = filename[uniq(filename)]
  nymd     = nymd[uniq(nymd)]

; Now grab 0Z of each
  nf = n_elements(filename)
  for i = 0, nf-1 do begin
   print, i
   nc4readvar, filename[i], 'totexttau', duext_, time=time, lon=lon, lat=lat, wantnymd=nymd[i]
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

; Find the grid boxes where all mean AOT > thresh
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
  mon = strlowcase(month[imon-1])
  device, file='tropatl_duexttau.freq.'+string(thresh*100,format='(i03)')+'.'+mon+'.ps', $
   /helvetica, font_size=12, $
   /color, xoff=.5, yoff=.5, xsize=27, ysize=16
  !p.font=0

;  map_set, limit=[-12,-125,60,10], $
  map_set, limit=[10,-45,40,10], $
   position=[.05,.15,.95,.9]
  contour, dufreq, lon, lat, /nodata, /overplot, $
   xrange=[-100,-10], yrange=[-12,40]
  title=month[imon-1]+', Frequency DAOD > '+string(thresh,format='(f4.2)')+' (2010-2016)'
  xyouts, .05, .95, title, /normal
  loadct, 3
  levels = findgen(11)*.1
  colors = 255-findgen(11)*20
  contour, dufreq, lon, lat, /overplot, $
   levels=levels, c_color=colors, /cell
  map_continents, /hires
  map_grid, /box

  makekey, .05, .05, .9, .05, 0, -.025, $
   color=colors, align=0, label=string(levels,format='(f4.1)')

  loadct, 39
  plots, -22.9, 16.7, psym=sym(1), color=85, symsize=2

;; AERONET sites
;  loadct, 39
;  aeronet_valid, '2015', loc, lon, lat
;  plots, lon, lat, psym=sym(4), color=176, symsize=1.5, noclip=0
;  plots, lon, lat, psym=sym(9), color=0, symsize=1.5, noclip=0

;; MPLNET sites
;  plots, mpllon, mpllat, psym=sym(3), color=84, symsize=1.25
;  plots, mpllon, mpllat, psym=sym(8), color=5, symsize=1.25



; Notes on range ring
; ER-2 has airspeed of 410 knots; range = 3000 nm for 8 hour flight, 7 hours of data
; ER-2 takes .75 hr to reach cruise speed, distance of 205 nm
; ER-2 takes .60 hr to descend from cruise speed, distance of 320 nm
; 3 hour ring = 205 nm + 410*1.25 = 717.50 nm
; conversion of nm to km is 1.852
;  for i = 0, n_elements(wantlon)-1 do begin
;   range_ring, wantlat[i], wantlon[i], 717.5*1.852, 36, nearing, latp, lonp
;   latp = [latp,latp[0]]
;   lonp = [lonp,lonp[0]]
;   color=0
;   lonp_ = lonp-360.
;   loadct, 39, /silent
   ;plot within ring
   ;for j=0, naero_loc-1 do begin
   ;  if ((lon_aero[j] ge min(lonp_)) and (lon_aero[j] le max(lonp_)))  then begin
   ;    if ((lat_aero[j] ge min(latp)) and (lat_aero[j] le max(latp)))  then begin
   ;      plots, lon_aero[j], lat_aero[j], psym=sym(4), color=176, symsize=1.5, noclip=0
   ;      plots, lon_aero[j], lat_aero[j], psym=sym(9), color=0, symsize=1.5, noclip=0	     
   ;    endif
   ;  endif
   ;endfor
   ;;plot Cape Verde, etc.
   ;for j=0, naero_loc-1 do begin
   ;  if (lon_aero[j] ge -50)  then begin
   ;    if ((lat_aero[j] ge 0.) and (lat_aero[j] le 35.))  then begin
   ;      plots, lon_aero[j], lat_aero[j], psym=sym(4), color=176, symsize=1.5, noclip=0
   ;      plots, lon_aero[j], lat_aero[j], psym=sym(9), color=0, symsize=1.5, noclip=0	     
   ;    endif
   ;  endif
   ;endfor   
;  loadct, 0, /silent
  ;plots, wantlon[i], wantlat[i], psym=sym(1)
;  plots, lonp, latp, thick=6, color=color 
;  endfor


; P-3 has optimal airspeed of 285 knots at 8000 ft
; Assuming 20 minutes to reach speed & 30 minutes for descent
;  loadct, 39, /silent
;  for i = 0, n_elements(wantlon)-1 do begin
;   range_ring, wantlat[i], wantlon[i], 570.*1.852, 36, nearing, latp, lonp
;   latp = [latp,latp[0]]
;   lonp = [lonp,lonp[0]]
;   color=50
;   ;plots, wantlon[i], wantlat[i], psym=sym(1), color=color
;   plots, lonp, latp, thick=6, color=color 
;  endfor 
   
;; MPLNET sites
;  plots, mpllon, mpllat, psym=sym(3), color=84, symsize=1.25
;  plots, mpllon, mpllat, psym=sym(8), color=5, symsize=1.25

;; Add Legend
;  polyfill, [.07,.23,.23,.07,.07], [.30,.30,.33,.33,.30], /fill, color=255, /normal
;  polyfill, [.07,.20,.20,.07,.07], [.27,.27,.30,.30,.27], /fill, color=255, /normal
;  polyfill, [.07,.21,.21,.07,.07], [.24,.24,.27,.27,.27], /fill, color=255, /normal  
;  polyfill, [.07,.21,.21,.07,.07], [.21,.21,.24,.24,.21], /fill, color=255, /normal  
;  plots, [.07,.13], [.32,.32], color=0, thick=5, /normal
;  plots, [.07,.13], [.29,.29], color=50, thick=5, /normal
;  plots, .08, .26, psym=sym(3), color=84, symsize=1.25, /normal
;  plots, .08, .26, psym=sym(8), color=5, symsize=1.25, /normal
;  plots, .08, .23, psym=sym(4), color=176, symsize=1.5, noclip=0, /normal
;  plots, .08, .23, psym=sym(9), color=0, symsize=1.5, noclip=0, /normal
;  xyouts, .135, .31, 'ER-2', /normal, color=0
;  xyouts, .135, .28, 'P-3', /normal, color=0  
;  xyouts, .09, .25, 'MPLNET', /normal, color=0
;  xyouts, .09, .22, 'AERONET', /normal, color=0  

;  loadct, 39, /silent
;  for i = 0, n_elements(wantlon)-1 do begin
;   color=0
;   plots, wantlon[i], wantlat[i], psym=sym(1), color=color, symsize=.7
;  endfor 
  
  device, /close


end

