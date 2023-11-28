; Colarco, October 2006
; Read the lifetime file

  pro read_lifetime, expid, year, date, var, tau, ksca, kwet, ksed, kdry

  ny = n_elements(year)
  ndate = 12*ny

  for iy = 0, ny -1 do begin

  filename = 'lifetime.'+expid+'.'+year[iy]+'.txt'

  openr, lun, './output/tables/'+filename, /get_lun
  readf, lun, nmon, nvar

  if(iy eq 0) then begin
   date = strarr(ndate)
   var  = strarr(nvar)
   tau  = fltarr(ndate,nvar)
   ksca = fltarr(ndate,nvar)
   kwet = fltarr(ndate,nvar)
   ksed = fltarr(ndate,nvar)
   kdry = fltarr(ndate,nvar)
  endif

  for idate = 0, nmon-1 do begin
   str = 'a'
   readf, lun, str
   readf, lun, str
   strtemp = strsplit(str,/extract)
   date[idate+iy*12] = strtemp[1]
   readf, lun, str
   for ivar = 0, nvar-1 do begin
    readf, lun, str
    strtemp = strsplit(str,/extract)
    var[ivar]        = strtemp[0]
    tau[idate+iy*12,ivar]  = strtemp[1]
    ksca[idate+iy*12,ivar] = strtemp[2]
    kwet[idate+iy*12,ivar] = strtemp[3]
    ksed[idate+iy*12,ivar] = strtemp[4]
    kdry[idate+iy*12,ivar] = strtemp[5]
   endfor
  endfor

  free_lun, lun

  endfor

; reorder and rearrange by years
  tau = reform(tau,12,ny,nvar)
  ksca = reform(ksca,12,ny,nvar)
  kwet = reform(kwet,12,ny,nvar)
  ksed = reform(ksed,12,ny,nvar)
  kdry = reform(kdry,12,ny,nvar)

  tau = transpose(tau,[0,2,1])
  ksca = transpose(ksca,[0,2,1])
  kwet = transpose(kwet,[0,2,1])
  ksed = transpose(ksed,[0,2,1])
  kdry = transpose(kdry,[0,2,1])
end
