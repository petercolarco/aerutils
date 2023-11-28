; Colarco, November 2006
; Goal is to compare the accumulated precipitation from g4dust and u000_c32 runs
  wanttime = ['200001','200412']

; Get the CERES run precip
  ctlfile = '/output/colarco/GEOS4_CER/tavg2d_eng_x/tavg2d_eng_x.template.ddf'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=timec, wanttime = ['20000115','20060615']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  ntc = n_elements(timec)
  preacc_c = fltarr(ntc)
  for it = 0, ntc-1 do begin
   preacc_c[it] = aave(preacc[*,*,it],area)
  endfor

; Get the B32 run precip
  ctlfile = 'carmaDust.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=timec, wanttime = ['200001','200606']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  ntc = n_elements(timec)
  preacc_b32 = fltarr(ntc)
  for it = 0, ntc-1 do begin
   preacc_b32[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u001_b55 run precip
;  ctlfile = 'u001_b55.ctl'
  ctlfile = 't001_b55.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200001','200512']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt = n_elements(time)
  preacc_u1 = fltarr(nt)
  for it = 0, nt-1 do begin
   preacc_u1[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u002_b55 run precip
  ctlfile = 'u002_b55.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200001','200012']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt = n_elements(time)
  preacc_u2 = fltarr(nt)
  for it = 0, nt-1 do begin
   preacc_u2[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u003_b55 run precip
;  ctlfile = 'u003_b55.ctl'
  ctlfile = 't002_b55.chem_diag.sfc.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200001','200512']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt = n_elements(time)
  preacc_u3 = fltarr(nt)
  for it = 0, nt-1 do begin
   preacc_u3[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u004_b55 run precip
  ctlfile = 'u004_b55.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200001','200012']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt = n_elements(time)
  preacc_u4 = fltarr(nt)
  for it = 0, nt-1 do begin
   preacc_u4[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u008_b55 run precip
  ctlfile = 'u008_b55.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200001','200012']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt = n_elements(time)
  preacc_u8 = fltarr(nt)
  for it = 0, nt-1 do begin
   preacc_u8[it] = aave(preacc[*,*,it],area)
  endfor

; Get the g4dust_b55r8.ctl run precip
  ctlfile = 'g4dust_b55r8.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200001','200604']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  ntg = n_elements(time)
  preacc_g4 = fltarr(ntg)
  for it = 0, ntg-1 do begin
   preacc_g4[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u000_c32_c.ctl run precip
;  ctlfile = 'u000_c32_c.ctl'
  ctlfile = 't003_c32.chem_diag.sfc.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200001','200512']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt = n_elements(time)
  preacc_c32 = fltarr(nt)
  for it = 0, nt-1 do begin
   preacc_c32[it] = aave(preacc[*,*,it],area)
  endfor

; Get the intex_2006.ctl run precip
  ctlfile = 'intex_2006.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200603','200606']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt_ = n_elements(time)
  preacc_cr = fltarr(nt_)
  for it = 0, nt_-1 do begin
   preacc_cr[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u006_c55.ctl run precip
  ctlfile = 'u006_c55.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200603','200606']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt_ = n_elements(time)
  preacc_u6 = fltarr(nt_)
  for it = 0, nt_-1 do begin
   preacc_u6[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u009_c55.ctl run precip
  ctlfile = 'u009_c55.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200603','200606']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt_ = n_elements(time)
  preacc_u9 = fltarr(nt_)
  for it = 0, nt_-1 do begin
   preacc_u9[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u010_c55.ctl run precip
  ctlfile = 'u010_c55.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200603','200606']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt_ = n_elements(time)
  preacc_u10 = fltarr(nt_)
  for it = 0, nt_-1 do begin
   preacc_u10[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u011_c55.ctl run precip
  ctlfile = 'u011_c55.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200603','200606']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt_ = n_elements(time)
  preacc_u11 = fltarr(nt_)
  for it = 0, nt_-1 do begin
   preacc_u11[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u012_c55.ctl run precip
  ctlfile = 'u012_c55.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200603','200606']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt_ = n_elements(time)
  preacc_u12 = fltarr(nt_)
  for it = 0, nt_-1 do begin
   preacc_u12[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u013_c32.ctl run precip
  ctlfile = 'u013_c32.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200603','200606']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt_ = n_elements(time)
  preacc_u13 = fltarr(nt_)
  for it = 0, nt_-1 do begin
   preacc_u13[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u014_c55.ctl run precip
  ctlfile = 'u014_c55.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200603','200606']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt_ = n_elements(time)
  preacc_u14 = fltarr(nt_)
  for it = 0, nt_-1 do begin
   preacc_u14[it] = aave(preacc[*,*,it],area)
  endfor

; Get the u015_c55.ctl run precip
  ctlfile = 'u015_c55.ctl'
  ga_getvar, ctlfile, 'preacc', preacc, lon=lonc, lat=latc, time=time, wanttime=['200603','200606']
  preacc  = reform(preacc)
  area, lonc, latc, nx, ny, dxx, dyy, area
  nt_ = n_elements(time)
  preacc_u15 = fltarr(nt_)
  for it = 0, nt_-1 do begin
   preacc_u15[it] = aave(preacc[*,*,it],area)
  endfor


; setup the tick marks on the x-axis of date
; What is the frequency of tick marks desired (in months)
  nn = 3
  ntick = n_elements(timec)/nn
  while(ntick gt 60) do begin
   nn = nn*4
   ntick = n_elements(timec)/nn
  endwhile
