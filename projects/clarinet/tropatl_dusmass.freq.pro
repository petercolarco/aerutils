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
; Pick off the Junes
  a = where(long(nymd)/10000L ge 2001 and long(nymd)/10000L le 2016 and $
            (long(nymd-long(nymd)/10000L*10000L)/100L eq 6 or $
             long(nymd-long(nymd)/10000L*10000L)/100L eq 6 or $
             long(nymd-long(nymd)/10000L*10000L)/100L eq 6))
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

  set_plot, 'z'
  device, set_resolution=[3600,3200], decomp=0, set_pixel_depth=24, $
   set_font='helvetica', set_character_size=[40,40]

  red   = [0, 166, 255, 255, 254, 254, 254, 236, 204, 153, 102,  49,  50, 253, 254, 255]
  green = [0, 189, 255, 247, 227, 196, 153, 112,  76,  52,  37, 163, 131, 253, 254, 255]
  blue  = [0, 219, 229, 188, 145,  79,  41,  20,   2,   4,   6,  84, 190, 253, 254, 255]
  tvlct, red, green, blue
  iblack = 0
  iwhite = n_elements(red)-1
  iblue  = 1
  iaero  = iwhite-4
  impln  = iwhite-3

  !p.font=1
  !p.background=iwhite
  !p.color=iblack

  position = [.05,.2,.95,.95]
  map_set, limit=[8,-100,40,-50], $
   position=position, /horizon, e_horizon={fill:1,color:iwhite-1}
  map_continents, /fill, color=iwhite-2
  map_continents, /hires, color=iblack, thick=12
  map_continents, /countries, /usa, color=iblack, thick=6
  map_continents, /hires, /coasts, /countries, /usa, color=iblack, thick=6
  map_grid, /box, glinethick=6, color=iblack

; AERONET sites
  aeronet_valid, '2015', loc, aerolon, aerolat
  plots, aerolon, aerolat, psym=sym(4), color=iaero, symsize=1.5, noclip=0
  plots, aerolon, aerolat, psym=sym(9), color=iblack, symsize=1.5, noclip=0

; MPLNET sites
  plots, mpllon, mpllat, psym=sym(3), color=impln, symsize=1.25
  plots, mpllon, mpllat, psym=sym(8), color=iblack, symsize=1.25

  aimg = tvrd(/true)

  mask  = aimg
  maskc = aimg
  mask[*,*,*]  = 0
  maskc[*,*,*] = 0

; Create the mask where sea is
  maskr = reform(aimg[0,*,*])
  maskr[where(maskr eq red[iwhite-1])] = red[1]
  maskg = reform(aimg[1,*,*])
  maskg[where(maskg eq green[iwhite-1])] = green[1]
  maskb = reform(aimg[2,*,*])
  maskb[where(maskb eq blue[iwhite-1])] = blue[1]
  mask[0,*,*] = maskr
  mask[1,*,*] = maskg
  mask[2,*,*] = maskb

; Create mask where black lines are
  maskr[*,*] = 255
  maskg[*,*] = 255
  maskb[*,*] = 255
  maskr[where(reform(aimg[0,*,*]) eq red[iblack])]   = red[iblack]
  maskg[where(reform(aimg[1,*,*]) eq green[iblack])] = green[iblack]
  maskb[where(reform(aimg[2,*,*]) eq blue[iblack])]  = blue[iblack]
; aeronet
  maskr[where(reform(aimg[0,*,*]) eq red[iaero])]   = red[iaero]
  maskg[where(reform(aimg[1,*,*]) eq green[iaero])] = green[iaero]
  maskb[where(reform(aimg[2,*,*]) eq blue[iaero])]  = blue[iaero]
; mplnet
  maskr[where(reform(aimg[0,*,*]) eq red[impln])]   = red[impln]
  maskg[where(reform(aimg[1,*,*]) eq green[impln])] = green[impln]
  maskb[where(reform(aimg[2,*,*]) eq blue[impln])]  = blue[impln]
  maskc[0,*,*] = maskr
  maskc[1,*,*] = maskg
  maskc[2,*,*] = maskb

  map_continents, /fill, color=iwhite
  levels = findgen(9)*.05
  colors = 2+indgen(9)
  contour, dufreq, lon, lat, /overplot, $
   levels=levels, c_color=colors, /cell
;  map_continents, /hires, thick=12, color=iblack
;  map_grid, /box, glinethick=6, color=iblack

  makekey, .05, .1, .9, .05, 0, -.025, $
   color=colors, align=0, label=string(levels*100,format='(i2)')+'%'

  xyouts, .5, .98, align=.5, /normal, $
   'June 2010 - 2015: Percent of time dust exceeds 25% of 24-hr PM2.5 standard'

  bimg  = tvrd(/true)

; Overwrite masks in order
  bimgr = reform(bimg[0,*,*])
  bimgr[where(reform(mask[0,*,*]) eq red[1])] = red[1]
  bimgr[where(reform(maskc[0,*,*]) eq red[iblack])] = red[iblack]
  bimgr[where(reform(maskc[0,*,*]) eq red[iaero])] = red[iaero]
  bimgr[where(reform(maskc[0,*,*]) eq red[impln])] = red[impln]
  bimgg = reform(bimg[1,*,*])
  bimgg[where(reform(mask[1,*,*]) eq green[1])] = green[1]
  bimgg[where(reform(maskc[1,*,*]) eq green[iblack])] = green[iblack]
  bimgg[where(reform(maskc[1,*,*]) eq green[iaero])] = green[iaero]
  bimgg[where(reform(maskc[1,*,*]) eq green[impln])] = green[impln]
  bimgb = reform(bimg[2,*,*])
  bimgb[where(reform(mask[2,*,*]) eq blue[1])] = blue[1]
  bimgb[where(reform(maskc[2,*,*]) eq blue[iblack])] = blue[iblack]
  bimgb[where(reform(maskc[2,*,*]) eq blue[iaero])] = blue[iaero]
  bimgb[where(reform(maskc[2,*,*]) eq blue[impln])] = blue[impln]
  bimg[0,*,*] = bimgr
  bimg[1,*,*] = bimgg
  bimg[2,*,*] = bimgb
  write_png, 'tropatl_dusmass.freq.png', bimg

stop 

; AERONET sites
  loadct, 39



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

