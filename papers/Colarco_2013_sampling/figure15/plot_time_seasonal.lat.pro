; Previously ran "time_seasonal.pro" to generate sav file
; Get the seasonal time series information
  restore, filename='time_seasonal.lat.sav'

; Now develop the envelopes for the max/min in each region
  reg_aot_max = fltarr(ny*nseas,nreg)
  reg_aot_min = fltarr(ny*nseas,nreg)
  reg_aot_maxx3 = fltarr(ny*nseas,nreg)
  reg_aot_minx3 = fltarr(ny*nseas,nreg)
  reg_sam_max = lonarr(ny*nseas,nreg)
  reg_sam_min = lonarr(ny*nseas,nreg)
  reg_sam_maxx3 = lonarr(ny*nseas,nreg)
  reg_sam_minx3 = lonarr(ny*nseas,nreg)

  reg_aot_max_c = fltarr(ny*nseas,nreg)
  reg_aot_min_c = fltarr(ny*nseas,nreg)
  reg_aot_max_n = fltarr(ny*nseas,nreg)
  reg_aot_min_n = fltarr(ny*nseas,nreg)

  for iy = 0, ny*nseas-1 do begin
   for ireg = 0, nreg- 1 do begin
    reg_aot_max[iy,ireg] = max(reg_aot[iy,ireg,*],i)
    reg_sam_max[iy,ireg] = i
    reg_aot_min[iy,ireg] = min(reg_aot[iy,ireg,*],i)
    reg_sam_min[iy,ireg] = i

   endfor
  endfor

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

  for ireg = 0, 7 do begin

  nstr = strpad(ireg+1,10)

  device, file='plot_time_seasonal.lat.'+nstr+'.eps', /color, /helvetica, font_size=12, /encap
  !p.font=0
  loadct, 39

  y = [reg_aot_min[*,ireg], reg_aot_max[*,ireg]]
  y = reform(y,ny*nseas,2)

;  yp = [reg_aot_minx3[*,ireg], reg_aot_maxx3[*,ireg]]
;  yp = reform(yp,ny*nseas,2)

;  yc = [reg_aot_min_c[*,ireg], reg_aot_max_c[*,ireg]]
;  yc = reform(yc,ny*nseas,2)

;  yn = [reg_aot_min_n[*,ireg], reg_aot_max_n[*,ireg]]
;  yn = reform(yn,ny*nseas,2)

  delta  = y[*,1]-y[*,0]
;  deltap = yp[*,1]-yp[*,0]
;  deltac = yc[*,1]-yc[*,0]
;  deltan = yn[*,1]-yn[*,0]
  frac   = delta / reg_aot[*,ireg,0]
;  fracp  = deltap / reg_aot[*,ireg,0]
  plot, x, delta, /nodata, $
   ytitle = '!9D!3AOT', $
;   position = [0.1,0.15,0.9,0.9], $
   xrange=[0,41], xstyle=1, xticks=41, xtickn=make_array(42,val=' '), $
   xthick=6, ythick=6, title=regstr[ireg], $
   position=[.15,.4,.95,.95]
  oplot, x, delta, thick=8
;  oplot, x, deltac, thick=8, color=75
;  oplot, x, deltan, thick=8, color=254
;  oplot, x, deltap, thick=10, lin=2
  if(ireg eq 0) then begin
;   plots, [10,13], .074, thick=8
;   plots, [10,13], .066, thick=10, lin=2
;   xyouts, 14, .073, '!9D!3AOT (all samples)', charsize=.8
;   xyouts, 14, .065, '!9D!3AOT (exclude C3, N3)', charsize=.8
;   plots, [26,29], .074, thick=8, color=254
;   plots, [26,29], .066, thick=8, color=75
;   xyouts, 30, .073, '!9D!3AOT (FS, C1, C2, C4)', charsize=.8
;   xyouts, 30, .065, '!9D!3AOT (FS, N1, N2, N4)', charsize=.8
  endif

  plot, x, delta, /nodata, /noerase, $
   ytitle = 'AOT!DFull Swath!N!C!CFraction of AOT!DFull Swath!N', yrange=[0,1], $
   xrange=[0,41], xstyle=1, xticks=41, xtickn=make_array(42,val=' '), $
   xthick=6, ythick=6, $
   position=[.15,.1,.95,.4], yticks=5, ytickn=['0.0','0.2','0.4','0.6','0.8', ' ']
  oplot, x, frac, thick=8, lin=2
  oplot, x, reg_aot[*,ireg,0], thick=8
  for ix = 0, 41 do begin
   xyouts, ix, -0.05, xtn[ix], orient=-45, charsize=.5
  endfor
  for ix = 2, 41, 4 do begin
   year = strpad((ix-2)/4+2003,1000L)
   xyouts, ix, -0.25, year, align=0
  endfor

  if(ireg eq 0) then begin
   plots, [24,27], .8, thick=8
   plots, [24,27], .65, thick=8, lin=2
   xyouts, 28, .78, 'AOT!DFull Swath!N', charsize=.8
   xyouts, 28, .63, '!9D!3AOT fraction of AOT!DFull Swath!N', charsize=.8
  endif

  r2 = string(correlate(delta,reg_aot[*,ireg,0])^2.,format='(f5.2)')
  xyouts, 3, .78, 'r!E2!N!DAOT!N = '+r2, charsize=.8
  r2 = string(correlate(delta,frac)^2.,format='(f5.2)')
  xyouts, 3, .63, 'r!E2!N!Dfraction!N = '+r2, charsize=.8

  device, /close

  endfor


end
