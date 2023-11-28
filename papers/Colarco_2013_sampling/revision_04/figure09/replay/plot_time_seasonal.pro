; Previously ran "time_seasonal.pro" to generate sav file
; Get the seasonal time series information

; Get the MODIS along-track
  restore, filename='../time_seasonal.along_track.sav'
;  restore, filename='time_seasonal.along_track.sample_then_average.sav'

; Now develop the envelopes for the max/min in each region
  reg_aot_max = fltarr(ny*nseas,nreg)
  reg_aot_min = fltarr(ny*nseas,nreg)
  reg_aot_maxx3 = fltarr(ny*nseas,nreg)
  reg_aot_minx3 = fltarr(ny*nseas,nreg)
  reg_sam_max = lonarr(ny*nseas,nreg)
  reg_sam_min = lonarr(ny*nseas,nreg)
  reg_sam_maxx3 = lonarr(ny*nseas,nreg)
  reg_sam_minx3 = lonarr(ny*nseas,nreg)

; curtain along-track only
  reg_aot_max_c = fltarr(ny*nseas,nreg)
  reg_aot_min_c = fltarr(ny*nseas,nreg)
; narrow along-track only
  reg_aot_max_n = fltarr(ny*nseas,nreg)
  reg_aot_min_n = fltarr(ny*nseas,nreg)
; across-track only
  reg_aot_max_l = fltarr(ny*nseas,nreg)
  reg_aot_min_l = fltarr(ny*nseas,nreg)
; across-track only - average-then-mask
  reg_aot_max_l2 = fltarr(ny*nseas,nreg)
  reg_aot_min_l2 = fltarr(ny*nseas,nreg)
; model along-track only
  reg_aot_max_m = fltarr(ny*nseas,nreg)
  reg_aot_min_m = fltarr(ny*nseas,nreg)
; model along-track only (forcing)
  reg_aot_max_f = fltarr(ny*nseas,nreg)
  reg_aot_min_f = fltarr(ny*nseas,nreg)
; model replay along-track only
  reg_aot_max_r = fltarr(ny*nseas,nreg)
  reg_aot_min_r = fltarr(ny*nseas,nreg)



  for iy = 0, ny*nseas-1 do begin
   for ireg = 0, nreg- 1 do begin
    reg_aot_max[iy,ireg] = max(reg_aot[iy,ireg,*],i)
    reg_sam_max[iy,ireg] = i
    reg_aot_min[iy,ireg] = min(reg_aot[iy,ireg,*],i)
    reg_sam_min[iy,ireg] = i
    reg_aot_maxx3[iy,ireg] = max(reg_aot[iy,ireg,0:7],i)
    reg_sam_maxx3[iy,ireg] = i
    reg_aot_minx3[iy,ireg] = min(reg_aot[iy,ireg,0:7],i)
    reg_sam_minx3[iy,ireg] = i

    reg_aot_max_c[iy,ireg] = max(reg_aot[iy,ireg,[0,5,6,7]],i)
    reg_aot_min_c[iy,ireg] = min(reg_aot[iy,ireg,[0,5,6,7]],i)
    reg_aot_max_n[iy,ireg] = max(reg_aot[iy,ireg,[0,2,3,4]],i)
    reg_aot_min_n[iy,ireg] = min(reg_aot[iy,ireg,[0,2,3,4]],i)
   endfor
  endfor

; Get the MODIS across-track (sample then average)
  restore, filename='../time_seasonal.across_track.sample_then_average.sav'
  for iy = 0, ny*nseas-1 do begin
   for ireg = 0, nreg- 1 do begin
    reg_aot_max_l[iy,ireg] = max(reg_aot[iy,ireg,*],i)
    reg_aot_min_l[iy,ireg] = min(reg_aot[iy,ireg,*],i)
   endfor
  endfor

; Get the MODIS across-track (average-then-mask)
  restore, filename='../time_seasonal.across_track.sav'
  for iy = 0, ny*nseas-1 do begin
   for ireg = 0, nreg- 1 do begin
    reg_aot_max_l2[iy,ireg] = max(reg_aot[iy,ireg,*],i)
    reg_aot_min_l2[iy,ireg] = min(reg_aot[iy,ireg,*],i)
   endfor
  endfor

; Get the model along-track
  restore, filename='../time_seasonal_model.dR_MERRA-AA-r2.noTERRA.sav'
  for iy = 0, ny*nseas-1 do begin
   for ireg = 0, nreg- 1 do begin
    reg_aot_max_m[iy,ireg] = max(reg_aot[iy,ireg,*],i)
    reg_aot_min_m[iy,ireg] = min(reg_aot[iy,ireg,*],i)
   endfor
  endfor

