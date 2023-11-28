; Colarco, Feb. 2006
; Read in the model and aeronet data for one year and assemble
; a database of daily averaged values of:
;  lon, lat
;  elevation
;  aeronet aot 500
;  aeronet angstrom 440-870
;  model aot 500
;   total
;   dust
;   seasalt
;   sulfate
;   carbon
; model angstrom 440-870


  pro mon_mean, exppath, expid, years, $
                outtag=outtag, scalefac=scalefac, $
                aerPath=aerPath, nminret=nminret, nminmon=nminmon, $
                diag=diag, carmaext=carmaext, sample=sample, $
                hwl=hwl, taod=taod, $
                hourly=hourly, threehourly=threehourly, sixhourly=sixhourly, $
                aeronet_locs_dat=aeronet_locs_dat


  spawn, 'echo $AERONETDIR', headDir

; Mandatory:
;  exppath is the location of the model extracts (flat)
;  expid is the experiment short name
;  years is an array of years, e.g., ['2000','2001',...] to process
   ny   = n_elements(years)
   nexp = 1

; Check the optional keywords
; name used for output files
  if(not(keyword_set(outtag))) then outtag = expid[0]
; Where to find the aeronet data
  if(not(keyword_set(aerPath))) then aerPath = headDir+'LEV30/'
; Number of valid retrievals per six-hour block to contribute to daily AOT
  if(not(keyword_set(nminret))) then nminret = 1
; Number of valid days per month block to contribute a monthly AOT
  if(not(keyword_set(nminmon))) then nminmon = 4
; If asking for diag files, then we will be getting only the 550 nm
; wavelength
  if(not(keyword_set(diag))) then diag = 0
  if(keyword_set(hwl)) then diag = 1
  if(not(keyword_set(carmaext))) then carmaext = 0
  if(not(keyword_set(taod))) then taod = 0
  lambdabase = '500'
  if(diag or taod) then lambdabase = '550'
  if(not(keyword_set(sample))) then sample = 0

; Temporal Sampling
  if(not keyword_set(hourly))  then hourly = 0
  if(not keyword_set(threehourly)) then threehourly = 0
  if(not keyword_set(sixhourly)) then sixhourly = 0
  if(not(hourly) and not(threehourly) and not(sixhourly)) then threehourly = 1

  if(not(keyword_set(aeronet_locs_dat))) then aeronet_locs_dat = 'aeronet_locs.dat'

; Check on the scale factors (possibly) requested
; scalefac is a multiplicative factor to be applied on a tracer-by-tracer
; basis to scale the AOT contribution of a tracer.

; A list of variables to extract from the model files
  varwant = [ 'du001', 'du002', 'du003', 'du004', 'du005', $
              'ss001', 'ss002', 'ss003', 'ss004', 'ss005', $
              'OCphilic', 'OCphobic', 'BCphilic', 'BCphobic', 'S04' ]

  if(diag) then begin
   varwant = ['duexttau','ssexttau','ocexttau','bcexttau','suexttau']
   varscat = ['duscatau','ssscatau','ocscatau','bcscatau','suscatau']
  endif

  if(taod) then begin
   varwant = ['taod']
   varabs  = ['aaod']
  endif

  if(carmaext) then $
   varwant = [ 'dust001', 'dust002', 'dust003', 'dust004', $
               'dust005', 'dust006', 'dust007', 'dust008', $
               'seasalt001', 'seasalt002', 'seasalt003', 'seasalt004', $
               'seasalt005', 'seasalt006', 'seasalt007', 'seasalt008']

  nvar = n_elements(varwant)
  if(keyword_set(scalefac)) then begin
   if(n_elements(scalefac) ne nvar) then begin
    print, 'Check consistency:  nvar = ', nvar
    print, ' you provided n_scalefac = ', n_elements(scalefac)
    print, ' exit!'
    stop
   endif
  endif else begin
   scalefac = make_array(nvar,val=1.)
  endelse

; For now set on, do statistics
  do_stat = 1


; Read the database of aeronet locations
  openr, lun, aeronet_locs_dat, /get_lun
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

