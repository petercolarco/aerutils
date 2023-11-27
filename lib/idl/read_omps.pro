; Colarco, November 2018
; Read the gridded OMPS LP profile data Ghassan provides

  pro read_omps, filename, ext675, extstd, lon, lat, alt, troph

; filename could be an array...

; ext657 = provides 3d gridded aerosol extinction at 675 nm
; extstd = standard deviation
; lon
; lat
; alt    = tangent height altitude grid 10.5 - 40.5 km
; troph  = tropopause height

  lat     = fltarr(121)
  lon     = fltarr(19)
  ext675_ = fltarr(31,19,121) ;aerosol gridded profiles
  extstd_ = fltarr(31,19,121); standard deviation
  alt     = fltarr(31); Tangent height 10.5 to 40.5 km
  troph_  = fltarr(19,121) ; tropopause height (from where?)

; Read a file
  openr, 1, filename[0]
  readf,1,alt
  readf,1,Lon
  readf,1,Lat
  readf,1,ext675_
  readf,1,extstd_
  readf,1,troph_
  close,1

  ext675 = ext675_
  extstd = extstd_
  troph  = troph_

; If more than one file
  nf = n_elements(filename)
  fcount = nf
  if(nf gt 1) then begin
   for i = 1, nf-1 do begin
    if(file_test(filename[i])) then begin
     openr, 1, filename[i]
     readf,1,alt
     readf,1,Lon
     readf,1,Lat
     readf,1,ext675_
     readf,1,extstd_
     readf,1,troph_
     close,1
     ext675 = [ext675,ext675_]
     extstd = [extstd,extstd_]
     troph  = [troph,troph_]
    endif else begin
     print, 'Missing: ', filename[i], ', count reduced'
     fcount = fcount-1
    endelse
   endfor
  endif

; reform here...
  if(nf gt 1) then begin
   troph  = reform(troph,19,fcount,121)
   troph  = transpose(troph,[0,2,1])
   ext675 = reform(ext675,31,fcount,19,121)
   ext675 = transpose(ext675,[2,3,0,1])
   extstd = reform(extstd,31,fcount,19,121)
   extstd = transpose(extstd,[2,3,0,1])
  endif

; clean up and scale (from 1e4 km-1 to Mm-1)
  ext675[where(ext675 lt -900.)] = !values.f_nan
  extstd[where(extstd lt -900.)] = !values.f_nan
  ext675 = ext675/1.e4*1.e3
  extstd = extstd/1.e4*1.e3

end

