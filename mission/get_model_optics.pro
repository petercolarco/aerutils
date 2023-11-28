; Colarco
; Given delp, rh, and mmr calculate the optics

  pro get_model_optics, varname, lambda, mmr, delp, rh, tau, ssa, $
                                         gout, bbckout, etobout

; Check on varname for opticsfile
  varname_ = strlowcase(varname)
  opticsdir = '/Users/colarco/Desktop/TC4/20070719/'
  case varname_ of
   'du001'      : opticsfile = opticsDir+'/optics_DU.v2.hdf'
   'du002'      : opticsfile = opticsDir+'/optics_DU.v2.hdf'
   'du003'      : opticsfile = opticsDir+'/optics_DU.v2.hdf'
   'du004'      : opticsfile = opticsDir+'/optics_DU.v2.hdf'
   'du005'      : opticsfile = opticsDir+'/optics_DU.v2.hdf'
   'ss001'      : opticsfile = opticsDir+'/optics_SS.hdf'
   'ss002'      : opticsfile = opticsDir+'/optics_SS.hdf'
   'ss003'      : opticsfile = opticsDir+'/optics_SS.hdf'
   'ss004'      : opticsfile = opticsDir+'/optics_SS.hdf'
   'ss005'      : opticsfile = opticsDir+'/optics_SS.hdf'
   'so4'        : opticsfile = opticsDir+'/optics_SU.hdf'
   'ocphobic'   : opticsfile = opticsDir+'/optics_OC.hdf'
   'ocphilic'   : opticsfile = opticsDir+'/optics_OC.hdf'
   'bcphobic'   : opticsfile = opticsDir+'/optics_BC.hdf'
   'bcphilic'   : opticsfile = opticsDir+'/optics_BC.hdf'
  endcase

; Check on varname for handling
  case varname_ of
   'du001'      : begin & idx = 0 & do_rh = 0 & end
   'du002'      : begin & idx = 1 & do_rh = 0 & end
   'du003'      : begin & idx = 2 & do_rh = 0 & end
   'du004'      : begin & idx = 3 & do_rh = 0 & end
   'du005'      : begin & idx = 4 & do_rh = 0 & end
   'ss001'      : begin & idx = 0 & do_rh = 1 & end
   'ss002'      : begin & idx = 1 & do_rh = 1 & end
   'ss003'      : begin & idx = 2 & do_rh = 1 & end
   'ss004'      : begin & idx = 3 & do_rh = 1 & end
   'ss005'      : begin & idx = 4 & do_rh = 1 & end
   'so4'        : begin & idx = 0 & do_rh = 1 & end
   'ocphobic'   : begin & idx = 0 & do_rh = 0 & end
   'ocphilic'   : begin & idx = 1 & do_rh = 1 & end
   'bcphobic'   : begin & idx = 0 & do_rh = 0 & end
   'bcphilic'   : begin & idx = 1 & do_rh = 1 & end
  endcase


; read the optics file
  readoptics, opticsfile, reff, lambdaf, qext, qsca, bext, bsca, g, bbck, $
                          rhf, rmass, refreal, refimag

; reserve only desired variable
  reff = reform(reff[*,idx])
  qext = reform(qext[*,*,idx])
  qsca = reform(qsca[*,*,idx])
  bext = reform(bext[*,*,idx])
  bsca = reform(bsca[*,*,idx])
  g    = reform(g[*,*,idx])
  bbck = reform(bbck[*,*,idx])

; interpolate to wavelength wanted
  ilam = interpol(indgen(n_elements(lambdaf)),lambdaf,lambda)
  qext = reform(interpolate(transpose(qext),ilam))
  qsca = reform(interpolate(transpose(qsca),ilam))
  bext = reform(interpolate(transpose(bext),ilam))
  bsca = reform(interpolate(transpose(bsca),ilam))
  g    = reform(interpolate(transpose(g),ilam))
  bbck = reform(interpolate(transpose(bbck),ilam))


; Now compute the tau
  grav = 9.81
  szmmr = size(mmr)
  nx = szmmr[1]
  nz = szmmr[2]
  nrh = n_elements(rhf)
  tau = fltarr(nx,nz)
  ssa = fltarr(nx,nz)
  gout = fltarr(nx,nz)
  bbckout = fltarr(nx,nz)
  etobout = fltarr(nx,nz)
  if(not do_rh) then begin
    tau  = bext[0]*mmr*delp/grav
    ssa  = bsca[0]/bext[0]
    gout = g[0]
    bbckout = bbck[0]
    etobout[*,*] = bext[0]/bbck[0]
  endif else begin
   for iz = 0, nz-1 do begin
    for ix = 0, nx-1 do begin
     irh = interpol(indgen(nrh),rhf,rh[ix,iz])
     bext_ = interpolate(bext,irh)
     bsca_ = interpolate(bsca,irh)
     tau[ix,iz]  = bext_*mmr[ix,iz]*delp[ix,iz]/grav
     ssa[ix,iz]  = bsca_/bext_
     gout[ix,iz] = interpolate(g,irh)
     bbckout[ix,iz] = interpolate(bbck,irh)
     etobout[ix,iz] = bext_/bbckout[ix,iz]
    endfor
   endfor
  endelse

end
