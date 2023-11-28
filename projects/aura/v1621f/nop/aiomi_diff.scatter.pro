; Colarco, October 2015
; Read in the synthetic OMI data and plot the AOD at 388 nm for
; a day

; Files
  files = '../'+ ['OMI-Aura_L2-OMAERUV_2007m0605t0056-o15360_v003-2015m0918t202921.vl_rad.geos5_pressure.he5', $
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

  ofiles = ['2007m0605-o15360_POMI_Nov232015.nc', '2007m0605-o15361_POMI_Nov232015.nc', $
            '2007m0605-o15362_POMI_Nov232015.nc', '2007m0605-o15363_POMI_Nov232015.nc', $
            '2007m0605-o15364_POMI_Nov232015.nc', '2007m0605-o15365_POMI_Nov232015.nc', $
            '2007m0605-o15366_POMI_Nov232015.nc', '2007m0605-o15367_POMI_Nov232015.nc', $
            '2007m0605-o15368_POMI_Nov232015.nc', '2007m0605-o15369_POMI_Nov232015.nc', $
            '2007m0605-o15370_POMI_Nov232015.nc', '2007m0605-o15371_POMI_Nov232015.nc', $
            '2007m0605-o15372_POMI_Nov232015.nc', '2007m0605-o15373_POMI_Nov232015.nc' ]

  pfiles =['OMI-Aura_L2-OMAERUV_2007m0605t0056-o15360_v003-2015m0918t202921.vl_rad.he5', $
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
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Data Fields/UVAerosolIndex')
    rex_    = h5d_read(var_id)
    rex_    = reform(rex_,nxy)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prx_    = h5d_read(var_id)
    prx_    = reform(prx_,nxy)
    h5f_close, file_id

    file_id = h5f_open(pfiles[ifile])
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prs_    = h5d_read(var_id)
    prs_    = reform(prs_,nxy)
    h5f_close, file_id

;   Get the OMI returned values and map
    res_    = make_array(nx,ny,val=-1.e30)
    cdfid = ncdf_open(ofiles[ifile])
    id    = ncdf_varid(cdfid,'AI')
    ncdf_varget, cdfid, id, res_inp
    ncdf_close, cdfid
    res_[*,199:1399] = res_inp
    res_ = reform(res_,nxy)

    if(ifile eq 0) then begin
     rex = rex_
     res = res_
     prx = prx_
     prs = prs_
     lon = lon_
     lat = lat_
    endif else begin
     rex = [rex,rex_]
     res = [res,res_]
     prx = [prx,prx_]
     prs = [prs,prs_]
     lon = [lon,lon_]
     lat = [lat,lat_]
    endelse
  endfor

; Now set up a plot
  set_plot, 'ps'
  device, file='aiomi_diff.scatter.ps', xsize=16, ysize=12, xoff=.5, yoff=.5, /color, /helvetica
  !p.font=0
  loadct, 0
  p0 = 0
  p1 = 0

  a = where(res gt -100 and rex gt -100)
  var = rex[a]-res[a]
  lon = lon[a]
  lat = lat[a]
  nxy = n_elements(a)
  rex = rex[a]
  prs = prx[a]-prs[a]

; Condition the variable for plotting
  a = where(prs lt -50)
  prs[a] = -50.
  a = where(prs gt 50.)
  prs[a] = 50.
  prs = prs+50.
  prs = prs/100.*254

  plot, findgen(10), /nodata, $
   position=[.1,.25,.95,.95], $
   xrange=[-1,5], yrange=[-2,2], $
   xtitle='MERRAero Aerosol Index', $
   ytitle='!9D!3AI (MERRAero-OMAERUV!Dp!N)'

  loadct, 74
  plots, rex, var, psym=3, color=prs, noclip=0
a = where(abs(var) gt 0.2)
print, n_elements(var), n_elements(a)
  labels = ['-50','0','50']
  makekey, .2, .1, .65, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder
  loadct, 0
  xyouts, .525, .025, /normal, 'Pressure Difference (MERRAero - OMAERUV) [hPa]', $
   charsize=.75, align=.5

  device, /close

end
