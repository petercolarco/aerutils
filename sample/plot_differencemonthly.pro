; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  sample = 'caliop2'
  sample_title = strupcase(sample)

  for ii = 6,6 do begin

  mm = strpad(ii,10)

  satid = 'MOD04'
  nymd = '2009'+mm+'15'
  nhms = '120000'
  yyyymm = string(nymd/100L,format='(i6)')
  yyyy   = string(nymd/10000L,format='(i4)')
  mm     = strpad(string(long(yyyymm)-long(yyyy)*100L,format='(i2)'),10)
  geolimits = [-90,-180,90,180]
;  geolimits = [-10,30,60,140]
  varwant = ['aot']

; Full swath
  filetemplate = '/misc/prc10/MODIS/Level3/'+satid+'/ten/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2_ocn.aero_tc8_051.qast.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aoto, /sum, lon=lon, lat=lat, lev=lev
  filetemplate = '/misc/prc10/MODIS/Level3/'+satid+'/ten/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2_lnd.aero_tc8_051.qast3.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotl, /sum, lon=lon, lat=lat, lev=lev
  aotsat = average_land_ocean(aoto, aotl, lon, lat)

; Sample swath
  filetemplate = '/misc/prc10/MODIS/Level3/'+satid+'/ten/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2_ocn.'+sample+'.aero_tc8_051.qast.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aoto, /sum, lon=lon, lat=lat, lev=lev
  filetemplate = '/misc/prc10/MODIS/Level3/'+satid+'/ten/GRITAS/Y%y4/M%m2/'+ $
                 satid+'_L2_lnd.'+sample+'.aero_tc8_051.qast.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotl, /sum, lon=lon, lat=lat, lev=lev
  aotmod = average_land_ocean(aoto, aotl, lon, lat)

; Now average results together
  a = where(aotsat gt 100.)
  aotsat[a] = !values.f_nan
  a = where(aotmod gt 100.)
  aotmod[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)

; Difference
  colorArray = [64,80,96,144,176,255,192,199,208,254,10]
;  a =  where(finite(aotmod) ne 1)
;  if(a[0] ne -1) then aotsat[a] = !values.f_nan

  set_plot, 'ps'
  device, file='./output/plots/'+satId+'.'+sample+'.qast.aodtau550_difference.'+yyyymm+'.ps', $
;  device, file='./output/plots/'+satId+'.aodtau550_difference.'+yyyymm+'.ps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=15, ysize=25
 !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]
; difference as % difference
   diff = (aotsat-aotmod)/aotsat*100.
   dlevels = [-5,-.25,-.2,-.15,-.1,-.05,.05,.1,.15,.2,.25]*100.
   dlabelarray = string(dlevels,format='(i4)')
   dlabelarray[0] = ''

   xycomp, aotsat, aotmod, lon, lat, dx, dy, $
     diff=diff, dlevels=dlevels, dlabelarray=dlabelarray

   title='Terra MOD04 MODIS (top), '+ $
         sample_title+' (middle), MODIS-'+ $
         sample_title+' (bottom) sampled'
   xyouts, .45, .97, title, align=.5, /normal
   xyouts, .95, .97, yyyymm, align=.5, /normal

   device, /close

endfor

end
