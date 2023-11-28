; Do this for the double sampling with the specified other sample:
  dual = 'ss450.750km.ddf'

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

  files =  ['gpm045.750km.ddf', $
           'gpm.750km.ddf', 'gpm050.750km.ddf', $
           'gpm055.750km.ddf']

  for ifile = 0, n_elements(files)-1 do begin
  file = files[ifile]

; Now we're going to read a time series and accumulate the
; daily area covered for one of our samples
  filetemplate = file
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)  
  a = where(nymd gt '20140532' and nymd lt '20141131' and nhms eq '000000')
  filename = filename[a]

; Get the dual filenames
  ga_times, dual, nymd, nhms, template=template
  filename_=strtemplate(template,nymd,nhms)  
  a = where(nymd gt '20140532' and nymd lt '20141131' and nhms eq '000000')
  filename_ = filename_[a]


; Daily area coverage
  nt = n_elements(a)
  avisit = fltarr(9,nt)

; Now loop over every day and read a mask
  for it = 0, nt-1 do begin
   print, filename[it]
   nc4readvar, filename[it], 'totexttau', gpm, wantlon=lonrange, wantlat=latrange, lon=lon, lat=lat
   nc4readvar, filename_[it], 'totexttau', gpm_, wantlon=lonrange, wantlat=latrange, lon=lon, lat=lat
   visit = intarr(n_elements(lon),n_elements(lat))
   visit3 = intarr(n_elements(lon)*n_elements(lat),8)
   visit[*,*] = 0
   for iit = 0, 23 do begin
    ij = iit/3
    a = where(gpm[*,*,iit] lt 1e14 or gpm_[*,*,iit] lt 1e14)
    if(a[0] ne -1) then visit[a] = 1
    if(a[0] ne -1) then visit3[a,ij] = 1
   endfor
   for ij = 0, 7 do begin
    a = where(visit3[*,ij] eq 1)
    if(a[0] ne -1) then avisit[ij,it] = total(area[a])
   endfor
   a = where(visit eq 1)
   if(a[0] ne -1) then avisit[8,it] = total(area[where(visit eq 1)])
  endfor

; Write to a file
  openw, lun, 'hurricane_region.'+filetemplate+'.'+dual+'.txt', /get
  printf, lun, total(area)
  printf, lun, avisit, format='(9e11.4)'
  free_lun, lun

  endfor

end
