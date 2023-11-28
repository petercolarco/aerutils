; Compare to MERRA-2 AOD
  resolution = 'c180'
  case resolution of
   'c90' : grid = 'c'
   'c48' : grid = 'b'
   'c180': grid = 'd'
  endcase

  set_plot, 'ps'
  device, file='merra2_comp.'+resolution+'.ps', /helvetica, font_size=14, /color, $
   xoff=.5, yoff=.5, xsize=24, ysize=14
  !p.font=0
  !p.multi=[0,3,2]

  vars = ['totexttau','duexttau','ssexttau','ocexttau','suexttau','niexttau']
  title = ['Total AOD', 'Dust', 'Sea Salt', 'Particulate Organic Matter', 'Sulfate', 'Nitrate']

  for i = 0, 5 do begin
print, i
  expid = resolution+'F_H54p3-acma'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, vars[i], cFtot, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  cFtot = aave(cFtot,area)

  expid = resolution+'R_H54p3-acma'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, vars[i], cRtot, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  cRtot = aave(cRtot,area)

  expid = resolution+'Rreg_H54p3-acma'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, vars[i], cRrtot, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  cRrtot = aave(cRrtot,area)

  expid = resolution+'ctm_H54p3-acma'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, vars[i], cCTMtot, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  cCTMtot = aave(cCTMtot,area)

  loadct, 39
  yrange = [0,0.08]
  if(vars[i] eq 'totexttau') then yrange=[0,0.25]
  if(vars[i] eq 'niexttau') then yrange = [0.,0.01]
  x = findgen(12)+1
  plot, x, cFtot, thick=6, yrange=yrange, $
        xrange=[0,13], xstyle=1, xticks=13, $
        xtickn = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' '], $
        title=title[i], /nodata

  if(vars[i] eq 'totexttau') then begin
   plots, [1,3], .1, thick=10
   plots, [1,3], .08, thick=6, color=176
   plots, [1,3], .06, thick=6, color=254
   plots, [1,3], .04, thick=6, color=84
   plots, [1,3], .02, thick=6, color=208
   xyouts, 3.5, .095, 'MERRA-2', charsize=.6
   xyouts, 3.5, .075, 'Free', charsize=.6
   xyouts, 3.5, .055, 'Replay!Dinstantaneous!N', charsize=.6
   xyouts, 3.5, .035, 'Replay!Dincremental!N', charsize=.6
   xyouts, 3.5, .015, 'CTM', charsize=.6
  endif

  if(vars[i] ne 'niexttau') then begin
   expid = 'merra2'
   filetemplate = 'merra2.ctl'
   ga_times, filetemplate, nymd, nhms, template=template
   filename=strtemplate(template,nymd,nhms)
   nc4readvar, filename, vars[i], m2tot, lon=lon, lat=lat
   area, lon, lat, nx, ny, dx, dy, area, grid='d'
   m2tot = aave(m2tot,area)
   oplot, x, m2tot, thick=10
  endif

  fac = 1.
;  if(vars[i] eq 'duexttau') then fac = 1.20
;  if(vars[i] eq 'ssexttau') then fac = 0.8
  oplot, x, cFtot*fac, thick=6, color=176
  oplot, x, cRtot*fac, thick=6, color=254
  oplot, x, cRrtot*fac, thick=6, color=84
  oplot, x, cCTMtot*fac, thick=6, color=208

; Get the non-SOA AOD
  if(vars[i] eq 'ocexttau') then begin
  expid = resolution+'F_H54p3-acma'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ocexttauanth','ocexttaubiob'], cFtot, lon=lon, lat=lat, /sum
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  cFtot = aave(cFtot,area)

  expid = resolution+'R_H54p3-acma'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ocexttauanth','ocexttaubiob'], cRtot, lon=lon, lat=lat, /sum
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  cRtot = aave(cRtot,area)

  expid = resolution+'Rreg_H54p3-acma'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, ['ocexttauanth','ocexttaubiob'], cRrtot, lon=lon, lat=lat, /sum
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  cRrtot = aave(cRrtot,area)

  expid = resolution+'ctm_H54p3-acma'
  filetemplate = expid+'.tavg2d_aer_x.ctl'
  ga_times, filetemplate, nymd, nhms, template=template
  filename=strtemplate(template,nymd,nhms)
  nc4readvar, filename, vars[i], cCTMtot, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  cCTMtot = aave(cCTMtot,area)

  oplot, x, cFtot*fac, thick=6, color=176, lin=2
  oplot, x, cRtot*fac, thick=6, color=254, lin=2
  oplot, x, cRrtot*fac, thick=6, color=84, lin=2
  oplot, x, cCTMtot*fac, thick=6, color=208, lin=2

  endif


endfor

device, /close


end
