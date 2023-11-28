; Colarco, October 2015
; Read in the synthetic OMI data and plot the AOD at 388 nm for
; a day

; Files
  files = ['OMI-Aura_L2-OMAERUV_2007m0605t0056-o15360_v003-2015m0918t202921.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t0235-o15361_v003-2015m0918t203509.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t0414-o15362_v003-2015m0918t203414.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t0552-o15363_v003-2015m0918t203359.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t0731-o15364_v003-2015m0918t203217.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t0910-o15365_v003-2015m0918t203431.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t1049-o15366_v003-2015m0918t203635.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t1228-o15367_v003-2015m0918t203336.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2015m0918t203128.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t1546-o15369_v003-2015m0918t203321.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t1725-o15370_v003-2015m0918t203346.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t1904-o15371_v003-2015m0918t203336.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t2042-o15372_v003-2015m0918t203314.vl_rad.geos5_pressure.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t2221-o15373_v003-2015m0918t203315.vl_rad.geos5_pressure.he5' ]

  ofiles = ['2007m0605-o15360_julian156.nc', '2007m0605-o15361_julian156.nc', $
            '2007m0605-o15362_julian156.nc', '2007m0605-o15363_julian156.nc', $
            '2007m0605-o15364_julian156.nc', '2007m0605-o15365_julian156.nc', $
            '2007m0605-o15366_julian156.nc', '2007m0605-o15367_julian156.nc', $
            '2007m0605-o15368_julian156.nc', '2007m0605-o15369_julian156.nc', $
            '2007m0605-o15370_julian156.nc', '2007m0605-o15371_julian156.nc', $
            '2007m0605-o15372_julian156.nc', '2007m0605-o15373_julian156.nc' ]


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
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/MERRAero_AOT')
    aox_    = h5d_read(var_id)
    aox_    = reform(aox_[1,*,*],nxy)
    h5f_close, file_id

;   Get the OMI returned values and map
    aod_    = make_array(nx,ny,val=-1.e30)
    cdfid = ncdf_open(ofiles[ifile])
    id    = ncdf_varid(cdfid,'AOD388')
    ncdf_varget, cdfid, id, aod_inp
    ncdf_close, cdfid
    aod_[*,199:1399] = aod_inp
    aod_ = reform(aod_,nxy)

    if(ifile eq 0) then begin
     aox = aox_
     aod = aod_
     lon = lon_
     lat = lat_
    endif else begin
     aox = [aox,aox_]
     aod = [aod,aod_]
     lon = [lon,lon_]
     lat = [lat,lat_]
    endelse
  endfor

; Now set up a plot
  set_plot, 'ps'
  device, file='aodomi_diff.ps', xsize=16, ysize=12, xoff=.5, yoff=.5, /color, /helvetica
  !p.font=0
  loadct, 72
  p0 = 0
  p1 = 0

  a = where(aod gt -100 and aox gt -100)
  var = aox[a]-aod[a]
  lon = lon[a]
  lat = lat[a]
  nxy = n_elements(a)
stop
  var = var+1.
  a = where(var lt 0)
  var[a] = 0.
  a = where(var gt 2)
  if(a[0] ne -1) then var[a] = 2
  var = var/2.*254

  map_set, p0, p1, /noborder, /robinson, /iso, /noerase
  usersym, [-1,1,1,-1,-1]*.1, [-1,-1,1,1,-1]*.1, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon[ixy], lat[ixy], color=var[ixy], psym=8
  endfor

  labels = ['<-1','0','>1']
  makekey, .1, .05, .8, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder



  loadct, 0
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noborder, /robinson, /iso, /noerase, $
           /horizon, /grid, glinestyle=0, color=0, glinethick=2


  device, /close

end
