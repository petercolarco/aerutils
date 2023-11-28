; December 2012
; Read the monthly AOT
; If a sub-sample is requested, optional parameters will mask on the
; full swath.
; If a set of regional parameters is presented, will average over the
; regions and optionally return regional values.

; Exclude means return the full swath *excluding* points where the
; sample has finite values

; Inverse (which requires exclude) means return the full swath *only*
; where the sample has finite values 

; If keyword "num" is set then just withdraw the number of retrievals

  pro read_monthly_model, model, sample, yyyy, mm, aotsat, res=res, exclude=exclude, inverse=inverse, $
                     lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, reg_std=reg_std

  if(not(keyword_set(res))) then res = 'd'
  area, x, y, nx, ny, dx, dy, area, grid = res

  samplestr = '.'+sample

  satstr = ''
  if(model eq 'c1000d') then satstr = 'Nature Run'
  if(model eq 'dR_F25b18') then satstr = 'Replay'
  if(model eq 'cR_F25b18') then satstr = 'Replay'
  if(model eq 'F25b18') then satstr = 'Replay'
  if(model eq 'dR_MERRA-AA-r2') then satstr = 'MERRAero'
  if(satstr eq '') then stop

  if(model eq 'c1000d') then modeldir = '/Volumes/bender/prc15/colarco/'+model
  if(model eq 'dR_F25b18') then modeldir = '/Users/pcolarco/data/'+model+'/inst2d_hwl_x/Y%y4/M%m2/'
  if(model eq 'F25b18') then modeldir = '/Users/pcolarco/data/'+model+'/inst2d_hwl_x/Y%y4/M%m2/'
  if(model eq 'cR_F25b18') then modeldir = '/Users/pcolarco/data/'+model+'/inst2d_hwl_x/Y%y4/M%m2/'
  if(model eq 'dR_MERRA-AA-r2') then modeldir = '/Users/pcolarco/data/'+model+'/inst2d_hwl_x/Y%y4/M%m2/'

  nymd = yyyy+mm+'15'
  nhms = '120000'
  yyyymm = string(nymd/100L,format='(i6)')
  yyyy   = string(nymd/10000L,format='(i4)')
  if(not(keyword_set(geolimits))) then geolimits = [-90,-180,90,180]
  varwant = ['totexttau']
  
; Read the land and ocean AOT for the requested sample
  filetemplate = modeldir +'/'+ model + '.tinst_2d_wms_chem_Lx.totexttau'+samplestr+'.%y4%m2.nc4'
  if(model eq 'c1000d') then filetemplate = modeldir +'/'+ model + '.tinst_2d_wms_chem_Lx.totexttau'+samplestr+'.%y4%m2.nc4'
  if(model eq 'dR_F25b18') then filetemplate = modeldir +'/'+ model + '.inst2d_hwl_x'+samplestr+'.%y4%m2.nc4'
  if(model eq 'cR_F25b18') then filetemplate = modeldir +'/'+ model + '.inst2d_hwl_x'+samplestr+'.%y4%m2.nc4'
  if(model eq 'F25b18') then filetemplate = modeldir +'/'+ model + '.inst2d_hwl_x'+samplestr+'.%y4%m2.nc4'
  if(model eq 'dR_MERRA-AA-r2') then filetemplate = modeldir +'/'+ model + '.inst2d_hwl_x'+samplestr+'.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aoto, /sum, lon=lon, lat=lat, lev=lev
  aotl = aoto

  a= where(aoto ge 1e14)
  aoto[a] = !values.f_nan
  a= where(aotl ge 1e14)
  aotl[a] = !values.f_nan

