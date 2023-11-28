; Set up bins in latitude
  nlatbin = 24
  dlatbin = 120 / nlatbin
  latbin0 = -60.             + findgen(nlatbin)*dlatbin
  latbin1 = -60. + dlatbin   + findgen(nlatbin)*dlatbin
  latbin  = -60. + dlatbin/2.+ findgen(nlatbin)*dlatbin

  zbin  = fltarr(nlatbin,72)
  dzbin = fltarr(nlatbin,72)
  bcbin = fltarr(nlatbin,72)
  nobs  = fltarr(nlatbin)

  satwant = 1  ; -1 for all, else 1 - 20
  sats    = [2*satwant-1,2*satwant]

; Set up the file read
  nymd0 = '20090101'
  nymd1 = '20091231'
  dateexpand, nymd0, nymd1, '120000', '120000', nymd, nhms

  for id = 0, n_elements(nymd)-1 do begin

   filename = 'output/data/dR_Fortuna-2-4-b4.socrates08.'+nymd[id]+'.nc'
   bc = 1
   so2 = 1
   airdens = 1
   read_curtain, filename, lon, lat, time, z, dz, orbit_track, $
                     bc = bc, so2 = so2, airdens = airdens

; put bc in mixing ratio space
  bc = bc/airdens

   for i = 0, nlatbin-1 do begin
    if(satwant eq -1) then a = where(orbit_track gt 0)
    if(satwant gt 0)  then a = where(orbit_track eq sats[0] or $
                                     orbit_track eq sats[1])
    b = where(lat[a] ge latbin0[i] and lat[a] lt latbin1[i])
    if(b[0] ne -1) then begin
     if(id eq 0) then begin
      zbin[i,*]  = total(z[*,a[b]],2)
      dzbin[i,*] = total(dz[*,a[b]],2)
      bcbin[i,*] = total(bc[*,a[b]],2)
      nobs[i]    = n_elements(a[b])
     endif else begin
      if(n_elements(b) gt 1) then begin
       zbin[i,*]  = zbin[i,*]  + total(z[*,a[b]],2)
       dzbin[i,*] = dzbin[i,*] + total(dz[*,a[b]],2)
       bcbin[i,*] = bcbin[i,*] + total(bc[*,a[b]],2)
      endif else begin
       zbin[i,*]  = zbin[i,*]  + z[*,a[b]]
       dzbin[i,*] = dzbin[i,*] + dz[*,a[b]]
       bcbin[i,*] = bcbin[i,*] + bc[*,a[b]]
      endelse
      nobs[i]    = nobs[i]    + n_elements([b])
     endelse
    endif
   endfor

  endfor

; Now form the average
  for i = 0, nlatbin-1 do begin
   zbin[i,*]  = zbin[i,*] / nobs[i]
   dzbin[i,*] = dzbin[i,*] / nobs[i]
   bcbin[i,*] = bcbin[i,*] / nobs[i]
  endfor
; put in km
  zbin  = zbin / 1000.
  dzbin = dzbin / 1000.
; put in ng m-3
  bcbin = bcbin * 1000.

  set_plot, 'ps'
  device, file = 'socrates_01.08.ps', /color, /helvetica, $
   xsize=18, ysize=12, xoff=.5, yoff=.5, font_size=14
  !p.font=0

  plot, indgen(10), /nodata, thick=3, $
   xrange = [-60,60], xtitle = 'latitude', $
   yrange = [0,30], ytitle = 'altitude [km]', ystyle = 9, $
   position = [.1, .25, .85, .95]

  level = [1,2,5,10,20,50,100]
  color = 220 - findgen(7)*30
  plotgrid, bcbin, level, color, latbin, zbin, dlatbin, dzbin

  plot, indgen(10), /nodata, /noerase, thick=3, $
   xrange = [-60,60], yrange = [0,30], ystyle = 9, $
   position = [.1, .25, .85, .95]

  axis, yaxis=1, yrange=[1000,10], /ylog, ythick=3, ytitle='pressure [hPa]'

  makekey, .1, .075, .75, .05, 0, -.05, align = 0, $
   color=color, label=['1','2','5','10','20','50','100']

  device, /close

end
