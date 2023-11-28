  openr, lun, 'OMPS_NPP_SO2_TRU_Raikoke_20190622-ZN.dat', /get
  str = 'a'
  i = 0
  while(not(eof(lun))) do begin
   readf, lun, str
   data = strsplit(str,/extract)
   if(i eq 0) then begin
    lat = data[0]
    lon = data[1]
    h   = data[4]
    so2 = data[3]
   endif else begin
    lat = [lat,data[0]]
    lon = [lon,data[1]]
    h   = [h,data[4]]
    so2 = [so2,data[3]]
   endelse
   i = i+1
  endwhile
  free_lun, lun

; Now write some text suitable for GEOS input format
; SO2 is kg per grid box (50 km x 50 km)
; Convert to kg S m-2 s-1 for a three hour window
  so2 = float(so2)
  s   = so2/2./3600./3.     ; kg S s-1

; Write as text for placement in GEOS input file
  lat = string(float(lat),format='(f7.3)')
  lon = string(float(lon),format='(f8.3)')
  s   = string(float(s),format='(e12.4)')
  h0  = string((float(h)-3.)*1000.,format='(i5)')
  h1  = string(float(h)*1000.,format='(i5)')

  openw, lun, 'out_so2.txt', /get

  for j = 0, i-1 do begin
   printf, lun, lat[j], lon[j], s[j], h0[j], h1[j], '000000', '030000', $
    format='(a7,2x,a8,2x,a12,2x,i5,2x,i5,2x,a6,2x,a6)'
  endfor

  free_lun, lun

end
