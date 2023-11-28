; Colarco
; December 2005
; Goal is to manipulate the AERONET Level 2.0 version 2.0 daily mean data.
; First need to parse the data listing and see what is available.  Apparently
; the database is updated on a weekly basis (since Sep 2005) and I have a
; copy of each of the updates so that there is a lot of repitition in the
; data I have.

  spawn, 'echo $AERONETDIR', headDir
  dataDir = headDir+'AOT/AOT/LEV20/ALL_POINTS/'
  filelist = file_search(dataDir+'*', count=nfiles)

; What hourly resolution do you want?
  nhr = 1
  if(nhr eq 0 or nhr gt 24 or fix(nhr) ne nhr) then begin
   print, 'something wrong with the hours you asked for'
   stop
  endif
  nt = 24/nhr


; Here is the date range I expect my generated file to go over 
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
  channels = [1640, 1020, 870, 675, 667, 555, 551, 532, 531, 500, $
              490, 443, 440, 412, 380, 340]
  nangpairs = 6
  angstrompairs = ['440-870', '380-500', '440-675', '500-870', '340-440', $
                   '440-675 polar']


;  Now loop and read the aeronet file and strip the desired
;  information
   for iloc = 0, n_elements(loc1)-1 do begin
;   create data table to write
    aot = make_array(nchannels,n_elements(date),val=-9999.)
    ang = make_array(nangpairs,n_elements(date),val=-9999.)
    naot = make_array(nchannels,n_elements(date),val=-9999)
    nang = make_array(nangpairs,n_elements(date),val=-9999)

;   Read from the daily averaged files
;   On return the values returned are the daily averaged aot, etc.
    s1 = systime(1,/seconds)
    filename = dataDir + dateBeg[0] +'_'+uniqfileend[nFileEnd-1] +'_'+loc1[iloc]
    read_aeronet_allpts, filename, location, lon, lat, elev, nmeas, pi, pi_email, $
     dateIn, aotIn, angIn

    s2 = systime(1,/seconds)
    ds1 = s2-s1

    yyyy_  = dateIn/1000000L
    mm_    = (dateIn-yyyy_*1000000L)/10000L
    dd_    = (dateIn-yyyy_*1000000L-mm_*10000L)/100L
    hh_    = (dateIn-yyyy_*1000000L-mm_*10000L-dd_*100L)
    jdayIn = julday(mm_,dd_,yyyy_,hh_)
    fd     = nhr/24.

;   Fill in my master array of dates only where there are site values.
    s1 = systime(1,/seconds)
    for idate = 0L, n_elements(date)-1 do begin

;    Check dates for overwrite
;    Use the julian date...
     yyyy_ = date[idate]/1000000L
     mm_   = (date[idate]-yyyy_*1000000L)/10000L
     dd_   = (date[idate]-yyyy_*1000000L-mm_*10000L)/100L
     hh_   = (date[idate]-yyyy_*1000000L-mm_*10000L-dd_*100L)
     jday_idate = julday(mm_,dd_,yyyy_,hh_)
     a = where(jdayIn ge jday_idate-fd/2 and $
               jdayIn lt jday_idate+fd/2)
     if(nhr eq 1) then a = where(jdayIn eq jday_idate)

;    Do any of the dates match?
     if(a[0] ne -1) then begin
      ilam670 = 3
      ich = where(aotIn[4,a] gt 0.)
      if(ich[0] ne -1) then ilam670 = 4
      bsave = -1
      b = where(aotIn[ilam670,a] gt 0.001)      

      if(b[0] ne -1) then begin

;      Gather the AOT
       for ich = 0, nchannels-1 do begin
        aot[ich,idate]  = mean(aotIn[ich,a[b]])
        naot[ich,idate] = n_elements(b)
       endfor

;      Angstrom pairs are valid at all AOT valid points, use bsave
       for ipair = 0, nangpairs-1 do begin
        ang[ipair,idate] = mean(angIn[ipair,a[b]]*aotIn[ilam670,a[b]])/$
                           aot[ilam670,idate]
        nang[ipair,idate] = n_elements(b)
       endfor
      endif

