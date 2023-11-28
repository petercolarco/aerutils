; Colarco
; September 2, 2008
; Read the CALIPSO track files provided by Chieko Kittaka

; With the optional MBL keyword, read Judd Welton's files
;  0 = chieko provided file header
;  1 = Welton provided offset MBL tracks
;  2 = Welton provided original MBL tracks
;  3 = Welton provided netcdf track file

  pro read_calipso_track, trackfile, lon, lat, date, mbl=mbl

  if(not(keyword_set(mbl))) then mbl = 0


  case mbl of
   0: begin
;     Chieko provided tracks
      nhead = 1
      ncol = 8
      nlon = 4
      nlat = 5
      end
   1: begin
;     Offset MBL tracks
      nhead = 0
      ncol = 3
      nlon = 2
      nlat = 1
      end
   2: begin
;     Original MBL tracks
      nhead = 6
      ncol = 3
      nlon = 2
      nlat = 1
      end
   3: begin
      end
  endcase

if(mbl ne 3) then begin

; Count lines in file
  openr, lun, trackfile, /get_lun
; read a header
  str = 'a'
  for i = 0, nhead-1 do begin
   readf, lun, str
  endfor
; count the lines after the header
  i = 0L
  while(not eof(lun) ) do begin
   readf, lun, str
   i = i +1L
  endwhile
  free_lun, lun

; Create the data array
  dataInp = dblarr(ncol,i)
; Open to read
  openr, lun, trackfile, /get_lun
; read a header
  str = 'a'
  for i = 0, nhead-1 do begin
   readf, lun, str
  endfor
  readf, lun, dataInp
  free_lun, lun

  lon = reform(dataInp[nlon,*])
  lat = reform(dataInp[nlat,*])

  if(mbl eq 0) then begin
;  Split date from Chieko's files
   sec_  = reform(double(dataInp[3,*]))
   yyyy_ = reform(long(dataInp[0,*]))
   mm_   = reform(long(dataInp[1,*]))
   dd_   = reform(long(dataInp[2,*]))

   yyyym1_ = yyyy_-1

;  cast the date as a fractional day number
;  Judd gives date as YYYYMMDD.fraction_of_day_from_0Z
   date   = yyyy_*10000.d + mm_*100.d + dd_*1.d + sec_/86400.d
   daynum_ = julday(mm_,dd_,yyyy_) - julday(12,31,yyyym1_) + sec_/86400.

  endif else begin
   date = reform(dataInp[0,*])
  endelse

  return
endif

; Interface for netcdf provided track files
  cdfid = ncdf_open(trackfile)
  id = ncdf_varid(cdfid,'date')
  ncdf_varget, cdfid, id, date
  date = string(date)
  id = ncdf_varid(cdfid,'lon')
  ncdf_varget, cdfid, id, lon
  id = ncdf_varid(cdfid,'lat')
  ncdf_varget, cdfid, id, lat
  ncdf_close, cdfid

; Massage the date to be YYYYMMDD.fraction_of_day_from_00Z
  nd = n_elements(date)
  dd = fltarr(nd)
  mm = fltarr(nd)
  yyyy = fltarr(nd)
  hhmmss = strarr(nd)
  fday = dblarr(nd)
  mon = ['jan','feb','mar','apr','may','jun', $
         'jul','aug','sep','oct','nov','dec']
  for id = 0L, nd-1 do begin
   datesplit = strsplit(date[id],/extract)
   dd[id] = datesplit[0]
   mm[id] = where(strlowcase(datesplit[1]) eq mon) + 1.
   yyyy[id] = datesplit[2]
   hhmmss[id] = datesplit[3]
   datesplit = strsplit(hhmmss[id],':',/extract)
   fday[id] = (datesplit[0]*3600.d + datesplit[1]*60.d + $
               datesplit[2]) / 86400.d
  endfor
  date = yyyy*10000.d + mm*100.d + dd*1.d + fday

end

