; Colarco, July 2006
; Given a control file and a range of dates, compute the aerosol lifetimes
; 

  pro print_lifetime, expid, year, resolution=resolution, varwant=varwant

  if(not keyword_set(resolution)) then resolution = 'c'
  if(not keyword_set(varwant)) then varwant = ['du','su','ss','bc','oc']

  month = ['01','02','03','04','05','06','07','08','09','10','11','12']
  ctlfile = expid + '.ctl'

  gocart = 0
  if(strpos(expid,'gocart') ne -1) then gocart = 1


  openw, lun, './output/tables/lifetime.'+expid+'.'+year+'.txt', /get_lun

  nvar = n_elements(varwant)
  ny = n_elements(year)
  ndate = ny*12
  tau = fltarr(ndate,nvar)
  kscav = fltarr(ndate,nvar)
  kwet  = fltarr(ndate,nvar)
  kdry  = fltarr(ndate,nvar)
  ksed  = fltarr(ndate,nvar)

  printf, lun, ndate, nvar

  for iy = 0, ny-1 do begin

   idate = iy*12
   date = year[iy]+['01', '12']
   print, date
   for ivar = 0, nvar-1 do begin
    ctlfile_ = ctlfile
    lifetime, ctlfile_, varwant[ivar], date, $
              lon, lat, tauOut, kscav_, kwet_, ksed_, kdry_, resolution=resolution, gocart=gocart
    tau[idate:idate+11,ivar] = tauOut
    kscav[idate:idate+11,ivar] = kscav_
    ksed[idate:idate+11,ivar]  = ksed_
    kwet[idate:idate+11,ivar]  = kwet_
    kdry[idate:idate+11,ivar]  = kdry_


   endfor

   for it = 0, 11 do begin
    mm = strcompress(string(it+1),/rem)
    if(fix(mm) lt 10) then mm = '0'+mm
    printf, lun, ''
    printf, lun, expid, ' ', year[iy]+mm
    printf, lun, 'spec:   tau:       ksca:        kwet:         ksed:       kdry:'
    for ivar = 0, nvar-1 do begin
     printf, lun, varwant[ivar], tau[idate+it,ivar], $
             kscav[idate+it,ivar], kwet[idate+it,ivar], $
             ksed[idate+it,ivar], kdry[idate+it,ivar]
    endfor
   endfor

  endfor

  free_lun, lun

end

