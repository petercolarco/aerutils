; Puerto Rico
  wantlon = [-80,-65,-25]
  wantlat = [ 15]

; Get standard atmosphere profile
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

; Get the MERRA2_GMI file template
  filetemplate = 'MERRA2_GMI.tavg24_3d_aer_Np.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
; Pick off the "Julys"
  a = where(long(nymd)/10000L ge 2001 and long(nymd)/10000L le 2017 and $
            long(nymd-long(nymd)/10000L*10000L)/100L eq 7)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)

  nf = n_elements(filename)

; Loop over wantlons
  nlon = n_elements(wantlon)
  for il = 0, nlon-1 do begin

  icnt = 0
  for i = 0, nf-1 do begin
   nc4readvar, filename[i], 'du', du_, lon=lon, lat=lat, lev=lev, $
     wantlon=wantlon[il], wantlat=[wantlat-5,wantlat+5], rc=rc
   print, i, rc
   if(rc ne 0) then continue
   icnt = icnt+1
   a = where (du_ gt 1e14)
   if(a[0] ne -1) then du_[a] = !values.f_nan
   du_ = mean(du_,dim=1,/nan)
   if(i eq 0) then begin
    du = du_
   endif else begin
    du = [du,du_]
   endelse
  endfor
  nz = n_elements(lev)
  du = reform(du,nz,icnt)

; Find median altitude
  delp = lev
  delp[1:nz-1] = lev[1:nz-1]-lev[0:nz-2]
  if(il eq 0) then vert = fltarr(nlon,nz)
  for i = 0, icnt-1 do begin
   a = where(du[*,i]*rhoa eq max(du[*,i]*rhoa))
   vert[il,a[0]] = vert[il,a[0]]+1
  endfor
  endfor







; Get the MERRA2_GMI file template
  wantlon = [-65,-45,-20]
  wantlat = [ 10]
  filetemplate = 'MERRA2_GMI.tavg24_3d_aer_Np.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
; Pick off the "Marchs"
  a = where(long(nymd)/10000L ge 2001 and long(nymd)/10000L le 2017 and $
            long(nymd-long(nymd)/10000L*10000L)/100L eq 3)
  nymd = nymd[a]
  nhms = nhms[a]
  filename=strtemplate(template,nymd,nhms)

  nf = n_elements(filename)

; Loop over wantlons
  nlon = n_elements(wantlon)
  for il = 0, nlon-1 do begin

  icnt = 0
  for i = 0, nf-1 do begin
   nc4readvar, filename[i], 'du', du_, lon=lon, lat=lat, lev=lev, $
     wantlon=wantlon[il], wantlat=[wantlat-5,wantlat+5], rc=rc
   print, i, rc
   if(rc ne 0) then continue
   icnt = icnt+1
   a = where (du_ gt 1e14)
   if(a[0] ne -1) then du_[a] = !values.f_nan
   du_ = mean(du_,dim=1,/nan)
   if(i eq 0) then begin
    du = du_
   endif else begin
    du = [du,du_]
   endelse
  endfor
  nz = n_elements(lev)
  du = reform(du,nz,icnt)

; Find median altitude
  delp = lev
  delp[1:nz-1] = lev[1:nz-1]-lev[0:nz-2]
  if(il eq 0) then vert2 = fltarr(nlon,nz)
  for i = 0, icnt-1 do begin
   a = where(du[*,i]*rhoa eq max(du[*,i]*rhoa))
   vert2[il,a[0]] = vert2[il,a[0]]+1
  endfor
  endfor

; Make an altitude in km
  alt = interpol(z,p/100.,lev)/1000.   ; km

  set_plot, 'ps'
  device, file='duconc_max.ps', /color, /helvetica, font_size=20, $
   xsize=16, ysize=8, xoff=.5, yoff=.5
  !p.font=0

  !p.multi=[0,3,1]

  plot, vert[2,*], alt, /nodata, xrange=[0,.3], xstyle=9, $
   yrange=[0,4], ystyle=9, ytitle='Altitude [km]', $
   xtitle='frequency', xminor=2, yticks=4, yminor=2, $
   title='West', xticks=3
  oplot, vert[0,*]/total(vert[0,*]), alt, thick=8
  oplot, vert2[0,*]/total(vert2[0,*]), alt, thick=8, lin=2

  plot, vert[2,*], alt, /nodata, xrange=[0,.3], xstyle=9, $
   yrange=[0,4], ystyle=9, ytitle='Altitude [km]', $
   xtitle='frequency', xminor=2, yticks=4, yminor=2, $
   title='East', xticks=3
  oplot, vert[1,*]/total(vert[1,*]), alt, thick=8
  oplot, vert2[1,*]/total(vert2[1,*]), alt, thick=8, lin=2

  plot, vert[2,*], alt, /nodata, xrange=[0,.3], xstyle=9, $
   yrange=[0,4], ystyle=9, ytitle='Altitude [km]', $
   xtitle='frequency', xminor=2, yticks=4, yminor=2, $
   title='Africa', xticks=3
  oplot, vert[2,*]/total(vert[2,*]), alt, thick=8
  oplot, vert2[2,*]/total(vert2[2,*]), alt, thick=8, lin=2

  device, /close

end

