; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

; Apply LAR derived correction factors (valid only for MYD04) for sub-sampling

  pro plot_differenceannual_corrected, satid, sample, yyyy, relative=relative, difference=difference

; New as of 3/2
  corrfact = [ [0.0044,-0.0027,-0.0006,-0.0049,0.0208,-0.0001,0.0026,0.0177], $ ; ocean
               [-0.0023,-0.0229,-0.0298,-0.0168,0.0056,-0.0268,-0.0095,0.0168]]   ; land

  corrfact_modis = [0.0044,-0.0023]

  case sample of
   'supermisr' : corrfact = [-0.0027,-0.0229] ; ocean, land
   'misr1'     : corrfact = [-0.0006,-0.0298]
   'misr2'     : corrfact = [-0.0049,-0.0168]
   'misr3'     : corrfact = [0.0208,0.0056]
   'caliop1'   : corrfact = [-0.0001,-0.0268]
   'caliop2'   : corrfact = [0.0026,-0.0095]
   'caliop3'   : corrfact = [0.0177,0.0168]
   else        : corrfact = [0.0044,-0.0023]
  endcase

  case sample of
   'supermisr' : sample_title = 'SM'
   'misr1'     : sample_title = 'M1'
   'misr2'     : sample_title = 'M2'
   'misr3'     : sample_title = 'M3'
   'caliop1'   : sample_title = 'C1'
   'caliop2'   : sample_title = 'C2'
   'caliop3'   : sample_title = 'C3'
   else        : sample_title = ' '
  endcase

  satstr = ''
  if(satid eq 'MOD04') then satstr = 'MODIS Terra'
  if(satid eq 'MYD04') then satstr = 'MODIS Aqua'
  if(satstr eq '') then stop

  spawn, 'echo $MODISDIR', MODISDIR

  numstr = '.num'
;  numstr = ''
  res = 'b'
;  res = 'd'

;  satid = 'MYD04'
  nymd = yyyy+'0615'
  nhms = '120000'
  yyyymm = string(nymd/100L,format='(i6)')
  yyyy   = string(nymd/10000L,format='(i4)')
  mm     = strpad(string(long(yyyymm)-long(yyyy)*100L,format='(i2)'),10)
  geolimits = [-90,-180,90,180]
;  geolimits = [-10,30,60,140]
  varwant = ['aot']
;  varwant = ['totexttau']

; Full swath
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_ocn.aero_tc8_051.qast_qawt'+numstr+'.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aoto, /sum, lon=lon, lat=lat, lev=lev
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_ocn.aero_tc8_051.qast_qafl.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, 'num', numo, lon=lon, lat=lat, lev=lev
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_lnd.aero_tc8_051.qast3_qawt'+numstr+'.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotl, /sum, lon=lon, lat=lat, lev=lev
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_lnd.aero_tc8_051.qast3_qafl.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, 'num', numl, lon=lon, lat=lat, lev=lev

  a= where(aoto ge 1e14)
  aoto[a] = !values.f_nan
  numo[a] = !values.f_nan
  a= where(aotl ge 1e14)
  aotl[a] = !values.f_nan
  numl[a] = !values.f_nan
  aotsat = average_land_ocean(aoto-corrfact_modis[0], aotl-corrfact_modis[1], lon, lat)
  area, x, y, nx, ny, dx, dy, area, grid = res
  print, 'modis', aave(aotsat,area,/nan)
  print, '  lnd', aave(aotl*numl,area,/nan)/aave(numl,area,/nan)-corrfact_modis[1]
  print, '  ocn', aave(aoto*numo,area,/nan)/aave(numo,area,/nan)-corrfact_modis[0]

