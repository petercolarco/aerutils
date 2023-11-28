; Colarco, October 2015
; Read in the synthetic OMI data and plot the AOD at 388 nm for
; a day

; Files
  files  = file_search('/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/', $
                       'OMI-Aura_L2-OMAERUV_2007m06*vl_rad.geos5_pressure.he5')

  ofilesd = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full_returned/POMI/'

  pfilesd = '/misc/prc14/colarco/aura/dR_MERRA-AA-r2-v1621f_Full/'


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

;   Get the pressure filename
    str1 = strsplit(files[ifile],'/',/extract,count=n)
    str2 = strsplit(str1[n-1],'.',/extract)
    filet = str2[0]
    filen = pfilesd+filet+'.vl_rad.he5'
    result = file_search(filen)
    if(result eq '') then goto, jump1

    file_id = h5f_open(filen)
    var_id  = h5d_open(file_id,'HDFEOS/SWATHS/Aerosol NearUV Swath/Geolocation Fields/TerrainPressure')
    prs_    = h5d_read(var_id)
;print, files[ifile], n_elements(prs_), nxy
    prs_    = reform(prs_,nxy)
    h5f_close, file_id

;   Get the OMI returned values and map
    filet = str2[0]
    filen = ofilesd+strmid(filet,20,21)+'_OMAERUVx_Outputs.nc4'
    result = file_search(filen)
    if(result eq '') then goto, jump1
    cdfid = ncdf_open(filen)
    id    = ncdf_varid(cdfid,'ai')
    ncdf_varget, cdfid, id, res_
    ncdf_close, cdfid
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

    goto, jump2
jump1: print, 'missing: ', filen
jump2:
  endfor

; Now set up a plot
  set_plot, 'ps'
  device, file='aiomi_diff.scatter.nop.ps', xsize=16, ysize=12, xoff=.5, yoff=.5, /color, /helvetica
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
print, n_elements(var), n_elements(a), float(n_elements(a))/float(n_elements(var))
  labels = ['-50','0','50']
  makekey, .2, .1, .65, .05, 0, -0.035, $
           charsize=.75, align=.5, colors=findgen(254), $
           labels=labels, /noborder
  loadct, 0
  xyouts, .525, .025, /normal, 'Pressure Difference (MERRAero - OMAERUV) [hPa]', $
   charsize=.75, align=.5

  device, /close

end
