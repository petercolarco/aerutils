; Colarco
; July 2011

; Read the Level 2 version 2.0 all points AERONET files for all
; available sites.  Concatenate into a single netcdf file per site
; for easy access.  You need to provide the location of the AERONET 
; data provided from aeronet.gsfc.nasa.gov:AOT_Level2_Daily.tar.gz
; as expanded (dataDir).  You also need to give the bounding dates
; you care to concatenate (dat0, date1).

; The daily mean files contain daily mean AOT as a mean of the
; daily averages (idAOTm) and the weighted mean of all AOT (idAOTw).
; No Angstrom parameters are present in the input files, so none are
; saved here.

; For now: ignore refractive indices, asymmetry paremeter, 
;          22 bin PSD representation, fluxes

  spawn, 'echo $AERONETDIR', headDir
  dataDir = headDir+'INV/INV/DUBOV/ALL_POINTS/'
  filelist = file_search(dataDir+'*', count=nfiles)

; What hourly resolution do you want?
  nhr = 1
  if(nhr eq 0 or nhr gt 24 or fix(nhr) ne nhr) then begin
   print, 'something wrong with the hours you asked for'
   stop
  endif
  nt = 24/nhr

; Here are the date range I expect my generated file to go over
  date0 = 19920101L
  date1 = 20171231L

; Parse the filenames for start and end dates
  dateBeg = strarr(nfiles)
  dateEnd = strarr(nfiles)
  len = strlen(dataDir)
  dateBeg = strmid(filelist,len,6)
  dateEnd = strmid(filelist,len+7,6)

; The beginning date is the same for all files, but the end date is not
; How many files have the same end date
  nFileEnd = n_elements(uniq(dateEnd))
  uniqFileEnd = dateEnd(uniq(dateEnd))
  nfe = make_array(nfileend,val=0)
  for i = 0, nFiles-1 do begin
   a = where(dateEnd[i] eq uniqFileEnd)
   if(a[0] ne -1) then nfe[a[0]] = nfe[a[0]] + 1
  endfor

; Compare the locations listed in the earliest of the end dates
; to the locations listed in the latest of the end dates
  b0 = where(dateEnd eq uniqFileEnd[0])
  b1 = where(dateEnd eq uniqFileEnd[nFileEnd-1])
  loc0 = strmid(filelist[b0],len+14,100)
  loc1 = strmid(filelist[b1],len+14,100)

; Find sites not in each other's lists
; Any loc0 sites not in loc1?
  print, 'Missing loc0 in loc1'
  for i = 0, n_elements(loc0)-1 do begin
   a = where(loc0[i] eq loc1)
   if(a[0] eq -1) then print, loc0[i]
  endfor

  print, ' '

  print, 'Missing loc1 in loc0'
  for i = 0, n_elements(loc1)-1 do begin
   a = where(loc1[i] eq loc0)
   if(a[0] eq -1) then print, loc1[i]
  endfor


; Structure of desired output file
  nlocs = n_elements(loc1)
  yyyy = date0/10000L
  mm = (date0-yyyy*10000L)/100
  dd = (date0-yyyy*10000L - mm*100)
  jday0 = julday(mm,dd,yyyy)
  yyyy = date1/10000L
  mm = (date1-yyyy*10000L)/100
  dd = (date1-yyyy*10000L - mm*100)
  jday1 = julday(mm,dd,yyyy)
  ndays = jday1-jday0+1
  ndates = ndays*nt
  date = lonarr(ndates)
  jday = jday0
  for iday = 0L, ndays-1 do begin
   caldat, jday, mm, dd, yyyy
   date[iday*nt] = long(yyyy*1000000L + mm*10000L + dd*100)
   for it = 1, nt-1 do begin
    date[iday*nt+it] = long(yyyy*1000000L + mm*10000L + dd*100) + it*nhr
   endfor
   jday = jday+1
  endfor

  nchannels = 16
  ninvs     = 4
  npsd      = 22
  channels = [1640, 1020, 870, 675, 667, 555, 551, 532, 531, 500, $
              490, 443, 440, 412, 380, 340]
  channels_inversion = [440, 670, 870, 1020]

; Now loop and read the aeronet file and strip the desired information
  for iloc = 0, n_elements(loc1)-1 do begin
