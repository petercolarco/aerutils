; Colarco, Feb. 2006
; Read in the model and aeronet data for one year and assemble
; a database of daily averaged values of:
;  lon, lat
;  elevation
;  aeronet aot 550
;  aeronet angstrom 440-870
;  model aot 550
;   total
;   dust
;   seasalt
;   sulfate
;   carbon
; model angstrom 440-870

; construction is only for the model days sampled on AERONET obs


;  expid = ['u000_c32_e']
;  varwant = [ ['du001', 'du002', 'du003', 'du004', 'du005', $
;               'ss001', 'ss002', 'ss003', 'ss004', 'ss005', $
;               'OCphilic', 'OCphobic', 'BCphilic', 'BCphobic', 'SO4'] ]
  expid = ['carmaDust']
  varwant = [ ['du001', 'du002', 'du003', 'du004', 'du005'] ]
; specify multiplicative factors to apply to each species.  Note: this is
; probably the most useful for scaling the dust and seasalt total emissions
  varfac = [ [make_array(15,val=1.)], [make_array(15,val=1.)]]
;  fac = 1840./3136.
;  varfac[0:4,0] = fac

  aerPath = '/output/colarco/AERONET/AOT_Version2/'
  do_stat = 1
  outstring = expid[0]

  years = ['2000', '2001', '2002', '2003', '2004', '2005', '2006']
  ny = n_elements(years)
  for iy = 0, ny-1 do begin
  print, years[iy]
  yyyy = years[iy]

; Assemble the model/AERONET data
  openr, lun, 'aeronet_locs.dat', /get_lun
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
  cdfid = ncdf_create('./output/mon_mean/aeronet_model_mon_mean.'+outstring+'.'+yyyy+'.nc', /clobber)
   idLoc  = NCDF_DIMDEF(cdfid,'location',nlocs)
   idTime = NCDF_DIMDEF(cdfid,'time',/unlimited)
   idLen  = NCDF_DIMDEF(cdfid,'length',100)

   idLocation  = NCDF_VARDEF(cdfid,'location',[idLen,idLoc],/char)
   idLat       = NCDF_VARDEF(cdfid,'latitude',[idLoc],/float)
   idLon       = NCDF_VARDEF(cdfid,'longitude',[idLoc],/float)
   idEle       = NCDF_VARDEF(cdfid,'elevation',[idLoc],/float)
   idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)
   idaotAer    = NCDF_VARDEF(cdfid, 'aotaeronet', [idLoc,idTime], /float)
   idangAer    = NCDF_VARDEF(cdfid, 'angaeronet', [idLoc,idTime], /float)
   idaotstdAer = NCDF_VARDEF(cdfid, 'aotaeronetstd', [idLoc,idTime], /float)
   idangstdAer = NCDF_VARDEF(cdfid, 'angaeronetstd', [idLoc,idTime], /float)
   idaotMod    = NCDF_VARDEF(cdfid, 'aotmodel', [idLoc,idTime], /float)
   idaotModDU  = NCDF_VARDEF(cdfid, 'aotmodeldu', [idLoc,idTime], /float)
   idaotModSS  = NCDF_VARDEF(cdfid, 'aotmodelss', [idLoc,idTime], /float)
   idaotModSU  = NCDF_VARDEF(cdfid, 'aotmodelsu', [idLoc,idTime], /float)
   idaotModCC  = NCDF_VARDEF(cdfid, 'aotmodelcc', [idLoc,idTime], /float)
   idangMod    = NCDF_VARDEF(cdfid, 'angmodel', [idLoc,idTime], /float)
   idaotstdMod = NCDF_VARDEF(cdfid, 'aotmodelstd', [idLoc,idTime], /float)
   idangstdMod = NCDF_VARDEF(cdfid, 'angmodelstd', [idLoc,idTime], /float)
   idaotcorr   = NCDF_VARDEF(cdfid, 'aotcorr', [idLoc,idTime], /float)
   idaotbias   = NCDF_VARDEF(cdfid, 'aotbias', [idLoc,idTime], /float)
   idaotrms    = NCDF_VARDEF(cdfid, 'aotrms', [idLoc,idTime], /float)
   idaotskill  = NCDF_VARDEF(cdfid, 'aotskill', [idLoc,idTime], /float)
   idaotslope  = NCDF_VARDEF(cdfid, 'aotslope', [idLoc,idTime], /float)
   idaotoffset = NCDF_VARDEF(cdfid, 'aotoffset', [idLoc,idTime], /float)
   idangcorr   = NCDF_VARDEF(cdfid, 'angcorr', [idLoc,idTime], /float)
   idangbias   = NCDF_VARDEF(cdfid, 'angbias', [idLoc,idTime], /float)
   idangrms    = NCDF_VARDEF(cdfid, 'angrms', [idLoc,idTime], /float)
   idangskill  = NCDF_VARDEF(cdfid, 'angskill', [idLoc,idTime], /float)
   idangslope  = NCDF_VARDEF(cdfid, 'angslope', [idLoc,idTime], /float)
   idangoffset = NCDF_VARDEF(cdfid, 'angoffset', [idLoc,idTime], /float)
   idndays     = NCDF_VARDEF(cdfid, 'ndays', [idLoc,idTime], /long)

   ncdf_control, cdfid, /endef