; Get the model along-track forcing
  restore, filename='../time_seasonal_model_surf.dR_MERRA-AA-r2.noTERRA.allsky.sav'
  for iy = 0, ny*nseas-1 do begin
   for ireg = 0, nreg- 1 do begin
    reg_aot_max_f[iy,ireg] = max(reg_aot[iy,ireg,*],i)
    reg_aot_min_f[iy,ireg] = min(reg_aot[iy,ireg,*],i)
   endfor
  endfor

; Get replay along-track
  restore, filename='time_seasonal_model.dR_F25b18.noTERRA.sav'
  for iy = 0, 9-1 do begin
   for isea = 0, nseas-1 do begin
   for ireg = 0, nreg- 1 do begin
    reg_aot_max_r[iy*nseas+isea,ireg] = max(reg_aot[isea,ireg,*],i)
    reg_aot_min_r[iy*nseas+isea,ireg] = min(reg_aot[isea,ireg,*],i)
   endfor
   endfor
  endfor


; And recover the MODIS along-track
  restore, filename='../time_seasonal.along_track.sav'


  x = findgen(ny*nseas)+1
;  y = [reg_aot_min[*,0], reg_aot_max[*,0]]
;  y = reform(y,ny*nseas,2)

; Plot the regional range time series due to sampling
;  plot, x, y[*,0], /nodata
;  loadct, 1
;  polymaxmin, x, y, fill=224, color=224

  sea = ['JFM','AMJ','JAS','OND']
  xtn = [' ', sea, sea, sea, sea, sea, sea, sea, sea, sea, sea, ' ']
  
; Plot instead as the magnitude of difference
  regstr = ['South America', 'Southern Africa', 'African Dust', 'Nile River', $
            'Indogangetic Plain', 'China', 'Southeast Asia', 'Asian Outflow']
  set_plot, 'ps'

; regional maximums
  ymax = [0.16, 0.04, 0.08, 0.25, 0.18, 0.16, 0.16, 0.08]

  for ireg = 0, 7 do begin

  nstr = strpad(ireg+1,10)

  device, file='plot_time_seasonal.'+nstr+'.eps', /color, /helvetica, font_size=12, /encap
  !p.font=0
  loadct, 39

  y = [reg_aot_min[*,ireg], reg_aot_max[*,ireg]]
  y = reform(y,ny*nseas,2)

  yp = [reg_aot_minx3[*,ireg], reg_aot_maxx3[*,ireg]]
  yp = reform(yp,ny*nseas,2)

  yc = [reg_aot_min_c[*,ireg], reg_aot_max_c[*,ireg]]
  yc = reform(yc,ny*nseas,2)

  yn = [reg_aot_min_n[*,ireg], reg_aot_max_n[*,ireg]]
  yn = reform(yn,ny*nseas,2)

  yl = [reg_aot_min_l[*,ireg], reg_aot_max_l[*,ireg]]
  yl = reform(yl,ny*nseas,2)

  yl2 = [reg_aot_min_l2[*,ireg], reg_aot_max_l2[*,ireg]]
  yl2 = reform(yl2,ny*nseas,2)

  ym = [reg_aot_min_m[*,ireg], reg_aot_max_m[*,ireg]]
  ym = reform(ym,ny*nseas,2)

  yr = [reg_aot_min_r[*,ireg], reg_aot_max_r[*,ireg]]
  yr = reform(yr,ny*nseas,2)

  yf = [reg_aot_min_f[*,ireg], reg_aot_max_f[*,ireg]]
  yf = reform(yf,ny*nseas,2)

  delta  = y[*,1]-y[*,0]
  deltap = yp[*,1]-yp[*,0]
print, deltap[10]
  deltac = yc[*,1]-yc[*,0]
  deltan = yn[*,1]-yn[*,0]
  deltam = ym[*,1]-ym[*,0]
  deltar = yr[*,1]-yr[*,0]
  deltaf = yf[*,1]-yf[*,0]
  deltal = yl[*,1]-yl[*,0]
  deltal2 = yl2[*,1]-yl2[*,0]
  frac   = delta / reg_aot[*,ireg,0]
  fracp  = deltap / reg_aot[*,ireg,0]

; Set up the plot for the main axis
  plot, x, deltap, /nodata, $
   ytitle = '!9D!3AOT', yrange=[0,ymax[ireg]], ystyle=9, $
   xrange=[0,41], xstyle=1, xticks=41, xtickn=make_array(42,val=' '), $
   xthick=6, ythick=6, title=regstr[ireg], $
   position=[.15,.4,.9,.95]

