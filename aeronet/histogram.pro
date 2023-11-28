; Colarco, Feb. 2006
; Read in the model and aeronet data for one year and assemble
; a database of histogram like values of:
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

  pro histogram, exppath, expid, years, $
                 outtag=outtag, scalefac=scalefac, $
                 aerPath=aerPath, nminret=nminret, nminmon=nminmon, $
                 diag=diag, hwl=hwl, carmaext=carmaext, sample=sample, $
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
  lambdabase = '500'
  if(diag) then lambdabase = '550'
  if(not(keyword_set(sample))) then sample = 0

; Sampling
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
  if(diag) then $
   varwant = ['duexttau','ssexttau','ocexttau','bcexttau','suexttau']

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
   scalefac = make_array(15,val=1.)
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

;   Set-up histogram bins
    nbin = 41
    taumin = findgen(nbin)*0.05
    taumax = (findgen(nbin)+1)*.05
    taumax[nbin-1] = 100.
    absmin = findgen(nbin)*0.02
    absmax = (findgen(nbin)+1)*.02
    absmax[nbin-1] = 100.
    nbinang = 61
    angmin = findgen(nbinang)*0.05 - 0.5 
    angmax = (findgen(nbinang)+1)*.05 - 0.5
    angmax[nbinang-1] = 100.



;   Open and create the output NCDF file desired
    cdfid = ncdf_create('./output/histogram/aeronet_model_histogram.'+outstring+'.'+yyyy+'.nc', /clobber)
    idLoc  = NCDF_DIMDEF(cdfid,'location',nlocs)
    idLen  = NCDF_DIMDEF(cdfid,'length',100)
    idnbin = NCDF_DIMDEF(cdfid,'nbintau',nbin)
    idnbinang = NCDF_DIMDEF(cdfid,'nbinang',nbinang)

    idLocation  = NCDF_VARDEF(cdfid,'location',[idLen,idLoc],/char)
    idLat       = NCDF_VARDEF(cdfid,'latitude',[idLoc],/float)
    idLon       = NCDF_VARDEF(cdfid,'longitude',[idLoc],/float)
    idEle       = NCDF_VARDEF(cdfid,'elevation',[idLoc],/float)
    idtaumin    = NCDF_VARDEF(cdfid,'taumin', [idnbin],/float)
    idtaumax    = NCDF_VARDEF(cdfid,'taumax', [idnbin],/float)
    idabsmin    = NCDF_VARDEF(cdfid,'absmin', [idnbin],/float)
    idabsmax    = NCDF_VARDEF(cdfid,'absmax', [idnbin],/float)
    idangmin    = NCDF_VARDEF(cdfid,'angmin', [idnbinang],/float)
    idangmax    = NCDF_VARDEF(cdfid,'angmax', [idnbinang],/float)
    idaotAer    = NCDF_VARDEF(cdfid, 'aotbin_aer', [idLoc,idnbin], /float)
    idabsAer    = NCDF_VARDEF(cdfid, 'absbin_aer', [idLoc,idnbin], /float)
    idangAer    = NCDF_VARDEF(cdfid, 'angbin_aer', [idLoc,idnbinang], /float)
    idaotMod    = NCDF_VARDEF(cdfid, 'aotbin_mod', [idLoc,idnbin], /float)
    idabsMod    = NCDF_VARDEF(cdfid, 'absbin_mod', [idLoc,idnbin], /float)
    idangMod    = NCDF_VARDEF(cdfid, 'angbin_mod', [idLoc,idnbinang], /float) 

    ncdf_control, cdfid, /endef

    ncdf_varput, cdfid, idtaumin, taumin
    ncdf_varput, cdfid, idtaumax, taumax
    ncdf_varput, cdfid, idabsmin, absmin
    ncdf_varput, cdfid, idabsmax, absmax
    ncdf_varput, cdfid, idangmin, angmin
    ncdf_varput, cdfid, idangmax, angmax

;   Read in the AERONET and model data for the desired locations
    for iloc = 0, nlocs-1 do begin
     print, yyyy, iloc
     locwant = location[iloc]
     ncdf_varput, cdfid, idLocation, locwant, offset=[0,iloc]
     ncdf_varput, cdfid, idLat, lat[iloc], offset=[iloc]
     ncdf_varput, cdfid, idLon, lon[iloc], offset=[iloc]
     ncdf_varput, cdfid, idEle, ele[iloc], offset=[iloc]

;    read in the aot and angstrom exponents
     angstromaeronetIn = 1.
     angstrommodelIn = 1.
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

     nt = n_elements(datemodel)
     nspec = n_elements(aotModel[0,*])

;    Process and create the Angstrom parameter
     if(diag) then begin
      for it = 0, nt-1 do begin
       aotModel[it,*] = aotModel[it,*]*usefac
      endfor
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


;    Process and create the absorbing aot
     if(diag) then begin
;     From hwl files just use totscatau
      absaotmodelIn = aotModel[*,0]
      readmodel, exppath, expid_, yyyy, locwant, lambdabase, ['totscatau'], scaout, dateout
;     if the variable is not missing (fewer than nt elements are
;     undef) use it
      if(n_elements(where(scaout ge 1.e15)) lt nt) then absaotModelIn = (total(aotModel,2)-scaout)
     endif


