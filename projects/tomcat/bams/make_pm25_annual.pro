  pro readit, type, pm25, nx, ny, nt, lon, lat, nn, aod=aod, cloud=cloud

; Get the true pm25
  filetemplate = type+'.pm25.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
; only need read one per day because it gets all hours
  filename = filename[where(nhms eq '000000')]
  nd = n_elements(filename)

; Get the AOD and cloud if asked for
  if(keyword_set(aod)) then begin
   filetemplate = type+'.ddf'
   ga_times, filetemplate, nymd, nhms, template=template
   filenamea=strtemplate(template,nymd,nhms)
;  only need read one per day because it gets all hours
   filenamea = filenamea[where(nhms eq '000000')]
  endif
  if(keyword_set(cloud)) then begin
   filetemplate = type+'.cldtot.ddf'
   ga_times, filetemplate, nymd, nhms, template=template
   filenamec=strtemplate(template,nymd,nhms)
;  only need read one per day because it gets all hours
   filenamec = filenamec[where(nhms eq '000000')]
  endif

; Get the first file
   nc4readvar, filename[0], 'pm25',pm25, lon=lon, lat=lat
   if(keyword_set(aod)) then nc4readvar, filenamea[0], 'totexttau', aod
   if(keyword_set(cloud)) then nc4readvar, filenamec[0], 'cldtot', cld
   nx = n_elements(lon)
   ny = n_elements(lat)
   nt = 24
   a = where(pm25 gt 1e14)
   if(keyword_set(aod)) then a = where(pm25 gt 1e14 or aod lt 0.1)
   if(keyword_set(cloud)) then a = where(pm25 gt 1e14 or cld gt 0.8)
   if(keyword_set(cloud)and keyword_set(aod)) then $
     a = where(pm25 gt 1e14 or cld gt 0.8 or aod lt 0.1)
   if(a[0] ne -1) then pm25[a] = 0.
   nn = make_array(n_elements(lon), n_elements(lat), 24, val=1)
   if(a[0] ne -1) then nn[a] = 0

;  Get the later files
   for ifile = 1, nd-1 do begin
    print, filename[ifile]
    nc4readvar, filename[ifile], 'pm25',pm25_
    if(keyword_set(aod)) then nc4readvar, filenamea[ifile], 'totexttau', aod
    if(keyword_set(cloud)) then nc4readvar, filenamec[ifile], 'cldtot', cld
    a = where(pm25_ gt 1e14)
    if(keyword_set(aod)) then a = where(pm25 gt 1e14 or aod lt 0.1)
    if(keyword_set(cloud)) then a = where(pm25 gt 1e14 or cld gt 0.8)
    if(keyword_set(cloud)and keyword_set(aod)) then $
      a = where(pm25 gt 1e14 or cld gt 0.8 or aod lt 0.1)
    if(a[0] ne -1) then pm25_[a] = 0.
    b = where(pm25_ gt 0)
    pm25 = pm25+pm25_
    if(b[0] ne -1) then nn[b] = nn[b]+1
   endfor

  end

  pro make_pm25_annual, type_, aod=aod, cloud=cloud

  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]

  type = type_
; special case of tomcata
  if(strmid(type_,0,7) eq 'tomcata') then begin
   type = 'tomcat1.'+strmid(type_,8,5)
   readit, type, pm25, nx, ny, nt, lon, lat, nn, aod=aod, cloud=cloud

   type = 'tomcat2.'+strmid(type_,8,5)
   readit, type, pm25_, nx, ny, nt, lon, lat, nn_, aod=aod, cloud=cloud
   pm25 = pm25+pm25_
   nn = nn+nn_

   type = 'tomcat3.'+strmid(type_,8,5)
   readit, type, pm25_3, nx, ny, nt, lon, lat, nn_3, aod=aod, cloud=cloud
   pm25 = pm25+pm25_
   nn = nn+nn_

   type = 'tomcat4.'+strmid(type_,8,5)
   readit, type, pm25_4, nx, ny, nt, lon, lat, nn_4, aod=aod, cloud=cloud
   pm25 = pm25+pm25_
   nn = nn+nn_

  endif else begin
   readit, type, pm25, nx, ny, nt, lon, lat, nn, aod=aod, cloud=cloud
  endelse

;  Do the aggregation
   a = where(nn gt 0)
   pm25[a] = pm25[a]/nn[a] ; daily mean cycle
   b = where(nn eq 0)
   pm25[b] = !values.f_nan
   fileout = 'pm25_annual.'+type_+'.2014'
   if(keyword_set(aod)) then fileout = fileout+'.aod'
   if(keyword_set(cloud)) then fileout = fileout+'.cloud'
   save_diurnal_nc, fileout, nx, ny, nt, $
                    lon, lat, pm25, 'pm25', nn


end

make_pm25_annual, 'full', /aod, /cloud
make_pm25_annual, 'tomcat1.450km', /aod, /cloud
make_pm25_annual, 'tomcat1.nadir', /aod, /cloud
make_pm25_annual, 'tomcat2.450km', /aod, /cloud
make_pm25_annual, 'tomcat2.nadir', /aod, /cloud
make_pm25_annual, 'tomcat3.450km', /aod, /cloud
make_pm25_annual, 'tomcat3.nadir', /aod, /cloud
make_pm25_annual, 'tomcat4.450km', /aod, /cloud
make_pm25_annual, 'tomcat4.nadir', /aod, /cloud
make_pm25_annual, 'tomcata.450km', /aod, /cloud
make_pm25_annual, 'tomcata.nadir', /aod, /cloud

end
