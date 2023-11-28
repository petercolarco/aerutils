; Colarco, January 2016
; Grid the retrievals to a regular lat/lon grid

  pro grid_retrieval, filen, tdef, lon, lat, $
                      ler388, ref388, aod, ssa, $
                      aerh, aert, residue, ai, prs, $
                      resolution=resolution, aerht=aerht

; Add optional flag to retain only points where aerh > 0
; Affects AOD, SSA only

; create the output filename
  x = strpos(filen,'.nc4')
  fileout2 = strmid(filen,0,x)+'.grid'

  if(not(keyword_set(resolution))) then resolution = 'd'

  area, lon_, lat_, nx, ny, dx, dy, area, grid=resolution

;  ler354_ = make_array(nx,ny,val=1.e15)
  ler388_ = make_array(nx,ny,val=1.e15)
;  ref354_ = make_array(nx,ny,val=1.e15)
  ref388_ = make_array(nx,ny,val=1.e15)
  aod_    = make_array(nx,ny,val=1.e15)
  ssa_    = make_array(nx,ny,val=1.e15)
  aerh_   = make_array(nx,ny,val=1.e15)
  residue_= make_array(nx,ny,val=1.e15)
  ai_     = make_array(nx,ny,val=1.e15)
  prs_    = make_array(nx,ny,val=1.e15)

;  ler354__ = make_array(nx,ny,val=0.)
  ler388__ = make_array(nx,ny,val=0.)
;  ref354__ = make_array(nx,ny,val=0.)
  ref388__ = make_array(nx,ny,val=0.)
  aod__    = make_array(nx,ny,val=0.)
  ssa__    = make_array(nx,ny,val=0.)
  aerh__   = make_array(nx,ny,val=0.)
  residue__= make_array(nx,ny,val=0.)
  ai__     = make_array(nx,ny,val=0.)
  prs__    = make_array(nx,ny,val=0.)
;  nler354__ = make_array(nx,ny,val=0)
  nler388__ = make_array(nx,ny,val=0)
;  nref354__ = make_array(nx,ny,val=0)
  nref388__ = make_array(nx,ny,val=0)
  naod__    = make_array(nx,ny,val=0)
  nssa__    = make_array(nx,ny,val=0)
  naerh__   = make_array(nx,ny,val=0)
  nsulf__   = make_array(nx,ny,val=0)
  ndust__   = make_array(nx,ny,val=0)
  nsmok__   = make_array(nx,ny,val=0)
  nresidue__= make_array(nx,ny,val=0)
  nai__     = make_array(nx,ny,val=0)
  nprs__    = make_array(nx,ny,val=0)

;  pts  = where(ler354 gt -1e14)
;  ler354 = ler354[pts]
;  npts = n_elements(pts)
;  ix = interpol(indgen(nx), lon_, lon[pts])
;  iy = interpol(indgen(ny), lat_, lat[pts])
;  ix = fix(ix+.5)
;  iy = fix(iy+.5)
;  a = where(ix eq nx)            ; wrap around
;  if(a[0] ne -1) then ix[a] = 0
;  for ipts = 0L, npts-1 do begin
;   if(ler354[ipts] gt -1e14) then begin
;    ler354__[ix[ipts],iy[ipts]] = ler354__[ix[ipts],iy[ipts]] + ler354[ipts]
;    nler354__[ix[ipts],iy[ipts]] = nler354__[ix[ipts],iy[ipts]] + 1
;   endif
;  endfor
;  a = where(nler354__ gt 0)
;  ler354_[a] = ler354__[a]/nler354__[a]


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