; -----------------------------------------------------------
; Loop over the experiments

  for iexp = 0, nexp-1 do begin

   expid_  = expid[iexp]

   outstring = outtag[iexp]

   for iy = 0, ny-1 do begin
    yyyy = years[iy]
    print, expid_+': ', yyyy

;   Open and create the output NCDF file desired
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
    idaotabsAer    = NCDF_VARDEF(cdfid, 'aotabsaeronet', [idLoc,idTime], /float)
;    idangabsAer    = NCDF_VARDEF(cdfid, 'angabsaeronet', [idLoc,idTime], /float)
    idaotabsstdAer = NCDF_VARDEF(cdfid, 'aotabsaeronetstd', [idLoc,idTime], /float)
;    idangabsstdAer = NCDF_VARDEF(cdfid, 'angabsaeronetstd', [idLoc,idTime], /float)
    idaotMod    = NCDF_VARDEF(cdfid, 'aotmodel', [idLoc,idTime], /float)
    idaotabsMod = NCDF_VARDEF(cdfid, 'aotabsmodel', [idLoc,idTime], /float)
    idaotModDU  = NCDF_VARDEF(cdfid, 'aotmodeldu', [idLoc,idTime], /float)
    idaotModSS  = NCDF_VARDEF(cdfid, 'aotmodelss', [idLoc,idTime], /float)
    idaotModSU  = NCDF_VARDEF(cdfid, 'aotmodelsu', [idLoc,idTime], /float)
    idaotModCC  = NCDF_VARDEF(cdfid, 'aotmodelcc', [idLoc,idTime], /float)
    idangMod    = NCDF_VARDEF(cdfid, 'angmodel', [idLoc,idTime], /float)
    idaotstdMod = NCDF_VARDEF(cdfid, 'aotmodelstd', [idLoc,idTime], /float)
    idaotabsstdMod = NCDF_VARDEF(cdfid, 'aotabsmodelstd', [idLoc,idTime], /float)
    idangstdMod = NCDF_VARDEF(cdfid, 'angmodelstd', [idLoc,idTime], /float)
    idaotcorr   = NCDF_VARDEF(cdfid, 'aotcorr', [idLoc,idTime], /float)
    idaotbias   = NCDF_VARDEF(cdfid, 'aotbias', [idLoc,idTime], /float)
    idaotrms    = NCDF_VARDEF(cdfid, 'aotrms', [idLoc,idTime], /float)
    idaotskill  = NCDF_VARDEF(cdfid, 'aotskill', [idLoc,idTime], /float)
    idaotslope  = NCDF_VARDEF(cdfid, 'aotslope', [idLoc,idTime], /float)
    idaotoffset = NCDF_VARDEF(cdfid, 'aotoffset', [idLoc,idTime], /float)
    idaotabscorr   = NCDF_VARDEF(cdfid, 'aotabscorr', [idLoc,idTime], /float)
    idaotabsbias   = NCDF_VARDEF(cdfid, 'aotabsbias', [idLoc,idTime], /float)
    idaotabsrms    = NCDF_VARDEF(cdfid, 'aotabsrms', [idLoc,idTime], /float)
    idaotabsskill  = NCDF_VARDEF(cdfid, 'aotabsskill', [idLoc,idTime], /float)
    idaotabsslope  = NCDF_VARDEF(cdfid, 'aotabsslope', [idLoc,idTime], /float)
    idaotabsoffset = NCDF_VARDEF(cdfid, 'aotabsoffset', [idLoc,idTime], /float)
    idangcorr   = NCDF_VARDEF(cdfid, 'angcorr', [idLoc,idTime], /float)
    idangbias   = NCDF_VARDEF(cdfid, 'angbias', [idLoc,idTime], /float)
    idangrms    = NCDF_VARDEF(cdfid, 'angrms', [idLoc,idTime], /float)
    idangskill  = NCDF_VARDEF(cdfid, 'angskill', [idLoc,idTime], /float)
    idangslope  = NCDF_VARDEF(cdfid, 'angslope', [idLoc,idTime], /float)
    idangoffset = NCDF_VARDEF(cdfid, 'angoffset', [idLoc,idTime], /float)
    idndays     = NCDF_VARDEF(cdfid, 'ndays', [idLoc,idTime], /long)

    ncdf_control, cdfid, /endef