; Read in the AERONET and model data for the desired locations
  for iloc = 0, nlocs-1 do begin
   print, yyyy, iloc
   locwant = location[iloc]
   ncdf_varput, cdfid, idLocation, locwant, offset=[0,iloc]
   ncdf_varput, cdfid, idLat, lat[iloc], offset=[iloc]
   ncdf_varput, cdfid, idLon, lon[iloc], offset=[iloc]
   ncdf_varput, cdfid, idEle, ele[iloc], offset=[iloc]

;  read in the aot and angstrom exponents
   angstromaeronetIn = 1.
   angstrommodelIn = 1.
   read_aeronet2nc, aerPath, locwant, '550', yyyy, aotaeronetIn, dateaeronet, $
                    angstrom=angstromaeronetIn
;   read_aeronet2nc, aerPath, locwant, '440', yyyy, aotaeronetIn440, dateaeronet
;   read_aeronet2nc, aerPath, locwant, '870', yyyy, aotaeronetIn870, dateaeronet
;   a = where(aotaeronetIn gt 0)
;   angstromaeronetIn[*] = -9999.
;   if(a[0] ne -1) then $
;    angstromaeronetIn[a] = -alog(aotaeronetin440[a]/aotaeronetin870[a])/alog(440./870.)

;  Now read the model, possibly from more than one expid
   nexpid = n_elements(expid)
   for iexpid = 0, nexpid-1 do begin
    getexpid = expid[iexpid]
    exppath = '/output/colarco/'+getexpid+'/tau/'
    varexpid = varwant[*,iexpid]
    usefac = varfac[*,iexpid]
    a = where(varexpid ne ' ')
    if(a[0] ne -1) then begin
     varexpid = varexpid[a]
     usefac = usefac[a]
    endif
    readmodel, exppath, getexpid, yyyy, locwant, '550', varexpid, aotModel, dateModel
;   Get wavelengths for Angstrom exponent calculation
    readmodel, exppath, getexpid, yyyy, locwant, '440', varexpid, aotModelIn440, dateModel
    readmodel, exppath, getexpid, yyyy, locwant, '870', varexpid, aotModelIn870, dateModel
;   Apply correcting multiplicative factors
    nt = n_elements(datemodel)
    for it = 0, nt-1 do begin
     aotModel[it,*] = aotModel[it,*]*usefac
     aotModelIn440[it,*] = aotModelIn440[it,*]*usefac
     aotModelIn870[it,*] = aotModelIn870[it,*]*usefac
    endfor
    if(iexpid eq 0) then begin
     aotModelIn = aotModel
     aotmodel440 = total(aotmodelin440,2)
     aotmodel870 = total(aotmodelin870,2)
    endif else begin
     aotModelIn = transpose([transpose(aotModelIn), transpose(aotModel)])
     aotmodel440 = aotmodel440+total(aotmodelin440,2)
     aotmodel870 = aotmodel870+total(aotmodelin870,2)
    endelse
   endfor
   angstrommodelIn = -alog(aotmodel440/aotmodel870) / alog(440./870.)
   nspec = n_elements(aotModelIn[0,*])

;  Form a daily average of the model based on the datemodel parameter
   datemodel_ = long(dateModel/100)
   dateuniq   = uniq(datemodel_)
   nday = n_elements(dateuniq)
   dateModel = datemodel_[dateuniq]
   aotModel_ = fltarr(nday,nspec)
   for iday = 0, nday-1 do begin
    a = where(dateModel_ eq dateModel[iday])
    aotModel_[iday,*] = total(aotModelIn[a,*],1)/n_elements(a)
   endfor
   aotModelIn = aotModel_

