; Colarco, October 2008
; Given a list of files of model lidar extracts, create a netcdf file (with
; the same format as the lidar extracts that encompasses the zonal mean.

  pro write_zonal_lidartrack, trackfiles, outstring, outstring_met, dateinp


!quiet = 1L
; Hard coded for the moment, but potentially would want to make variable
; output variables
  ny = 361
  nz = 72
  latg = findgen(ny)*0.5 - 90.
  extg = fltarr(nz,ny)
  taug = fltarr(nz,ny)
  bckg = fltarr(nz,ny)
  e2bg = fltarr(nz,ny)
  absg = fltarr(nz,ny)
  abtg = fltarr(nz,ny)
  ssag = fltarr(nz,ny)
  masg = fltarr(nz,ny)

  psg = fltarr(ny)
  pblhg = fltarr(ny)
  hg = fltarr(nz,ny)
  heg = fltarr(nz+1,ny)
  rhg = fltarr(nz,ny)
  tg = fltarr(nz,ny)
  delpg = fltarr(nz,ny)
  cldg = fltarr(nz,ny)
  tclig = fltarr(nz,ny)
  tclwg = fltarr(nz,ny)

  numg = lonarr(ny)

; Loop over the provided files
  print, 'doing: ', outstring
  for it = 0, n_elements(trackfiles)-1 do begin

; Get the path to the files
   filename = trackfiles[it]
   istr = strpos(filename,'/',/reverse_search)
   filedir = './'
   if(istr ne -1) then $
    filedir = strmid(filename,0,istr+1)
   filename = strmid(filename,istr+1,strlen(filename)-(istr+1))
   orbit = strsplit(filename,'.',/extract)
   expid = orbit[0]

   if(orbit[3] eq 'dry') then begin
    orbit = orbit[4]+'.'+orbit[5]+'.'+orbit[6]
   endif else begin
    orbit = orbit[3]+'.'+orbit[4]+'.'+orbit[5]
   endelse
 

   filetoread = filedir+filename
   read_lidartrack, hyai, hybi, time, date, lon, lat, extinction, ssa, $
                    tau, backscat, mass, filetoread=filetoread

   filetoread = filedir + expid+'.met.'+orbit+'.hdf'
   read_lidartrack_met, hyai, hybi, lon, lat, time, date, $
                        surfp, pblh, h, hghte, relhum, t, delp, $ 
                        cloud, taucli, tauclw, $
                        filetoread=filetoread

   iy = interpol(indgen(n_elements(latg)),latg,lat)
   iy = fix(iy+.5)
   for ix = 0, n_elements(iy)-1 do begin
    extg[*,iy[ix]] = extg[*,iy[ix]] + extinction[*,ix]
    ssag[*,iy[ix]] = ssag[*,iy[ix]] + ssa[*,ix]
    taug[*,iy[ix]] = taug[*,iy[ix]] + tau[*,ix]
    bckg[*,iy[ix]] = bckg[*,iy[ix]] + backscat[*,ix]
    masg[*,iy[ix]] = masg[*,iy[ix]] + mass[*,ix]

    psg[iy[ix]] = psg[iy[ix]] + surfp[ix]
    pblhg[iy[ix]] = pblhg[iy[ix]] + pblh[ix]
    hg[*,iy[ix]] = hg[*,iy[ix]] + h[*,ix]
    heg[*,iy[ix]] = heg[*,iy[ix]] + hghte[*,ix]
    rhg[*,iy[ix]] = rhg[*,iy[ix]] + relhum[*,ix]
    tg[*,iy[ix]] = tg[*,iy[ix]] + t[*,ix]
    delpg[*,iy[ix]] = delpg[*,iy[ix]] + delp[*,ix]
    cldg[*,iy[ix]] = cldg[*,iy[ix]] + cloud[*,ix]
    tclig[*,iy[ix]] = tclig[*,iy[ix]] + taucli[*,ix]
    tclwg[*,iy[ix]] = tclwg[*,iy[ix]] + tauclw[*,ix]

    numg[iy[ix]] = numg[iy[ix]]+1

    
   endfor

  endfor

  for iy = 0, ny-1 do begin
   if(numg[iy] gt 0) then begin
    extg[*,iy] = extg[*,iy]/numg[iy]
    ssag[*,iy] = ssag[*,iy]/numg[iy]
    taug[*,iy] = taug[*,iy]/numg[iy]
    bckg[*,iy] = bckg[*,iy]/numg[iy]
    masg[*,iy] = masg[*,iy]/numg[iy]

    psg[iy] = psg[iy]/numg[iy]
    pblhg[iy] = pblhg[iy]/numg[iy]
    hg[*,iy] = hg[*,iy]/numg[iy]
    heg[*,iy] = heg[*,iy]/numg[iy]
    rhg[*,iy] = rhg[*,iy]/numg[iy]
    tg[*,iy] = tg[*,iy]/numg[iy]
    delpg[*,iy] = delpg[*,iy]/numg[iy]
    cldg[*,iy] = cldg[*,iy]/numg[iy]
    tclig[*,iy] = tclig[*,iy]/numg[iy]
    tclwg[*,iy] = tclwg[*,iy]/numg[iy]
   endif else begin
    extg[*,iy] = !values.f_nan
    ssag[*,iy] = !values.f_nan
    taug[*,iy] = !values.f_nan
    bckg[*,iy] = !values.f_nan
    masg[*,iy] = !values.f_nan

    psg[iy] = !values.f_nan
    pblhg[iy] = !values.f_nan
    hg[*,iy] = !values.f_nan
    heg[*,iy] = !values.f_nan
    rhg[*,iy] = !values.f_nan
    tg[*,iy] = !values.f_nan
    delpg[*,iy] = !values.f_nan
    cldg[*,iy] = !values.f_nan
    tclig[*,iy] = !values.f_nan
    tclwg[*,iy] = !values.f_nan
   endelse

  endfor

; -----------------------------------------------------------
; Create an output file
  filetocreate = outstring+'.hdf'
  varlist = ['extinction','tau', 'backscat', 'ext2back', 'aback_sfc', $
             'aback_toa', 'ssa','mass']
  nvars = n_elements(varlist) 
  idVar = lonarr(nvars)

  cdfid = hdf_sd_start(fileToCreate, /create)

   idx = hdf_sd_create(cdfid, 'hyai', [nz+1], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='zp1'
   hdf_sd_adddata, idx, hyai
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'hybi', [nz+1], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='zp1'
   hdf_sd_adddata, idx, hybi
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'time', [0], /double)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idx, make_array(ny,val=double(dateinp))
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'date', [0], /long)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idx, make_array(ny,val=long(dateinp))
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'lon', [0], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idx, make_array(ny,val=0.)
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'lat', [0], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idx, latg
   hdf_sd_endaccess, idx

   for iv = 0, nvars-1 do begin
    idVar[iv] = hdf_sd_create(cdfid,varlist[iv], [nz,0], /float)
    dim = hdf_sd_dimgetid(idvar[iv],0)
    hdf_sd_dimset, dim, name='z'
    dim = hdf_sd_dimgetid(idvar[iv],1)
    hdf_sd_dimset, dim, name='time'
    hdf_sd_endaccess, idx
   endfor


  hdf_sd_adddata, idVar[0], extg
  hdf_sd_adddata, idVar[1], taug
  hdf_sd_adddata, idVar[2], bckg
  hdf_sd_adddata, idVar[6], ssag
  hdf_sd_adddata, idVar[7], masg

  hdf_sd_end, cdfid

  filetocreate = outstring_met+'.hdf'
  cdfid = hdf_sd_start(fileToCreate, /create)

   idx = hdf_sd_create(cdfid, 'hyai', [nz+1], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='zp1'
   hdf_sd_adddata, idx, hyai
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'hybi', [nz+1], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='zp1'
   hdf_sd_adddata, idx, hybi
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'time', [0], /double)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idx, make_array(ny,val=double(dateinp))
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'date', [0], /long)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idx, make_array(ny,val=long(dateinp))
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'lon', [0], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idx, make_array(ny,val=0.)
   hdf_sd_endaccess, idx

   idx = hdf_sd_create(cdfid, 'lat', [0], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idx, latg
   hdf_sd_endaccess, idx

   idSurfp = hdf_sd_create(cdfid, 'surfp', [0], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idSurfp, psg
   hdf_sd_endaccess, idSurfp

   idPblh = hdf_sd_create(cdfid, 'pblh', [0], /float)
   dim = hdf_sd_dimgetid(idx,0)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idPblh, pblhg
   hdf_sd_endaccess, idPblh

   idH = hdf_sd_create(cdfid,'h', [nz,0], /float)
   dim = hdf_sd_dimgetid(idH,0)
   hdf_sd_dimset, dim, name='z'
   dim = hdf_sd_dimgetid(idH,1)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idH, hg
   hdf_sd_endaccess, idH

   idHghte = hdf_sd_create(cdfid,'hghte', [nz+1,0], /float)
   dim = hdf_sd_dimgetid(idHghte,0)
   hdf_sd_dimset, dim, name='zp1'
   dim = hdf_sd_dimgetid(idHghte,1)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idHghte, heg
   hdf_sd_endaccess, idHghte

   idRelhum = hdf_sd_create(cdfid,'relhum', [nz,0], /float)
   dim = hdf_sd_dimgetid(idRelhum,0)
   hdf_sd_dimset, dim, name='z'
   dim = hdf_sd_dimgetid(idRelhum,1)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idRelhum, rhg
   hdf_sd_endaccess, idRelhum

   idT = hdf_sd_create(cdfid,'t', [nz,0], /float)
   dim = hdf_sd_dimgetid(idT,0)
   hdf_sd_dimset, dim, name='z'
   dim = hdf_sd_dimgetid(idT,1)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idT, tg
   hdf_sd_endaccess, idT

   idDelp = hdf_sd_create(cdfid,'delp', [nz,0], /float)
   dim = hdf_sd_dimgetid(idDelp,0)
   hdf_sd_dimset, dim, name='z'
   dim = hdf_sd_dimgetid(idDelp,1)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idDelp, delpg
   hdf_sd_endaccess, idDelp

   idCloud = hdf_sd_create(cdfid,'cloud', [nz,0], /float)
   dim = hdf_sd_dimgetid(idCloud,0)
   hdf_sd_dimset, dim, name='z'
   dim = hdf_sd_dimgetid(idCloud,1)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idCloud, cldg
   hdf_sd_endaccess, idCloud

   idTauCli = hdf_sd_create(cdfid,'taucli', [nz,0], /float)
   dim = hdf_sd_dimgetid(idTauCli,0)
   hdf_sd_dimset, dim, name='z'
   dim = hdf_sd_dimgetid(idTauCli,1)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idTauCli, tclig
   hdf_sd_endaccess, idTauCli

   idTauClw = hdf_sd_create(cdfid,'tauclw', [nz,0], /float)
   dim = hdf_sd_dimgetid(idTauClw,0)
   hdf_sd_dimset, dim, name='z'
   dim = hdf_sd_dimgetid(idTauClw,1)
   hdf_sd_dimset, dim, name='time'
   hdf_sd_adddata, idTauClw, tclwg
   hdf_sd_endaccess, idTauClw

  hdf_sd_end, cdfid



end

