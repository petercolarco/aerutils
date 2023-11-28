; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

; Apply LAR derived correction factors (valid only for MYD04) for sub-sampling

  pro plot_annual, satid, sample, yyyy, res=res, exclude=exclude, geolimits=geolimits, geoname=geoname, inverse=inverse, $
                   iplot=iplot, tplot=tplot

  if(not(keyword_set(iplot))) then iplot = 1
  if(not(keyword_set(tplot))) then tplot = 1
  iplot = iplot -1 

  if(tplot ne 1 and tplot ne 4) then stop

  case tplot of
   1: begin
      position = [.05,.2,.95,.9]
      xsize=12
      ysize=10
      noerase = 0
      lstr = ''
      end
   4: begin
      position = [ [.025,.6,.475,.95], $
                   [.525,.6,.975,.95], $
                   [.025,.15,.475,.475], $
                   [.525,.15,.975,.475] ]
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

  if(not(keyword_set(res))) then res = 'd'
print, iplot
  case sample of
   'supermisr' : sample_title = ' MW '
   'lat1'      : sample_title = ' L1 '
   'lat2'      : sample_title = ' L2 '
   'lat3'      : sample_title = ' L3 '
   'lat4'      : sample_title = ' L4 '
   'lat5'      : sample_title = ' L5 '
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
   else        : sample_title = ' Full Swath '
  endcase
  samplestr = '.'+sample
  if(sample_title eq ' Full Swath ') then samplestr = ''

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
  if(not(keyword_set(geolimits))) then geolimits = [-75,-180,75,180]
  varwant = ['aot']

; Sample swath
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_ocn'+samplestr+'.aero_tc8_051.qast_qawt'+numstr+'.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aoto, /sum, lon=lon, lat=lat, lev=lev
 ; filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
 ;                satid+'_L2_ocn'+samplestr+'.aero_tc8_051.qast_qafl.%y4.nc4'
 ; filename = strtemplate(filetemplate,nymd,nhms)
 ; nc4readvar, filename, 'num', numo, lon=lon, lat=lat, lev=lev
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_lnd'+samplestr+'.aero_tc8_051.qast3_qawt'+numstr+'.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotl, /sum, lon=lon, lat=lat, lev=lev
 ; filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
 ;                satid+'_L2_lnd'+samplestr+'.aero_tc8_051.qast3_qafl.%y4.nc4'
 ; filename = strtemplate(filetemplate,nymd,nhms)
 ; nc4readvar, filename, 'num', numl, lon=lon, lat=lat, lev=lev

  a= where(aoto ge 1e14)
  aoto[a] = !values.f_nan
;  numo[a] = !values.f_nan
  a= where(aotl ge 1e14)
  aotl[a] = !values.f_nan
;  numl[a] = !values.f_nan

; If the "exclude" keyword is thrown then also read in the full swath
; values and remove points seen in the sample
  if(keyword_set(exclude)) then begin

  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_ocn.aero_tc8_051.qast_qawt'+numstr+'.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aoto_, /sum, lon=lon, lat=lat, lev=lev
 ; filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
 ;                satid+'_L2_ocn.aero_tc8_051.qast_qafl.%y4.nc4'
 ; filename = strtemplate(filetemplate,nymd,nhms)
 ; nc4readvar, filename, 'num', numo_, lon=lon, lat=lat, lev=lev
  filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
                 satid+'_L2_lnd.aero_tc8_051.qast3_qawt'+numstr+'.%y4.nc4'
  filename = strtemplate(filetemplate,nymd,nhms)
  nc4readvar, filename, varwant, aotl_, /sum, lon=lon, lat=lat, lev=lev
 ; filetemplate = MODISDIR[0]+'/MODIS/Level3/'+satid+'/'+res+'/GRITAS/Y%y4/'+ $
 ;                satid+'_L2_lnd.aero_tc8_051.qast3_qafl.%y4.nc4'
 ; filename = strtemplate(filetemplate,nymd,nhms)
 ; nc4readvar, filename, 'num', numl_, lon=lon, lat=lat, lev=lev
  
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
;  numo[a] = !values.f_nan
  a= where(aotl ge 1e14)
  aotl[a] = !values.f_nan
;  numl[a] = !values.f_nan

  aotsat = aotl
  aotsat[where(finite(aoto) eq 1)] = aoto[where(finite(aoto) eq 1)]
;  aotsat = average_land_ocean(aoto, aotl, lon, lat, numo=numo, numl=numl)
;  area, x, y, nx, ny, dx, dy, area, grid = res
;  print, 'modis', aave(aotsat,area,/nan)
;  print, '  lnd', aave(aotl*numl,area,/nan)/aave(numl,area,/nan)
;  print, '  ocn', aave(aoto*numo,area,/nan)/aave(numo,area,/nan)

; Now average results together
;  a = where(aotsat gt 100. or aotsat lt 0.)
  a = where(aotsat gt 100.)
  aotsat[a] = !values.f_nan

  nx = n_elements(lon)
  ny = n_elements(lat)

  relstr = ''
  excstr = ''
  if(keyword_set(exclude)) then excstr = 'exclude.'
  if(keyword_set(exclude) and keyword_set(inverse)) then excstr = 'exclude_inverse.'

  if(keyword_set(geoname)) then geoname = '.'+geoname else geoname = ''

  if(iplot eq 0) then begin
   set_plot, 'ps'
   device, file='./'+satId+samplestr+'.qast.'+res+numstr+'.aodtau550_annual.'+excstr+yyyy+geoname+'.eps', $
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
  plotgrid, aotsat, [-.1], [220], lon, lat, dx, dy, /map, /missing
; plot data
  loadct, 39
  levels = findgen(11)*.1
  levels = findgen(11)*.05
  colors = [30,64,80,96,144,176,192,199,208,254,10]
  plotgrid, aotsat, levels, colors, lon, lat, dx, dy, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position[*,iplot], limit=geolimits
  map_grid, /box

; Resstr
  case res of
   'ten' : resstr = '10!E O!N x 10!E O!N'
   'b'   : resstr = '2!E O!N x 2.5!E O!N'
   'c'   : resstr = '1!E O!N x 1.25!E O!N'
   'd'   : resstr = '0.5!E O!N x 0.625!E O!N'
  endcase

  title =  sample_title + 'AOT ('+resstr+')'
  if(keyword_set(exclude)) then $
   title = 'Full Swath AOT where'+sample_title+'does not observe'
  if(keyword_set(exclude) and keyword_set(inverse)) then $
   title = 'Full Swath AOT only where'+sample_title+'observes'

  xyouts, position[0,iplot], position[3,iplot]+.025, lstr+title, /normal, charsize=1.2

  if(tplot eq 1) then begin
   makekey, .1, .075, .8, .05, 0, -.035, color=colors, $
    align=0, label=string(levels,format='(f4.2)')
  endif
  if(iplot eq 0 and tplot eq 4) then begin
   title = 'AOT [550 nm] (Annual mean year '+yyyy+')'
   xyouts, .5, .08, title, /normal, charsize=1.2, align=.5
   makekey, .1, .035, .8, .035, 0, -.025, color=colors, $
    align=0, label=string(levels,format='(f4.2)')
  endif
  if(iplot eq tplot-1) then device, /close


end
