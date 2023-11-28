  pro make_preccon_annual, type

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]

; Get the true preccon
  filetemplate = type+'.cloud.hourly.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
; only need read one per day because it gets all hours
  filename = filename[where(nhms eq '000000')]
  nd = n_elements(filename)

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
   for ifile = 1, nd-1 do begin
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
   save_diurnal_nc, 'preccon_annual.'+type+'.2014', nx, ny, nt, $
                    lon, lat, preccon, 'preccon', nn


end

make_preccon_annual, 'wide040'
make_preccon_annual, 'nadir040'
stop
make_preccon_annual, 'full'
make_preccon_annual, 'nadir045'
make_preccon_annual, 'nadir050'
make_preccon_annual, 'nadir055'
make_preccon_annual, 'nadir060'
make_preccon_annual, 'nadir065'
make_preccon_annual, 'wide045'
make_preccon_annual, 'wide050'
make_preccon_annual, 'wide055'
make_preccon_annual, 'wide060'
make_preccon_annual, 'wide065'

end
