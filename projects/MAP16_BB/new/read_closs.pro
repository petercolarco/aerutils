  nx = 720
  ny = 287

  yyyy = 1980
  cdfid = ncdf_open('CatCN_LDASsa45_c10_'+string(yyyy,format='(i4)')+'.nc')
     id = ncdf_varid(cdfid,'CLOSS')
  ncdf_varget, cdfid, id, closs

end
