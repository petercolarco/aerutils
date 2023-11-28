; Get and read Patricia's files to aggregate PDF of angles
; Read the satellite sub-point values

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']

  for im = 0, 11 do begin

; Get the filenames to probe...
  filen = file_search('/misc/prc19/colarco/OBS/A-CCP/GPM/LevelB','*nc4')
  filen = filen[where(strpos(filen,'2006'+mm[im]) ne -1)]

; Now generate some random numbers
  num = 100000L   ; a large number for all the samples that fail sza
  numwant = 10000 ; number of samples I really want
  nf = n_elements(filen) ; number of files in selection
  ns = 3600              ; number of seconds in file
  spawn, 'ps -A | sum | cut -c1-5', seed
  seed = long(seed[0])
  ifile = fix(randomu(seed,num)*nf)
  isec  = fix(randomu(seed,num)*ns)

  inumwant = 0
  ii = 0

  while(inumwant lt numwant) do begin

  cdfid = ncdf_open(filen[ifile[ii]])
  id = ncdf_varid(cdfid,'trjLon')
  ncdf_varget, cdfid, id, lon_, offset=[isec[ii]], count=[1]
  id = ncdf_varid(cdfid,'trjLat')
  ncdf_varget, cdfid, id, lat_, offset=[isec[ii]], count=[1]
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time_, offset=[isec[ii]], count=[1]
  id = ncdf_varid(cdfid,'time_ss')
  ncdf_varget, cdfid, id, time_ss_, offset=[0,isec[ii]], count=[10,1]
  id = ncdf_varid(cdfid,'vza_ss')
  ncdf_varget, cdfid, id, vza_, offset=[0,isec[ii]], count=[10,1]
  id = ncdf_varid(cdfid,'sza_ss')
  ncdf_varget, cdfid, id, sza_, offset=[0,isec[ii]], count=[10,1]
  id = ncdf_varid(cdfid,'saa_ss')
  ncdf_varget, cdfid, id, saa_, offset=[0,isec[ii]], count=[10,1]
  id = ncdf_varid(cdfid,'vaa_ss')
  ncdf_varget, cdfid, id, vaa_, offset=[0,isec[ii]], count=[10,1]
  id = ncdf_varid(cdfid,'scatAngle_ss')
  ncdf_varget, cdfid, id, scat_, offset=[0,isec[ii]], count=[10,1]
  ncdf_close, cdfid

  a = where(sza_ le 80.)

; save these if a[0] ne -1, else iterate
  if(strpos(filen[ifile[ii]],'20060101_00') eq -1 and $
     n_elements(a) eq 10) then begin  ; only select cases where all SZA are < 80

   print, inumwant, ii, filen[ifile[ii]]

   if(inumwant eq 0) then begin
    lon     = reform(lon_)
    lat     = reform(lat_)
    vza     = reform(vza_[a])
    sza     = reform(sza_[a])
    vaa     = reform(vaa_[a])
    saa     = reform(saa_[a])
    scat    = reform(scat_[a])
    time    = reform(time_)
    time_ss = reform(time_ss_[a])
    date    = strmid(filen[ifile[ii]],strpos(filen[ifile[ii]],'.2006')+1,14)
   endif else begin
    lon     = [lon,reform(lon_)]
    lat     = [lat,reform(lat_)]
    vza     = [vza,reform(vza_[a])]
    sza     = [sza,reform(sza_[a])]
    vaa     = [vaa,reform(vaa_[a])]
    saa     = [saa,reform(saa_[a])]
    scat    = [scat,reform(scat_[a])]
    time    = [time,reform(time_)]
    time_ss = [time_ss,reform(time_ss_[a])]
    date = date+' '+strmid(filen[ifile[ii]],strpos(filen[ifile[ii]],'.2006')+1,14)
   endelse

   inumwant = inumwant + 1

  endif

  ii = ii + 1

  endwhile

; Rearrange
  vza  = reform(vza,10,numwant)
  sza  = reform(sza,10,numwant)
  vaa  = reform(vaa,10,numwant)
  saa  = reform(saa,10,numwant)
  scat = reform(scat,10,numwant)
  time_ss = reform(time_ss,10,numwant)

  date = strsplit(date,' ',/extract)

  openw, lun, 'gpm/gpm.random.2006'+mm[im]+'.txt', /get
  printf, lun, numwant, 10
  for i = 0, numwant-1 do begin
   for j = 0, 9 do begin
    printf, lun, lon[i],',',lat[i],',',date[i],',',time[i],',', time_ss[j,i],',',$
                 vza[j,i],',',sza[j,i],',', $
                 vaa[j,i],',',saa[j,i],',', $
                 scat[j,i], format='(f8.3,1a,f8.3,1a,14a,1a,7(f8.3,1a))'
   endfor
  endfor
  free_lun, lun

  endfor

end
