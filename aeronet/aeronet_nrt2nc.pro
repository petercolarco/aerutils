; Colarco
; April 2011
; Given a once per day file from the AERONET Level 1.5 retrievals,
; pull out and assemble format similar netcdf files aggregating the
; data.
; Because the files name contain data from previous, current, and
; next date, read surrounding files if available.

  pro aeronet_nrt2nc, dateinp, rc=rc

  rc = 0

  datewant = string(dateinp, format='(i8)')
  dateprev = strmid(string(incstrdate(dateinp*100L,-24L),format='(i10)'),0,8)
  datenext = strmid(string(incstrdate(dateinp*100L, 24L),format='(i10)'),0,8)

; Read the previous date dataset
  datestr = dateprev
  prev = 0
  filename = '/misc/prc10/AERONET/AOT/AOT/LEV15/NRT/' +$
             strmid(datestr,0,4)+'_'+strmid(datestr,4,2)+'_'+$
             strmid(datestr,6,2)+'_level1.5'
  if(file_search(filename) ne '') then begin
   read_aeronet_nrt, filename, site0, date0, aot0, lon0, lat0
   prev = 1
  endif

; Read the current date dataset
  datestr = datewant
  curr = 0
  filename = '/misc/prc10/AERONET/AOT/AOT/LEV15/NRT/' +$
             strmid(datestr,0,4)+'_'+strmid(datestr,4,2)+'_'+$
             strmid(datestr,6,2)+'_level1.5'
  if(file_search(filename) ne '') then begin
   read_aeronet_nrt, filename, sites, dates, aot, lon, lat
   curr = 1
  endif

; Read the previous date dataset
  datestr = datenext
  next = 0
  filename = '/misc/prc10/AERONET/AOT/AOT/LEV15/NRT/' +$
             strmid(datestr,0,4)+'_'+strmid(datestr,4,2)+'_'+$
             strmid(datestr,6,2)+'_level1.5'
  if(file_search(filename) ne '') then begin
   read_aeronet_nrt, filename, site2, date2, aot2, lon2, lat2
   next = 1
  endif

  if(curr eq 0) then begin
   rc = 1
   return
  endif

  if(prev) then begin
   dates = [date0,dates]
   sites = [site0,sites]
   lon   = [lon0,lon]
   lat   = [lat0,lat]
   aot   = transpose([transpose(aot0),transpose(aot)])
  endif 

  if(next) then begin
   dates = [dates,date2]
   sites = [sites,site2]
   lon   = [lon,lon2]
   lat   = [lat,lat2]
   aot   = transpose([transpose(aot),transpose(aot2)])
  endif 

; Retain only dates on the current date wanted
  a = where(long(dates)/100L eq dateinp)
  sites = sites[a]
  dates = dates[a]
  aot   = aot[*,a]
  lon   = lon[a]
  lat   = lat[a]

; Sort what is left
  a = sort(sites)
  sites = sites[a]
  dates = dates[a]
  aot   = aot[*,a]
  lon   = lon[a]
  lat   = lat[a]

  nt = 24
  nhr = 24./nt

  date = dateinp*100L + long(indgen(nt)*nhr)

; Information about the data
  nchannels = 16
  channels = [1640, 1020, 870, 675, 667, 555, 551, 532, 531, 500, $
              490, 443, 440, 412, 380, 340]

  location = sites[uniq(sites)]
  nlocs    = n_elements(location)
  
; Create the output files

    cdfid = ncdf_create('./output/aeronet2nc/NRT/aot_nrt.'+datewant+'.nc', /clobber)
    idLoc  = NCDF_DIMDEF(cdfid,'location',nlocs)
    idChn  = NCDF_DIMDEF(cdfid,'channels',nchannels)
    idTime = NCDF_DIMDEF(cdfid,'time',/unlimited)
    idLen  = NCDF_DIMDEF(cdfid,'length',100)
    idDate      = NCDF_VARDEF(cdfid, 'time', [idTime], /long)
    idChannels  = NCDF_VARDEF(cdfid,'channels',[idChn],/float)
    idLocation  = NCDF_VARDEF(cdfid,'location',[idLen,idLoc],/char)
    idLon       = NCDF_VARDEF(cdfid,'lon',[idLoc],/float)
    idLat       = NCDF_VARDEF(cdfid,'lat',[idLoc],/float)
    idAOT      = NCDF_VARDEF(cdfid,'aot_average', [idLoc,idChn,idTime], /float)
    idNaot     = NCDF_VARDEF(cdfid,'number_of_aot', [idLoc,idChn,idTime], /long)

    ncdf_attput, cdfid, idDate, 'long_name', 'date in YYYYMMDD'
    ncdf_attput, cdfid, idChannels, 'long_name', 'AERONET channel in nm'
    ncdf_attput, cdfid, idLocation, 'long_name', 'AERONET location name'
    ncdf_attput, cdfid, idLon, 'long_name', 'AERONET location longitude'
    ncdf_attput, cdfid, idLat, 'long_name', 'AERONET location latitude'
    ncdf_attput, cdfid, idAOT, 'long_name', 'AOT Average'
    ncdf_attput, cdfid, idNaot, 'long_name', 'Number of aot measurements in time slice'

    ncdf_control, cdfid, /endef

    ncdf_varput, cdfid, idChannels, channels
    ncdf_varput, cdfid, idDate, date
    ncdf_varput, cdfid, idLocation, location, offset=[0,0]
 
;   Now, per location, put data in file
    for iloc = 0, nlocs-1 do begin

     a = where(sites eq location[iloc])
     ncdf_varput, cdfid, idLocation, location[iloc], offset=[0,0]
     ncdf_varput, cdfid, idLon, lon[a[0]], offset=[iloc], count=[1]
     ncdf_varput, cdfid, idLat, lat[a[0]], offset=[iloc], count=[1]

     for idate = 0L, n_elements(date)-1 do begin

      b    = where(dates[a] eq date[idate])
      if(b[0] ne -1 ) then begin
       aot_ = reform(aot[*,a[b]],nchannels,n_elements(b))
       c = where(aot_ lt 0)
       if(c[0] ne -1) then aot_[c] = !values.f_nan
       for ich = 0, nchannels-1 do begin
        aoto = mean(aot_[ich,*],/nan)
        d = where(finite(aot_[ich,*]) eq 1)
        if(d[0] eq -1) then n = 0 else n = n_elements(d)
        if(n eq 0) then begin
         ncdf_varput, cdfid, idaot, -9999., offset=[iloc,ich,idate], count=[1,1,1]
         ncdf_varput, cdfid, idnaot, 0, offset=[iloc,ich,idate], count=[1,1,1]
        endif else begin
         ncdf_varput, cdfid, idaot, aoto, offset=[iloc,ich,idate], count=[1,1,1]
         ncdf_varput, cdfid, idnaot, n, offset=[iloc,ich,idate], count=[1,1,1]
        endelse
       endfor
      endif else begin
       ncdf_varput, cdfid, idaot, make_array(nchannels,val=-9999.), offset=[iloc,0,idate], count=[1,nchannels,1]
       ncdf_varput, cdfid, idnaot, make_array(nchannels,val=0), offset=[iloc,0,idate], count=[1,nchannels,1]
      endelse

     endfor
    endfor


    ncdf_close, cdfid

end

