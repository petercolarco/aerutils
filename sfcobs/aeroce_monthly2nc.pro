; Colarco
; September 2006
; Goal is to manipulate the AEROCE monthly data from the AEROCOM web site and grid
; into a single netcdf file for easy manipulation
  spawn, 'echo $SFCOBSDIR', headDir
  dataDir = headDir+'/AEROCE/fromAerocom/AEROCE/'
  filelist = file_search(dataDir+'*', count=nfiles)

; Here is the date range I expect my generated file to go over 
  date0 = 19960101L
  date1 = 20101231L

; Parse the filenames for the years and sites
  nfile = n_elements(filelist)
  nparts = n_elements(strsplit(filelist[0],'./',/extract))
  fileparts = strarr(nparts,nfile)
  for i = 0, nfile-1 do begin
   fileparts[*,i] = strsplit(filelist[i],'./',/extract)
  endfor
  fileparts = reform(fileparts[5,*])
  years = strarr(nfile)
  const = strarr(nfile)
  sitesOrig = strarr(nfile)
  sites     = strarr(nfile)
  for i = 0, nfile-1 do begin
   len = strlen(fileparts[i])
   a = strsplit(fileparts[i],'_',length=length)
   const[i] = strmid(fileparts[i],a[1], length[1])
   years[i] = strmid(fileparts[i],a[2]+2, length[2]-2)
   sitesOrig[i] = strmid(fileparts[i],a[3], len-a[3])
   sites[i] = sitesOrig[i]
  endfor

; Unique sites, years, and constituents
  sites = sites[uniq(sites,sort(sites))]
  years = years[uniq(years,sort(years))]
  const = const[uniq(const,sort(const))]
  nconst = n_elements(const)
  nyears = n_elements(years)
  nsites = n_elements(sites)

; Go into the obs data base to get the site information
  lon = fltarr(nsites)
  lat = fltarr(nsites)
  elev = fltarr(nsites)
  mnt = make_array(nsites,val=-9999.)
  openr, lun, dataDir+'../obs_aerinput.prn.txt', /get_lun
  in = 0
  readf, lun, in
  for i = 0, in-1 do begin
   str = 'a'
   readf, lun, str
   str = strsplit(str,/extract)
   a = where(sites eq str[0])
   if(a[0] ne -1) then begin
    lon[a] = float(str[1])
    lat[a] = float(str[2])
    elev[a] = float(str[3])
    mnt[a]  = float(str[5])
   endif
  endfor
  free_lun, lun

; Throw out missing sites that were not reset
  a = where(mnt ne -9999.)
  if(a[0] ne -1) then begin
   sites = sites[a]
   mnt = mnt[a]
   lon = lon[a]
   lat = lat[a]
   elev = elev[a]
   nsites = n_elements(sites)
  endif

; Now this part is klugy, but for the moment we throw out mountain sites
; from further analysis.
  a = where(mnt eq 1)
  sitesMnt = sites[a]
  for i = 0, n_elements(sitesMnt)-1 do begin
   a = where(sitesOrig ne sitesMnt[i])
   sitesOrig = sitesOrig[a]
   filelist = filelist[a]
  endfor
  a = where(mnt eq 0)
  sites=sites[a]
  lon = lon[a]
  lat = lat[a]
  elev= elev[a]
  mnt = mnt[a]
  nsites = n_elements(sites)

  dateBeg = strarr(nfiles)
  dateEnd = strarr(nfiles)
  len = strlen(dataDir)
  dateBeg = strmid(filelist,len,6)
  dateEnd = strmid(filelist,len+7,6)



; Structure of desired output file
  yyyy = date0/10000L
  mm = (date0-yyyy*10000L)/100
  dd = (date0-yyyy*10000L - mm*100)
  jday0 = julday(mm,dd,yyyy)
  ny = date1/10000L - yyyy + 1
  ndates = ny*12
  date = lonarr(ndates)
  for iy = 0, ny - 1 do begin
   for im = 0, 11 do begin
    date[iy*12+im] = long((yyyy+iy)*10000L) + (im+1)*100 + 15
   endfor
  endfor


