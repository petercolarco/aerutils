; Read the chem.eta of the model and extract all along track

; First find the variables in the file
  model = '/Users/colarco/Desktop/TC4/20070719/d5_tc4_01.inst3d_aer_v.20070719_1800z.hdf'
  ga_getvar_, model, '', varout, varlist=varlist, /noprint

; Now read the flight track
  outfile = 'asm_optics.er2.20070719.nc'
  datewant= '20070719'
  datadir = '/Users/colarco/Desktop/TC4/data/'
  get_er2_navtrack, datadir, datewant, lonf, latf, levf, prsf, gmt
  nx = n_elements(gmt)


; Get the model profile
  vars = [varlist[4:13],varlist[16],varlist[18:21]]
  get_model_navtrack, model, 'ps', ps, lonf, latf, lev, wanttime=[1]
  get_model_navtrack, model, 'rh', rh, lonf, latf, lev, wanttime=[1]
  get_model_navtrack, model, 'delp', delp, lonf, latf, lev, wanttime=[1]
  szarr = size(rh)
  nx = szarr[1]
  nz = szarr[2]
  nv = n_elements(vars)
  mmr = fltarr(nx,nz,nv)
  tau = fltarr(nx,nz,nv)
  ssa = fltarr(nx,nz,nv)
  g   = fltarr(nx,nz,nv)
  bbck = fltarr(nx,nz,nv)
  etob = fltarr(nx,nz,nv)

; optics
  lambda = .532e-6
  for iv = 0, nv-1 do begin
   get_model_navtrack, model, vars[iv], mmr_, lonf, latf, lev, wanttime=[1]
   get_model_optics, vars[iv], lambda, mmr_, delp, rh, tau_, ssa_, $
                                       g_, bbck_, etob_
   mmr[*,*,iv] = mmr_
   tau[*,*,iv] = tau_
   ssa[*,*,iv] = ssa_
   g[*,*,iv]   = g_
   bbck[*,*,iv] = bbck_
   etob[*,*,iv] = etob_
  endfor

; integrate the optics
  integrateoptics, tau, ssa, g, bbck, etob, $
                   tauout, ssaout, gout, bbckout, etob, abck0, abck1

  rh = transpose(rh)
  delp = transpose(delp)
  mmr = transpose(total(mmr,3))
  tauout = transpose(tauout)
  ssaout = transpose(ssaout)
  gout = transpose(gout)
  etob = transpose(etob)
  abck0 = transpose(abck0)
  abck1 = transpose(abck1)

  cdfid = ncdf_create(outfile, /clobber)
   idLon = ncdf_dimdef(cdfid,'lon',1)
   idLat = ncdf_dimdef(cdfid,'lat',1)
   idLev = ncdf_dimdef(cdfid,'lev',nz)
   idtime = ncdf_dimdef(cdfid,'time',nx)

   idLonv = ncdf_vardef(cdfid,'lon',[idlon])
   idLatv = ncdf_vardef(cdfid,'lat',[idlat])
   idLevv = ncdf_vardef(cdfid,'lev',[idlev])
   idTimv = ncdf_vardef(cdfid,'time',[idtime])

   idps   = ncdf_vardef(cdfid,'ps',[idlon,idlat,idTime])
   idRH   = ncdf_vardef(cdfid,'rh',[idlon,idlat,idlev,idTime])
   idDelp = ncdf_vardef(cdfid,'delp',[idlon,idlat,idlev,idTime])
   idMmr = ncdf_vardef(cdfid,'mmr',[idlon,idlat,idlev,idTime])
   idtau = ncdf_vardef(cdfid,'tau',[idlon,idlat,idlev,idTime])
   idssa = ncdf_vardef(cdfid,'ssa',[idlon,idlat,idlev,idTime])
   idg   = ncdf_vardef(cdfid,'g',[idlon,idlat,idlev,idTime])
   idetob    = ncdf_vardef(cdfid,'etob',[idlon,idlat,idlev,idTime])
   idabck0   = ncdf_vardef(cdfid,'attback0',[idlon,idlat,idlev,idTime])
   idabck1   = ncdf_vardef(cdfid,'attback1',[idlon,idlat,idlev,idTime])

  ncdf_control, cdfid, /endef
  ncdf_varput, cdfid, idLonv, 0.
  ncdf_varput, cdfid, idLatv, 0.
  ncdf_varput, cdfid, idLevv, indgen(nz)+1
  ncdf_varput, cdfid, idTimv, indgen(nx)+1

  ncdf_varput, cdfid, idPS, reform(ps,1,1,nx)
  ncdf_varput, cdfid, idRH, reform(rh,1,1,nz,nx)
  ncdf_varput, cdfid, idDelp, reform(delp,1,1,nz,nx)

  ncdf_varput, cdfid, idMmr, reform(mmr,1,1,nz,nx)
  ncdf_varput, cdfid, idTau, reform(tauOut,1,1,nz,nx)
  ncdf_varput, cdfid, idSsa, reform(ssaOUt,1,1,nz,nx)
  ncdf_varput, cdfid, idG,   reform(gOut,1,1,nz,nx)
  ncdf_varput, cdfid, idetob,   reform(etob,1,1,nz,nx)
  ncdf_varput, cdfid, idabck0,   reform(abck0,1,1,nz,nx)
  ncdf_varput, cdfid, idabck1,   reform(abck1,1,1,nz,nx)

  ncdf_close, cdfid


end
