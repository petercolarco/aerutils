; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

; Apply LAR derived correction factors (valid only for MYD04) for sub-sampling

  pro plot_seasonal, satid, sample, yyyy, season, res=res, exclude=exclude, geolimits=geolimits, geoname=geoname, inverse=inverse, pdf=pdf

  if(not(keyword_set(res))) then res = 'd'
  area, x, y, nx, ny, dx, dy, area, grid = res

  regtitle = ['South America', 'Southern Africa', 'African Dust', 'Nile Valley', $
              'Indogangetic Plain', 'China', 'Southeast Asia', 'Asian Outflow']
  ymax   = [1,.6,.8,.8,.8,1,.8,.5]
  regstr = ['sam','saf','naf','nrv','igp','chn','sea','npac']
  lon0 = [-75,-15,-30, 30, 75, 100,  95, 135]
  lon1 = [-45, 35,-15, 36, 95, 125, 110, 165]
  lat0 = [-20,-20, 10, 22, 20,  25,  10,  30]
  lat1 = [  0,  0, 30, 32, 30,  42,  25,  55]
  nreg = n_elements(lon0)


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
  if(not(keyword_set(geolimits))) then geolimits = [-90,-180,90,180]
  yyyy_ = yyyy
  read_seasonal, satid, sample, yyyy, season, aotsat, res=res, exclude=exclude, inverse=inverse, $
                 lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, reg_std=reg_std, num=num, pdf=pdf

  yyyy = yyyy_
; If PDF requested then the output should massaged accordingly
  if(keyword_set(pdf)) then begin
   numstr = '.pdf'
goto, jump
;  Make the mean AOT
   aotbin = findgen(51)*.05
   aotsat_ = fltarr(nx,ny)
   for ix = 0, nx-1 do begin
    for iy = 0, ny-1 do begin
     if(total(aotsat[ix,iy,*]) eq 0) then aotsat_[ix,iy] = !values.f_nan else $
        aotsat_[ix,iy] = total(aotbin*aotsat[ix,iy,*]) / total(aotsat[ix,iy,*])
    endfor
   endfor
   aotsat = aotsat_
;  Calculate the regional mean value and regional std
   reg_aot_ = fltarr(nreg)
   reg_std_ = fltarr(nreg)
   for ireg = 0, nreg-1 do begin
    aotpdf = reform(reg_aot[ireg,*])
    sw = 0
    for ibin = 0, 50 do begin
     if(aotpdf[ibin] gt 0) then begin
      if(sw eq 0) then begin
       aot = make_array(aotpdf[ibin],val=aotbin[ibin])
       sw = 1
      endif else begin
       aot = [aot,make_array(aotpdf[ibin],val=aotbin[ibin])]
      endelse
     endif
    endfor
    reg_aot_[ireg] = mean(aot)
    reg_std_[ireg] = stddev(aot)
   endfor
   reg_aot = reg_aot_
   reg_std = reg_std_
jump:
  endif

  if(geoname eq 'tropical_atlantic') then begin
   for ireg = 0, 3 do begin
    print, reg_aot[ireg], ' (', reg_std[ireg], ')', format='(f4.2,a2,f4.2,a1)'
;   print, regtitle[ireg], reg_aot[ireg], reg_std[ireg], format='(a20,2(2x,f6.4))'
   endfor
  endif

  if(geoname eq 'asia') then begin
   for ireg = 4, 7 do begin
    print, reg_aot[ireg], ' (', reg_std[ireg], ')', format='(f4.2,a2,f4.2,a1)'
;   print, regtitle[ireg], reg_aot[ireg], reg_std[ireg], format='(a20,2(2x,f6.4))'
   endfor
  endif

print, ' '

  relstr = ''
  excstr = ''
  if(keyword_set(exclude)) then excstr = 'exclude.'
  if(keyword_set(exclude) and keyword_set(inverse)) then excstr = 'exclude_inverse.'

  if(keyword_set(geoname)) then geoname = '.'+geoname else geoname = ''

  set_plot, 'ps'
  device, file='./'+satId+samplestr+'.qast.'+res+numstr+'.aodtau550_seasonal.'+excstr+yyyy+season+geoname+'.eps', $
          /color, /helvetica, font_size=9, $
          xoff=.5, yoff=.5, xsize=12, ysize=10, /encap
 !p.font=0

  p0 = 0
  p1 = 0
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.

  position1 = [.05,.2,.95,.9]
  map_set, p0, p1, position=position1, /noborder, limit=geolimits
; plot missing data as light shade
  loadct, 0
  plotgrid, aotsat, [-.1], [120], x, y, dx, dy, /map, /missing
; plot data
  loadct, 39
  levels = findgen(11)*.1
  colors = [30,64,80,96,144,176,192,199,208,254,10]
  plotgrid, aotsat, levels, colors, x, y, dx, dy, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, p0, p1, /noerase, position = position1, limit=geolimits
  map_grid, /box

; Resstr
  case res of
   'ten' : resstr = '10!E O!N x 10!E O!N'
   'b'   : resstr = '2!E O!N x 2.5!E O!N'
   'c'   : resstr = '1!E O!N x 1.25!E O!N'
   'd'   : resstr = '0.5!E O!N x 0.625!E O!N'
  endcase

  title = 'MODIS Aqua'+ sample_title + 'AOT ('+yyyy+' '+season+')'
  if(keyword_set(exclude)) then $
   title = 'MODIS Aqua full AOT swath where'+sample_title+'does not observe ('+yyyy+' '+season+')'
  if(keyword_set(exclude) and keyword_set(inverse)) then $
   title = 'MODIS Aqua full AOT swath only where'+sample_title+'observes ('+yyyy+' '+season+')'

  xyouts, .05, .95, title, /normal

; Draw some boxes and print some averages
; South America
  plots, [-75,-45,-45,-75,-75], [-20,-20,0,0,-20], thick=6, color=255

; South Africa
  plots, [-15,30,30,-15,-15], [-20,-20,0,0,-20], thick=6, color=255

; Saharan dust
  plots, [-30,-15,-15,-30,-30], [10,10,30,30,10], thick=6, color=255

; Nile Valley
  plots, [30,36,36,30,30], [22,22,32,32,22], thick=6, color=255


; Draw some boxes and print some averages
; IGP
  plots, [75,95,95,75,75], [20,20,30,30,20], thick=6, color=255

; China
  plots, [100,125,125,100,100], [25,25,42,42,25], thick=6, color=255

; SEA
  plots, [95,110,110,95,95], [10,10,25,25,10], thick=6, color=255

; Asian outflow
  plots, [135,165,165,135,135], [30,30,55,55,30], thick=6, color=255

  makekey, .1, .075, .8, .05, 0, -.035, color=colors, $
   align=0, label=string(levels,format='(f3.1)')
 device, /close


end
