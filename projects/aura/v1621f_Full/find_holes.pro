; Colarco
; Find files which somehow appear not complete, as judged by size of
; arrays

   files   = file_search('/misc/prc08/colarco/OMAERUV_V1621_DATA/2007/', $
                         'OMI-Aura_L2-OMAERUV_2007m06*.he5')
  gfilesd  = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/'

; Read the files and get a variable
  for ifile = 0, n_elements(files)-1 do begin

;   Get the level 2 for the lat/lon
    file_id = h5f_open(files[ifile])
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prx_    = h5d_read(var_id)
    nxy1    = n_elements(prx_)
    h5f_close, file_id

;   Get the PGEO filename
    str1 = strsplit(files[ifile],'/',/extract,count=n)
    str2 = strsplit(str1[n-1],'.',/extract)
    filet = str2[0]

    on_ioerror, jump1
    filen = gfilesd+filet+'.vl_rad.he5'
    res = file_search(filen)
    if(res eq '') then goto, jump1
    file_id = h5f_open(filen)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prx_    = h5d_read(var_id)
    nxy2    = n_elements(prx_)
    h5f_close, file_id

    on_ioerror, jump1
    filen = gfilesd+filet+'.vl_rad.geos5_pressure.he5'
    res = file_search(filen)
    if(res eq '') then goto, jump1
    file_id = h5f_open(filen)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prx_    = h5d_read(var_id)
    nxy3    = n_elements(prx_)
    h5f_close, file_id

    if((nxy1 ne nxy2) or (nxy1 ne nxy3)) then print, filet, nxy1, nxy2, nxy3

    goto, jump2

jump1: print, 'missing ', filet

jump2:

  endfor

 end
