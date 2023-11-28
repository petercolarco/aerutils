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

nminret_ = [1,2,4,8,16]
nminmon_ = [1,2,4,8,16]

for inr = 0, 4 do begin
for ind = 0, 4 do begin


; construction is only for the model days sampled on AERONET obs
; Minimum number of AERONET retrievals per six-hour block needed to make 
; valid daily average
;  nminret = 4
; Minimun number of days in a month of valid AERONET retrievals to make
; valid monthly average
;  nminmon = 4

  nminret = nminret_[inr]
  nminmon = nminmon_[ind]

  specialtag = ''
  cnr = strcompress(string(nminret),/rem)
  cnd = strcompress(string(nminmon),/rem)
  specialtag = '.nr'+cnr+'_nd'+cnd


; A list of experiment ids to run against.
;  expid  = ['t006_b32', 't003_c32', 't005_b32', 't002_b55']
  expid  = ['t003_c32']
  expDir = expid
  nexp = n_elements(expid)

; Years to do this over
  years = ['2000', '2001', '2002', '2003', '2004', '2005', '2006']
  ny = n_elements(years)

; Read the database of aeronet locations
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

; A list of variables to extract from the model files
  varwant = [ 'du001', 'du002', 'du003', 'du004', 'du005', $
              'ss001', 'ss002', 'ss003', 'ss004', 'ss005', $
              'OCphilic', 'OCphobic', 'BCphilic', 'BCphobic', 'SO4' ]

; Possibly you want to modify the quantities by applying a multiplicative
; factor to each
  varfac = [ [make_array(15,val=1.)], [make_array(15,val=1.)]]
;  varfac[0:4,0] = 0.    ; e.g., dust
;  varfac[5:9,0] = 0.    ; e.g., sea salt

  aerPath = '/output/AERONET/AOT_Version2/'
  do_stat = 1



; -----------------------------------------------------------
; Loop over the experiments

  for iexp = 0, nexp-1 do begin

   expDir_ = expid[iexp]
   expid_  = expid[iexp]

   outstring = expid_+specialtag

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

;   Now loop over the locations
    for iloc = 0, nlocs-1 do begin

     print, expid_+': ', yyyy, iloc+1, '/', nlocs
     locwant = location[iloc]
     ncdf_varput, cdfid, idLocation, locwant, offset=[0,iloc]
     ncdf_varput, cdfid, idLat, lat[iloc], offset=[iloc]
     ncdf_varput, cdfid, idLon, lon[iloc], offset=[iloc]
     ncdf_varput, cdfid, idEle, ele[iloc], offset=[iloc]

;    read in the aeronet aot and angstrom exponents
     angstromaeronetIn = 1.
     angstrommodel = 1.
     read_aeronet2nc, aerPath, locwant, '550', yyyy, aotaeronetIn, dateaeronet, $
                      angstrom=angstromaeronetIn, /hourly, naot=naotaeronet

;    read the model
     exppath = '/output/colarco/'+expid_+'/tau/'
     varexpid = varwant
     usefac = varfac
     a = where(varexpid ne ' ')
     if(a[0] ne -1) then begin
      varexpid = varexpid[a]
      usefac = usefac[a]
     endif
     readmodel, exppath, expid_, yyyy, locwant, '550', varexpid, aotModel, dateModel
;    Get wavelengths for Angstrom exponent calculation
     readmodel, exppath, expid_, yyyy, locwant, '440', varexpid, aotModel440, dateModel
     readmodel, exppath, expid_, yyyy, locwant, '870', varexpid, aotModel870, dateModel
     nt = n_elements(datemodel)
     nspec = n_elements(aotModel[0,*])

;    Apply correcting multiplicative factors
     for it = 0, nt-1 do begin
      aotModel[it,*] = aotModel[it,*]*usefac
      aotModel440[it,*] = aotModel440[it,*]*usefac
      aotModel870[it,*] = aotModel870[it,*]*usefac
     endfor

;    Integrate over species at 440 and 870 to compute angstrom
     aotmodel440 = total(aotmodel440,2)
     aotmodel870 = total(aotmodel870,2)
     angstrommodelIn = -alog(aotmodel440/aotmodel870) / alog(440./870.)

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
     aotaeronet_ = make_array(nday,val=-9999.)
     angaeronet_ = make_array(nday,val=-9999.)
     naeronet_   = make_array(nday,val=-9999.)
     for iday = 0, nday-1 do begin
      a = where(long(dateaeronet/100) eq dateaeronet_[iday])
      b = where(naotaeronet[a] ge nminret)
      if(b[0] ne -1) then begin
       aotaeronet_[iday] = total(aotaeronetIn[a[b]]*naotaeronet[a[b]])/ $
                           total(naotaeronet[a[b]])
       angaeronet_[iday] = total(angstromaeronetIn[a[b]]*aotaeronetIn[a[b]]*naotaeronet[a[b]])/ $
                           total(aotaeronetIn[a[b]]*naotaeronet[a[b]])
       naeronet_[iday]   = total(naotaeronet[a[b]])
       for ispec = 0, nspec-1 do begin
        aotmodel_[iday,ispec] = total(aotmodel[a[b],ispec]*naotaeronet[a[b]])/ $
                                total(naotaeronet[a[b]])
        angmodel_[iday] = total(angstrommodelIn[a[b]]*total(aotmodel[a[b],*],2)*naotaeronet[a[b]])/ $
                          total(total(aotmodel[a[b],*],2)*naotaeronet[a[b]])
       endfor
      endif
     endfor
     aotModelIn = aotmodel_
     aotAeronetIn = aotaeronet_
     angstromAeronetIn = angaeronet_
     dateModel = datemodel_
     dateaeronet = dateaeronet_
     naeronet = naeronet_
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
      ndays = n_elements(a)
      if(a[0] eq -1) then ndays = 0
      dateout = long(yyyy+mm+'15')
      ncdf_varput, cdfid, idDate, dateout, offset=[imon-1]
      ncdf_varput, cdfid, idndays, ndays, offset=[iloc,imon-1]


;     Only use months with more than 3 days observations in them
      if(ndays lt nminmon) then begin
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
       aotaeronet = total(aotAeronetIn[a]*naeronet[a])/total(naeronet[a])
       angaeronet = total(naeronet[a]*aotAeronetIn[a]*angstromaeronetIn[a]) $
                  / total(naeronet[a]*aotAeronetIn[a])
;      the model is here being averaged only on days that AERONET obs are present
       dateuse = dateaeronet[a]
       aottemp = make_array(nspec,val=0.)
       angtemp = 0.

       for ispec = 0, nspec-1 do begin
        aottemp[ispec] = total(aotmodelIn[a,ispec]*naeronet[a])/total(naeronet[a])
       endfor
       aotmodel   = total(aottemp)
       aotmodeldu = total(aottemp[0:4])
       aotmodelss = total(aottemp[5:9])
       aotmodelsu = total(aottemp[14])
       aotmodelcc = total(aottemp[10:13])
       angmodel = total(angstrommodelIn[a]*total(aotmodelIn[a,*],2)*naeronet[a]) / $
                  total(total(aotmodelIn[a,*],2)*naeronet[a])

if(angaeronet lt -1) then stop
;      Now do the low levels statistics
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

     endfor  ; month

    endfor   ; locations

    ncdf_close, cdfid

   endfor   ; year


  endfor   ; expid


endfor
endfor
 
end
