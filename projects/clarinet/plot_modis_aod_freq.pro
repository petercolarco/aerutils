  mm = '07'

  thresh = .25

  mod04 = '/science/modis/data/Level3/MOD04/hourly/d/GRITAS/'
  myd04 = '/science/modis/data/Level3/MYD04/hourly/d/GRITAS/'

; Get the files
  mod04f = file_search(mod04,'*M'+mm+'/*ocn.aero_tc8_006.qast.201*')
  myd04f = file_search(myd04,'*M'+mm+'/*ocn.aero_tc8_006.qast.201*')

; Get the aot
  nx = 576
  ny = 361
  num = fltarr(nx,ny)
  tot = fltarr(nx,ny)
  nf = n_elements(mod04f)
  for i = 0, nf-1 do begin
   print, i+1, nf
   cdfid = ncdf_open(mod04f[i])
   id = ncdf_varid(cdfid,'aot')
   ncdf_varget, cdfid, id, aot
   ncdf_close, cdfid
   for it = 0, 23 do begin
    aot_ = aot[*,*,it]
    a = where(aot_ gt thresh and aot_ lt 100.)
    b = where(                   aot_ lt 100.)
    if(a[0] ne -1) then num[a] = num[a]+1.
    if(b[0] ne -1) then tot[b] = tot[b]+1.
   endfor
  endfor

  a = where(tot gt 0)
  fnum = num
  fnum[a] = num[a]/tot[a]
  contour, fnum, /fill, lev=findgen(10)*.1

end