; Create netcdf file for output
  cdfid = ncdf_create('./output/data/aeroce_monthly.nc', /clobber)
   idLoc  = NCDF_DIMDEF(cdfid,'location',nsites)
   idTime = NCDF_DIMDEF(cdfid,'time',/unlimited)
   idLen  = NCDF_DIMDEF(cdfid,'length',100)

   idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)
   idLocation  = NCDF_VARDEF(cdfid,'location',[idLen,idLoc],/char)
   idPi        = NCDF_VARDEF(cdfid,'pi',[idLen,idLoc],/char)
   idPiEmail   = NCDF_VARDEF(cdfid,'pi_email',[idLen,idLoc],/char)
   idLon       = NCDF_VARDEF(cdfid,'lon',[idLoc],/float)
   idLat       = NCDF_VARDEF(cdfid,'lat',[idLoc],/float)
   idElev      = NCDF_VARDEF(cdfid,'elevation',[idLoc],/float)

   ncdf_attput, cdfid, idDate, 'long_name', 'date in YYYYMMDD'
   ncdf_attput, cdfid, idLocation, 'long_name', 'AEROCE location name'
   ncdf_attput, cdfid, idPi, 'long_name', 'AEROCE PI Name'
   ncdf_attput, cdfid, idPiEmail, 'long_name', 'AEROCE PI Email Address'
   ncdf_attput, cdfid, idLon, 'long_name', 'AEROCE location longitude'
   ncdf_attput, cdfid, idLat, 'long_name', 'AEROCE location latitude'
   ncdf_attput, cdfid, idElev, 'long_name', 'AEROCE location elevation in m'

   idCnst      = lonarr(nconst)
   for i = 0, nconst-1 do begin
    idCnst[i]  = NCDF_VARDEF(cdfid,const[i],[idloc,idTime])
    ncdf_attput, cdfid, idCnst[i], 'long_name', $
     'Constituent surface mass monthly average [ug('+const[i]+') m-3]'
   endfor

   idCnstStd   = lonarr(nconst)
   for i = 0, nconst-1 do begin
    idCnstStd[i]  = NCDF_VARDEF(cdfid,const[i]+'std',[idloc,idTime])
    ncdf_attput, cdfid, idCnstStd[i], 'long_name', $
     'Constituent surface mass monthly average stddev [ug('+const[i]+') m-3]'
   endfor

   ncdf_control, cdfid, /endef

;  Write the location independent stuff
   ncdf_varput, cdfid, idDate, date


;  Now loop and read the aeronet file and strip the desired information
   for iloc = 0, nsites-1 do begin

    for iconst = 0, nconst-1 do begin

;    Create dummy output arrays
     varout = make_array(ndates,val=-9999.)
     stdout = make_array(ndates,val=-9999.)

     for iyear = 0, nyears-1 do begin
      filename = dataDir+'CONC_'+const[iconst]+'_an'+years[iyear]+'_'+sites[iloc]+'.txt'
      read_aeroce_monthly, filename, dateIn, valueIn, stdIn
b = where(valueIn lt 0)
if(b[0] ne -1) then begin
  valueIn[b] = -9999.
  stdIn[b] = -9999.
endif

;     and fill in the values
      for idate = 0, n_elements(dateIn)-1 do begin

;      Check dates for overwrite
       a = where(dateIn[idate] eq date)
       if(a[0] ne -1) then begin
        varout[a] = valueIn[idate]
        stdout[a] = stdIn[idate]
       endif
      endfor

     endfor

     ncdf_varput, cdfid, idCnst[iconst], varout, offset=[iloc,0], count=[1,ndates]
     ncdf_varput, cdfid, idCnstStd[iconst], stdOut, offset=[iloc,0], count=[1,ndates]

    endfor

;   and write for location...
    ncdf_varput, cdfid, idLocation, sites[iloc], offset=[0,iloc]
    ncdf_varput, cdfid, idPi, 'AEROCE', offset=[0,iloc]
    ncdf_varput, cdfid, idPiEmail, 'AEROCE', offset=[0,iloc]
    ncdf_varput, cdfid, idLon, lon[iloc], count=[1], offset=[iloc]
    ncdf_varput, cdfid, idLat, lat[iloc], count=[1], offset=[iloc]
    ncdf_varput, cdfid, idElev, elev[iloc], count=[1], offset=[iloc]


   endfor

   ncdf_close, cdfid


end