;  create data table to write
   aotw    = make_array(nchannels,n_elements(date),val=-9999.)
   water   = make_array(n_elements(date), val=-9999.)
   tauext  = make_array(ninvs,n_elements(date), val=-9999.)
   tauextf = make_array(ninvs,n_elements(date), val=-9999.)
   tauextc = make_array(ninvs,n_elements(date), val=-9999.)
   tauabs  = make_array(ninvs,n_elements(date), val=-9999.)
   ssa     = make_array(ninvs,n_elements(date), val=-9999.)
   angext  = make_array(n_elements(date), val=-9999.)
   angabs  = make_array(n_elements(date), val=-9999.)
   dvdlnr  = make_array(npsd,n_elements(date), val=-9999.)
   naot    = make_array(nchannels,n_elements(date),val=-9999)
   ninv    = make_array(ninvs,n_elements(date),val=-9999)


;  Read the data file
   s1 = systime(1,/seconds)
   filename = dataDir + dateBeg[0] +'_'+uniqfileend[nFileEnd-1] +'_'+loc1[iloc]
   read_aeronet_inversions_allpts, filename, location, lon, lat, elev, nmeas, pi, pi_email, $
    date_, aotw_, water_, tauext_, tauextf_, tauextc_, angext_, ssa_, tauabs_, angabs_, dvdlnr_, rc=rc

   if(rc ne 0) then continue
   s2 = systime(1,/seconds)
   ds1 = s2-s1

   yyyy_  = date_/1000000L
   mm_    = (date_-yyyy_*1000000L)/10000L
   dd_    = (date_-yyyy_*1000000L-mm_*10000L)/100L
   hh_    = (date_-yyyy_*1000000L-mm_*10000L-dd_*100L)
   jdayIn = julday(mm_,dd_,yyyy_,hh_)
   fd     = nhr/24.

;  Fill in my master array of dates only where there are site values.
   s1 = systime(1,/seconds)
   idatelow = max(where(date lt min(date_)))
   idatehi  = min(where(date gt max(date_)))

   for idate = idatelow, idatehi do begin

;   Check dates for overwrite
;   Use the julian date...
    yyyy_ = date[idate]/1000000L
    mm_   = (date[idate]-yyyy_*1000000L)/10000L
    dd_   = (date[idate]-yyyy_*1000000L-mm_*10000L)/100L
    hh_   = (date[idate]-yyyy_*1000000L-mm_*10000L-dd_*100L)
    jday_idate = julday(mm_,dd_,yyyy_,hh_)
    a = where(jdayIn ge jday_idate-fd/2 and $
              jdayIn lt jday_idate+fd/2)
    if(nhr eq 1) then a = where(jdayIn eq jday_idate)
;   Do any of the dates match?
    if(a[0] ne -1) then begin

      b = where(angext_[a] gt -9990.)
      if(b[0] ne -1) then angext[idate] = mean(angext_[a[b]])

      b = where(angabs_[a] gt -9990.)
      if(b[0] ne -1) then angabs[idate] = mean(angabs_[a[b]])

      b = where(water_[a] gt -9990.)
      if(b[0] ne -1) then water[idate] = mean(water_[a[b]])

      for ich = 0, nchannels-1 do begin
       b = where(aotw_[ich,a] gt -9990.)
       if(b[0] ne -1) then aotw[ich,idate] = mean(aotw_[ich,a[b]])
       if(b[0] ne -1) then naot[ich,idate] = n_elements(b)
      endfor

      for ich = 0, ninvs-1 do begin
       b = where(tauext_[ich,a] gt -9990.)
       if(b[0] ne -1) then tauext[ich,idate] = mean(tauext_[ich,a[b]])
       if(b[0] ne -1) then ninv[ich,idate] = n_elements(b)

       b = where(tauextf_[ich,a] gt -9990.)
       if(b[0] ne -1) then tauextf[ich,idate] = mean(tauextf_[ich,a[b]])

       b = where(tauextc_[ich,a] gt -9990.)
       if(b[0] ne -1) then tauextc[ich,idate] = mean(tauextc_[ich,a[b]])

       b = where(tauabs_[ich,a] gt -9990.)
       if(b[0] ne -1) then tauabs[ich,idate] = mean(tauabs_[ich,a[b]])

       b = where(ssa_[ich,a] gt -9990.)
       if(b[0] ne -1) then ssa[ich,idate] = mean(ssa_[ich,a[b]])
      endfor

      for ipsd = 0, npsd-1 do begin
       b = where(dvdlnr_[ipsd,a] gt -9990.)
       if(b[0] ne -1) then dvdlnr[ipsd,idate] = mean(dvdlnr_[ipsd,a[b]])
      endfor

