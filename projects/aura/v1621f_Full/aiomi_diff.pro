; Colarco, October 2015
; Read in the synthetic OMI data and plot the AOD at 388 nm for
; a day

; Files
  files  = file_search('/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/', $
                       'OMI-Aura_L2-OMAERUV_2007m0605*vl_rad.geos5_pressure.he5')

  ofiles = file_search('/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/PGEO/', $
                       '2007m0605*nc4')

; Read the files and get a variable
  for ifile = 0, n_elements(files)-1 do begin

;   Get the level 2 for the lat/lon
    file_id = h5f_open(files[ifile])
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Longitude')
    lon_    = h5d_read(var_id)
    nxy     = n_elements(lon_)
    lon_    = reform(lon_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/Latitude')
    lat_    = h5d_read(var_id)
    sz      = size(lat_)
    nx      = sz[1]
    ny      = sz[2]
    lat_    = reform(lat_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/UVAerosolIndex')
    rex_    = h5d_read(var_id)
    rex_    = reform(rex_,nxy)
    h5f_close, file_id

;   Get the OMI returned values and map
    res_    = make_array(nx,ny,val=-1.e30)
    cdfid = ncdf_open(ofiles[ifile])
    id    = ncdf_varid(cdfid,'ai')
    ncdf_varget, cdfid, id, res_
    ncdf_close, cdfid
    res_ = reform(res_,nxy)

    if(ifile eq 0) then begin
     rex = rex_
     res = res_
     lon = lon_
     lat = lat_
    endif else begin
     rex = [rex,rex_]
     res = [res,res_]
     lon = [lon,lon_]
     lat = [lat,lat_]
    endelse
  endfor

; Now set up a plot
  set_plot, 'ps'
  device, file='aiomi_diff.ps', xsize=16, ysize=12, xoff=.5, yoff=.5, /color, /helvetica
  !p.font=0
  loadct, 66
  p0 = 0
  p1 = 0

  a = where(res gt -100 and rex gt -100)
  var = rex[a]-res[a]
  lon = lon[a]
  lat = lat[a]
  nxy = n_elements(a)

  var = var+0.25
  a = where(var lt 0)
  var[a] = 0.
  a = where(var gt 0.5)
  if(a[0] ne -1) then var[a] = 0.5
  var = var/.5*254

  map_set, p0, p1, /noborder, /robinson, /iso, /noerase
  usersym, [-1,1,1,-1,-1]*.1, [-1,-1,1,1,-1]*.1, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon[ixy], lat[ixy], color=var[ixy], psym=8
  endfor
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noborder, /robinson, /iso, /noerase, $
           /horizon, /grid, glinestyle=0, color=0, glinethick=2

  labels = ['<-0.25','0','>0.25']
  makekey, .1, .05, .8, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder


  device, /close

end
