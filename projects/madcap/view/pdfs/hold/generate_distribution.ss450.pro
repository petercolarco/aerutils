; Get and read Patricia's files to aggregate PDF of angles

; Let's read only the "nadir" portion of the ground track
  ix = 498

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']

  for im = 0, 11 do begin

; Get the filenames to probe...
  filen = file_search('/misc/prc19/colarco/OBS/A-CCP/SS450/LevelB','*nc4')
  filen = filen[where(strpos(filen,'2006'+mm[im]) ne -1)]

; Now generate some random numbers
  num = 100000L   ; a large number for all the samples that fail sza
  numwant = 10000 ; number of samples I really want
  nf = n_elements(filen) ; number of files in selection
  ns = 3600              ; number of seconds in file
  na = 10                ; number of view angles at pixel
  seed = 12345
  ifile = fix(randomu(seed,num)*nf)
  isec  = fix(randomu(seed,num)*ns)
  iang  = fix(randomu(seed,num)*na)

  inumwant = 0
  ii = 0

  while(inumwant lt numwant) do begin

  cdfid = ncdf_open(filen[ifile[ii]])
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, lon_, offset=[ix,iang[ii],isec[ii]], count=[1,1,1]
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, lat_, offset=[ix,iang[ii],isec[ii]], count=[1,1,1]
  id = ncdf_varid(cdfid,'vza')
  ncdf_varget, cdfid, id, vza_, offset=[ix,iang[ii],isec[ii]], count=[1,1,1]
  id = ncdf_varid(cdfid,'sza')
  ncdf_varget, cdfid, id, sza_, offset=[ix,iang[ii],isec[ii]], count=[1,1,1]
  id = ncdf_varid(cdfid,'saa')
  ncdf_varget, cdfid, id, saa_, offset=[ix,iang[ii],isec[ii]], count=[1,1,1]
  id = ncdf_varid(cdfid,'vaa')
  ncdf_varget, cdfid, id, vaa_, offset=[ix,iang[ii],isec[ii]], count=[1,1,1]
  id = ncdf_varid(cdfid,'scatAngle')
  ncdf_varget, cdfid, id, scat_, offset=[ix,iang[ii],isec[ii]], count=[1,1,1]
  ncdf_close, cdfid

  ii = ii + 1

  a = where(sza_ le 80.)

; save these if a[0] ne -1, else iterate
  if(a[0] ne -1) then begin

   print, inumwant, ii, filen[ifile[ii]]

   if(inumwant eq 0) then begin
    lon  = reform(lon_[a])
    lat  = reform(lat_[a])
    vza  = reform(vza_[a])
    sza  = reform(sza_[a])
    vaa  = reform(vaa_[a])
    saa  = reform(saa_[a])
    scat = reform(scat_[a])
   endif else begin
    lon  = [lon,reform(lon_[a])]
    lat  = [lat,reform(lat_[a])]
    vza  = [vza,reform(vza_[a])]
    sza  = [sza,reform(sza_[a])]
    vaa  = [vaa,reform(vaa_[a])]
    saa  = [saa,reform(saa_[a])]
    scat = [scat,reform(scat_[a])]
   endelse

   inumwant = inumwant + 1
  endif

  endwhile

  openw, lun, 'ss450/ss450.random.2006'+mm[im]+'.txt', /get
  printf, lun, n_elements(lon), 81, 91, 361, 361, 181
  printf, lun, lon
  printf, lun, lat
  printf, lun, vza
  printf, lun, sza
  printf, lun, vaa
  printf, lun, saa
  printf, lun, scat

  psza = histogram(sza,min=0.,max=80.,location=lsza)
  pvza = histogram(vza,min=0.,max=90., location=lvza)
  psaa = histogram(saa,min=0.,max=360., location=lsaa)
  pvaa = histogram(vaa,min=0.,max=360., location=lvaa)
  psca = histogram(scat,min=0.,max=180., location=lsca)

  printf, lun, psza
  printf, lun, pvza
  printf, lun, psaa
  printf, lun, pvaa
  printf, lun, psca

  free_lun, lun

  endfor

end
