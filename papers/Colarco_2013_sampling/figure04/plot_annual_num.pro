; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

; Apply LAR derived correction factors (valid only for MYD04) for sub-sampling

  pro plot_annual_num, satid, sample, yyyy, res=res, exclude=exclude

  if(not(keyword_set(res))) then res = 'd'

  case sample of
   'supermisr' : sample_title = ' SN '
   'misr1'     : sample_title = ' N1 '
   'misr2'     : sample_title = ' N2 '
   'misr3'     : sample_title = ' N3 '
   'misr4'     : sample_title = ' N4 '
   'caliop1'   : sample_title = ' C1 '
   'caliop2'   : sample_title = ' C2 '
   'caliop3'   : sample_title = ' C3 '
   'caliop4'   : sample_title = ' C4 '
   'inverse_supermisr' : sample_title = ' !SN '
   'inverse_misr1'     : sample_title = ' !N1 '
   'inverse_misr2'     : sample_title = ' !N2 '
   'inverse_misr3'     : sample_title = ' !N3 '
   'inverse_misr4'     : sample_title = ' !N4 '
   'inverse_caliop1'   : sample_title = ' !C1 '
   'inverse_caliop2'   : sample_title = ' !C2 '
   'inverse_caliop3'   : sample_title = ' !C3 '
   'inverse_caliop4'   : sample_title = ' !C4 '
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
;  numstr = ''

;  satid = 'MYD04'
  nymd = yyyy+'0615'
  nhms = '120000'
  yyyymm = string(nymd/100L,format='(i6)')
  yyyy   = string(nymd/10000L,format='(i4)')
  mm     = strpad(string(long(yyyymm)-long(yyyy)*100L,format='(i2)'),10)
  geolimits = [-90,-180,90,180]
;  geolimits = [-30,-90,30,0]
;  geolimits = [-10,30,60,140]
  varwant = ['aot']
;  varwant = ['totexttau']

; Sample swath
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_ocn'+samplestr+'.aero_tc8_051.qast_qafl.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, 'num', numo, lon=lon, lat=lat, lev=lev
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_lnd'+samplestr+'.aero_tc8_051.qast3_qafl.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, 'num', numl, lon=lon, lat=lat, lev=lev

  a= where(numo ge 1e14)
  numo[a] = !values.f_nan
  a= where(numl ge 1e14)
  numl[a] = !values.f_nan

  numsat = numl
  numsat[where(finite(numo) eq 1)] = numo[where(finite(numo) eq 1)]

  nx = n_elements(lon)
  ny = n_elements(lat)


; Resstr
  case res of
   'ten' : resstr = '10!E O!N x 10!E O!N'
   'b'   : resstr = '2!E O!N x 2.5!E O!N'
   'c'   : resstr = '1!E O!N x 1.25!E O!N'
   'd'   : resstr = '0.5!E O!N x 0.625!E O!N'
  endcase


  set_plot, 'ps'
  device, file='./output/plots/'+satId+samplestr+'.qast.'+res+numstr+'.num_annual.'+yyyy+'.ps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=12, ysize=10
 !p.font=0


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

  p0 = 0
  p1 = 0
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.

  position1 = [.05,.2,.95,.9]
  map_set, p0, p1, position=position1, /noborder, limit=geolimits
; plot missing data as light shade
  loadct, 0
  plotgrid, numsat, [-.1], [120], lon, lat, dx, dy, /map, /missing
; plot data
  loadct, 39
  levels = findgen(11)*300
  colors = [30,64,80,96,144,176,192,199,208,254,10]
  plotgrid, numsat, levels, colors, lon, lat, dx, dy, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position1, limit=geolimits
  map_grid, /box

  if(res eq 'ten') then res = 'a'
  xyouts, .05, .95, 'MODIS Aqua'+ sample_title + 'Annual Number of Retrievals per Grid Box ('+resstr+', '+yyyy+')', /normal

  makekey, .1, .075, .8, .05, 0, -.035, color=colors, $
   align=0, label=string(levels,format='(i4)')
 device, /close


end
