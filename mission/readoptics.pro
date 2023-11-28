  pro readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
                  rh, rmass, refreal, refimag
  cdfid = ncdf_open(filename)
   id = ncdf_varid(cdfid, 'rEff')
   ncdf_varget, cdfid, id, reff
   id = ncdf_varid(cdfid, 'lambda')
   ncdf_varget, cdfid, id, lambda
   id = ncdf_varid(cdfid, 'qext')
   ncdf_varget, cdfid, id, qext
   id = ncdf_varid(cdfid, 'qsca')
   ncdf_varget, cdfid, id, qsca
   id = ncdf_varid(cdfid, 'bext')
   ncdf_varget, cdfid, id, bext
   id = ncdf_varid(cdfid, 'bsca')
   ncdf_varget, cdfid, id, bsca
   id = ncdf_varid(cdfid, 'g')
   ncdf_varget, cdfid, id, g
   id = ncdf_varid(cdfid, 'bbck')
   ncdf_varget, cdfid, id, bbck
   id = ncdf_varid(cdfid, 'rh')
   ncdf_varget, cdfid, id, rh
   id = ncdf_varid(cdfid, 'rMass')
   ncdf_varget, cdfid, id, rmass
   id = ncdf_varid(cdfid, 'refreal')
   ncdf_varget, cdfid, id, refreal
   id = ncdf_varid(cdfid, 'refimag')
   ncdf_varget, cdfid, id, refimag
  ncdf_close, cdfid

end


