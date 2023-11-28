; Colarco, January 2016
; Grid the retrievals to a regular lat/lon grid

  pro grid_retrieval, filen, tdef, lon, lat, $
                      ler388, aod, ssa, $
                      residue, ai, prs, $
                      rad354, rad388, $
                      resolution=resolution

; create the output filename
  x = strpos(filen,'.he5')
  fileout2 = strmid(filen,0,x)+'.grid'

  if(not(keyword_set(resolution))) then resolution = 'd'

  area, lon_, lat_, nx, ny, dx, dy, area, grid=resolution

  ler388_ = make_array(nx,ny,val=1.e15)
  rad354_ = make_array(nx,ny,val=1.e15)
  rad388_ = make_array(nx,ny,val=1.e15)
  aod_    = make_array(nx,ny,val=1.e15)
  ssa_    = make_array(nx,ny,val=1.e15)
  residue_= make_array(nx,ny,val=1.e15)
  ai_     = make_array(nx,ny,val=1.e15)
  prs_    = make_array(nx,ny,val=1.e15)

  ler388__ = make_array(nx,ny,val=0.)
  rad354__ = make_array(nx,ny,val=0.)
  rad388__ = make_array(nx,ny,val=0.)
  aod__    = make_array(nx,ny,val=0.)
  ssa__    = make_array(nx,ny,val=0.)
  residue__= make_array(nx,ny,val=0.)
  ai__     = make_array(nx,ny,val=0.)
  prs__    = make_array(nx,ny,val=0.)
  nler388__ = make_array(nx,ny,val=0)
  nrad354__ = make_array(nx,ny,val=0)
  nrad388__ = make_array(nx,ny,val=0)
  naod__    = make_array(nx,ny,val=0)
  nssa__    = make_array(nx,ny,val=0)
  nresidue__= make_array(nx,ny,val=0)
  nai__     = make_array(nx,ny,val=0)
  nprs__    = make_array(nx,ny,val=0)

  pts  = where(ler388 gt -1e14)
  ler388 = ler388[pts]
  npts = n_elements(pts)
  ix = interpol(indgen(nx), lon_, lon[pts])
  iy = interpol(indgen(ny), lat_, lat[pts])
  ix = fix(ix+.5)
  iy = fix(iy+.5)
  a = where(ix eq nx)            ; wrap around
  if(a[0] ne -1) then ix[a] = 0
  for ipts = 0L, npts-1 do begin
   if(ler388[ipts] gt -1e14) then begin
    ler388__[ix[ipts],iy[ipts]] = ler388__[ix[ipts],iy[ipts]] + ler388[ipts]
    nler388__[ix[ipts],iy[ipts]] = nler388__[ix[ipts],iy[ipts]] + 1
   endif
  endfor
  a = where(nler388__ gt 0)
  ler388_[a] = ler388__[a]/nler388__[a]


  pts  = where(rad354 gt -1e14)
  rad354 = rad354[pts]
  npts = n_elements(pts)
  ix = interpol(indgen(nx), lon_, lon[pts])
  iy = interpol(indgen(ny), lat_, lat[pts])
  ix = fix(ix+.5)
  iy = fix(iy+.5)
  a = where(ix eq nx)            ; wrap around
  if(a[0] ne -1) then ix[a] = 0
  for ipts = 0L, npts-1 do begin
   if(rad354[ipts] gt -1e14) then begin
    rad354__[ix[ipts],iy[ipts]] = rad354__[ix[ipts],iy[ipts]] + rad354[ipts]
    nrad354__[ix[ipts],iy[ipts]] = nrad354__[ix[ipts],iy[ipts]] + 1
   endif
  endfor
  a = where(nrad354__ gt 0)
  rad354_[a] = rad354__[a]/nrad354__[a]


  pts  = where(rad388 gt -1e14)
  rad388 = rad388[pts]
  npts = n_elements(pts)
  ix = interpol(indgen(nx), lon_, lon[pts])
  iy = interpol(indgen(ny), lat_, lat[pts])
  ix = fix(ix+.5)
  iy = fix(iy+.5)
  a = where(ix eq nx)            ; wrap around
  if(a[0] ne -1) then ix[a] = 0
  for ipts = 0L, npts-1 do begin
   if(rad388[ipts] gt -1e14) then begin
    rad388__[ix[ipts],iy[ipts]] = rad388__[ix[ipts],iy[ipts]] + rad388[ipts]
    nrad388__[ix[ipts],iy[ipts]] = nrad388__[ix[ipts],iy[ipts]] + 1
   endif
  endfor
  a = where(nrad388__ gt 0)
  rad388_[a] = rad388__[a]/nrad388__[a]


  pts  = where(aod gt -1e14)
  aod = aod[pts]
  npts = n_elements(pts)
  ix = interpol(indgen(nx), lon_, lon[pts])
  iy = interpol(indgen(ny), lat_, lat[pts])
  ix = fix(ix+.5)
  iy = fix(iy+.5)
  a = where(ix eq nx)            ; wrap around
  if(a[0] ne -1) then ix[a] = 0
  for ipts = 0L, npts-1 do begin
   if(aod[ipts] gt -1e14) then begin
    aod__[ix[ipts],iy[ipts]] = aod__[ix[ipts],iy[ipts]] + aod[ipts]
    naod__[ix[ipts],iy[ipts]] = naod__[ix[ipts],iy[ipts]] + 1
   endif
  endfor
  a = where(naod__ gt 0)
  aod_[a] = aod__[a]/naod__[a]

  pts  = where(ssa gt -1e14)
  ssa = ssa[pts]
  npts = n_elements(pts)
  ix = interpol(indgen(nx), lon_, lon[pts])
  iy = interpol(indgen(ny), lat_, lat[pts])
  ix = fix(ix+.5)
  iy = fix(iy+.5)
  a = where(ix eq nx)            ; wrap around
  if(a[0] ne -1) then ix[a] = 0
  for ipts = 0L, npts-1 do begin
   if(ssa[ipts] gt -1e14) then begin
    ssa__[ix[ipts],iy[ipts]] = ssa__[ix[ipts],iy[ipts]] + ssa[ipts]
    nssa__[ix[ipts],iy[ipts]] = nssa__[ix[ipts],iy[ipts]] + 1
   endif
  endfor
  a = where(nssa__ gt 0)
  ssa_[a] = ssa__[a]/nssa__[a]


  residue = residue[pts]
  npts = n_elements(pts)
  ix = interpol(indgen(nx), lon_, lon[pts])
  iy = interpol(indgen(ny), lat_, lat[pts])
  ix = fix(ix+.5)
  iy = fix(iy+.5)
  a = where(ix eq nx)            ; wrap around
  if(a[0] ne -1) then ix[a] = 0
  for ipts = 0L, npts-1 do begin
   if(residue[ipts] gt -1e14) then begin
    residue__[ix[ipts],iy[ipts]] = residue__[ix[ipts],iy[ipts]] + residue[ipts]
    nresidue__[ix[ipts],iy[ipts]] = nresidue__[ix[ipts],iy[ipts]] + 1
   endif
  endfor
  a = where(nresidue__ gt 0)
  residue_[a] = residue__[a]/nresidue__[a]


  pts  = where(ai gt -1e14)
  ai = ai[pts]
  npts = n_elements(pts)
  ix = interpol(indgen(nx), lon_, lon[pts])
  iy = interpol(indgen(ny), lat_, lat[pts])
  ix = fix(ix+.5)
  iy = fix(iy+.5)
  a = where(ix eq nx)            ; wrap around
  if(a[0] ne -1) then ix[a] = 0
  for ipts = 0L, npts-1 do begin
   if(ai[ipts] gt -1e14) then begin
    ai__[ix[ipts],iy[ipts]] = ai__[ix[ipts],iy[ipts]] + ai[ipts]
    nai__[ix[ipts],iy[ipts]] = nai__[ix[ipts],iy[ipts]] + 1
   endif
  endfor
  a = where(nai__ gt 0)
  ai_[a] = ai__[a]/nai__[a]


  pts  = where(prs gt -1e14)
  prs = prs[pts]
  npts = n_elements(pts)
  ix = interpol(indgen(nx), lon_, lon[pts])
  iy = interpol(indgen(ny), lat_, lat[pts])
  ix = fix(ix+.5)
  iy = fix(iy+.5)
  a = where(ix eq nx)            ; wrap around
  if(a[0] ne -1) then ix[a] = 0
  for ipts = 0L, npts-1 do begin
   if(prs[ipts] gt -1e14) then begin
    prs__[ix[ipts],iy[ipts]] = prs__[ix[ipts],iy[ipts]] + prs[ipts]
    nprs__[ix[ipts],iy[ipts]] = nprs__[ix[ipts],iy[ipts]] + 1
   endif
  endfor
  a = where(nprs__ gt 0)
  prs_[a] = prs__[a]/nprs__[a]