; --------------------------------------------------------------------
; Note that at the moment to get either the PDF or the "inverse" you
; must set the "exclude" keyword.  That's what gets into this
; logic to read the full swath regardless of the sample requested.

  if(keyword_set(exclude)) then begin

  template = 0
  sum = 1
  if(keyword_set(pdf)) then numstr = '.pdf'
  if(keyword_set(pdf)) then varwant = ['aotpdf']
  if(keyword_set(pdf)) then template = 1
  if(keyword_set(pdf)) then sum = 0

  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_ocn.aero_tc8_051.qast_qawt'+numstr+'.%y4'+season+'.nc4'
  if(clim) then $
   filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/'+ $
                  satid+'_L2_ocn.aero_tc8_051.qast_'+filet+numstr+'.clim'+season+'.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aoto_, sum=sum, template=template, lon=lon, lat=lat, lev=lev
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_lnd.aero_tc8_051.qast3_qawt'+numstr+'.%y4'+season+'.nc4'
  if(clim) then $
   filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/'+ $
                  satid+'_L2_lnd.aero_tc8_051.qast3_'+filet+numstr+'.clim'+season+'.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotl_, sum=sum, template=template, lon=lon, lat=lat, lev=lev

  a= where(aoto_ ge 1e14)
  aoto_[a] = !values.f_nan
  a= where(aotl_ ge 1e14)
  aotl_[a] = !values.f_nan

  
  if(keyword_set(pdf)) then begin
   npdf = n_elements(aotl_[0,0,*])
   aoto_ = reform(aoto_,nx*ny*1L,npdf)
   aotl_ = reform(aotl_,nx*ny*1L,npdf)
   for ipdf = 0, npdf-1 do begin
    if(keyword_set(inverse)) then begin
     aoto_[where(finite(aoto) ne 1),ipdf] = !values.f_nan
     aotl_[where(finite(aotl) ne 1),ipdf] = !values.f_nan
    endif else begin
     aoto_[where(finite(aoto) eq 1),ipdf] = !values.f_nan
     aotl_[where(finite(aotl) eq 1),ipdf] = !values.f_nan
    endelse
   endfor
;  Now average over PDF to get a grid cell mean consistent with
;  non-PDF method
   aotbin = findgen(51)*.05
   aoto = make_array(nx,ny,val=!values.f_nan)
   aotl = make_array(nx,ny,val=!values.f_nan)
   aoto_ = reform(aoto_,nx,ny,npdf)
   aotl_ = reform(aotl_,nx,ny,npdf)
   for ix = 0, nx-1 do begin
    for iy = 0, ny-1 do begin
     if(total(aoto_[ix,iy,*]) ne 0) then aoto[ix,iy] = total(aotbin*aoto_[ix,iy,*]) / total(aoto_[ix,iy,*])
     if(total(aotl_[ix,iy,*]) ne 0) then aotl[ix,iy] = total(aotbin*aotl_[ix,iy,*]) / total(aotl_[ix,iy,*])
    endfor
   endfor
   aoto_ = reform(aoto_,nx*ny*1L,npdf)
   aotl_ = reform(aotl_,nx*ny*1L,npdf)
  endif else begin
   npdf = 1
   if(keyword_set(inverse)) then begin
    aoto_[where(finite(aoto) ne 1)] = !values.f_nan
    aotl_[where(finite(aotl) ne 1)] = !values.f_nan
   endif else begin
    aoto_[where(finite(aoto) eq 1)] = !values.f_nan
    aotl_[where(finite(aotl) eq 1)] = !values.f_nan
   endelse
   aoto = aoto_
   aotl = aotl_
  endelse

  endif

  aotsat = aotl

  aotsat[where(finite(aoto) eq 1)] = aoto[where(finite(aoto) eq 1)]

; Now check to see if averaging regions are provided
  if(keyword_set(lon0)) then begin

  nreg = n_elements(lon0)

; If doing PDF then handle differently
npdf = 1
  if(npdf gt 1) then begin
   reg_aot = fltarr(nreg,npdf)
   reg_std = fltarr(nreg,npdf)
   for ireg = 0, nreg-1 do begin
    a = where(lon ge lon0[ireg] and lon le lon1[ireg])
    b = where(lat ge lat0[ireg] and lat le lat1[ireg])
    for ipdf = 0, npdf-1 do begin
     btmp = aotsat[a,*,ipdf]
     btmp = btmp[*,b]
     reg_aot[ireg,ipdf] = total(btmp,/nan)
     reg_std[ireg,ipdf] = stddev(btmp,/nan)
    endfor
   endfor
  endif else begin
   reg_aot = fltarr(nreg)
   reg_std = fltarr(nreg)
   for ireg = 0, nreg-1 do begin
    a = where(lon ge lon0[ireg] and lon le lon1[ireg])
    b = where(lat ge lat0[ireg] and lat le lat1[ireg])
    atmp = area[a,*]
    atmp = atmp[*,b]
    btmp = aotsat[a,*]
    btmp = btmp[*,b]
    reg_aot[ireg] = aave(btmp,atmp,/nan)
    reg_std[ireg] = stddev(btmp,/nan)
   endfor
  endelse

  endif
end
