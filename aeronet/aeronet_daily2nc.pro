; Colarco
; July 2008

; Read the Level 2 version 2.0 daily mean AERONET files for all
; available sites.  Concatenate into a single netcdf file for easy
; access.  You need to provide the location of the AERONET data
; provided from aeronet.gsfc.nasa.gov:AOT_Level2_Daily.tar.gz
; as expanded (dataDir).  You also need to give the bounding dates
; you care to concatenate (dat0, date1).
; The monthly mean files contain monthly mean AOT as a mean of the
; daily averages (idAOTm) and the weighted mean of all AOT (idAOTw).
; No Angstrom parameters are present in the input files, so none are
; saved here.

  spawn, 'echo $AERONETDIR', headDir
  dataDir = headDir+'AOT/AOT/LEV20/DAILY/'
  filelist = file_search(dataDir+'*', count=nfiles)

; Here is the date range I expect my generated file to go over 
  date0 = 1992010112L
  date1 = 2017123112L

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
  yyyy = date0/1000000L
  mm = (date0-yyyy*1000000L)/10000L
  dd = (date0-yyyy*1000000L - mm*10000L - 12)/100L
  jday0 = julday(mm,dd,yyyy)
  yyyy = date1/1000000L
  mm = (date1-yyyy*1000000L)/10000L
  dd = (date1-yyyy*1000000L - mm*10000L - 12)/100L
  jday1 = julday(mm,dd,yyyy)
  ndates = jday1-jday0+1
  date = lonarr(ndates)
  jday = jday0

  for iday = 0, ndates-1 do begin
   caldat, jday, mm, dd, yyyy
   date[iday] = long(yyyy*1000000L + mm*10000L + dd*100L + 12L)
   jday = jday+1
  endfor

  nchannels = 16
  channels = [1640, 1020, 870, 675, 667, 555, 551, 532, 531, 500, $
              490, 443, 440, 412, 380, 340]
  nangpairs = 6
  angstrompairs = ['440-870', '380-500', '440-675', '500-870', '340-440', $
                   '440-675 polar']

; Create netcdf file for output
  cdfid = ncdf_create(headDir+'LEV30/aot_daily.nc', /clobber)
   idLoc  = NCDF_DIMDEF(cdfid,'location',nlocs)
   idChn  = NCDF_DIMDEF(cdfid,'channels',nchannels)
   idAngPair  = NCDF_DIMDEF(cdfid,'angstrom_pairs',nangpairs)
   idTime = NCDF_DIMDEF(cdfid,'time',/unlimited)
   idLen  = NCDF_DIMDEF(cdfid,'length',100)

   idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)
   idChannels  = NCDF_VARDEF(cdfid,'channels',[idChn],/float)
   idAngstromPairs  = NCDF_VARDEF(cdfid,'angstrom_pairs',[idLen,idAngPair],/char)
   idLocation  = NCDF_VARDEF(cdfid,'location',[idLen,idLoc],/char)
   idPi        = NCDF_VARDEF(cdfid,'pi',[idLen,idLoc],/char)
   idPiEmail   = NCDF_VARDEF(cdfid,'pi_email',[idLen,idLoc],/char)
   idLon       = NCDF_VARDEF(cdfid,'lon',[idLoc],/float)
   idLat       = NCDF_VARDEF(cdfid,'lat',[idLoc],/float)
   idElev      = NCDF_VARDEF(cdfid,'elevation',[idLoc],/float)
   idNmsr      = NCDF_VARDEF(cdfid,'number_of_measurements',[idLoc],/long)

   idAOT      = NCDF_VARDEF(cdfid,'aot_daily_average', [idLoc,idChn,idTime], /float)
   idAng      = NCDF_VARDEF(cdfid,'angstrom_parameter_daily_average', [idLoc,idAngPair,idTime], /float)
   idNaot     = NCDF_VARDEF(cdfid,'number_of_aot', [idLoc,idChn,idTime], /long)
   idNang      = NCDF_VARDEF(cdfid,'number_of_angstrom', [idLoc,idAngPair,idTime], /long)

   ncdf_attput, cdfid, idDate, 'long_name', 'date in YYYYMMDD'
   ncdf_attput, cdfid, idChannels, 'long_name', 'AERONET channel in nm'
   ncdf_attput, cdfid, idAngPair, 'long_name', 'AERONET Angstrom Parameter pairs'
   ncdf_attput, cdfid, idLocation, 'long_name', 'AERONET location name'
   ncdf_attput, cdfid, idPi, 'long_name', 'AERONET PI Name'
   ncdf_attput, cdfid, idPiEmail, 'long_name', 'AERONET PI Email Address'
   ncdf_attput, cdfid, idLon, 'long_name', 'AERONET location longitude'
   ncdf_attput, cdfid, idLat, 'long_name', 'AERONET location latitude'
   ncdf_attput, cdfid, idElev, 'long_name', 'AERONET location elevation in m'
   ncdf_attput, cdfid, idNmsr, 'long_name', 'AERONET location nmeas'

   ncdf_attput, cdfid, idAOT, 'long_name', 'AOT Daily Average'
   ncdf_attput, cdfid, idAng, 'long_name', 'Angstrom Parameter Daily Average'
   ncdf_attput, cdfid, idNaot, 'long_name', 'Number of aot measurements in day'
   ncdf_attput, cdfid, idNang, 'long_name', 'Number of angstrom parameter measurements in day'


   ncdf_control, cdfid, /endef

;  Write the location independent stuff
   ncdf_varput, cdfid, idChannels, channels
   ncdf_varput, cdfid, idAngstromPairs, angstrompairs
   ncdf_varput, cdfid, idDate, date

;  Now loop and read the aeronet file and strip the desired information
   for iloc = 0, n_elements(loc1)-1 do begin
;   create data table to write
    aot = make_array(nchannels,n_elements(date),val=-9999.)
    ang = make_array(nangpairs,n_elements(date),val=-9999.)
    naot = make_array(nchannels,n_elements(date),val=-9999)
    nang = make_array(nangpairs,n_elements(date),val=-9999)

;   Read from the daily averaged files
;   On return the values returned are the daily averaged aot, etc.
    filename = dataDir + dateBeg[0] +'_'+uniqfileend[nFileEnd-1] +'_'+loc1[iloc]
    read_aeronet_daily, filename, location, lon, lat, elev, nmeas, pi, pi_email, $
     dateIn, aotIn, angIn, naotIn, nangIn

;   Fill in my master array of dates only where there are site values.
    for idate = 0, n_elements(dateIn)-1 do begin

;    Check dates for overwrite
     a = where(dateIn[idate] eq date)
     if(a[0] ne -1) then begin
      aot[*,a] = aotIn[*,idate]
      ang[*,a] = angIn[*,idate]
      naot[*,a] = naotIn[*,idate]
      nang[*,a] = nangIn[*,idate]
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

    ncdf_varput, cdfid, idaot, aot, count=[1,nchannels,n_elements(date)], offset=[iloc,0,0]
    ncdf_varput, cdfid, idang, ang, count=[1,nangpairs,n_elements(date)], offset=[iloc,0,0]
    ncdf_varput, cdfid, idnaot, naot, count=[1,nchannels,n_elements(date)], offset=[iloc,0,0]
    ncdf_varput, cdfid, idnang, nang, count=[1,nangpairs,n_elements(date)], offset=[iloc,0,0]

    nl = string(iloc+1, format='(i4)')
    nt = string(n_elements(loc1), format='(i4)')
    print, 'finished: '+nl+'/'+nt+', '+location

   endfor

   ncdf_close, cdfid


end

