; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  expid  = 'dR_arctas'
  expid2 = 'dRA_arctas'
  satid  = 'MYD04'
  geolimits = [-90,-180,90,180]
;  geolimits = [10,-50,30,0]
  varwant = ['duexttau','suexttau','ssexttau','bcexttau','ocexttau']

  set_plot, 'ps'
  device, file='./output/plots/'+expid+'_'+expid2+'.aodtau550_difference.ps', $
;               '.aodtau550_difference.tropatl.ps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=15, ysize=25
 !p.font=0

  for ii = 6,6 do begin

  mm = strpad(ii,10)

  nymd = '2008'+mm+'15'
  nhms = '120000'
  yyyymm = string(nymd/100L,format='(i6)')
  yyyy   = string(nymd/10000L,format='(i4)')
  mm     = strpad(string(long(yyyymm)-long(yyyy)*100L,format='(i2)'),10)

; Baseline
  filetemplate = '/misc/prc14/colarco/'+expid+'/inst2d_hwl_x/Y%y4/M%m2/'+ $
                 expid+'.inst2d_hwl_x.nnr_001.'+satid+'_l3a.ocean.%y4%m2.nc4' 
  filename = strtemplate(filetemplate,nymd,nhms,str=expid)
  nc4readvar, filename, varwant, aotocn, /sum, lon=lon, lat=lat, lev=lev
  filetemplate = '/misc/prc14/colarco/'+expid+'/inst2d_hwl_x/Y%y4/M%m2/'+ $
                 expid+'.inst2d_hwl_x.nnr_001.'+satid+'_l3a.land.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms,str=expid)
  nc4readvar, filename, varwant, aotlnd, /sum, lon=lon, lat=lat, lev=lev

; Now average results together
  a = where(aotocn gt 100.)
  aotocn[a] = !values.f_nan
  a = where(aotlnd gt 100.)
  aotlnd[a] = !values.f_nan
  nx = n_elements(lon)
  ny = n_elements(lat)
  aotsat = fltarr(nx,ny)
  for i = 0L, nx*ny-1 do begin
   aotsat[i] = mean([aotocn[i],aotlnd[i]],/nan)
  endfor

; Assimilation
  filetemplate = '/misc/prc14/colarco/'+expid2+'/inst2d_hwl_x/Y%y4/M%m2/'+ $
                 expid2+'.inst2d_hwl_x.nnr_001.'+satid+'_l3a.ocean.%y4%m2.nc4' 
  filename = strtemplate(filetemplate,nymd,nhms,str=expid)
  nc4readvar, filename, varwant, aotocn, /sum, lon=lon, lat=lat, lev=lev
  filetemplate = '/misc/prc14/colarco/'+expid2+'/inst2d_hwl_x/Y%y4/M%m2/'+ $
                 expid2+'.inst2d_hwl_x.nnr_001.'+satid+'_l3a.land.%y4%m2.nc4'
  filename = strtemplate(filetemplate,nymd,nhms,str=expid)
  nc4readvar, filename, varwant, aotlnd, /sum, lon=lon, lat=lat, lev=lev

; Now average results together
  a = where(aotocn gt 100.)
  aotocn[a] = !values.f_nan
  a = where(aotlnd gt 100.)
  aotlnd[a] = !values.f_nan
  nx = n_elements(lon)
  ny = n_elements(lat)
  aotmod = fltarr(nx,ny)
  for i = 0L, nx*ny-1 do begin
   aotmod[i] = mean([aotocn[i],aotlnd[i]],/nan)
  endfor

  nx = n_elements(lon)
  ny = n_elements(lat)

; Difference
  colorArray = [64,80,96,144,176,255,192,199,208,254,10]
;  a =  where(finite(aotmod) ne 1)
;  if(a[0] ne -1) then aotsat[a] = !values.f_nan

   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   xycomp, aotsat, aotmod, lon, lat, dx, dy, geolimits=geolimits

   title = expid+' (top), '+expid2+' (middle), top-middle (bottom)'
   xyouts, .45, .97, title, align=.5, /normal
   xyouts, .95, .97, yyyymm, align=.5, /normal

endfor

   device, /close


end
