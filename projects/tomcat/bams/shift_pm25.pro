; Read the save files and make a new file that shifts to local time
; and export

  files = ['full','tomcat1.450km','tomcat1.nadir', $
                  'tomcat2.450km','tomcat2.nadir', $
                  'tomcat3.450km','tomcat3.nadir', $
                  'tomcat4.450km','tomcat4.nadir', $
                  'tomcata.450km','tomcata.nadir' ]

  nfile = n_elements(files)
  for i = 0, nfile-1 do begin
   filen = 'pm25_annual.'+files[i]+'.2014.aod.cloud.nc4'
   read_diurnal_annual_nc, filen, 'pm25', nx, ny, nt, lon, lat, var, nn
   head = 'pm25_annual.'+files[i]+'.2014.aod.cloud.shifted'
   save_diurnal_nc, head, nx, ny, nt, lon, lat, var, 'pm25', nn
endfor

end
