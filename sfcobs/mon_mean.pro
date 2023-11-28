; Colarco, Feb. 2006
; Read in the model and sfcobs data for one year and assemble
; a database of monthly averaged values of:
;  lon, lat
;  elevation
;  sfcobs concentrations
;  model sfc values.

; construction is only for the model days sampled on surface obs


  expid = ['dR_MERRA-AA-r1']
  varwant = [ 'dusmass', 'sssmass', 'ocsmass', 'bcsmass', 'so4smass' ]

  data_yyyy = '2000'

; specify multiplicative factors to apply to each species.  Note: this is
; probably the most useful for scaling the dust and seasalt total emissions
  varfac = [ [make_array(7,val=1.)] ]
;  varfac[2:3] = 0.5

  do_stat = 1
  outstring = expid[0]

  years = ['2003','2004','2005','2006','2007','2008','2009','2010']
  ny = n_elements(years)

; loop over years
  for iy = 0, ny-1 do begin
  print, years[iy]
  yyyy = years[iy]

; Assemble the model/surface obs data
  openr, lun, 'sfcobs_locs.dat', /get_lun
  a = 'a'
  i = 0 
  while(not eof(lun)) do begin
   readf, lun, a
   strparse = strsplit(a,' ',/extract)
   if(strpos(strparse[0],'#') eq -1) then begin
    location_ = strparse[0]
    lat_ = float(strparse[1]) + float(strparse[2])/60. + float(strparse[3])/3600.
    lon_ = float(strparse[4]) + float(strparse[5])/60. + float(strparse[6])/3600.
    ele_ = float(strparse[7])
    if(i eq 0) then begin
     location = location_
     lat = lat_
     lon = lon_
     ele = ele_
    endif else begin
     location = [location,strparse[0]]
     lat = [lat, lat_]
     lon = [lon, lon_]
     ele = [ele, ele_]
    endelse
    i = i+1
   endif
  endwhile
  free_lun, lun
  nlocs = n_elements(location)

; Open and create the output NCDF file desired
  cdfid = ncdf_create('./output/mon_mean/sfcobs_model_mon_mean.'+outstring+'.'+yyyy+'.nc', /clobber)
   idLoc  = NCDF_DIMDEF(cdfid,'location',nlocs)
   idTime = NCDF_DIMDEF(cdfid,'time',/unlimited)
   idLen  = NCDF_DIMDEF(cdfid,'length',100)

   idLocation  = NCDF_VARDEF(cdfid,'location',[idLen,idLoc],/char)
   idLat       = NCDF_VARDEF(cdfid,'latitude',[idLoc],/float)
   idLon       = NCDF_VARDEF(cdfid,'longitude',[idLoc],/float)
   idEle       = NCDF_VARDEF(cdfid,'elevation',[idLoc],/float)
   idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)

   idAerDU     = NCDF_VARDEF(cdfid, 'du_aeroce', [idLoc,idTime], /float)
   idAerDUstd  = NCDF_VARDEF(cdfid, 'du_aeroce_std', [idLoc,idTime], /float)
   idAerSS     = NCDF_VARDEF(cdfid, 'ss_aeroce', [idLoc,idTime], /float)
   idAerSSstd  = NCDF_VARDEF(cdfid, 'ss_aeroce_std', [idLoc,idTime], /float)

   idEmepSO4     = NCDF_VARDEF(cdfid, 'so4_emep', [idLoc,idTime], /float)
   idEmepSO4std  = NCDF_VARDEF(cdfid, 'so4_emep_std', [idLoc,idTime], /float)

   idImpSO4     = NCDF_VARDEF(cdfid, 'so4_imp', [idLoc,idTime], /float)
   idImpSO4std  = NCDF_VARDEF(cdfid, 'so4_imp_std', [idLoc,idTime], /float)
   idImpSS      = NCDF_VARDEF(cdfid, 'ss_imp', [idLoc,idTime], /float)
   idImpSSstd   = NCDF_VARDEF(cdfid, 'ss_imp_std', [idLoc,idTime], /float)
   idImpBC      = NCDF_VARDEF(cdfid, 'bc_imp', [idLoc,idTime], /float)
   idImpBCstd   = NCDF_VARDEF(cdfid, 'bc_imp_std', [idLoc,idTime], /float)
   idImpOC      = NCDF_VARDEF(cdfid, 'oc_imp', [idLoc,idTime], /float)
   idImpOCstd   = NCDF_VARDEF(cdfid, 'oc_imp_std', [idLoc,idTime], /float)

   nvar = n_elements(varwant)
   idModel = lonarr(nvar)
   idModelStd = lonarr(nvar)
   for ivar = 0, nvar-1 do begin
    idModel[ivar] = NCDF_VARDEF(cdfid,varwant[ivar],[idLoc,idTime],/float)
    idModelStd[ivar] = NCDF_VARDEF(cdfid,varwant[ivar]+'std',[idLoc,idTime],/float)
   endfor

   ncdf_control, cdfid, /endef

; Read in the surface obs and model data for the desired locations
  for iloc = 0, nlocs-1 do begin
   print, yyyy, iloc
   locwant = location[iloc]
   ncdf_varput, cdfid, idLocation, locwant, offset=[0,iloc]
   ncdf_varput, cdfid, idLat, lat[iloc], offset=[iloc]
   ncdf_varput, cdfid, idLon, lon[iloc], offset=[iloc]
   ncdf_varput, cdfid, idEle, ele[iloc], offset=[iloc]