;    Now create a daily average of the AERONET and the model
;    AOT sampled consistently and can then pass to existing
;    monthly integration code
     datedaily = long(dateModel/100)
     dateuniq  = uniq(datedaily)
     nday = n_elements(dateuniq)
     datemodel_ = datedaily[dateuniq]
     dateaeronet_ = datedaily[dateuniq]
     aotmodel_ = make_array(nday,nspec,val=-9999.)
     angmodel_ = make_array(nday,val=-9999.)
     absmodel_ = make_array(nday,val=-9999.)
     aotaeronet_ = make_array(nday,val=-9999.)
     angaeronet_ = make_array(nday,val=-9999.)
     absaeronet_ = make_array(nday,val=-9999.)
     naeronet_   = make_array(nday,val=-9999.)
     ninversion_   = make_array(nday,val=-9999.)

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
         for ispec = 0, nspec-1 do begin
          absmodel_[iday] = total(absaotmodelIn[a[b[c]]]*ninvaeronet[a[b[c]]])/ $
                            total(ninvaeronet[a[b[c]]])
         endfor
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
        for ispec = 0, nspec-1 do begin
         absmodel_[iday] = total(absaotmodelIn[a[b[c]]]*ninvaeronet[a[b[c]]])/ $
                           total(ninvaeronet[a[b[c]]])
        endfor
       endif
      endelse
     endfor
     aotModelIn = total(aotmodel_,2)
     aotAeronetIn = aotaeronet_
     absAeronetIn = absaeronet_
     angstromAeronetIn = angaeronet_
     dateModel = datemodel_
     dateaeronet = dateaeronet_
     naeronet = naeronet_
     ninversion = ninversion_
     angstrommodelIn = angmodel_
     absaotModelIn = absmodel_

;    Cast the dates to strings for comparison with desired month
     dateAeronet = strcompress(string(dateAeronet),/rem)
     dateModel   = strcompress(string(dateModel),/rem)


;    bin the aeronet data
     taubin_aer = intarr(nbin)
     absbin_aer = intarr(nbin)
     angbin_aer = intarr(nbinang)
     for ibin = 0, nbin-1 do begin
      a = where(aotaeronetin ge taumin[ibin] and aotaeronetin lt taumax[ibin])
      taubin_aer[ibin] = 0
      if(a[0] ne -1) then taubin_aer[ibin] = n_elements(a)
     endfor
     for ibin = 0, nbin-1 do begin
      a = where(absaeronetin ge absmin[ibin] and absaeronetin lt absmax[ibin])
      absbin_aer[ibin] = 0
      if(a[0] ne -1) then absbin_aer[ibin] = n_elements(a)
     endfor
     for ibin = 0, nbinang-1 do begin
      a = where(angstromaeronetin ge angmin[ibin] and angstromaeronetin lt angmax[ibin])
      angbin_aer[ibin] = 0
      if(a[0] ne -1) then angbin_aer[ibin] = n_elements(a)
     endfor
     print, locwant, n_elements(where(aotaeronetin lt 0)), total(taubin_aer), $
                     n_elements(where(aotaeronetin lt 0)) + total(taubin_aer)
     print, locwant, n_elements(where(absaeronetin lt 0)), total(absbin_aer), $
                     n_elements(where(absaeronetin lt 0)) + total(absbin_aer)
     print, locwant, n_elements(where(aotaeronetin lt 0)), total(angbin_aer), $
                     n_elements(where(aotaeronetin lt 0)) + total(angbin_aer)

     ncdf_varput, cdfid, idaotaer, taubin_aer, offset=[iloc,0], count=[1,nbin]
     ncdf_varput, cdfid, idabsaer, absbin_aer, offset=[iloc,0], count=[1,nbin]
     ncdf_varput, cdfid, idangaer, angbin_aer, offset=[iloc,0], count=[1,nbinang]


;    bin the model
     taubin_mod = intarr(nbin)
     absbin_mod = intarr(nbin)
     angbin_mod = intarr(nbinang)
     b = where(aotaeronetIn gt 0)
     if(b[0] ne -1) then begin

      for ibin = 0, nbin-1 do begin
       a = where(aotmodelin[b] ge taumin[ibin] and aotmodelin[b] lt taumax[ibin])
       taubin_mod[ibin] = 0
       if(a[0] ne -1) then taubin_mod[ibin] = n_elements(a)
      endfor
      for ibin = 0, nbin-1 do begin
       a = where(absaotmodelin[b] ge absmin[ibin] and absaotmodelin[b] lt absmax[ibin])
       absbin_mod[ibin] = 0
       if(a[0] ne -1) then absbin_mod[ibin] = n_elements(a)
      endfor
      for ibin = 0, nbinang-1 do begin
       a = where(angstrommodelin[b] ge angmin[ibin] and angstrommodelin[b] lt angmax[ibin])
       angbin_mod[ibin] = 0
       if(a[0] ne -1) then angbin_mod[ibin] = n_elements(a)
      endfor

     endif

     print, locwant, n_elements(where(aotaeronetin lt 0)), total(taubin_mod), $
                     n_elements(where(aotaeronetin lt 0)) + total(taubin_mod)
     print, locwant, n_elements(where(absaeronetin lt 0)), total(absbin_mod), $
                     n_elements(where(absaeronetin lt 0)) + total(absbin_mod)
     print, locwant, n_elements(where(aotaeronetin lt 0)), total(angbin_mod), $
                     n_elements(where(aotaeronetin lt 0)) + total(angbin_mod)

     ncdf_varput, cdfid, idaotmod, taubin_mod, offset=[iloc,0], count=[1,nbin]
     ncdf_varput, cdfid, idabsmod, absbin_mod, offset=[iloc,0], count=[1,nbin]
     ncdf_varput, cdfid, idangmod, angbin_mod, offset=[iloc,0], count=[1,nbinang]

    endfor  ; loc

    ncdf_close, cdfid

   endfor   ; year

  endfor    ;expid
 
end
