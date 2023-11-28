; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  expid = 'MYD04'
  satid = 'MYD04'
  geolimits = [-90,-180,90,180]
;  geolimits = [10,-50,30,0]
  varwant = ['duexttau','suexttau','ssexttau','bcexttau','ocexttau']

  set_plot, 'ps'
  device, file='./output/plots/MYD04_NNR.aodtau550_difference.ps', $
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

  read_modis, aotsat, lon, lat, yyyy, mm, satid=satid, res='d', /old

  read_modis, aotmod, lon, lat, yyyy, mm, satid=satid, res='d'

; Now average results together
  a = where(aotsat gt 100.)
  aotsat[a] = !values.f_nan
  aotmod[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)

; Difference
  colorArray = [64,80,96,144,176,255,192,199,208,254,10]
;  a =  where(finite(aotmod) ne 1)
;  if(a[0] ne -1) then aotsat[a] = !values.f_nan

   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

   xycomp, aotsat, aotmod, lon, lat, dx, dy, geolimits=geolimits

   title=satid+' (top), '+satid+' NNR (middle), top-middle (bottom)'
   xyouts, .45, .97, title, align=.5, /normal
   xyouts, .95, .97, yyyymm, align=.5, /normal

endfor

   device, /close


end
