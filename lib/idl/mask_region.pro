; Colarco, Mar. 2009
; Modeled on integrate_region.pro

; Pass in a variable, lon, lat, and mask, and return region masked as requested.
; Inputs
;  var -- (NX,NY) array of values to operate on, global grid
;  lon -- (NX) longitude values
;  lat -- (NY) latitude values
;  mask -- (NX,NY) array of mask values
;  maskwant -- number of mask area wanted
;  lon0, lon1 -- bounding longitudes
;  lat0, lat1 -- bounding latitudes
; Output
;  varout -- (NX,NY) masked regional map (all else is NaN)
; Optional
;  q -- this is an (NX,NY) map filled with "1"s where the region is valid

  pro mask_region, var, lon, lat, mask, maskwant, $
                   lon0, lon1, lat0, lat1, varout, q=q

; Let's check for a requested negative longitude
  lon2 = lon
  var2 = var
  mask2 = mask
  xshift = -1.

; If requested longitude < 0 then need to shift input (assumed 0 - 360)
  if(lon0 lt 0) then begin
   a = where(lon ge 180)
   if(a[0] ne -1) then lon[a] = lon[a]-360.
   xshift = n_elements(a)
   lon = shift(lon,xshift)
   var = shift(var,xshift,0)
   mask = shift(mask,xshift,0)
  endif


  nx = n_elements(lon)
  ny = n_elements(lat)

  lonuse = fltarr(nx,ny)
  for iy = 0, ny-1 do begin
   lonuse[*,iy] = lon
  endfor
  latuse = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   latuse[ix,*] = lat
  endfor


;  Find the points in the region
   if(maskwant eq -1) then begin   ; whole world
    a = where(finite(mask) eq 1)
   endif else begin
    if(maskwant eq -2) then begin  ; land
     a = where(mask ne 0 and $
               lonuse gt lon0 and lonuse le lon1 and $
               latuse gt lat0 and latuse le lat1 )
    endif else begin               ; specific region (could be ocean)
     a = where(mask eq maskwant and $
               lonuse gt lon0 and lonuse le lon1 and $
               latuse gt lat0 and latuse le lat1 )
    endelse
   endelse

;  create the varout
   varout = make_array(nx,ny,val=!values.f_nan)

;  two dimensional array, 1 inside region, 0 outside
   q = make_array(nx,ny, val=0.)

   if(a[0] eq -1) then goto, getout


;  create the region field in Tg mon-1
   b = where(finite(var[a] eq 1) and var[a] lt 1.e15)
   if(b[0] ne -1) then varout[a[b]] = var[a[b]]

; Reset to saved values
getout:
  lon = lon2
  var = var2
  mask = mask2
  if(xshift ne -1) then q = shift(q,-xshift)
  if(xshift ne -1) then varout = shift(varout,-xshift)

end