; Write an intermediary file
  rnum = strcompress(string(abs(randomu(seed,/long))),/rem)
  fileout = 'aot.'+rnum+'.nc'
   cdfid = ncdf_create(fileout, /clobber)
    idLon = NCDF_DIMDEF(cdfid,'lon',nx)
    idLat = NCDF_DIMDEF(cdfid,'lat',ny)
    idTime = NCDF_DIMDEF(cdfid,'time',/unlimited)
    idLongitude = NCDF_VARDEF(cdfid,'lon',[idLon], /float)
    idLatitude  = NCDF_VARDEF(cdfid,'lat',[idLat], /float)
    idAot  = NCDF_VARDEF(cdfid,'aot',[idLon,idLat], /float)
    idSSA  = NCDF_VARDEF(cdfid,'ssa',[idLon,idLat], /float)
    idLer388  = NCDF_VARDEF(cdfid,'ler388',[idLon,idLat], /float)
    idRad354  = NCDF_VARDEF(cdfid,'rad354',[idLon,idLat], /float)
    idRad388  = NCDF_VARDEF(cdfid,'rad388',[idLon,idLat], /float)
    idResidue  = NCDF_VARDEF(cdfid,'residue',[idLon,idLat], /float)
    idAI  = NCDF_VARDEF(cdfid,'ai',[idLon,idLat], /float)
    idPRS = NCDF_VARDEF(cdfid,'prs',[idLon,idLat], /float)
    idnAot  = NCDF_VARDEF(cdfid,'naot',[idLon,idLat], /float)
    idnSSA  = NCDF_VARDEF(cdfid,'nssa',[idLon,idLat], /float)
    idnLer388  = NCDF_VARDEF(cdfid,'nler388',[idLon,idLat], /float)
    idnRad354  = NCDF_VARDEF(cdfid,'nrad354',[idLon,idLat], /float)
    idnRad388  = NCDF_VARDEF(cdfid,'nrad388',[idLon,idLat], /float)
    idnResidue  = NCDF_VARDEF(cdfid,'nresidue',[idLon,idLat], /float)
    idnAI  = NCDF_VARDEF(cdfid,'nai',[idLon,idLat], /float)
    idnPrs = NCDF_VARDEF(cdfid,'nprs',[idLon,idLat], /float)
    idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)
    ncdf_control, cdfid, /endef
    ncdf_varput, cdfid, idLongitude, lon_
    ncdf_varput, cdfid, idLatitude, lat_
    ncdf_varput, cdfid, idDate, '1'
    ncdf_varput, cdfid, idAot, aod_
    ncdf_varput, cdfid, idSSA, ssa_
    ncdf_varput, cdfid, idLer388, ler388_
    ncdf_varput, cdfid, idRad354, rad354_
    ncdf_varput, cdfid, idRad388, rad388_
    ncdf_varput, cdfid, idResidue, residue_
    ncdf_varput, cdfid, idAI, ai_
    ncdf_varput, cdfid, idPRS, prs_
    ncdf_varput, cdfid, idnAot, naod__
    ncdf_varput, cdfid, idnSSA, nssa__
    ncdf_varput, cdfid, idnLer388, nler388__
    ncdf_varput, cdfid, idnRad354, nrad354__
    ncdf_varput, cdfid, idnRad388, nrad388__
    ncdf_varput, cdfid, idnResidue, nresidue__
    ncdf_varput, cdfid, idnAI, nai__
    ncdf_varput, cdfid, idnPRS, nprs__
   ncdf_close, cdfid

; Make a control file and process
   fileout_ = 'aot.'+rnum+'.ctl'
   openw, lun, fileout_, /get_lun
   printf, lun, 'dset ^'+fileout
   printf, lun, 'undef 1e15'
   printf, lun, 'xdef lon '+string(nx)+' linear -180 '+string(dx)
   printf, lun, 'ydef lat '+string(ny)+' linear -90 '+string(dy)
   printf, lun, tdef
   free_lun, lun

   lonstr = ' -lon -180 '+strcompress(string(max(lon)),/rem)
;   lonstr = ''

   cmd = 'lats4d.sh -v -i '+fileout_+' -o '+fileout2+' -ftype xdf -shave'
   spawn, cmd, /sh

   cmd = '\rm -f aot.'+rnum+'.ctl aot.'+rnum+'.nc'
   spawn, cmd, /sh

end
