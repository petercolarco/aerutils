  pro make_aod, type

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]

; Get the true aod
  for im = 0, 11 do begin
   filetemplate = type+'.aod.hourly.ddf'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
;  only need read one per day because it gets all hours
   filename = filename[where(nhms eq '000000' and $
                             strmid(nymd,4,2) eq mm[im]) ]

; Get the first file
   nc4readvar, filename[0], 'totexttau',aod, lon=lon, lat=lat
   nx = n_elements(lon)
   ny = n_elements(lat)
   nt = 24
   a = where(aod gt 1e14)
   if(a[0] ne -1) then aod[a] = 0.
   nn = make_array(n_elements(lon), n_elements(lat), 24, val=1)
   if(a[0] ne -1) then nn[a] = 0

;  Get the later files
   for ifile = 1, nd[im]-1 do begin
    print, filename[ifile]
    nc4readvar, filename[ifile], 'totexttau',aod_
    a = where(aod_ gt 1e14)
    b = where(aod_ lt 1e14)
    if(a[0] ne -1) then aod_[a] = 0.
    aod = aod+aod_
    if(b[0] ne -1) then nn[b] = nn[b]+1
   endfor

;  Do the aggregation
   a = where(nn gt 0)
   aod[a] = aod[a]/nn[a] ; daily mean cycle
   b = where(nn eq 0)
   aod[b] = !values.f_nan
   save_diurnal_nc, 'aod.'+type+'.2014'+mm[im], nx, ny, nt, $
                    lon, lat, aod, 'aod', nn
  endfor

end

make_aod, 'full'
make_aod, 'nadir045'
make_aod, 'nadir050'
make_aod, 'nadir055'
;make_aod, 'nadir060'
make_aod, 'nadir065'
make_aod, 'wide045'
make_aod, 'wide050'
make_aod, 'wide055'
;make_aod, 'wide060'
make_aod, 'wide065'

end
