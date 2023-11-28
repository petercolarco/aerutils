  pro make_preccon, type

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]

; Get the true preccon
  for im = 0, 11 do begin
   filetemplate = type+'.cloud.hourly.ddf'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
;  only need read one per day because it gets all hours
   filename = filename[where(nhms eq '000000' and $
                             strmid(nymd,4,2) eq mm[im]) ]

; Get the first file
   nc4readvar, filename[0], 'preccon',preccon, lon=lon, lat=lat
   nx = n_elements(lon)
   ny = n_elements(lat)
   nt = 24
   a = where(preccon gt 1e14)
   if(a[0] ne -1) then preccon[a] = 0.
   nn = make_array(n_elements(lon), n_elements(lat), 24, val=1)
   if(a[0] ne -1) then nn[a] = 0

;  Get the later files
   for ifile = 1, nd[im]-1 do begin
    print, filename[ifile]
    nc4readvar, filename[ifile], 'preccon',preccon_
    a = where(preccon_ gt 1e14)
    b = where(preccon_ lt 1e14)
    if(a[0] ne -1) then preccon_[a] = 0.
    preccon = preccon+preccon_
    if(b[0] ne -1) then nn[b] = nn[b]+1
   endfor

;  Do the aggregation
   a = where(nn gt 0)
   preccon[a] = preccon[a]/nn[a] ; daily mean cycle
   b = where(nn eq 0)
   preccon[b] = !values.f_nan
   save_diurnal_nc, 'preccon.'+type+'.2014'+mm[im], nx, ny, nt, $
                    lon, lat, preccon, 'preccon', nn
  endfor

end

make_preccon, 'full'
make_preccon, 'nadir045'
make_preccon, 'nadir050'
make_preccon, 'nadir055'
make_preccon, 'nadir060'
make_preccon, 'nadir065'
make_preccon, 'wide045'
make_preccon, 'wide050'
make_preccon, 'wide055'
make_preccon, 'wide060'
make_preccon, 'wide065'

end
