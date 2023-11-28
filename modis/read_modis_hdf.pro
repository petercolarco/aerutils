; Colarco
; Read a gridded (4x daily) MODIS AOT ocn/land set and produce a merged
; daily average

; Date desired
  symd = '20090207'
  yyyy = strmid(symd,0,4)
  mm   = strmid(symd,4,2)

; Location of MODIS (Aqua) data
  datadir = '/misc/prc10/colarco/MODIS/Level3/MYD04/d/GRITAS/'
  datadir = dataDir + 'Y'+yyyy+'/M'+mm+'/'

; Get ocean
  filename = dataDir + 'MYD04_L2_ocn.aero_051.qawt.'+symd+'.hdf'
  hdfid = hdf_sd_start(filename)
     idx = hdf_sd_nametoindex(hdfid,'aodtau')
     if(idx eq -1) then idx = hdf_sd_nametoindex(hdfid,strupcase(varlist))
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, aotocn
     idx = hdf_sd_nametoindex(hdfid,'longitude')
     if(idx eq -1) then idx = hdf_sd_nametoindex(hdfid,strupcase(varlist))
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, lon
     idx = hdf_sd_nametoindex(hdfid,'latitude')
     if(idx eq -1) then idx = hdf_sd_nametoindex(hdfid,strupcase(varlist))
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, lat
     idx = hdf_sd_nametoindex(hdfid,'levels')
     if(idx eq -1) then idx = hdf_sd_nametoindex(hdfid,strupcase(varlist))
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, lev
  hdf_sd_end, hdfid
; Keep only the 550 nm AOT
  aotocn = reform(aotocn[*,*,5,*])

; Get land
  filename = dataDir + 'MYD04_L2_lnd.aero_051.qawt.'+symd+'.hdf'
  hdfid = hdf_sd_start(filename)
     idx = hdf_sd_nametoindex(hdfid,'aodtau')
     if(idx eq -1) then idx = hdf_sd_nametoindex(hdfid,strupcase(varlist))
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, aotlnd
     idx = hdf_sd_nametoindex(hdfid,'longitude')
     if(idx eq -1) then idx = hdf_sd_nametoindex(hdfid,strupcase(varlist))
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, lon
     idx = hdf_sd_nametoindex(hdfid,'latitude')
     if(idx eq -1) then idx = hdf_sd_nametoindex(hdfid,strupcase(varlist))
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, lat
     idx = hdf_sd_nametoindex(hdfid,'levels')
     if(idx eq -1) then idx = hdf_sd_nametoindex(hdfid,strupcase(varlist))
     id  = hdf_sd_select(hdfid,idx)
     hdf_sd_getdata, id, lev
  hdf_sd_end, hdfid
; Keep only the 550 nm AOT
  aotlnd = reform(aotlnd[*,*,1,*])

; Make NaN all missing values and average together to get daily mean
  a = where(aotocn ge 1e14)
  if(a[0] ne -1) then aotocn[a] = !values.f_nan
  a = where(aotlnd ge 1e14)
  if(a[0] ne -1) then aotlnd[a] = !values.f_nan

; Now make a daily average AOT
  nx = n_elements(lon)
  ny = n_elements(lat)
  aot = fltarr(nx,ny)
  for ix = 0, nx-1 do begin
   for iy = 0, ny-1 do begin
    aot[ix,iy] = mean([aotocn[ix,iy,*],aotlnd[ix,iy,*]],/nan)
   endfor
  endfor



end
