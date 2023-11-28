  pro make_aod_annual, type

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]

; Get the true aod
  filetemplate = type+'.aod.hourly.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
; only need read one per day because it gets all hours
  filename = filename[where(nhms eq '000000')]
  nd = n_elements(filename)

; Get the first file
   nc4readvar, filename[0], 'totexttau',aod, lon=lon, lat=lat
   print, filename[0]
   check, aod
   nx = n_elements(lon)
   ny = n_elements(lat)
   nt = 24
   a = where(aod gt 1e14)
   if(a[0] ne -1) then aod[a] = 0.
   nn = make_array(n_elements(lon), n_elements(lat), 24, val=1)
   if(a[0] ne -1) then nn[a] = 0

;  Get the later files
   for ifile = 1, nd-1 do begin
    nc4readvar, filename[ifile], 'totexttau',aod_
    print, filename[ifile]
    check, aod
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
   save_diurnal_nc, 'aod_annual.'+type+'.2014', nx, ny, nt, $
                    lon, lat, aod, 'aod', nn


end

make_aod_annual, 'nadir040'
make_aod_annual, 'wide040'
stop
make_aod_annual, 'full'
make_aod_annual, 'nadir045'
make_aod_annual, 'nadir050'
make_aod_annual, 'nadir055'
make_aod_annual, 'nadir060'
make_aod_annual, 'nadir065'
make_aod_annual, 'wide045'
make_aod_annual, 'wide050'
make_aod_annual, 'wide055'
make_aod_annual, 'wide060'
make_aod_annual, 'wide065'

end
