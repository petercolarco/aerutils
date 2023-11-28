pro read_aerosol,month,aero_ocean,longitude,latitude,err

dir = '/misc/prc10/MISR/Level3/e/GRITAS/clim/'

;** read aerosol data
file_o = 'MISR_L2.aero_tc8_F12_0022.noqawt.clim'  ;** ocean

;** Where "MM" is 01, 02, 03, ... 12 for month of year.

;** The climatology is composed of the years 2003 - 2009 MODIS Aqua data.
;** IDL code to read would be like the following, where "levels" is the wavelength in nm.
;**     Probably for both you only want levels = 550.

mm = long(month)

;** READ Ocean
filename = dir+file_o+string(long(mm),"$(i2.2)")+'.nc4'
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

;** isolate 550nm AOD for the output
qq=where(levels_o eq 558)
aero_ocean = aodtau_o(*,*,qq)

qq=where(aero_ocean ge 1000.)
if qq(0) ne -1 then aero_ocean(qq)=!values.f_nan

return
end
