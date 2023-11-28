; Colarco, Feb. 2008
; Read model points along flight track

; Get the flight track
  datewant= '20070719'
  datadir = '/Users/colarco/Desktop/TC4/data/'
  get_er2_navtrack, datadir, datewant, lonf, latf, levf, prsf, gmt
  nx = n_elements(gmt)

; Get the model along the track
  model = '/output/tc4/a_flk_04C/tau/Y2007/M07/'+ $
          'a_flk_04C.total.tau3d.20070719_1800z.hdf'
  get_model_navtrack, model, 'tau', tau, lonf, latf, lev, wanttime=[1]

  model = '/output/tc4/a_flk_04C/tau/Y2007/M07/'+ $
          'a_flk_04C.dust.tau3d.20070719_1800z.hdf'
  get_model_navtrack, model, 'tau', taudust, lonf, latf, lev, wanttime=[1]

; Correct the dust
  tau = tau - taudust + taudust/2.2


; Get layer edge heights (geopotential)
  met = '/output/tc4/d5_tc4_01/das/diag/Y2007/M07/'+ $
        'd5_tc4_01.tavg3d_met_e.20070719_1800z.hdf'
  get_model_navtrack, met, 'hghte', hghte, lonf, latf, lev, wanttime=[1]
  nz = n_elements(lev)-1
  dz = hghte[*,1:nz]-hghte[*,0:nz-1]
  hght = hghte[*,0:nz-1]+dz/2.

  ext = tau/dz

; Integrate tau from surface to above
  for ix = 0, nx-1 do begin
  for iz = 0, nz-1 do begin
   tau[ix,iz] = total(tau[ix,iz:nz-1])
  endfor
  endfor

; Make a plot
; convert seconds gmt to hh:mm:ss and figure tick marks
  dgmt = gmt[1] - gmt[0]
  hh0 = fix(min(gmt/3600.))
  hh1 = fix(max(gmt/3600.))+1
  nmajor = hh1-hh0
  nminor = 2
  hh = strcompress(string(fix(gmt/3600)),/rem)
  nn = strcompress(string(fix((gmt-hh*3600.)/60)),/rem)
  ss = strcompress(string(fix(gmt - hh*3600.-nn*60.)),/rem)
  a = where(hh lt 10)
  if(a[0] ne -1) then hh[a] = '0'+hh[a]
  a = where(nn lt 10)
  if(a[0] ne -1) then nn[a] = '0'+nn[a]
  a = where(ss lt 10)
  if(a[0] ne -1) then ss[a] = '0'+ss[a]
  timearray = hh+':'+nn+':'+ss
  ticklabel = hh0 + indgen(nmajor+1)
  ticklabel = string(ticklabel,format='(i2)')

; Make a plot
  set_plot, 'ps'
  fileps  = './ext_er2.'+datewant+'.ps'
  filepng = './ext_er2.'+datewant+'.png'
  device, file=fileps, font_size=14, /helvetica, $
   xoff=.5, yoff=.5, xsize=18, ysize=10, /color
  !p.font=0

  position=[.15,.3,.95,.9]
  contour, tau, gmt, reform(hght[0,*])/1000., /nodata, $
   yrange=[0,20],ythick=3, ystyle=9, $
   xstyle=9,  xthick=3, position=position, $
   xrange=[hh0*3600.,hh1*3600.], xticks=nmajor, xminor=nminor, xtickname=ticklabel
  levelarray = (findgen(10)*.005+.005)
  loadct, 39
  colorarray = [30,64,80,96,144,176,192,199,208,254]
  plotgrid, ext*1000., levelarray, colorarray, gmt, hght/1000., dgmt, dz/1000.
  contour, tau, gmt, reform(hght[0,*])/1000., /nodata, /noerase, $
   yrange=[0,20], ytitle = 'altitude [km]', ythick=3, ystyle=9, $
   xstyle=9, xtitle='hours gmt', xthick=3, position=position, $
   xrange=[hh0*3600.,hh1*3600.], xticks=nmajor, xminor=nminor, xtickname=ticklabel
  xyouts, .15, .92, 'GEOS-5 Aerosol Extinction [532 nm, 1/km] along ER-2 Track: '+datewant, $
          charsize=.8, /normal

  makekey, 0.15, .085, .8, .05, 0, -.05, align=0, charsize=.65, $
   color=colorarray, label=strcompress(string(levelarray,format='(f5.3)'),/rem)

  device, /close

  cmd = 'convert -density 150 '+fileps+' '+filepng
  spawn, cmd



; Make a plot
  set_plot, 'ps'
  fileps  = './aot_er2.'+datewant+'.ps'
  filepng = './aot_er2.'+datewant+'.png'
  device, file=fileps, font_size=14, /helvetica, $
   xoff=.5, yoff=.5, xsize=18, ysize=10, /color
  !p.font=0

  position=[.15,.3,.95,.9]
  contour, tau, gmt, reform(hght[0,*])/1000., /nodata, $
   yrange=[0,20],ythick=3, ystyle=9, $
   xstyle=9,  xthick=3, position=position, $
   xrange=[hh0*3600.,hh1*3600.], xticks=nmajor, xminor=nminor, xtickname=ticklabel
  levelarray = findgen(10)*.05+0.05
  levelarray = findgen(10)*.025+0.025
  loadct, 39
  colorarray = [30,64,80,96,144,176,192,199,208,254]
  plotgrid, tau, levelarray, colorarray, gmt, hght/1000., dgmt, dz/1000.
  contour, tau, gmt, reform(hght[0,*])/1000., /nodata, /noerase, $
   yrange=[0,20], ytitle = 'altitude [km]', ythick=3, ystyle=9, $
   xstyle=9, xtitle='hours gmt', xthick=3, position=position, $
   xrange=[hh0*3600.,hh1*3600.], xticks=nmajor, xminor=nminor, xtickname=ticklabel
  xyouts, .15, .92, 'GEOS-5 AOT [532 nm] above level along ER-2 Track: '+datewant, $
          charsize=.8, /normal

  makekey, 0.15, .085, .8, .05, 0, -.05, align=0, charsize=.65, $
   color=colorarray, label=strcompress(string(levelarray,format='(f5.3)'),/rem)

  device, /close

  cmd = 'convert -density 150 '+fileps+' '+filepng
  spawn, cmd


; Make a text file of the column tau versus time.
  openw, lun, 'aot_er2.'+datewant+'.txt', /get_lun
  for ix = 0, nx-1 do begin
   a = where(hght[ix,*]/1000. gt 5)
   printf, lun, gmt[ix], tau[ix,0], tau[ix,0]-tau[ix,a[0]], total(taudust[ix,*])/2.2
  endfor
  free_lun, lun


  a = where(gmt ge 15.*3600.)
  openw, lun, 'ext_er2.'+datewant+'.20070719_1500z.txt', /get_lun
  for iz = 0, nz-1 do begin
   printf, lun, hght[a[0],iz]/1000., ext[a[0],iz]*1000.
  endfor
  free_lun, lun


end