;  Cast the dates to strings for comparison with desired month
   dateAeronet = strcompress(string(dateAeronet),/rem)
   dateModel   = strcompress(string(dateModel),/rem)


;  Now select on month
   for imon = 1, 12 do begin
    mm = strcompress(string(imon),/rem)
    if(imon lt 10) then mm = '0'+mm
    a = where(strmid(dateAeronet,0,6) eq yyyy+mm and $
              aotAeronetIn gt 0 )
    ndays = n_elements(a)
    dateout = long(yyyy+mm+'15')
    ncdf_varput, cdfid, idDate, dateout, offset=[imon-1]
    ncdf_varput, cdfid, idndays, ndays, offset=[iloc,imon-1]


;   Only use months with more than 3 days observations in them
    if(ndays le 3) then begin
     aotaeronet = -9999.
     angaeronet = -9999.
     aotaeronetstd = -9999.
     angaeronetstd = -9999.
     aotmodel = -9999.
     aotmodeldu = -9999.
     aotmodelss = -9999.
     aotmodelsu = -9999.
     aotmodelcc = -9999.
     angmodel   = -9999.
     aotmodelstd = -9999.
     angmodelstd = -9999.
     aotcorr = -9999.
     aotbias = -9999.
     aotrms  = -9999.
     aotskill = -9999.
     aotslope = -9999.
     aotoffset = -9999.
     angcorr = -9999.
     angbias = -9999.
     angrms  = -9999.
     angskill = -9999.
     angslope = -9999.
     angoffset = -9999.
    endif else begin
     aotaeronet = total(aotAeronetIn[a])/ndays
     angaeronet = total(aotAeronetIn[a]*angstromaeronetIn[a]) $
                / total(aotAeronetIn[a])
;    the model is here being averaged only on days that AERONET obs are present
     dateuse = dateaeronet[a]
     aottemp = make_array(15,val=0.)
     angtemp = 0.

;    originally: sample model only at AERONET times
     for iday = 0, ndays-1 do begin
      b = where(datemodel eq dateuse[iday])
      aottemp[0:4] = aottemp[0:4] + total(aotmodelIn[b,*],1)/ndays
      angtemp = angtemp + angstrommodelin[b]*total(aotmodelin[b,*])
     endfor

     aotmodel   = total(aottemp)
     aotmodeldu = total(aottemp[0:4])
     aotmodelss = total(aottemp[5:9])
     aotmodelsu = total(aottemp[14])
     aotmodelcc = total(aottemp[10:13])
     angmodel   = angtemp/(aotmodel*ndays)
     
;    Now do the low levels statistics
     f1 = aotAeronetIn[a]
     for iday = 0, ndays-1 do begin
      b = where(datemodel eq dateuse[iday])
      if(iday eq 0) then begin
       f0 = total(aotModelIn[b,*])
      endif else begin
       f0 = [f0, total(aotModelIn[b,*])]
      endelse
     endfor
     statistics, f0, f1, mean0, mean1, aotmodelstd, aotaeronetstd, $
                 aotcorr, aotbias, aotrms, aotskill, aotslope, aotoffset

     f1 = angstromAeronetIn[a]
     for iday = 0, ndays-1 do begin
      b = where(datemodel eq dateuse[iday])
      if(iday eq 0) then begin
       f0 = angstromModelIn[b]
      endif else begin
       f0 = [f0, angstromModelIn[b]]
      endelse
     endfor
     statistics, f0, f1, mean0, mean1, angmodelstd, angaeronetstd, $
                 angcorr, angbias, angrms, angskill, angslope, angoffset
    endelse
    ncdf_varput, cdfid, idaotaer, aotaeronet, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idangaer, angaeronet, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotstdaer, aotaeronetstd, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idangstdaer, angaeronetstd, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotmod, aotmodel, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotmoddu, aotmodeldu, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotmodss, aotmodelss, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotmodsu, aotmodelsu, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotmodcc, aotmodelcc, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idangmod, angmodel, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotstdmod, aotmodelstd, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idangstdmod, angmodelstd, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotstdaer, aotaeronetstd, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotcorr, aotcorr, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotbias, aotbias, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotrms, aotrms, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotskill, aotskill, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotslope, aotslope, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idaotoffset, aotoffset, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idangcorr, angcorr, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idangbias, angbias, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idangrms, angrms, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idangskill, angskill, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idangslope, angslope, offset=[iloc,imon-1]
    ncdf_varput, cdfid, idangoffset, angoffset, offset=[iloc,imon-1]
   endfor
  endfor

  ncdf_close, cdfid

  endfor
 
end