;  pts  = where(ref354 gt -1e14)
;  ref354 = ref354[pts]
;  npts = n_elements(pts)
;  ix = interpol(indgen(nx), lon_, lon[pts])
;  iy = interpol(indgen(ny), lat_, lat[pts])
;  ix = fix(ix+.5)
;  iy = fix(iy+.5)
;  a = where(ix eq nx)            ; wrap around
;  if(a[0] ne -1) then ix[a] = 0
;  for ipts = 0L, npts-1 do begin
;   if(ref354[ipts] gt -1e14) then begin
;    ref354__[ix[ipts],iy[ipts]] = ref354__[ix[ipts],iy[ipts]] + ref354[ipts]
;    nref354__[ix[ipts],iy[ipts]] = nref354__[ix[ipts],iy[ipts]] + 1
;   endif
;  endfor
;  a = where(nref354__ gt 0)
;  ref354_[a] = ref354__[a]/nref354__[a]


  pts  = where(ref388 gt -1e14)
  ref388 = ref388[pts]
  npts = n_elements(pts)
  ix = interpol(indgen(nx), lon_, lon[pts])
  iy = interpol(indgen(ny), lat_, lat[pts])
  ix = fix(ix+.5)
  iy = fix(iy+.5)
  a = where(ix eq nx)            ; wrap around
  if(a[0] ne -1) then ix[a] = 0
  for ipts = 0L, npts-1 do begin
   if(ref388[ipts] gt -1e14) then begin
    ref388__[ix[ipts],iy[ipts]] = ref388__[ix[ipts],iy[ipts]] + ref388[ipts]
    nref388__[ix[ipts],iy[ipts]] = nref388__[ix[ipts],iy[ipts]] + 1
   endif
  endfor
  a = where(nref388__ gt 0)
  ref388_[a] = ref388__[a]/nref388__[a]


  pts  = where(aod gt -1e14)
  if(keyword_set(aerht)) then pts  = where(aod gt -1e14 and aerh gt 0)
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
  if(keyword_set(aerht)) then pts  = where(ssa gt -1e14 and aerh gt 0)
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


  pts  = where(aerh gt -1e14)
  aerh = aerh[pts]
  npts = n_elements(pts)
  ix = interpol(indgen(nx), lon_, lon[pts])
  iy = interpol(indgen(ny), lat_, lat[pts])
  ix = fix(ix+.5)
  iy = fix(iy+.5)
  a = where(ix eq nx)            ; wrap around
  if(a[0] ne -1) then ix[a] = 0
  for ipts = 0L, npts-1 do begin
   if(aerh[ipts] gt -1e14) then begin
    aerh__[ix[ipts],iy[ipts]] = aerh__[ix[ipts],iy[ipts]] + aerh[ipts]
    naerh__[ix[ipts],iy[ipts]] = naerh__[ix[ipts],iy[ipts]] + 1
   endif
  endfor
  a = where(naerh__ gt 0)
  aerh_[a] = aerh__[a]/naerh__[a]


  pts  = where(residue gt -1e14)
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

  pts  = where(aert gt -1e14)
  aert = aert[pts]
  npts = n_elements(pts)
  ix = interpol(indgen(nx), lon_, lon[pts])
  iy = interpol(indgen(ny), lat_, lat[pts])
  ix = fix(ix+.5)
  iy = fix(iy+.5)
  a = where(ix eq nx)            ; wrap around
  if(a[0] ne -1) then ix[a] = 0
; for efficiency, sort on ix
  a = sort(ix)
  ix = ix[a]
  iy = iy[a]
  aert = aert[a]
  b = uniq(ix)
; Now search on uniq ix
  for ib = 0, n_elements(b)-1 do begin
   if(ib eq 0) then sb = 0 else sb = b[ib-1]+1
   eb = b[ib]
   iix = ix[sb]
   iyq = iy[sb:eb]
   aertq = aert[sb:eb]
   c = sort(iyq)
   iyq = iyq[c]
   aertq = aertq[c]
   d = uniq(iyq)
   for id = 0, n_elements(d)-2 do begin
    if(id eq 0) then sd = 0 else sd = d[id-1]+1
    ed = d[id]
    iiy = iyq[d[id]]
    aertqx = aertq[sd:ed]
    e = where(aertqx gt -1 and aertqx lt 250)
    if(e[0] ne -1) then begin
      result = histogram(aertqx[e],min=1,max=3,nbins=3)
      nsulf__[iix,iiy] = result[2]
      ndust__[iix,iiy] = result[1]
      nsmok__[iix,iiy] = result[0]
    endif
   endfor
  endfor

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
;    idLer354  = NCDF_VARDEF(cdfid,'ler354',[idLon,idLat], /float)
    idLer388  = NCDF_VARDEF(cdfid,'ler388',[idLon,idLat], /float)
