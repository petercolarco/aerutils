; Colarco
; July 2011

; Read the Level 2 version 2.0 monthly mean AERONET files for all
; available sites.  Concatenate into a single netcdf file for easy
; access.  You need to provide the location of the AERONET data
; provided from aeronet.gsfc.nasa.gov:AOT_Level2_Monthly.tar.gz
; as expanded (dataDir).  You also need to give the bounding dates
; you care to concatenate (dat0, date1).

; The monthly mean files contain monthly mean AOT as a mean of the
; daily averages (idAOTm) and the weighted mean of all AOT (idAOTw).
; No Angstrom parameters are present in the input files, so none are
; saved here.

; For now: ignore refractive indices, asymmetry paremeter, 
;          22 bin PSD representation, fluxes

  spawn, 'echo $AERONETDIR', headDir
  dataDir = headDir+'INV/INV/DUBOV/MONTHLY/'
  filelist = file_search(dataDir+'*', count=nfiles)

; Here are the date range I expect my generated file to go over
; In monthly form, one entry per month
; Assume each year is complete (i.e., starts Jan 15 of first year
; and ends Dec 15 of last year)
  date0 = 1992011512L
  date1 = 2017121512L
  yyyy0 = fix(date0/1000000L)
  yyyy1 = fix(date1/1000000L)
  nmon  = ((yyyy1-yyyy0)+1)*12

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
  date = lonarr(nmon)
  dd = 15
  for imon = 0, nmon-1 do begin
   mm = (imon) - 12*(imon/12) + 1
   yyyy = yyyy0 + imon/12
   date[imon] = yyyy*1000000L + mm*10000L + dd*100L + 12L
  endfor

  nchannels = 16
  ninvs     = 4
  npsd      = 22
  channels = [1640, 1020, 870, 675, 667, 555, 551, 532, 531, 500, $
              490, 443, 440, 412, 380, 340]
  channels_inversion = [440, 670, 870, 1020]
  

; Create netcdf file for output
  cdfid = ncdf_create(headDir+'LEV30/inversions_monthly.nc', /clobber)
   idLoc  = NCDF_DIMDEF(cdfid,'location',nlocs)
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

   idAOTw      = NCDF_VARDEF(cdfid,'aot_of_weighted_average', [idLoc,idChn,idTime], /float)
   idWater     = NCDF_VARDEF(cdfid,'water_inversion', [idLoc,idTime],/float)
   idNdays     = NCDF_VARDEF(cdfid,'number_of_days', [idLoc,idChn,idTime], /long)
   idNaot      = NCDF_VARDEF(cdfid,'number_of_aot', [idLoc,idChn,idTime], /long)
   idNinv      = NCDF_VARDEF(cdfid,'number_of_inversions', [idLoc,idInv,idTime], /long)

   idtauext    = NCDF_VARDEF(cdfid,'total_extinction_aot_inversion', [idLoc,idInv,idTime], /float)
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

   ncdf_attput, cdfid, idAOTw, 'long_name', 'AOT mean of weighted average'
   ncdf_attput, cdfid, idWater, 'long_name', 'Column Water [cm]'
   ncdf_attput, cdfid, idNdays, 'long_name', 'Number of days of measurement in month'
   ncdf_attput, cdfid, idNaot, 'long_name', 'Number of AOT observations in month'
   ncdf_attput, cdfid, idNinv, 'long_name', 'Number of inversions in month'
   ncdf_attput, cdfid, idtauext, 'long_name', 'Total Extinction Optical Thickness (inversion)'
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

;  Now loop and read the aeronet file and strip the desired information
   for iloc = 0, n_elements(loc1)-1 do begin
