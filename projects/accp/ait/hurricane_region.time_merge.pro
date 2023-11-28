; Define a sampling box
  latrange = [10,35]
  lonrange = [-100,-40]

; Read a day to get full lon/lat for area coverage
  filename = '/misc/prc19/colarco/M2R12K/hourly/M2R12K.gpm.nodrag.1100km.pm.hourly.20140605.nc4'
  nc4readvar, filename, 'dusmass', gpm, lon=lon, lat=lat
; Get the grid area
  area, lon, lat, nx, ny, dx, dy, area

; Now reduce the area to the ranges
  a = where(lon ge lonrange[0] and lon le lonrange[1])
  b = where(lat ge latrange[0] and lat le latrange[1])
  area = area[a,*]
  area = area[*,b]

; Now we're going to read a time series and accumulate the
; daily area covered for one of our samples
  filetemplate = 'ss450.1100km.pm.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)  
  a = where(nymd gt '20140532' and nymd lt '20141131' and nhms eq '000000')
  filename = filename[a]
  filetemplate = 'gpm.1100km.pm.ddf'
  ga_times, filetemplate, nymd, nhms, template=template
  filename_=strtemplate(template,nymd,nhms)  
  a = where(nymd gt '20140532' and nymd lt '20141131' and nhms eq '000000')
  filename_ = filename_[a]

; Daily area coverage
  nt = n_elements(a)
  avisit = fltarr(nt)

; Now loop over every day and read a mask
  for it = 0, nt-1 do begin
   print, filename[it]
   nc4readvar, filename[it], 'dusmass', ss450, wantlon=lonrange, wantlat=latrange, lon=lon, lat=lat
   nc4readvar, filename_[it], 'dusmass', gpm, wantlon=lonrange, wantlat=latrange, lon=lon, lat=lat
   visit = intarr(n_elements(lon),n_elements(lat))
   visit[*,*] = 0
   for iit = 0, 23 do begin
    a = where(gpm[*,*,iit] lt 1e14 or ss450[*,*,iit] lt 1e14)
    if(a[0] ne -1) then visit[a] = 1
   endfor
   avisit[it] = total(area[where(visit eq 1)])
  endfor

; Write to a file
  openw, lun, 'hurricane_region.merge_1100km.txt', /get
  printf, lun, avisit
  free_lun, lun

end
