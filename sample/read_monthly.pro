; Colarco
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

  pro read_monthly, satid, sample, yyyy, mm, aotsat, res=res, exclude=exclude, inverse=inverse, $
                    lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, reg_std=reg_std, num=num

  if(not(keyword_set(res))) then res = 'd'
  area, x, y, nx, ny, dx, dy, area, grid = res

  case sample of
   'supermisr' : sample_title = ' Super-MISR '
   'misr1'     : sample_title = ' MISR1 '
   'misr2'     : sample_title = ' MISR2 '
   'misr3'     : sample_title = ' MISR3 '
   'misr4'     : sample_title = ' MISR4 '
   'caliop1'   : sample_title = ' CALIOP1 '
   'caliop2'   : sample_title = ' CALIOP2 '
   'caliop3'   : sample_title = ' CALIOP3 '
   'caliop4'   : sample_title = ' CALIOP4 '
   'inverse_supermisr' : sample_title = ' !Super-MISR '
   'inverse_misr1'     : sample_title = ' !MISR1 '
   'inverse_misr2'     : sample_title = ' !MISR2 '
   'inverse_misr3'     : sample_title = ' !MISR3 '
   'inverse_misr4'     : sample_title = ' !MISR4 '
   'inverse_caliop1'   : sample_title = ' !CALIOP1 '
   'inverse_caliop2'   : sample_title = ' !CALIOP2 '
   'inverse_caliop3'   : sample_title = ' !CALIOP3 '
   'inverse_caliop4'   : sample_title = ' !CALIOP4 '
   else        : sample_title = ' '
  endcase
  samplestr = '.'+sample
  if(sample_title eq ' ') then samplestr = ''

  satstr = ''
  if(satid eq 'MOD04') then satstr = 'MODIS Terra'
  if(satid eq 'MYD04') then satstr = 'MODIS Aqua'
  if(satstr eq '') then stop

  spawn, 'echo $MODISDIR', MODISDIR

  numstr = '.num'

  nymd = yyyy+mm+'15'
  nhms = '120000'
  yyyymm = string(nymd/100L,format='(i6)')
  yyyy   = string(nymd/10000L,format='(i4)')
  if(not(keyword_set(geolimits))) then geolimits = [-90,-180,90,180]
  varwant = ['aot']
  if(keyword_set(num)) then varwant = ['num']
  if(keyword_set(num)) then numstr = ''
  
; Get the sample
  filet = 'qawt'
  if(keyword_set(num)) then filet = 'qafl'
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2_ocn'+samplestr+'.aero_tc8_051.qast_'+filet+numstr+'.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aoto, /sum, lon=lon, lat=lat, lev=lev

  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2_lnd'+samplestr+'.aero_tc8_051.qast3_'+filet+numstr+'.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotl, /sum, lon=lon, lat=lat, lev=lev

  a= where(aoto ge 1e14)
  aoto[a] = !values.f_nan
  a= where(aotl ge 1e14)
  aotl[a] = !values.f_nan

; If the "exclude" keyword is thrown then also read in the full swath
; values and remove points seen in the sample
  if(keyword_set(exclude)) then begin

  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2_ocn.aero_tc8_051.qast_qawt'+numstr+'.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aoto_, /sum, lon=lon, lat=lat, lev=lev
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2_lnd.aero_tc8_051.qast3_qawt'+numstr+'.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotl_, /sum, lon=lon, lat=lat, lev=lev
  
  if(keyword_set(inverse)) then begin
   aoto_[where(finite(aoto) ne 1)] = 1.e15
   aotl_[where(finite(aotl) ne 1)] = 1.e15
  endif else begin
   aoto_[where(finite(aoto) eq 1)] = 1.e15
   aotl_[where(finite(aotl) eq 1)] = 1.e15
  endelse
  aoto = aoto_
  aotl = aotl_

  endif

  a= where(aoto ge 1e14)
  aoto[a] = !values.f_nan
  a= where(aotl ge 1e14)
  aotl[a] = !values.f_nan

  aotsat = aotl
  aotsat[where(finite(aoto) eq 1)] = aoto[where(finite(aoto) eq 1)]

; Now check to see if averaging regions are provided
  if(keyword_set(lon0)) then begin

  nreg = n_elements(lon0)

  reg_aot = fltarr(nreg)
  reg_std = fltarr(nreg)

  for ireg = 0, nreg-1 do begin
   a = where(lon ge lon0[ireg] and lon le lon1[ireg])
   b = where(lat ge lat0[ireg] and lat le lat1[ireg])
   atmp = area[a,*]
   atmp = atmp[*,b]
   btmp = aotsat[a,*]
   btmp = btmp[*,b]
   if(n_elements(atmp) eq 1) then begin
    reg_aot[ireg] = btmp
    reg_std[ireg] = !values.f_nan
   endif else begin
    reg_aot[ireg] = aave(btmp,atmp,/nan)
    reg_std[ireg] = stddev(btmp,/nan)
   endelse
  endfor

  endif

end
