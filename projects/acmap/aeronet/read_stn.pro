; Colarco, Jan. 2017
; Read a station sampled file one variable at a time, request a site

  pro read_stn, file, site, varwant, varout, nymd, nhms, rc=rc

  rc = 0

;file = '/misc/prc13/MERRA2/aeronet/MERRA2.tavg1_2d_aer_Nx.aeronet.2008.nc4'
  cdfid = ncdf_open(file)

; Get the list of station names
  id = ncdf_varid(cdfid,'stnName')
  ncdf_varget, cdfid, id, stnName
  a = where(strcompress(string(stnName),/rem) eq site)
  if(a[0] eq -1) then begin
   rc = 1
   ncdf_close, cdfid
   return
  endif
  offset = [0,a[0]]

; Get the time
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time
  ncdf_attget, cdfid, id, 'units', units
; Hack -- assume units has "since " in string followed
; by YYYY-MM-DD and assume 0z is start
  units = string(units)
  a = strsplit(units)
  yyyy = strmid(units,a[2],4)
  mm   = strmid(units,a[2]+5,2)
  dd   = strmid(units,a[2]+8,2)
  nt = n_elements(time)
  count = [nt,1]
  monstr = [' ','jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']
  mon = monstr[fix(mm)]
  tdef = 'tdef time '+string(nt)+' linear 0z'+dd+mon+yyyy+' 1hr'
  dateexpand, nymd0, nymd1, nhms0, nhms1, nymd, nhms, tdef=tdef


; Get the variable
  id = ncdf_varid(cdfid,varwant)
  ncdf_varget, cdfid, id, varout, offset=offset, count=count

  ncdf_close, cdfid



end