;   Now loop over the locations
    for iloc = 0, nlocs-1 do begin

     print, location[iloc], expid_+': ', yyyy, iloc+1, '/', nlocs
     locwant = location[iloc]
     ncdf_varput, cdfid, idLocation, locwant, offset=[0,iloc]
     ncdf_varput, cdfid, idLat, lat[iloc], offset=[iloc]
     ncdf_varput, cdfid, idLon, lon[iloc], offset=[iloc]
     ncdf_varput, cdfid, idEle, ele[iloc], offset=[iloc]

;    read in the aeronet aot and angstrom exponents
     angstromaeronetIn = 1.
     angstrommodel = 1.
     read_aeronet2nc, aerPath, locwant, lambdabase, yyyy, aotaeronetIn, dateaeronet, $
                      angpair=1, angstrom=angstromaeronetIn, naot=naotaeronet, $
                      hourly=hourly, threehourly=threehourly, sixhourly=sixhourly
     read_aeronet_inversions2nc, aerPath, locwant, lambdabase, yyyy, tauextaeronetIn, tauabsaeronetIn, $
                      dateaeronet, ninv=ninvaeronet, $
                      hourly=hourly, threehourly=threehourly, sixhourly=sixhourly

;    Now read the model
     varexpid = varwant
     usefac = scalefac
     a = where(varexpid ne ' ')
     if(a[0] ne -1) then begin
      varexpid = varexpid[a]
      usefac = usefac[a]
     endif

     readmodel, exppath, expid_, yyyy, locwant, lambdabase, varexpid, aotModel, dateModel
     if(diag) then readmodel, exppath, expid_, yyyy, locwant, lambdabase, varscat, scaModel, dateModel
     if(taod) then readmodel, exppath, expid_, yyyy, locwant, lambdabase, varabs,  absModel, dateModel
     if(taod) then scaModel = aotModel - absModel

     nt = n_elements(datemodel)
     nspec = n_elements(aotModel[0,*])

;    Process and create the Angstrom parameter
     if(diag) then begin
      for it = 0, nt-1 do begin
       aotModel[it,*] = aotModel[it,*]*usefac
       scaModel[it,*] = scaModel[it,*]*usefac
      endfor
;;;;;;;;;;;;;;;;
;;     This is a horrible hack because did not save the scattering AOT
;;     in the right files; assume dust SSA is about 0.935 and correct
;;     for dust burden change
      scaModel = aotModel[*,0]
      scaModel = 0.
      if(diag) then readmodel, exppath, expid_, yyyy, locwant, lambdabase, 'totscatau', scaModel, dateModel
       aotabsmodel = total(aotModel,2)-scaModel
;      scamodel[*] = 0.
;;     element 0 is the dust element
;      scamodel[*,0] = scamodel_ - (1.-usefac[0])*0.935*aotmodel[*,0]/usefac[0]
;;;;;;;;;;;;;;;;

;     From tavg2d_aer_x(diag) or hwl files do not have
;     multi-wavelength AOT, so either Angstrom parmeter is a
;     diagnostic or it needs to be faked
      angstrommodelIn = aotModel[*,0]
      angstrommodelIn[*] = 1.
      readmodel, exppath, expid_, yyyy, locwant, lambdabase, ['totangstr'], angout, dateout
;     if the variable is not missing (fewer than nt elements are
;     undef) use it
      if(n_elements(where(angout ge 1.e15)) lt nt) then angstrommodelIn = angout
     endif else begin
;     From inst2d_ext_x file have multi-wavelength AOT calculated, so
;     create Angstrom paremeter from data
      readmodel, exppath, expid_, yyyy, locwant, '440', varexpid, aotModel440, dateModel
      readmodel, exppath, expid_, yyyy, locwant, '870', varexpid, aotModel870, dateModel
      for it = 0, nt-1 do begin
       aotModel[it,*] = aotModel[it,*]*usefac
       aotModel440[it,*] = aotModel440[it,*]*usefac
       aotModel870[it,*] = aotModel870[it,*]*usefac
      endfor
