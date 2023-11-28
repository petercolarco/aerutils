  pro readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
                  rh, rmass, refreal, refimag, radius=r, dr=dr, $
                  rlow=rlow, rup=rup, sigma=sigma, rmod0=rmod0, $
                  rmode=rmode, rmin=rmin, rmax=rmax, nsubbin=nsubbin, $
                  pmoments=pmoments, pback=pback, rhop=rhop, gf=gf
  cdfid = ncdf_open(filename)
   id = ncdf_varid(cdfid, 'rEff')
   ncdf_varget, cdfid, id, reff
   id = ncdf_varid(cdfid, 'radius')
   ncdf_varget, cdfid, id, r
   if(keyword_set(rhop)) then begin
    id = ncdf_varid(cdfid, 'rhop')
    ncdf_varget, cdfid, id, rhop
   endif
   id = ncdf_varid(cdfid, 'growth_factor')
   if(id ne -1) then ncdf_varget, cdfid, id, gf
   id = ncdf_varid(cdfid, 'rLow')
   ncdf_varget, cdfid, id, rLow
   id = ncdf_varid(cdfid, 'rUp')
   ncdf_varget, cdfid, id, rUp
   id = ncdf_varid(cdfid, 'rMin')
   if(id ne -1) then ncdf_varget, cdfid, id, rMin
   id = ncdf_varid(cdfid, 'rMax')
   if(id ne -1) then ncdf_varget, cdfid, id, rMax
   id = ncdf_varid(cdfid, 'rMod0')
   if(id ne -1) then ncdf_varget, cdfid, id, rMod0
   id = ncdf_varid(cdfid, 'rMode')
   if(id ne -1) then ncdf_varget, cdfid, id, rMode
   id = ncdf_varid(cdfid, 'sigma')
   if(id ne -1) then ncdf_varget, cdfid, id, sigma
   id = ncdf_varid(cdfid, 'nsubbin')
   if(id ne -1) then ncdf_varget, cdfid, id, nsubbin
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
   id = ncdf_varid(cdfid, 'pmom')
   if(id ne -1) then ncdf_varget, cdfid, id, pmoments
   id = ncdf_varid(cdfid, 'pback')
   if(id ne -1) then ncdf_varget, cdfid, id, pback
  ncdf_close, cdfid

  dr = rUp - rLow

end