; Sample swath
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_ocn.'+sample+'.aero_tc8_051.qast_qawt'+numstr+'.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aoto, /sum, lon=lon, lat=lat, lev=lev
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_ocn.'+sample+'.aero_tc8_051.qast_qafl.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, 'num', numo, lon=lon, lat=lat, lev=lev
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_lnd.'+sample+'.aero_tc8_051.qast3_qawt'+numstr+'.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotl, /sum, lon=lon, lat=lat, lev=lev
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_lnd.'+sample+'.aero_tc8_051.qast3_qafl.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, 'num', numl, lon=lon, lat=lat, lev=lev

  a= where(aoto ge 1e14)
  aoto[a] = !values.f_nan
  numo[a] = !values.f_nan
  a= where(aotl ge 1e14)
  aotl[a] = !values.f_nan
  numl[a] = !values.f_nan
  aotmod = average_land_ocean(aoto-corrfact[0], aotl-corrfact[1], lon, lat)
  print, sample, aave(aotmod,area,/nan)
  print, '  lnd', aave(aotl*numl,area,/nan)/aave(numl,area,/nan)-corrfact[1]
  print, '  ocn', aave(aoto*numo,area,/nan)/aave(numo,area,/nan)-corrfact[0]


; Now average results together
  a = where(aotsat gt 100. or aotsat lt 0.)
  aotsat[a] = !values.f_nan
  a = where(aotmod gt 100. or aotmod lt 0.)
  aotmod[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)

; Difference
  colorArray = [64,80,96,144,176,255,192,199,208,254,10]
;  a =  where(finite(aotmod) ne 1)
;  if(a[0] ne -1) then aotsat[a] = !values.f_nan

  relstr = ''
  if(not(keyword_set(relative))) then relative = 0
  if(relative) then relstr = 'relative.'
  if(relative) then difference = 0
  if(difference) then relstr = 'difference.'

  set_plot, 'ps'
  device, file='./output/plots/'+satId+'.'+sample+'.qast.'+res+numstr+'.aodtau550_difference_corrected.'+relstr+yyyy+'.ps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=15, ysize=25
 !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]
; difference as % difference
   if(relative) then begin
    diff = (aotsat-aotmod)/aotsat*100.
    a = where(aotsat eq !values.f_nan or aotmod eq !values.f_nan)
    if(a[0] ne -1) then diff[a] = !values.f_nan
    dlevels = [-5,-.25,-.2,-.15,-.1,-.05,.05,.1,.15,.2,.25]*100.
    dlabelarray = string(dlevels,format='(i4)')
    dlabelarray[0] = ''
    diffstr = '%-difference'
  endif

; difference as an absolute difference
  if(not(relative) and not(difference)) then begin
    diff = (aotsat-aotmod)
    a = where(aotsat eq !values.f_nan or aotmod eq !values.f_nan)
    if(a[0] ne -1) then diff[a] = !values.f_nan
    dlevels = [-5,-.05,-.03,-.02,-.01,-0.005,0.005,.01,.02,.03,.05]
    dlabelarray = string(dlevels,format='(f6.3)')
    dlabelarray[0] = ''
    diffstr = 'Full Swath - '+sample_title+' AOT Difference'
   endif

; Instead show only grid boxes where AOT difference greater than 0.01
  if(difference) then begin
    diff = (aotsat-aotmod)
    diffstr = 'Full Swath - '+sample_title+' AOT Difference'
    dlevels = [0.01]
    dlabelarray = string(dlevels,format='(f6.3)')
    dlabelarray[0] = ''
    a = where(aotsat eq !values.f_nan or aotmod eq !values.f_nan)
    if(a[0] ne -1) then diff[a] = !values.f_nan
    a = where(abs(diff) lt dlevels[0])
    if(a[0] ne -1) then diff[a] = 0.
;    diff = abs(diff)
  endif


   xycomp, aotsat, aotmod, lon, lat, dx, dy, $
     diff=diff, dlevels=dlevels, dlabelarray=dlabelarray

;   title='Full Swath(top), '+ $
;         sample_title+' (middle), MODIS-'+ $
;         sample_title+' (bottom) sampled'
;   xyouts, .45, .97, title, align=.5, /normal
;   xyouts, .95, .97, yyyy, align=.5, /normal

   xyouts, .05, .97, satstr+' Full Swath AOT', /normal
   xyouts, .05, .65, satstr+' '+sample_title+' AOT', /normal
   xyouts, .05, .33, diffstr, /normal

   device, /close


end