;     Integrate over species at 440 and 870 to compute angstrom
      aotmodel440 = total(aotmodel440,2)
      aotmodel870 = total(aotmodel870,2)
      angstrommodelIn = -alog(aotmodel440/aotmodel870) / alog(440./870.)

     endelse

;    Now create a daily average of the AERONET and the model
;    AOT sampled consistently and can then pass to existing
;    monthly integration code
     datedaily = long(dateModel/100)
     dateuniq  = uniq(datedaily)
     nday = n_elements(dateuniq)
     datemodel_ = datedaily[dateuniq]
     dateaeronet_ = datedaily[dateuniq]
     aotmodel_ = make_array(nday,nspec,val=-9999.)
     absmodel_ = make_array(nday,val=-9999.)
     angmodel_ = make_array(nday,val=-9999.)
     aotaeronet_ = make_array(nday,val=-9999.)
     absaeronet_ = make_array(nday,val=-9999.)
     angaeronet_ = make_array(nday,val=-9999.)
     naeronet_   = make_array(nday,val=-9999.)
     ninversion_ = make_array(nday,val=-9999.)

     for iday = 0, nday-1 do begin
      a = where(long(dateaeronet/100) eq dateaeronet_[iday])
      b = where(naotaeronet[a] ge nminret)
      if(b[0] ne -1) then begin
       aotaeronet_[iday] = total(aotaeronetIn[a[b]]*naotaeronet[a[b]])/ $
                           total(naotaeronet[a[b]])
       angaeronet_[iday] = total(angstromaeronetIn[a[b]]*aotaeronetIn[a[b]]*naotaeronet[a[b]])/ $
                           total(aotaeronetIn[a[b]]*naotaeronet[a[b]])
       naeronet_[iday]   = total(naotaeronet[a[b]])
;      Only save inversions of days which pass naot threshold
       c = where(tauabsaeronetin[a[b]] gt 0)
       if(c[0] ne -1) then begin
        absaeronet_[iday] = total(tauabsaeronetIn[a[b[c]]]*ninvaeronet[a[b[c]]])/ $
                            total(ninvaeronet[a[b[c]]])
        ninversion_[iday] = total(ninvaeronet[a[b[c]]])
       endif
      endif
      if(sample) then begin
       if(b[0] ne -1) then begin
        for ispec = 0, nspec-1 do begin
         aotmodel_[iday,ispec] = total(aotmodel[a[b],ispec]*naotaeronet[a[b]])/ $
                                 total(naotaeronet[a[b]])
        endfor
        angmodel_[iday] = total(angstrommodelIn[a[b]]*total(aotmodel[a[b],*],2)*naotaeronet[a[b]])/ $
                          total(total(aotmodel[a[b],*],2)*naotaeronet[a[b]])
        if(angmodel_[iday] lt -1) then stop
;       Only save inversions of days which pass naot threshold
        c = where(tauabsaeronetin[a[b]] gt 0)
        if(diag and c[0] ne -1) then begin
         absmodel_[iday] = total(aotabsmodel[a[b[c]]]*ninvaeronet[a[b[c]]])/ $
                           total(ninvaeronet[a[b[c]]])
        endif
       endif
      endif else begin
       for ispec = 0, nspec-1 do begin
        aotmodel_[iday,ispec] = total(aotmodel[a,ispec])/n_elements(a)
       endfor
       angmodel_[iday] = total(angstrommodelIn[a]*total(aotmodel[a,*],2))/ $
                         total(total(aotmodel[a,*],2))
       if(angmodel_[iday] lt -1) then stop
       if(diag) then begin
        absmodel_[iday] = total(aotabsmodel[a[b[c]]]*ninvaeronet[a[b[c]]])/ $
                          total(ninvaeronet[a[b[c]]])
       endif
      endelse
     endfor

     aotModelIn = aotmodel_
     absModelIn = absmodel_
     aotAeronetIn = aotaeronet_
     absAeronetIn = absaeronet_
     angstromAeronetIn = angaeronet_
     dateModel = datemodel_
     dateaeronet = dateaeronet_
     naeronet   = naeronet_
     ninversion = ninversion_
     angstrommodelIn = angmodel_