;    idRef354  = NCDF_VARDEF(cdfid,'ref354',[idLon,idLat], /float)
    idRef388  = NCDF_VARDEF(cdfid,'ref388',[idLon,idLat], /float)
    idAerh  = NCDF_VARDEF(cdfid,'aerh',[idLon,idLat], /float)
    idResidue  = NCDF_VARDEF(cdfid,'residue',[idLon,idLat], /float)
    idAI  = NCDF_VARDEF(cdfid,'ai',[idLon,idLat], /float)
    idPRS  = NCDF_VARDEF(cdfid,'prs',[idLon,idLat], /float)
    idnAot  = NCDF_VARDEF(cdfid,'naot',[idLon,idLat], /float)
    idnSSA  = NCDF_VARDEF(cdfid,'nssa',[idLon,idLat], /float)
    idnLer388  = NCDF_VARDEF(cdfid,'nler388',[idLon,idLat], /float)
    idnRef388  = NCDF_VARDEF(cdfid,'nref388',[idLon,idLat], /float)
    idnAerh  = NCDF_VARDEF(cdfid,'naerh',[idLon,idLat], /float)
    idnSulf  = NCDF_VARDEF(cdfid,'nsulf',[idLon,idLat], /float)
    idnDust  = NCDF_VARDEF(cdfid,'ndust',[idLon,idLat], /float)
    idnSmok  = NCDF_VARDEF(cdfid,'nsmok',[idLon,idLat], /float)
    idnResidue  = NCDF_VARDEF(cdfid,'nresidue',[idLon,idLat], /float)
    idnAI  = NCDF_VARDEF(cdfid,'nai',[idLon,idLat], /float)
    idnPRS  = NCDF_VARDEF(cdfid,'nprs',[idLon,idLat], /float)
    idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)
    ncdf_control, cdfid, /endef
    ncdf_varput, cdfid, idLongitude, lon_
    ncdf_varput, cdfid, idLatitude, lat_
    ncdf_varput, cdfid, idDate, '1'
    ncdf_varput, cdfid, idAot, aod_
    ncdf_varput, cdfid, idSSA, ssa_
;    ncdf_varput, cdfid, idLer354, ler354_
    ncdf_varput, cdfid, idLer388, ler388_
;    ncdf_varput, cdfid, idRef354, ref354_
    ncdf_varput, cdfid, idRef388, ref388_
    ncdf_varput, cdfid, idResidue, residue_
    ncdf_varput, cdfid, idAI, ai_
    ncdf_varput, cdfid, idPRS, prs_
    ncdf_varput, cdfid, idAerh, aerh_
    ncdf_varput, cdfid, idnAot, naod__
    ncdf_varput, cdfid, idnSSA, nssa__
    ncdf_varput, cdfid, idnLer388, nler388__
    ncdf_varput, cdfid, idnRef388, nref388__
    ncdf_varput, cdfid, idnResidue, nresidue__
    ncdf_varput, cdfid, idnAI, nai__
    ncdf_varput, cdfid, idnPRS, nprs__
    ncdf_varput, cdfid, idnAerh, naerh__
    ncdf_varput, cdfid, idnSulf, nsulf__
    ncdf_varput, cdfid, idnDust, ndust__
    ncdf_varput, cdfid, idnSmok, nsmok__
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
