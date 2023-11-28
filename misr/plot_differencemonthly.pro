; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  expid = 'dR_ARCTAS-F25b23'
expid = 'dR_MERRA-AA-r2'
expid = 'dR_Fortuna-M-1-1'
  satid = 'MISR'
  geolimits = [-90,-180,90,180]
  geolimits = [30,180,80,300]
  geolimits = [-45,-45,15,60]
  varwant = ['duexttau','suexttau','ssexttau','bcexttau','ocexttau']

; Dates
  nymd0 = '20070915'
  nhms0 = '120000'
  nymd1 = '20070930'
  nhms1 = '120000'
  dateexpand, nymd0, nymd1, nhms0, nhms1, nymd, nhms, /monthly

  nt = n_elements(nymd)

  for ii = 0, nt-1 do begin

  mm = strpad(ii,10)

  yyyymm = string(nymd[ii]/100L,format='(i6)')
  yyyy   = string(nymd[ii]/10000L,format='(i4)')
  mm     = strpad(string(long(yyyymm)-long(yyyy)*100L,format='(i2)'),10)
print, yyyymm
  set_plot, 'ps'
  device, file='./output/plots/'+expid+'.'+satId+$
               '.aodtau550_difference.'+yyyymm+'.ps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=15, ysize=25
 !p.font=0

  read_aot, aotsat, lon, lat, yyyy, mm, satid=satid, res='d';, /hourly

  filetemplate = '/misc/prc15/colarco/'+expid+'/inst2d_hwl_x/Y%y4/M%m2/'+ $
                 expid+'.inst2d_hwl_x.MISR_L2.aero_tc8_F12_0022.noqawt.%y4%m2.nc4' 
  filename = strtemplate(filetemplate,nymd[ii],nhms[ii],str=expid)

  nc4readvar, filename, varwant, aotocn, /sum, lon=lon, lat=lat, lev=lev
  aotlnd = aotocn

; Now average results together
  a = where(aotsat gt 100.)
  aotsat[a] = !values.f_nan
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

; Difference
  colorArray = [64,80,96,144,176,255,192,199,208,254,10]
;  a =  where(finite(aotmod) ne 1)
;  if(a[0] ne -1) then aotsat[a] = !values.f_nan

   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   xycomp, aotmod, aotsat, lon, lat, dx, dy, geolimits=geolimits, $
           levels=findgen(11)*.1

   title=satid+' (top), '+expid+' (middle), top-middle (bottom)'
   xyouts, .45, .97, title, align=.5, /normal
   xyouts, .95, .97, yyyymm, align=.5, /normal

   device, /close


endfor


end