;     The dates are sorted.  The timing bottleneck is in comparing
;     dateIn to date[idate].  Throw out already considered dateIn elements
      nd = n_elements(date_)
      date_    = date_[a[0]:nd-1]
      jdayIn   = jdayIn[a[0]:nd-1]
      aotw_    = aotw_[*,a[0]:nd-1]
      water_   = water_[a[0]:nd-1]
      tauext_  = tauext_[*,a[0]:nd-1]
      tauextf_ = tauextf_[*,a[0]:nd-1]
      tauextc_ = tauextc_[*,a[0]:nd-1]
      tauabs_  = tauabs_[*,a[0]:nd-1]
      ssa_     = ssa_[*,a[0]:nd-1]
      angext_  = angext_[a[0]:nd-1]
      angabs_  = angabs_[a[0]:nd-1]
      dvdlnr_  = dvdlnr_[*,a[0]:nd-1]

     endif
   endfor
   s2 = systime(1,/seconds)
   ds2 = s2-s1

;  and write...
;  Create netcdf file for output
   s1 = systime(1,/seconds)
   cdfid = ncdf_create(headDir+'LEV30/inversions_allpts.'+location+'.nc', /clobber)
   idLoc  = NCDF_DIMDEF(cdfid,'location',1)
   idChn  = NCDF_DIMDEF(cdfid,'channels',nchannels)
   idInv  = NCDF_DIMDEF(cdfid,'channels_inversion',ninvs)
   idPSD  = NCDF_DIMDEF(cdfid,'size_bins',npsd)
   idTime = NCDF_DIMDEF(cdfid,'time',/unlimited)
   idLen  = NCDF_DIMDEF(cdfid,'length',100)

   idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)
   idChannels  = NCDF_VARDEF(cdfid,'channels',[idChn],/float)
   idChnInv    = NCDF_VARDEF(cdfid,'channels_inversion',[idInv],/float)
   idLocation  = NCDF_VARDEF(cdfid,'location',[idLen,idLoc],/char)
   idPi        = NCDF_VARDEF(cdfid,'pi',[idLen,idLoc],/char)
   idPiEmail   = NCDF_VARDEF(cdfid,'pi_email',[idLen,idLoc],/char)
   idLon       = NCDF_VARDEF(cdfid,'lon',[idLoc],/float)
   idLat       = NCDF_VARDEF(cdfid,'lat',[idLoc],/float)
   idElev      = NCDF_VARDEF(cdfid,'elevation',[idLoc],/float)
   idNmsr      = NCDF_VARDEF(cdfid,'number_of_measurements',[idLoc],/long)
   idRadius    = NCDF_VARDEF(cdfid,'r', [idPSD], /float)
   idDr        = NCDF_VARDEF(cdfid,'dr', [idPSD], /float)

   idAOTw      = NCDF_VARDEF(cdfid,'aot_average', [idLoc,idChn,idTime], /float)
   idWater     = NCDF_VARDEF(cdfid,'water_inversion', [idLoc,idTime],/float)
   idNaot      = NCDF_VARDEF(cdfid,'number_of_aot', [idLoc,idChn,idTime], /long)

   idtauext    = NCDF_VARDEF(cdfid,'total_extinction_aot_inversion', [idLoc,idInv,idTime], /float)
   idNinv      = NCDF_VARDEF(cdfid,'number_of_inversions', [idLoc,idChn,idTime], /long)
   idtauextf   = NCDF_VARDEF(cdfid,'fine_extinction_aot_inversion', [idLoc,idInv,idTime], /float)
   idtauextc   = NCDF_VARDEF(cdfid,'coarse_extinction_aot_inversion', [idLoc,idInv,idTime], /float)
   idssa       = NCDF_VARDEF(cdfid,'single_scatter_albedo_inversion', [idLoc,idInv,idTime], /float)
   idtauabs    = NCDF_VARDEF(cdfid,'total_absorption_aot_inversion', [idLoc,idInv,idTime], /float)
   idangext    = NCDF_VARDEF(cdfid,'extinction_440-870_angstrom_parameter_inversion', [idLoc,idTime], /float)
   idangabs    = NCDF_VARDEF(cdfid,'absorption_440-870_angstrom_parameter_inversion', [idLoc,idTime], /float)


   idDvdlnr    = NCDF_VARDEF(cdfid,'dvdlnr', [idLoc,idPSD,idTime], /float)   

   ncdf_attput, cdfid, idRadius, 'long_name', 'radius [um]'
   ncdf_attput, cdfid, idDr, 'long_name', 'radius bin width [um]'
   ncdf_attput, cdfid, idDvdlnr, 'long_name', 'dVd(lnr) particle size distribution (column) [um3 um-2]'
   ncdf_attput, cdfid, idDate, 'long_name', 'date in YYYYMMDD'
   ncdf_attput, cdfid, idChannels, 'long_name', 'AERONET channel in nm'
   ncdf_attput, cdfid, idLocation, 'long_name', 'AERONET location name'
   ncdf_attput, cdfid, idPi, 'long_name', 'AERONET PI Name'
   ncdf_attput, cdfid, idPiEmail, 'long_name', 'AERONET PI Email Address'
   ncdf_attput, cdfid, idLon, 'long_name', 'AERONET location longitude'
   ncdf_attput, cdfid, idLat, 'long_name', 'AERONET location latitude'
   ncdf_attput, cdfid, idElev, 'long_name', 'AERONET location elevation in m'
   ncdf_attput, cdfid, idNmsr, 'long_name', 'AERONET location nmeas'

   ncdf_attput, cdfid, idAOTw, 'long_name', 'AOT Daily Average'
   ncdf_attput, cdfid, idWater, 'long_name', 'Column Water [cm]'
   ncdf_attput, cdfid, idNaot, 'long_name', 'Number of aot measurements in time slice'
   ncdf_attput, cdfid, idtauext, 'long_name', 'Total Extinction Optical Thickness (inversion)'
   ncdf_attput, cdfid, idNinv, 'long_name', 'Number of inversions in time slice'
   ncdf_attput, cdfid, idtauextf, 'long_name', 'Fine Mode Extinction Optical Thickness (inversion)'
   ncdf_attput, cdfid, idtauextc, 'long_name', 'Coarse Mode Extinction Optical Thickness (inversion)'
   ncdf_attput, cdfid, idtauabs, 'long_name', 'Absorption Optical Thickness (inversion)'
   ncdf_attput, cdfid, idssa, 'long_name', 'Single Scattering Albedo (inversion)'
   ncdf_attput, cdfid, idangext, 'long_name', '440-870 nm Extinction Angstrom Parameter (inversion)'
   ncdf_attput, cdfid, idangabs, 'long_name', '440-870 nm Absorption Angstrom Parameter (inversion)'


   ncdf_control, cdfid, /endef

