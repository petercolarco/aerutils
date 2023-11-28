; Procedure to read MODIS lat/lon information from Level 2 files
; and create a dataset of lat/lon points

; Location of level 2 files
  modisdir = '/output/MODIS/Level2/MOD04/'

; years
  yyyy = ['2000','2001','2002','2003','2004','2005','2006','2007','2008']

; Loop over years
; Inside year, loop over days
; Find all granules in a day
; Open granule and read lat/lon, reserving only the nadir lat/lon
; Write to a text file

  ny = n_elements(yyyy)
  for iy = 0, ny-1 do begin
   jday0 = julday(12,31,fix(yyyy[iy])-1,12,0,0)

   for id = 1, 366 do begin
    ddd = strcompress(string(id),/rem)
    if(ddd lt 10) then ddd = '0'+ddd
    if(ddd lt 100) then ddd = '0'+ddd
    granules = file_search(modisdir+yyyy[iy]+'/'+ddd+'/MOD04_L2.*')
    if(granules[0] eq '') then goto, getout

;   Find the calendar day
    caldat, jday0+fix(ddd), mm_, dd_, yyyy_
    mm_ = strcompress(string(mm_),/rem)
    dd_ = strcompress(string(dd_),/rem)
    yyyy_ = strcompress(string(yyyy_),/rem)
    if(mm_ lt 10) then mm_ = '0'+mm_
    if(dd_ lt 10) then dd_ = '0'+dd_

    openw, lun, '/output/colarco/MODIS/Level2/MOD04.'+yyyy_+mm_+dd_+'.nadir.ascii', /get_lun
    printf, lun, 'Year Month Day Second Longitude Latitude Profile_ID_Start Profile_ID_End''

;   Now look at individual files
    ng = n_elements(granules)
    for ig = 0, ng-1 do begin
;    If zipped, try to unzip in place and zip again afterward
     zipped = 0
     izip = strpos(granules[ig],'.gz')
     if(izip ne -1) then begin
      zipped = 1
      cmd = 'gunzip '+granules[ig]
      spawn, cmd
      granules[ig] = strmid(granules[ig],0,izip)
     endif
     cdfid = hdf_sd_start(granules[ig])
     idx = hdf_sd_nametoindex(cdfid,'Longitude')
     idd = hdf_sd_select(cdfid,idx)
     hdf_sd_getdata, idd, lon
     idx = hdf_sd_nametoindex(cdfid,'Latitude')
     idd = hdf_sd_select(cdfid,idx)
     hdf_sd_getdata, idd, lat
     hdf_sd_end, cdfid
     if(zipped) then begin
      cmd = 'gzip '+granules[ig]
      spawn, cmd
     endif

;    Save only the lon, lat at center
     lon = reform(lon[67,*])
     lat = reform(lat[67,*])

;    Now construct what to print out
     is = strpos(granules[ig],'MOD04_L2')+18
     hhmm = fix(strmid(granules[ig],is,4))
     sec = long(hhmm/100L*3600L)+long(hhmm-(hhmm/100L)*100L)*60L

     nj = n_elements(lon)
     for j = 0, nj-1 do begin
      printf, lun, yyyy_, mm_, dd_, sec, $
                   lon[j], lat[j], 0, 0, $
                   format='(1x,i4,1x,i4,1x,i3,1x,f7.1,2(1x,f10.5),2(1x,i3))'
     endfor  ; spatial
    endfor   ; granules in day
    free_lun, lun

    getout:

   endfor    ; day
  endfor     ; year

end