; Default is to fill in every 4th tick
  tickname=replicate(' ', ntick+1)
  for it = 1, ntick, 4 do begin
   tickname[it] = strmid(timec[it*nn+2],0,7)
  endfor



  set_plot, 'ps'
  device, file='./output/preacc.ps', /helvetica, font_size=12, /color, $
   xsize=16, ysize=10, xoff=.5, yoff=.5
  !P.font=0
  loadct, 39

  plot, indgen(nt), preacc_c32, /nodata, thick=3, $
   xtitle = 'Month', ytitle='PREACC [mm/day]', $
   xticks=ntick, xtickv=(indgen(ntick)+1)*nn, xtickname=tickname, $
   title='Accumulated Precipitation [monthly, 200001 - 200606]', $
   xrange=[0,nt], yrange=[2,5], xstyle=9, ystyle=9
  oplot, indgen(12), preacc_u8, lin=0, thick=12, color=208
  oplot, indgen(72), preacc_u1, lin=2, thick=6, color=254
  oplot, indgen(ntc), preacc_c, lin=0, thick=6
  oplot, indgen(ntc), preacc_b32, lin=1, thick=6, color=176
  oplot, indgen(72), preacc_c32, thick=6, color=84
  oplot, indgen(12), preacc_u2, thick=6, color=254
  oplot, indgen(ntg), preacc_g4, lin=1, thick=6
  oplot, indgen(72), preacc_u3, lin=2, thick=6, color=0
  oplot, indgen(12), preacc_u4, lin=2, thick=6, color=84
  oplot, indgen(4)+74, preacc_cr, thick=6, color=176
  oplot, indgen(4)+74, preacc_u6, thick=6, color=84, lin=1
  oplot, indgen(4)+74, preacc_u9, thick=6, color=48, lin=0
  oplot, indgen(4)+74, preacc_u10, thick=6, color=176, lin=2
  plots, indgen(4)+74, preacc_u11, thick=2, color=32
  plots, indgen(4)+74, preacc_u12, thick=6, color=32
  plots, indgen(4)+74, preacc_u13, thick=6, color=190
  plots, indgen(4)+74, preacc_u14, thick=6, color=32, lin=2
  plots, indgen(4)+74, preacc_u15, thick=6, color=48, lin=2


  plots, [2,6],4.9, thick=6
  xyouts, 7, 4.85, 'CERES (c55)', charsize=.75

  plots, [2,6],4.75, thick=6, color=84
;  xyouts, 7, 4.7, 'Ave ANA/no-q (c32)', charsize=.75
  xyouts, 7, 4.7, 'Int ANA/no-q (c32)', charsize=.75

  plots, [2,6],4.6, thick=6, color=254
  xyouts, 7, 4.55, 'Ave ANA/no-q (b55)', charsize=.75

  plots, [2,6],4.45, thick=6, lin=1, color=0
  xyouts, 7, 4.4, 'Ave ANA/no-q (b55,ravig4)', charsize=.75

  plots, [2,6],4.3, thick=12, lin=0, color=208
  xyouts, 7, 4.25, 'Ave ANA (from c55)/no-q (b55)', charsize=.75

  plots, [2,6],4.15, thick=2, color=32
  xyouts, 7, 4.1, 'Ave ANA/q/no-fix/no-dryfix (c55)', charsize=.75

  plots, [2,6],4., color=190, thick=6
  xyouts, 7, 3.95, 'Ave ANA/no-q (c32)', charsize=.75

  plots, [2,6], 3.85, color=32, lin=2, thick=6
  xyouts, 7, 3.8, 'Ave ANA/no-q (c55)', charsize=.75



  plots, [32,36],4.9, thick=6, lin=2, color=254
  xyouts, 37, 4.85, 'GCM (b55)', charsize=.75

  plots, [32,36],4.75, thick=6, lin=2, color=0
  xyouts, 37, 4.7, 'Int ANA/no-q (b55)', charsize=.75

  plots, [32,36],4.6, thick=6, lin=2, color=84
  xyouts, 37, 4.55, 'Ave ANA/q (b55)', charsize=.75

  plots, [32,36],4.45, thick=6, lin=0, color=176
  xyouts, 37, 4.4, 'INTEX-2006 Ave ANA/no-q (c55)', charsize=.75

  plots, [32,36],4.3, thick=6, lin=1, color=84
  xyouts, 37, 4.25, 'Int ANA/no-q/no-fix (c55)', charsize=.75

  plots, [32,36],4.15, thick=6, lin=0, color=48
  xyouts, 37, 4.1, 'Int ANA/no-q/no-fix/no-dryfix (c55)', charsize=.75

  plots, [32,36],4.0, thick=6, lin=2, color=176
  xyouts, 37, 3.95, 'Int ANA/q/no-fix/no-dryfix (c55)', charsize=.75

  plots, [32,36],3.85, thick=6, color=32
  xyouts, 37, 3.8, 'Ave ANA/no-q/no-fix/no-dryfix (c55)', charsize=.75

  plots, [32,36],2.4, thick=6, color=176, lin=1
  xyouts, 37, 2.35, 'Int ANA/no-q (b32)', charsize=.75

  plots, [32,36],2.25, thick=6, color=48, lin=2
  xyouts, 37, 2.2, 'Pete Ave ANA/no-q (c55)', charsize=.75

  device, /close

end

