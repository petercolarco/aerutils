; Colarco
; Compare the default aeronet_locs.dat to the inventory in the model
; run and strip out only sites that are in both.


  read_aeronet_locs, location, lat, lon, elevation

  files = file_search('/misc/prc15/colarco/dR_MERRA-AA-r2/inst2d_hwl_x/dR_MERRA-AA-r2.inst2d_hwl.aeronet.*.2003.nc4')
; cut out header
  len1 = strlen('/misc/prc15/colarco/dR_MERRA-AA-r2/inst2d_hwl_x/dR_MERRA-AA-r2.inst2d_hwl.aeronet.')
  for i = 0, n_elements(files)-1 do begin
   split = strsplit(strmid(files[i],len1),'.',/extract)
   files[i] = split[0]
  endfor

; Open old location file and new location file
  openr, lun, 'aeronet_locs.dat', /get
  openw, lun2, 'aeronet_locs.dat.part', /get
  str = 'a'
  readf, lun, str
  printf, lun2, str
  readf, lun, str
  printf, lun2, str

  for i = 0, n_elements(location)-1 do begin
   a = where(location[i] eq files)
   readf, lun, str
   if(a[0] ne -1) then printf, lun2, str
  endfor

  free_lun, lun
  free_lun, lun2



end
