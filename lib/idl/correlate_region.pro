; Colarco, May 2006
; Pass in two variables, lon, lat, and mask, and return the region integrated
; correlation.

  pro correlate_region, var1, var2, lon, lat, mask, $
                        maskwant, lon0, lon1, lat0, lat1, varout, q=q


  area, lon, lat, nx, ny, dxx, dyy, area


; Let's check for a requested negative longitude
  lon_ = lon
  var1_ = var1
  var2_ = var2
  mask_ = mask
  area_ = area
  xshift = -1.
  if(lon0 lt 0) then begin
   a = where(lon ge 180)
   if(a[0] ne -1) then lon[a] = lon[a]-360.
   xshift = n_elements(a)
   lon = shift(lon,xshift)
   var1 = shift(var1,xshift,0)
   var2 = shift(var2,xshift,0)
   mask = shift(mask,xshift,0)
   area = shift(area,xshift,0)
  endif


  lonuse = fltarr(nx,ny)
  for iy = 0, ny-1 do begin
   lonuse[*,iy] = lon
  endfor
  latuse = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   latuse[ix,*] = lat
  endfor


;  Integrate for region
   if(maskwant eq -1) then begin
    a = where(area gt 0)
   endif else begin
    if(maskwant eq -2) then begin
     a = where(mask ne 0 and $
               lonuse gt lon0 and lonuse le lon1 and $
               latuse gt lat0 and latuse le lat1 )
    endif else begin
     a = where(mask eq maskwant and $
               lonuse gt lon0 and lonuse le lon1 and $
               latuse gt lat0 and latuse le lat1 )
    endelse
   endelse

;  two dimensional array, 1 inside region, 0 outside
   q = make_array(nx,ny)
   q[a] = 1.

;  create the region field in Tg mon-1
   b = where(var1[a] lt 1.e15 and var2[a] lt 1.e15)
   if(b[0] eq -1) then begin
    varout = !values.f_nan
   endif else begin
    varout = correlate(var1[a[b]],var2[a[b]])
   endelse


; Reset to saved values
  lon = lon_
  var1 = var1_
  var2 = var2_
  mask = mask_
  area = area_
  if(xshift ne -1) then q = shift(q,-xshift)

end