;  Write the location independent stuff
   ncdf_varput, cdfid, idChannels, channels
   ncdf_varput, cdfid, idChnInv, channels_inversion
   ncdf_varput, cdfid, idDate, date

;  Radius bins
   nbin = 22
   rmrat = (15.d/0.05d)^(3.d/(nbin-1))
   rmin = .05
   carmabins, nbin, rmrat, rmin, 2650., $
              rmass, rmassup, r, rup, dr, rlow
   ncdf_varput, cdfid, idRadius, r
   ncdf_varput, cdfid, idDr, dr

;   and write...
    ncdf_varput, cdfid, idLocation, location, offset=[0,0]
    ncdf_varput, cdfid, idPi, pi, offset=[0,0]
    ncdf_varput, cdfid, idPiEmail, pi_email, offset=[0,0]
    ncdf_varput, cdfid, idLon, lon, count=[1], offset=[0]
    ncdf_varput, cdfid, idLat, lat, count=[1], offset=[0]
    ncdf_varput, cdfid, idElev, elev, count=[1], offset=[0]
    ncdf_varput, cdfid, idNmsr, nmeas, count=[1], offset=[0]

    ncdf_varput, cdfid, idaotw, reform(aotw,1,nchannels,n_elements(date))
    ncdf_varput, cdfid, idWater, reform(water,1,n_elements(date))
    ncdf_varput, cdfid, idNaot, reform(naot,1,nchannels,n_elements(date))

    ncdf_varput, cdfid, idAngext, reform(angext,1,n_elements(date))
    ncdf_varput, cdfid, idAngabs, reform(angabs,1,n_elements(date))
    ncdf_varput, cdfid, idTauext, reform(tauext,1,ninvs,n_elements(date))
    ncdf_varput, cdfid, idNinv, reform(ninv,1,ninvs,n_elements(date))
    ncdf_varput, cdfid, idTauextf, reform(tauextf,1,ninvs,n_elements(date))
    ncdf_varput, cdfid, idTauextc, reform(tauextc,1,ninvs,n_elements(date))
    ncdf_varput, cdfid, idTauabs, reform(tauabs,1,ninvs,n_elements(date))
    ncdf_varput, cdfid, idSSA, reform(ssa,1,ninvs,n_elements(date))
    ncdf_varput, cdfid, idDvdlnr, reform(dvdlnr,1,npsd,n_elements(date))

    ncdf_close, cdfid
    s2 = systime(1,/seconds)
    ds3 = s2-s1

    nl = string(iloc+1, format='(i4)')
    nt = string(n_elements(loc1), format='(i4)')
    print, 'finished: '+nl+'/'+nt+', '+location, ds1, ds2, ds3

   endfor

end