;    Cast the dates to strings for comparison with desired month
     dateAeronet = strcompress(string(dateAeronet),/rem)
     dateModel   = strcompress(string(dateModel),/rem)

;    Now select on month
     for imon = 1, 12 do begin
      mm = strcompress(string(imon),/rem)
      if(imon lt 10) then mm = '0'+mm
      a = where(strmid(dateAeronet,0,6) eq yyyy+mm and $
                aotAeronetIn gt 0 )
      b = where(strmid(dateAeronet,0,6) eq yyyy+mm and $
                absAeronetIn gt 0 )
      ndays = n_elements(a)
      ndaysinv = n_elements(b)
      if(a[0] eq -1) then ndays = 0
      dateout = long(yyyy+mm+'15')
      ncdf_varput, cdfid, idDate, dateout, offset=[imon-1]
      ncdf_varput, cdfid, idndays, ndays, offset=[iloc,imon-1]

;     Create fill values for all variables
       aotaeronet = -9999.
       absaeronet = -9999.
       angaeronet = -9999.
       aotaeronetstd = -9999.
       absaeronetstd = -9999.
       angaeronetstd = -9999.
       aotcorr = -9999.
       aotbias = -9999.
       aotrms  = -9999.
       aotskill = -9999.
       aotslope = -9999.
       aotoffset = -9999.
       abscorr = -9999.
       absbias = -9999.
       absrms  = -9999.
       absskill = -9999.
       absslope = -9999.
       absoffset = -9999.
       angcorr = -9999.
       angbias = -9999.
       angrms  = -9999.
       angskill = -9999.
       angslope = -9999.
       angoffset = -9999.
       aotmodel = -9999.
       absmodel = -9999.
       aotmodeldu = -9999.
       aotmodelss = -9999.
       aotmodelsu = -9999.
       aotmodelcc = -9999.
       angmodel   = -9999.
       aotmodelstd = -9999.
       absmodelstd = -9999.
       angmodelstd = -9999.

;     Fill in AERONET observations where some criterion number of days
;     is met
      if(ndays lt nminmon) then begin
       print, ' No valid AERONET monthly mean at: ', location[iloc], dateout
      endif else begin
       aotaeronet = total(aotAeronetIn[a]*naeronet[a])/total(naeronet[a])
       angaeronet = total(naeronet[a]*aotAeronetIn[a]*angstromaeronetIn[a]) $
                  / total(naeronet[a]*aotAeronetIn[a])
      endelse

      if(ndaysinv lt nminmon) then begin
       print, ' No valid AERONET inversion monthly mean at: ', location[iloc], dateout
      endif else begin
       absaeronet = total(absAeronetIn[b]*ninversion[b])/total(ninversion[b])
      endelse

;     Now fill in the model based on whether sampling is requested or not
      if(ndays lt nminmon and sample) then begin
       print, ' No valid AERONET monthly mean at: ', location[iloc], dateout, $
              '; requested sampling'
      endif else begin
;      If "sample" then only use model days for which the AERONET obs
;      are present, otherwise use all days in month
       if(sample) then begin
        adate = a
        bdate = b
       endif else begin
        adate = where(strmid(dateAeronet,0,6) eq yyyy+mm)
        bdate = where(strmid(dateAeronet,0,6) eq yyyy+mm)
       endelse

;      AOT
       dateuse = dateaeronet[adate]
       ndays   = n_elements(adate)
       aottemp = make_array(nspec,val=0.)
       angtemp = 0.
       for ispec = 0, nspec-1 do begin
        if(sample) then begin
         aottemp[ispec] = total(aotmodelIn[adate,ispec]*naeronet[adate])/total(naeronet[adate])
        endif else begin
         aottemp[ispec] = total(aotmodelIn[adate,ispec])/n_elements(adate)
        endelse
       endfor
       aotmodel   = total(aottemp)