;   create data table to write
    aotw    = make_array(nchannels,n_elements(date),val=-9999.)
    ndays   = make_array(nchannels,n_elements(date),val=-9999)
    naot    = make_array(nchannels,n_elements(date),val=-9999)
    ninv    = make_array(ninvs,n_elements(date),val=-9999)
    water   = make_array(n_elements(date), val=-9999.)
    tauext  = make_array(ninvs,n_elements(date), val=-9999.)
    tauextf = make_array(ninvs,n_elements(date), val=-9999.)
    tauextc = make_array(ninvs,n_elements(date), val=-9999.)
    tauabs  = make_array(ninvs,n_elements(date), val=-9999.)
    ssa     = make_array(ninvs,n_elements(date), val=-9999.)
    angext  = make_array(n_elements(date), val=-9999.)
    angabs  = make_array(n_elements(date), val=-9999.)
    dvdlnr  = make_array(npsd, n_elements(date), val=-9999.)


    filename = dataDir + dateBeg[0] +'_'+uniqfileend[nFileEnd-1] +'_'+loc1[iloc]
    read_aeronet_inversions_monthly, filename, location, lon, lat, elev, nmeas, pi, pi_email, $
     date_, aotw_, water_, tauext_, tauextf_, tauextc_, angext_, ssa_, tauabs_, angabs_, $
     ndays_, naot_, ninv_, dvdlnr_

    for idate = 0, n_elements(date_)-1 do begin

;    Check dates for overwrite
     a = where(date_[idate] eq date)
     if(a[0] ne -1) then begin
      aotw[*,a]    = aotw_[*,idate]
      ndays[*,a]   = ndays_[idate]
      naot[*,a]    = naot_[idate]
      ninv[*,a]    = ninv_[idate]
      water[a]     = water_[idate]
      tauext[*,a]  = tauext_[*,idate]
      tauextf[*,a] = tauextf_[*,idate]
      tauextc[*,a] = tauextc_[*,idate]
      tauabs[*,a]  = tauabs_[*,idate]
      ssa[*,a]     = ssa_[*,idate]
      angext[a]    = angext_[idate]
      angabs[a]    = angabs_[idate]
      dvdlnr[*,a]  = dvdlnr_[*,idate]
     endif
    endfor

;   and write...
    ncdf_varput, cdfid, idLocation, location, offset=[0,iloc]
    ncdf_varput, cdfid, idPi, pi, offset=[0,iloc]
    ncdf_varput, cdfid, idPiEmail, pi_email, offset=[0,iloc]
    ncdf_varput, cdfid, idLon, lon, count=[1], offset=[iloc]
    ncdf_varput, cdfid, idLat, lat, count=[1], offset=[iloc]
    ncdf_varput, cdfid, idElev, elev, count=[1], offset=[iloc]
    ncdf_varput, cdfid, idNmsr, nmeas, count=[1], offset=[iloc]

    ncdf_varput, cdfid, idaotw, aotw, count=[1,nchannels,n_elements(date)], offset=[iloc,0,0]
    ncdf_varput, cdfid, idndays, ndays, count=[1,nchannels,n_elements(date)], offset=[iloc,0,0]
    ncdf_varput, cdfid, idnaot, naot, count=[1,nchannels,n_elements(date)], offset=[iloc,0,0]
    ncdf_varput, cdfid, idninv, ninv, count=[1,ninvs,n_elements(date)], offset=[iloc,0,0]

    ncdf_varput, cdfid, idWater, water, count=[1,n_elements(date)], offset=[iloc,0]
    ncdf_varput, cdfid, idAngext, angext, count=[1,n_elements(date)], offset=[iloc,0]
    ncdf_varput, cdfid, idAngabs, angabs, count=[1,n_elements(date)], offset=[iloc,0]
    ncdf_varput, cdfid, idTauext, tauext, count=[1,ninvs,n_elements(date)], offset=[iloc,0,0]
    ncdf_varput, cdfid, idTauextf, tauextf, count=[1,ninvs,n_elements(date)], offset=[iloc,0,0]
    ncdf_varput, cdfid, idTauextc, tauextc, count=[1,ninvs,n_elements(date)], offset=[iloc,0,0]
    ncdf_varput, cdfid, idTauabs, tauabs, count=[1,ninvs,n_elements(date)], offset=[iloc,0,0]
    ncdf_varput, cdfid, idSSA, ssa, count=[1,ninvs,n_elements(date)], offset=[iloc,0,0]
    ncdf_varput, cdfid, idDvdlnr, dvdlnr, count=[1,npsd,n_elements(date)], offset=[iloc,0,0]

    nl = string(iloc+1, format='(i4)')
    nt = string(n_elements(loc1), format='(i4)')
    print, 'finished: '+nl+'/'+nt+', '+location

   endfor

   ncdf_close, cdfid


end

