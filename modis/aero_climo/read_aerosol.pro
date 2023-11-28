pro read_aerosol,month,aero_ocean,aero_land,aero_blu,longitude,latitude,err, $
                 yyyy=yyyy, satid=satid, res=res

;** Where "MM" is 01, 02, 03, ... 12 for month of year.

;** The climatology is composed of the years 2003 - 2009 MODIS Aqua data.
;** IDL code to read would be like the following, where "levels" is the wavelength in nm.
;**     Probably for both you only want levels = 550.

mm = long(month)

if(not(keyword_set(satid))) then satid = 'MYD04'
if(not(keyword_set(res)))   then res   = 'e'
if(not(keyword_set(yyyy)))  then begin
 yyyy  = 'clim'
 dir = '/misc/prc10/MODIS/Level3/'+satid+'/'+res+'/GRITAS/clim/'
endif else begin
 yyyy  = string(long(yyyy),"$(i4.4)")
 dir = '/misc/prc10/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y'+ $
       yyyy+'/M'+string(long(mm),"$(i2.2)")+'/'
endelse


;** read aerosol data
file_o = 'MYD04_L2_ocn.aero_tc8_051.qawt.'+yyyy  ;** ocean
file_l = 'MYD04_L2_lnd.aero_tc8_051.qawt3.'+yyyy ;** land
file_b = 'MYD04_L2_blu.aero_tc8_051.qawt3.'+yyyy ;** land

;** READ Ocean
filename = dir+file_o+string(long(mm),"$(i2.2)")+'.nc4'
print, filename
cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'aodtau')
  ncdf_varget, cdfid, id, aodtau_o
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, longitude
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, latitude
  id = ncdf_varid(cdfid,'levels')
  ncdf_varget, cdfid, id, levels_o
ncdf_close, cdfid

;** READ Land
filename = dir+file_l+string(long(mm),"$(i2.2)")+'.nc4'
cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'aodtau')
  ncdf_varget, cdfid, id, aodtau_l
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, longitude
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, latitude
  id = ncdf_varid(cdfid,'levels')
  ncdf_varget, cdfid, id, levels_l
ncdf_close, cdfid

;** READ Blu
filename = dir+file_b+string(long(mm),"$(i2.2)")+'.nc4'
cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'aodtau')
  ncdf_varget, cdfid, id, aodtau_b
  id = ncdf_varid(cdfid,'longitude')
  ncdf_varget, cdfid, id, longitude
  id = ncdf_varid(cdfid,'latitude')
  ncdf_varget, cdfid, id, latitude
  id = ncdf_varid(cdfid,'levels')
  ncdf_varget, cdfid, id, levels_b
ncdf_close, cdfid

;** isolate 550nm AOD for the output
qq=where(levels_l eq 550)
aero_land  = aodtau_l(*,*,qq)
qq=where(levels_o eq 550)
aero_ocean = aodtau_o(*,*,qq)
qq=where(levels_b eq 550)
aero_blu   = aodtau_b(*,*,qq)

qq=where(aero_ocean ge 1000.)
if qq(0) ne -1 then aero_ocean(qq)=!values.f_nan
qq=where(aero_land ge 1000.)
if qq(0) ne -1 then aero_land(qq)=!values.f_nan
qq=where(aero_blu ge 1000.)
if qq(0) ne -1 then aero_blu(qq)=!values.f_nan

return
end
