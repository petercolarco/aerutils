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

  ofiles = './nop/'+['OMI-Aura_L2-OMAERUV_2007m0605t0056-o15360_v003-2015m0918t202921.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t0235-o15361_v003-2015m0918t203509.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t0414-o15362_v003-2015m0918t203414.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t0552-o15363_v003-2015m0918t203359.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t0731-o15364_v003-2015m0918t203217.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t0910-o15365_v003-2015m0918t203431.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t1049-o15366_v003-2015m0918t203635.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t1228-o15367_v003-2015m0918t203336.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t1407-o15368_v003-2015m0918t203128.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t1546-o15369_v003-2015m0918t203321.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t1725-o15370_v003-2015m0918t203346.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t1904-o15371_v003-2015m0918t203336.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t2042-o15372_v003-2015m0918t203314.vl_rad.he5', $
           'OMI-Aura_L2-OMAERUV_2007m0605t2221-o15373_v003-2015m0918t203315.vl_rad.he5' ]


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
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prs_    = h5d_read(var_id)
    prs_    = reform(prs_,nxy)
    h5f_close, file_id

    file_id = h5f_open(ofiles[ifile])
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prx_    = h5d_read(var_id)
    prx_    = reform(prx_,nxy)
    h5f_close, file_id

;   Difference
    prs_ = prs_-prx_

    if(ifile eq 0) then begin
     prs = prs_
     lon = lon_
     lat = lat_
    endif else begin
     prs = [prs,prs_]
     lon = [lon,lon_]
     lat = [lat,lat_]
    endelse
  endfor

  a = where(prs gt -1e5 and prs lt 1e5)
  prs = prs[a]
  lon = lon[a]
  lat = lat[a]
  nxy = n_elements(prs)

; Now set up a plot
  set_plot, 'ps'
  device, file='pressure_diff.ps', xsize=16, ysize=12, xoff=.5, yoff=.5, /color, /helvetica
  !p.font=0
  loadct, 66
  p0 = 0
  p1 = 0

  map_set, p0, p1, /noborder, /robinson, /iso, /noerase

; Condition the variable for plotting
  a = where(prs lt -50)
  prs[a] = -50.
  a = where(prs gt 50.)
  prs[a] = 50.
  prs = prs+50.
  prs = prs/100.*254
  usersym, [-1,1,1,-1,-1]*.1, [-1,-1,1,1,-1]*.1, /fill
  for ixy = 0, nxy-1 do begin
   plots, lon[ixy], lat[ixy], color=prs[ixy], psym=8
  endfor
  map_continents, color=0, thick=3
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noborder, /robinson, /iso, /noerase, $
           /horizon, /grid, glinestyle=0, color=0, glinethick=2

  labels = ['-50','0','50']
  makekey, .1, .05, .8, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder


  device, /close

end