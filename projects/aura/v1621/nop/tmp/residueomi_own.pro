; Colarco, October 2015
; Read in the synthetic OMI data and plot the AOD at 388 nm for
; a day

; Files
  files = '../'+['2007m0605-o15360_POMI_Oct282015.nc', '2007m0605-o15361_POMI_Oct282015.nc', $
           '2007m0605-o15362_POMI_Oct282015.nc', '2007m0605-o15363_POMI_Oct282015.nc', $
           '2007m0605-o15364_POMI_Oct282015.nc', '2007m0605-o15365_POMI_Oct282015.nc', $
           '2007m0605-o15366_POMI_Oct282015.nc', '2007m0605-o15367_POMI_Oct282015.nc', $
           '2007m0605-o15368_POMI_Oct282015.nc', '2007m0605-o15369_POMI_Oct282015.nc', $
           '2007m0605-o15370_POMI_Oct282015.nc', '2007m0605-o15371_POMI_Oct282015.nc', $
           '2007m0605-o15372_POMI_Oct282015.nc', '2007m0605-o15373_POMI_Oct282015.nc' ]


; Read the files and get a variable
;  for ifile = 0, n_elements(files)-1 do begin
  for ifile = 7,8 do begin
print, files[ifile]

    cdfid = ncdf_open(files[ifile])
    id    = ncdf_varid(cdfid,'LAT')
    ncdf_varget, cdfid, id, lat_
    id    = ncdf_varid(cdfid,'LON')
    ncdf_varget, cdfid, id, lon_
    id    = ncdf_varid(cdfid,'RESIDUE')
    ncdf_varget, cdfid, id, res_
    ncdf_close, cdfid

;    if(ifile eq 0) then begin
    if(ifile eq 7) then begin
     res = res_
     lon = lon_
     lat = lat_
    endif else begin
     res = [res,res_]
     lon = [lon,lon_]
     lat = [lat,lat_]
    endelse
  endfor

; Now set up a plot
  set_plot, 'ps'
  device, file='residueomi_own.ps', xsize=16, ysize=12, xoff=.5, yoff=.5, /color, /helvetica
  !p.font=0
  loadct, 0
  p0 = 0
  p1 = 0

  map_set, p0, p1, /noborder, /robinson, /iso, /noerase
  nxy = n_elements(lon)
; plot negative RES
  a = where(res lt 0.0001 and res gt -100)
  res_ = res[a]
  lon_ = lon[a]
  lat_ = lat[a]
  nxy = n_elements(a)
  usersym, [-1,1,1,-1,-1]*.1, [-1,-1,1,1,-1]*.1, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon_[ixy], lat_[ixy], color=120, psym=8
  endfor
; plot positive RES
  loadct, 39
  a = where(res gt 0.0001)
  res = res[a]
  lon = lon[a]
  lat = lat[a]
  nxy = n_elements(a)
  a = where(res gt 3.)
  res[a] = 3.
  res = res/3.*254
  usersym, [-1,1,1,-1,-1]*.1, [-1,-1,1,1,-1]*.1, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon[ixy], lat[ixy], color=res[ixy], psym=8
  endfor
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noborder, /robinson, /iso, /noerase, $
           /horizon, /grid, glinestyle=0, color=0, glinethick=2

  labels = ['0','1','2','3']
  makekey, .1, .05, .8, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder


  device, /close

end
