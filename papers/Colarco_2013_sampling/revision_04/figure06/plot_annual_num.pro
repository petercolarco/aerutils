; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

; Apply LAR derived correction factors (valid only for MYD04) for sub-sampling

  pro plot_annual_num, satid, sample, yyyy, res=res, exclude=exclude, $
                     iplot=iplot, tplot=tplot

  if(not(keyword_set(res))) then res = 'd'
  area, x, y, nx, ny, dx, dy, area, grid = res

  if(not(keyword_set(iplot))) then iplot = 1
  if(not(keyword_set(tplot))) then tplot = 1
  iplot = iplot -1 

  if(tplot ne 1 and tplot ne 2 and tplot ne 4) then stop

  case tplot of
   1: begin
      position = [.05,.2,.95,.9]
      xsize=12
      ysize=10
      noerase = 0
      lstr = ''
      end
   2: begin
      position = [ [.025,.2,.475,.9], $
                   [.525,.2,.975,.9] ]
      xsize=24
      ysize=10
      noerase = 0
      if(iplot eq 0) then lstr = '!4(a)!3 '
      if(iplot eq 1) then lstr = '!4(b)!3 '
      if(iplot gt 0) then noerase = 1
      end
   4: begin
      position = [ [.025,.6,.475,.95], $
                   [.525,.6,.975,.95], $
                   [.025,.15,.475,.525], $
                   [.525,.15,.975,.525] ]
      xsize=24
      ysize=20
      noerase = 0
      if(iplot eq 0) then lstr = '!4(a)!3 '
      if(iplot eq 1) then lstr = '!4(b)!3 '
      if(iplot eq 2) then lstr = '!4(c)!3 '
      if(iplot eq 3) then lstr = '!4(d)!3 '
      if(iplot gt 0) then noerase = 1
      end
   endcase

  case sample of
   'lat1'      : sample_title = ' L1 '
   'lat2'      : sample_title = ' L2 '
   'lat3'      : sample_title = ' L3 '
   'lat4'      : sample_title = ' L4 '
   'lat5'      : sample_title = ' L5 '
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
  if(sample_title eq ' ') then sample_title = ' Full Swath '

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


  if(iplot eq 0) then begin
   set_plot, 'ps'
   device, file='./'+satId+samplestr+'.qast.'+res+numstr+'.num_annual.'+yyyy+'.eps', $
           /color, /helvetica, font_size=9, $
           xoff=.5, yoff=.5, xsize=xsize, ysize=ysize, /encap
   !p.font=0
  endif


   dx = lon[1]-lon[0]
   dy = lat[1]-lat[0]

  p0 = 0
  p1 = 0
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.

  map_set, p0, p1, position=position[*,iplot], /noborder, limit=geolimits, noerase=noerase
; plot missing data as light shade
  loadct, 0
  plotgrid, numsat, [-.1], [220], lon, lat, dx, dy, /map, /missing
; plot data
  loadct, 39
  levels = findgen(11)*300
  levels = [0,10,20,50,100,200,500,1000,1500,2000,2500]
  if(res eq 'ten') then levels=levels*20.
  colors = [30,64,80,96,144,176,192,199,208,254,10]
  plotgrid, numsat, levels, colors, lon, lat, dx, dy, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position[*,iplot], limit=geolimits
  map_grid, /box

  if(res eq 'ten') then res = 'a'
  title= sample_title + 'Annual Number of Retrievals per Grid Box'
  xyouts, position[0,iplot], position[3,iplot]+.025, lstr+title, /normal, charsize=1.2

  if(tplot eq 1) then begin
   makekey, .1, .075, .8, .05, 0, -.035, color=colors, $
    align=0, label=string(levels,format='(i5)')
  endif
  if(iplot eq 0 and tplot eq 2) then begin
   makekey, .1, .075, .8, .05, 0, -.035, color=colors, $
    align=0, label=string(levels,format='(i5)')
  endif
  if(iplot eq 0 and tplot eq 4) then begin
   makekey, .1, .035, .8, .035, 0, -.025, color=colors, $
    align=0, label=string(levels,format='(i5)')
   title = 'Annual Number of Retrievals per Grid Box (Annual total year '+yyyy+')'
   xyouts, .5, .08, title, /normal, charsize=1.2, align=.5
  endif

  if(iplot eq tplot-1) then device, /close


end
