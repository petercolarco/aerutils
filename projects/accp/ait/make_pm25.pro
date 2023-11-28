  pro make_pm25, type

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]

; Get the true pm25
  for im = 0, 11 do begin
   filetemplate = type+'.pm25.hourly.ddf'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
;  only need read one per day because it gets all hours
   filename = filename[where(nhms eq '000000' and $
                             strmid(nymd,4,2) eq mm[im]) ]

; Get the first file
   nc4readvar, filename[0], 'pm25',pm25, lon=lon, lat=lat
   nx = n_elements(lon)
   ny = n_elements(lat)
   nt = 24
   a = where(pm25 gt 1e14)
   if(a[0] ne -1) then pm25[a] = 0.
   nn = make_array(n_elements(lon), n_elements(lat), 24, val=1)
   if(a[0] ne -1) then nn[a] = 0

;  Get the later files
   for ifile = 1, nd[im]-1 do begin
    print, filename[ifile]
    nc4readvar, filename[ifile], 'pm25',pm25_
    a = where(pm25_ gt 1e14)
    b = where(pm25_ lt 1e14)
    if(a[0] ne -1) then pm25_[a] = 0.
    pm25 = pm25+pm25_
    if(b[0] ne -1) then nn[b] = nn[b]+1
   endfor

;  Do the aggregation
   a = where(nn gt 0)
   pm25[a] = pm25[a]/nn[a] ; daily mean cycle
   b = where(nn eq 0)
   pm25[b] = !values.f_nan
   save_diurnal_nc, 'pm25.'+type+'.2014'+mm[im], nx, ny, nt, $
                    lon, lat, pm25, 'pm25', nn
  endfor

end

make_pm25, 'full'
make_pm25, 'nadir045'
make_pm25, 'nadir050'
make_pm25, 'nadir055'
make_pm25, 'nadir060'
make_pm25, 'nadir065'
make_pm25, 'wide045'
make_pm25, 'wide050'
make_pm25, 'wide055'
make_pm25, 'wide060'
make_pm25, 'wide065'

end