; Add the forcing to the plot
  loadct, 0
  axis, yaxis=1, ythick=6, /save, yrange=[0,max(deltaf)/4.], $
   ytitle='!9D!3Forcing [W m!E-2!N]', color=100
; Scale by factor of 4 to approximate diurnal average
  y = fltarr(n_elements(deltaf),2)
  y[*,1] = deltaf/4.
  polymaxmin, x, y, fill=200, color=200

; return to the main axis
  loadct, 39
  axis, yaxis=0, ythick=6, /save, ytitle = '!9D!3AOT', yrange=[0,ymax[ireg]], ystyle=9
;  oplot, x, delta, thick=8
  oplot, x, deltac, thick=10, color=254, lin=1
  oplot, x, deltan, thick=10, color=254, lin=2
  oplot, x, deltap, thick=8, color=254
  oplot, x, deltam, thick=8
  oplot, x, deltar, thick=8, lin=2
  oplot, x, deltal, thick=8, color=75
  oplot, x, deltal2, thick=8, color=75, lin=2
  if(ireg eq 0) then begin
   plots, [2,5], .0925*1.6, thick=8, color=254
   plots, [6,8], .086*1.6, thick=10, color=254, lin=1
   plots, [6,8], .080*1.6, thick=10, color=254, lin=2
   xyouts, 6, .091*1.6, '!9D!3AOT (along-track)', charsize=.8, color=254
   xyouts, 9, .085*1.6, 'FS, C1, C2, C4 only', charsize=.6, color=254
   xyouts, 9, .079*1.6, 'FS, N1, N2, N4 only', charsize=.6, color=254
   plots, [20,23], .0925*1.6, thick=8, color=75
   plots, [2,5], .075*1.6, thick=8
   xyouts, 24, .091*1.6, '!9D!3AOT (across-track)', charsize=.8, color=75
   plots, [24,26], .086*1.6, thick=10, color=75, lin=0
   plots, [24,26], .080*1.6, thick=10, color=75, lin=2
   xyouts, 27, .085*1.6, 'sample-then-average', charsize=.6, color=75
   xyouts, 27, .079*1.6, 'average-then-mask', charsize=.6, color=75
   xyouts, 6, .0735*1.6, '!9D!3AOT (MERRAero)', charsize=.8
   loadct, 0
   polyfill, [20,23,23,20,20], 1.6*[.073,.073,.077,.077,.073], color=200, /fill
   xyouts, 24, .0735*1.6, '!9D!3Forcing (MERRAero)', charsize=.8, color=100
   loadct, 39
  endif



  plot, x, delta, /nodata, /noerase, $
   ytitle = 'AOT!DFull Swath!N!C!CFraction of AOT!DFull Swath!N!C ', yrange=[0,0.8], $
   xrange=[0,41], xstyle=1, xticks=41, xtickn=make_array(42,val=' '), $
   xthick=6, ythick=6, $
   position=[.15,.1,.9,.4], yticks=4, ytickn=['0.0','0.2','0.4','0.6', ' ']
; plot range about full swath
  loadct, 3
  polymaxmin, x, yp, fillcolor=208, /noave
;stop
  loadct, 39
  oplot, x, fracp, thick=4, lin=2, color=254
  oplot, x, reg_aot[*,ireg,0], thick=4, color=254
  for ix = 0, 41 do begin
   xyouts, ix, -0.05, xtn[ix], orient=-45, charsize=.5
  endfor
  for ix = 2, 41, 4 do begin
   year = strpad((ix-2)/4+2003,1000L)
   xyouts, ix, -0.25, year, align=0
  endfor

  if(ireg eq 0) then begin
   plots, [23,26], .7, thick=4, color=254
   plots, [23,26], .6, thick=4, lin=2, color=254
   xyouts, 27, .68, 'AOT!DFull Swath!N', charsize=.8, color=254
   xyouts, 27, .58, '!9D!3AOT fraction of AOT!DFull Swath!N', charsize=.8, color=254
  endif

  r2 = string(correlate(deltap,reg_aot[*,ireg,0])^2.,format='(f5.2)')
  xyouts, 3, .68, 'r!E2!N!DAOT!N = '+r2, charsize=.8
  r2 = string(correlate(deltap,fracp)^2.,format='(f5.2)')
  xyouts, 3, .58, 'r!E2!N!Dfraction!N = '+r2, charsize=.8

  device, /close

  endfor


end
