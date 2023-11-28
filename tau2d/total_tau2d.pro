; The tau2d calculator returns a copy of all the variables in
; the chem bundle now turned into optical thickness.
; This is a lot more data than is needed for most applications,
; where maybe what is really desired is simply the sum of the 
; component AOTs.
; This little procedure can be modified to sum all those fields
; and save then in a separate file.

  expid = 't003_c32'
  filedir  = '/output/colarco/'+expid+'/tau/'

  filehead = expid+['.tau2d.MISR.']

  yyyy = ['2000','2001','2002','2003','2004','2005','2006']
  mm   = ['01','02','03','04','05','06','07','08','09','10','11','12']

  for iff = 0, n_elements(filehead)-1 do begin

  for iy = 0, n_elements(yyyy)-1 do begin
   for im = 0, 11 do begin

    filewant = filedir+'Y'+yyyy[iy]+'/M'+mm[im]+'/'+$
                filehead[iff]+yyyy[iy]+mm[im]+'.hdf'

;   Read the monthly averaged file
    varwant = ['du001','du002','du003','du004','du005', $
               'ss001','ss002','ss003','ss004','ss005', $
               'so4','bcphilic','bcphobic','ocphilic','ocphobic']
    ga_getvar, filewant, varwant, varout, /sum, /save, ofile='tmp.nc', $
     lon=lon, lat=lat, lev=lev

    nx = n_elements(lon)
    ny = n_elements(lat)
    dx = lon[1]-lon[0]
    dy = lat[1]-lat[0]
    nt = 1
    nlev = n_elements(lev)
    date = yyyy[iy]+mm[im]

;   Screen out the missing values
    a = where(varout gt 1e14)
    if(a[0] ne -1) then varout[a] = 1.e15

;   Write to a new file
    write_aot, filedir, filehead[iff]+'total', nx, ny, dx, dy, nt, nlev, date, $
                 lon, lat, lev, varout, /h4zip, /geos4

   endfor
  endfor

  endfor

end
