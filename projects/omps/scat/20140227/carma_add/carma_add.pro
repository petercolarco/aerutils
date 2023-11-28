  cdfid = ncdf_open('G41prcR2010.trj.nc', /write)
  id = ncdf_varid(cdfid,'su001')
  ncdf_varget, cdfid, id, su001
print, min(su001), max(su001)

  for i = 2, 22 do begin
   ii = strpad(i,10)
   id = ncdf_varid(cdfid,'su0'+ii)
   ncdf_varget, cdfid, id, su
print, min(su), max(su)
   su001 = su001+su
   su[*,*] = 0.
   ncdf_varput, cdfid, id, su
  endfor

  id = ncdf_varid(cdfid,'su001')
  ncdf_varput, cdfid, id, su001

  ncdf_close, cdfid
  
end