;  read in the data
   aerocePath = './output/data/'

   read_aeroce2nc, aerocePath, locwant, 'DUST', data_yyyy, varout, stdvalue=stdout, rc=rc
   if(rc) then begin
    varout = make_array(12,val=-9999.)
    stdout = make_array(12,val=-9999.)
   endif
   ncdf_varput, cdfid, idAerDU, varout, offset=[iloc,0], count=[1,12]
   ncdf_varput, cdfid, idAerDUstd, stdout, offset=[iloc,0], count=[1,12]
   read_aeroce2nc, aerocePath, locwant, 'SS', data_yyyy, varout, stdvalue=stdout, rc=rc
   if(rc) then begin
    varout = make_array(12,val=-9999.)
    stdout = make_array(12,val=-9999.)
   endif
   ncdf_varput, cdfid, idAerSS, varout, offset=[iloc,0], count=[1,12]
   ncdf_varput, cdfid, idAerSSstd, stdout, offset=[iloc,0], count=[1,12]

   emepPath = '/misc/prc10/EMEP/fromAerocom/'
   read_emep2nc, emepPath, locwant, 'SO4', data_yyyy, varout, /monflag, stdvalue=stdout, rc=rc
   if(rc) then begin
    varout = make_array(12,val=-9999.)
    stdout = make_array(12,val=-9999.)
   endif
   ncdf_varput, cdfid, idEmepSO4, varout, offset=[iloc,0], count=[1,12]
   ncdf_varput, cdfid, idEmepSO4std, stdout, offset=[iloc,0], count=[1,12]

   improvePath = '/misc/prc10/IMPROVE/fromAerocom/'
   read_improve2nc, improvePath, locwant, 'SO4', data_yyyy, varout, /monflag, stdvalue=stdout, rc=rc
   if(rc) then begin
    varout = make_array(12,val=-9999.)
    stdout = make_array(12,val=-9999.)
   endif
   ncdf_varput, cdfid, idImpSO4, varout, offset=[iloc,0], count=[1,12]
   ncdf_varput, cdfid, idImpSO4std, stdout, offset=[iloc,0], count=[1,12]
   read_improve2nc, improvePath, locwant, 'SS', data_yyyy, varout, /monflag, stdvalue=stdout, rc=rc
   if(rc) then begin
    varout = make_array(12,val=-9999.)
    stdout = make_array(12,val=-9999.)
   endif
   ncdf_varput, cdfid, idImpSS, varout, offset=[iloc,0], count=[1,12]
   ncdf_varput, cdfid, idImpSSstd, stdout, offset=[iloc,0], count=[1,12]
   read_improve2nc, improvePath, locwant, 'BC', data_yyyy, varout, /monflag, stdvalue=stdout, rc=rc
   if(rc) then begin
    varout = make_array(12,val=-9999.)
    stdout = make_array(12,val=-9999.)
   endif
   ncdf_varput, cdfid, idImpBC, varout, offset=[iloc,0], count=[1,12]
   ncdf_varput, cdfid, idImpBCstd, stdout, offset=[iloc,0], count=[1,12]
   read_improve2nc, improvePath, locwant, 'OC', data_yyyy, varout, /monflag, stdvalue=stdout, rc=rc
   if(rc) then begin
    varout = make_array(12,val=-9999.)
    stdout = make_array(12,val=-9999.)
   endif
   ncdf_varput, cdfid, idImpOC, varout, offset=[iloc,0], count=[1,12]
   ncdf_varput, cdfid, idImpOCstd, stdout, offset=[iloc,0], count=[1,12]


;  Now read the model
   getexpid = expid
   filename = getexpid+'.tavg2d_aer_x.ctl'
   wanttime = [yyyy+'01',yyyy+'12']
   ga_getvar, filename, '', varout, time=time, $
    wantlon=lon[iloc], wantlat=lat[iloc], wanttime=wanttime, /noprint
   dateModel = strmid(time,0,4)+strmid(time,5,2)+strmid(time,8,2)
   ndate = n_elements(dateModel)
   varmodel = fltarr(ndate,nvar)
   for ivar = 0, nvar-1 do begin
    ga_getvar, filename, varwant[ivar], varout, $
     wantlon=lon[iloc], wantlat=lat[iloc], wanttime=wanttime
    varmodel[*,ivar] = varfac[ivar]*varout
   endfor

;   Now form a monthly mean -- note the conversion to ug m-3
    varModelOut = fltarr(12,nvar)
    stdModelOut = fltarr(12,nvar)
    dateModelOut = lonarr(12)
    dateModel = long(dateModel)
    for im = 0, 11 do begin
     dateModelOut[im] = long(yyyy)*10000L + (im+1)*100L + 15
     a = where(dateModel/100L eq dateModelOut[im]/100L)
     for ivar = 0, nvar-1 do begin
      varModelOut[im,ivar] = total(varModel[a,ivar])/n_elements(a)*1e9
      if(n_elements(a) gt 1) then stdModelout[im,ivar] = stddev(varModel[a,ivar])*1e9
     endfor
    endfor

    for ivar = 0, nvar-1 do begin
     ncdf_varput, cdfid, idModel[ivar],  varModelout[*,ivar], offset = [iloc,0], count=[1,12]
     ncdf_varput, cdfid, idModelStd[ivar],  stdModelout[*,ivar], offset = [iloc,0], count=[1,12]
    endfor


   endfor

   ncdf_varput, cdfid, idDate, dateModelOut

   ncdf_close, cdfid

  endfor


;  endfor
 
end
