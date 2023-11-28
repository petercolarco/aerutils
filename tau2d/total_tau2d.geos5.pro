; The tau2d calculator returns a copy of all the variables in
; the chem bundle now turned into optical thickness.
; This is a lot more data than is needed for most applications,
; where maybe what is really desired is simply the sum of the 
; component AOTs.
; This little procedure can be modified to sum all those fields
; and save then in a separate file.

  expid = 'd5_arctas_02'
  filedir  = '/misc/prc10/colarco/arctas/d5_arctas/ARCTAS_REPLAY/tau/'

  filehead = expid+'.inst2d_ext_x.'

  yyyy = ['2008']
  mm   = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd   = ['31','28','31','30','31','30','31','31','30','31','30','31']
  hh   = ['00','06','12','18']

  for iff = 0, n_elements(filehead)-1 do begin

  for iy = 0, n_elements(yyyy)-1 do begin
   for im = 5, 6 do begin

    nday = fix(nd[im])
    if(im eq 1 and (fix(yyyy[iy]) eq 2000 or fix(yyyy[iy]) eq 2004 or $
                    fix(yyyy[iy]) eq 2008 )) then nday = 29

    for id = 0, nday-1 do begin

    dd = strcompress(string(id+1),/rem)
    if(fix(dd) lt 10) then dd = '0'+dd

    for ih = 0, 3 do begin

    filewant = filedir+'Y'+yyyy[iy]+'/M'+mm[im]+'/'+$
                filehead[iff]+yyyy[iy]+mm[im]+dd+'_'+hh[ih]+'00z.hdf'
    result = file_search(filewant)
    if(result ne '') then begin

;   Read the monthly averaged file
;    varwant = ['du001','du002','du003','du004','du005', $
;               'ss001','ss002','ss003','ss004','ss005']
    varwant = ['du001','du002','du003','du004','du005']
    ga_getvar, filewant, varwant, varout1, $
     lon=lon, lat=lat, lev=lev

    varwant = ['so4','bcphilic','bcphobic','ocphilic','ocphobic']
    ga_getvar, filewant, varwant, varout2, $
     lon=lon, lat=lat, lev=lev

;   compose the sum
    varout = varout1+varout2

    nx = n_elements(lon)
    ny = n_elements(lat)
    dx = 360./float(nx)
    dy = 180./float(ny-1)
    nt = 1
    nlev = n_elements(lev)
    date = yyyy[iy]+mm[im]+dd+hh[ih]

;   Screen out the missing values
    a = where(varout gt 1e14)
    if(a[0] ne -1) then varout[a] = 1.e15
    a = where(varout2 gt 1e14)
    if(a[0] ne -1) then varout2[a] = 1.e15

;   Write to a new file
    write_aot, filedir, filehead[iff]+'total', nx, ny, dx, dy, nt, nlev, date, $
                 lon, lat, lev, varout, /shave, resolution = 'd'
    write_aot, filedir, filehead[iff]+'fineaot', nx, ny, dx, dy, nt, nlev, date, $
                 lon, lat, lev, varout2, /shave, resolution = 'd'


    endif

    endfor ; ih

    endfor  ; iday

   endfor
  endfor

  endfor

end