;      Parse on variable name for species
       idu = where(strlowcase(strmid(varexpid,0,2)) eq 'du')
       iss = where(strlowcase(strmid(varexpid,0,2)) eq 'ss' or strlowcase(strmid(varexpid,0,7)) eq 'seasalt')
       icc = where(strlowcase(strmid(varexpid,0,2)) eq 'oc' or strlowcase(strmid(varexpid,0,2)) eq 'bc')
       isu = where(strlowcase(strmid(varexpid,0,2)) eq 'su' or strlowcase(strmid(varexpid,0,3)) eq 's04' $
                                                            or strlowcase(strmid(varexpid,0,3)) eq 'so4')

       if(idu[0] ne -1) then aotmodeldu = total(aottemp[idu])
       if(iss[0] ne -1) then aotmodelss = total(aottemp[iss])
       if(isu[0] ne -1) then aotmodelsu = total(aottemp[isu])
       if(icc[0] ne -1) then aotmodelcc = total(aottemp[icc])
       if(sample) then begin
        angmodel = total(angstrommodelIn[adate]*total(aotmodelIn[adate,*],2)*naeronet[adate]) / $
                   total(total(aotmodelIn[adate,*],2)*naeronet[adate])
       endif else begin
        angmodel = total(angstrommodelIn[adate]*total(aotmodelIn[adate,*],2)) / $
                   total(total(aotmodelIn[adate,*],2))
       endelse

;      Abs AOT
       dateuseinv = dateaeronet[bdate]
       ndaysinv   = n_elements(bdate)
       if(sample) then begin
         absmodel = total(absmodelIn[bdate]*ninversion[bdate])/total(ninversion[bdate])
       endif else begin
         absmodel = total(absmodelIn[bdate])/n_elements(bdate)
       endelse
       if(absmodel lt 0) then absmodel = -9999.

;      Now do the low levels statistics
       if(adate[0] ne -1 ) then begin
        f1 = aotAeronetIn[adate]
        bb = where(f1 gt -999.)
        if(bb[0] ne -1) then f1 = f1[where(f1 gt -999.)] else f1 = make_array(3,val=-9999.)
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

        f1 = angstromAeronetIn[adate]
        bb = where(f1 gt -999.)
        if(bb[0] ne -1) then f1 = f1[where(f1 gt -999.)] else f1 = make_array(3,val=-9999.)
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
       endif

       if(diag and bdate[0] ne -1) then begin
        f1 = absAeronetIn[bdate]
        bb = where(f1 gt -999.)
        if(bb[0] ne -1) then f1 = f1[where(f1 gt -999.)] else f1 = make_array(3,val=-9999.)
        for iday = 0, ndaysinv-1 do begin
         b = where(datemodel eq dateuseinv[iday])
         if(iday eq 0) then begin
          f0 = total(absModelIn[b,*])
         endif else begin
          f0 = [f0, total(absModelIn[b,*])]
         endelse
        endfor
        statistics, f0, f1, mean0, mean1, absmodelstd, absaeronetstd, $
                    abscorr, absbias, absrms, absskill, absslope, absoffset
       endif
      endelse

      ncdf_varput, cdfid, idaotaer, aotaeronet, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idangaer, angaeronet, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotstdaer, aotaeronetstd, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idangstdaer, angaeronetstd, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotabsstdaer, absaeronetstd, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotabsaer, absaeronet, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotmod, aotmodel, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotabsmod, absmodel, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotmoddu, aotmodeldu, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotmodss, aotmodelss, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotmodsu, aotmodelsu, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotmodcc, aotmodelcc, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idangmod, angmodel, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotstdmod, aotmodelstd, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idangstdmod, angmodelstd, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotabsstdmod, absmodelstd, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotstdaer, aotaeronetstd, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotcorr, aotcorr, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotbias, aotbias, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotrms, aotrms, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotskill, aotskill, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotslope, aotslope, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotoffset, aotoffset, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotabscorr, abscorr, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotabsbias, absbias, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotabsrms, absrms, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotabsskill, absskill, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotabsslope, absslope, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idaotabsoffset, absoffset, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idangcorr, angcorr, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idangbias, angbias, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idangrms, angrms, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idangskill, angskill, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idangslope, angslope, offset=[iloc,imon-1]
      ncdf_varput, cdfid, idangoffset, angoffset, offset=[iloc,imon-1]

     endfor  ; month

    endfor   ; locations

    ncdf_close, cdfid

   endfor   ; year


  endfor   ; expid


end