;     The dates are sorted.  The timing bottleneck is in comparing
;     dateIn to date[idate].  Throw out already considered dateIn elements
      nd = n_elements(dateIn)
      dateIn = dateIn[a[0]:nd-1]
      jdayIn = jdayIn[a[0]:nd-1]
      aotIn = aotIn[*,a[0]:nd-1]
      angIn = angIn[*,a[0]:nd-1]
     endif
    endfor
    s2 = systime(1,/seconds)
    ds2 = s2-s1

;   and write...
;   Create netcdf file for output
    s1 = systime(1,/seconds)
    cdfid = ncdf_create(headDir+'LEV30/aot_allpts.'+location+'.nc', /clobber)
    idLoc  = NCDF_DIMDEF(cdfid,'location',1)
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

    idAOT      = NCDF_VARDEF(cdfid,'aot_average', [idLoc,idChn,idTime], /float)
    idAng      = NCDF_VARDEF(cdfid,'angstrom_parameter_average', [idLoc,idAngPair,idTime], /float)
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

    ncdf_attput, cdfid, idAOT, 'long_name', 'AOT Average'
    ncdf_attput, cdfid, idAng, 'long_name', 'Angstrom Parameter Average'
    ncdf_attput, cdfid, idNaot, 'long_name', 'Number of aot measurements in time slice'
    ncdf_attput, cdfid, idNang, 'long_name', 'Number of angstrom parameter measurements in time slice'


    ncdf_control, cdfid, /endef

;   Write the location independent stuff
    ncdf_varput, cdfid, idChannels, channels
    ncdf_varput, cdfid, idAngstromPairs, angstrompairs
    ncdf_varput, cdfid, idDate, date
    ncdf_varput, cdfid, idLocation, location, offset=[0,0]
    ncdf_varput, cdfid, idPi, pi, offset=[0,0]
    ncdf_varput, cdfid, idPiEmail, pi_email, offset=[0,0]
    ncdf_varput, cdfid, idLon, lon, count=[1]
    ncdf_varput, cdfid, idLat, lat, count=[1]
    ncdf_varput, cdfid, idElev, elev, count=[1]
    ncdf_varput, cdfid, idNmsr, nmeas, count=[1]

;    ncdf_varput, cdfid, idaot, aot, count=[1,nchannels,n_elements(date)], offset=[iloc,0,0]
;    ncdf_varput, cdfid, idang, ang, count=[1,nangpairs,n_elements(date)], offset=[iloc,0,0]
;    ncdf_varput, cdfid, idnaot, naot, count=[1,nchannels,n_elements(date)], offset=[iloc,0,0]
;    ncdf_varput, cdfid, idnang, nang, count=[1,nangpairs,n_elements(date)], offset=[iloc,0,0]
    ncdf_varput, cdfid, idaot, reform(aot,1,nchannels,n_elements(date))
    ncdf_varput, cdfid, idang, reform(ang,1,nangpairs,n_elements(date))
    ncdf_varput, cdfid, idnaot, reform(naot,1,nchannels,n_elements(date))
    ncdf_varput, cdfid, idnang, reform(nang,1,nangpairs,n_elements(date))
;    ncdf_varput, cdfid, idaot, aot, offset=[iloc,0,0]
;    ncdf_varput, cdfid, idang, ang, offset=[iloc,0,0]
;    ncdf_varput, cdfid, idnaot, naot, offset=[iloc,0,0]
;    ncdf_varput, cdfid, idnang, nang, offset=[iloc,0,0]
    ncdf_close, cdfid
    s2 = systime(1,/seconds)
    ds3 = s2-s1

    nl = string(iloc+1, format='(i4)')
    nt = string(n_elements(loc1), format='(i4)')
    print, 'finished: '+nl+'/'+nt+', '+location, ds1, ds2, ds3

   endfor



end

