  files = file_search('./raw/','htap*elev*nc4')

  nf = n_elements(files)
  for i = 0, nf-1 do begin
   cdfid = ncdf_open(files[i])
   id = ncdf_varid(cdfid,'lon')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid,'lat')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,'time')
   ncdf_varget, cdfid, id, time
   id = ncdf_varid(cdfid,'sanl2')
   ncdf_varget, cdfid, id, sanl
   ncdf_close, cdfid

   for j = 0, 11 do begin
    a = where(finite(sanl[*,*,j]) ne 1)
     if(a[0] ne -1) then begin
      ind = array_indices(sanl[*,*,j],a[0])
      print, files[i], j, n_elements(a), a[0], lon[ind[0]], lat[ind[1]]
     endif else begin
      print, files[i], j, n_elements(a), a[0]
     endelse
   endfor

  endfor

end
