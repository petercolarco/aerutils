; Colarco, May 2006
; Pass in a variable, lon, lat, and mask, and return the region integrated
; quantity.  Useful for comparing results of different resolutions.
; Input:
;  var - input 2d (nx,ny) gridded variable on lon/lat
;  lon - nx longitude
;  lat - ny latitudes
;  mask - input 2d (nx,ny) grid of mask values
;  maskwant - select only on where mask = maskwant
;  lon0, lon1, lat0, lat1 - bounding lon/lat
; Output:
;  varout - area weighted sum
;  (unless keyword "avg" set, in which case is an area weighted average
; Optional:
;  q   - nx,ny map of points in the mask
;  avg - if true, then varout is returned as an area weighted average
;  std - if present (and avg = true) named variable returned with 
;        standard deviation of the masked values
;  num - if present, return the number of observations

  pro integrate_region, var, lon, lat, mask, $
                        maskwant, lon0, lon1, lat0, lat1, varout, $
                        q=q, avg=avg, std=std, num=num, weight=weight

  area, lon, lat, nx, ny, dxx, dyy, area

; Let's check for funny bounding of longitudes
  lon2 = lon
  var2 = var
  mask2 = mask
  area2 = area
  xshift = -1
  if(lon0 lt 0) then begin
   a = where(lon ge 180)
   if(a[0] ne -1) then begin
    lon[a] = lon[a]-360.
    xshift = n_elements(a)
    lon = shift(lon,xshift)
    var = shift(var,xshift,0)
    mask = shift(mask,xshift,0)
    area = shift(area,xshift,0)
   endif
  endif
  if(lon0 gt 180 or lon1 gt 180) then begin
   a = where(lon lt 0)
   if(a[0] ne -1) then begin
    lon[a] = lon[a]+360.
    xshift = -n_elements(a)
    lon = shift(lon,xshift)
    var = shift(var,xshift,0)
    mask = shift(mask,xshift,0)
    area = shift(area,xshift,0)
   endif
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
   q = make_array(nx,ny,val=0.)

;  If no points are valid
   if(a[0] eq -1) then begin
    if(keyword_set(num)) then num = 0
    if(keyword_set(std)) then std = !values.f_nan
    varout = !values.f_nan
    goto, getout
   endif

   q[a] = 1.

;  create the region field in Tg mon-1
   b = where(finite(var[a]) eq 1 and var[a] lt 1.e15)
   if(keyword_set(num)) then num = n_elements(b)
   if(b[0] eq -1) then begin
    if(keyword_set(num)) then num = 0.
    if(keyword_set(std)) then std = !values.f_nan
    varout = !values.f_nan
    goto, getout
   endif
   if(not(keyword_set(avg))) then begin
    varout = total(area[a[b]]*var[a[b]])*30.*86400./1.e9
   endif else begin
;   If averaging, then return a weighted average
;   Use area weighting unless some other weighting function is specified
    weight_ = area
    if(keyword_set(weight)) then weight_ = weight*area
    varout = total(weight_[a[b]]*var[a[b]])/total(weight_[a[b]])
    if(keyword_set(num)) then num = total(weight_[a[b]])
    if(keyword_set(std)) then begin
     if(n_elements(b) lt 3) then begin
      std = 0.
     endif else begin
      std = stddev(weight_[a[b]]*var[a[b]])/mean(weight_[a[b]])
     endelse
    endif
   endelse


; Reset to saved values
  getout:
  lon = lon2
  var = var2
  mask = mask2
  area = area2
  if(xshift ne -1) then q = shift(q,-xshift)

end
