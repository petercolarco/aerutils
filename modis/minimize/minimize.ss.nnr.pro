; Colarco, January 2011
; Based on conversation with Anton Darmenov
; Code to determine a multiplicative constant that minimizes the
; difference between some observational data set (e.g., MISR AOD) and
; some model data set (e.g., simulated AOD).

; The model is like this:
;  t_o  = observational data (e.g., AOD)
;  t_mi = model data (e.g., per species AOD)
;  t_ms = total of model data (e.g., sum of t_mi)
;  t_m  = total of model data with adjusted parameter
;         (e.g., f*t_mi(ss)+t_mi(du)+... where ss is the one adjusted)
;  f    = tuning constant for parameter-> seeking best value of this
;  y_o  = log transform of t_o (e.g., log10(t_0+.01))
;  y_m  = log transform of t_m
; What we want to do is plot
;  r(f) = sum ( (y_o - y_m)**2. * k(x,y,t) * dx*dy*dt)
; where we vary f and look for the minimum
;  k    = kernel function that selects weighting of points
;         (e.g., might choose to weight only where model ss is dominant)



; Observational data set
  ctl_o  = 'terra_nnr.ctl'
  dset_o = parsectl_dset(ctl_o)

; Model data set
  ctl_m  = 'model_nnr.ctl'
  ctl_m  = 'model_nnr.iter01.ctl'
  dset_m = parsectl_dset(ctl_m)

; Date range to integrate over
  nymd0 = '20080101'
  nhms0 = '000000'
  nymd1 = '20081231'
  nhms1 = '210000'
  dateexpand, nymd0, nymd1, nhms0, nhms1, nymd, nhms, tinc=180.

; Read in a masking map (e.g., to get only over ocean)
  filename = '../../data/b/colarco.regions_co.sfc.clm.nc4'
  nc4readvar, filename, 'comask', mask, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area
; retain only ocean points
  a = where(mask eq 0)
  b = where(mask gt 0)
  mask[b] = 0.
  mask[a] = 1.

; Set up the calculation
  nt  = n_elements(nymd)
  f   = findgen(101)*.02
  nf  = n_elements(f)
  rat_thresh = findgen(10)*.1
  nr  = n_elements(rat_thresh)
  r   = fltarr(nf,nt,nr)
;set_plot, 'ps'
  for it = 0, nt-1 do begin

;  Read the observation
   filename = strtemplate(dset_o,nymd[it],nhms[it])
   nc4readvar, filename, 'tau_', t_o, wanttime=[nymd[it],nhms[it]]
;  Screen fill values
   a = where(t_o gt 900.)
   if(a[0] ne -1) then t_o[a] = !values.f_nan
   y_o = alog10(t_o + .01)

;  Read the model
   filename = strtemplate(dset_m,nymd[it],nhms[it])
;   varlist = ['du','SO4','BC','OC']
;   nc4readvar, filename, varlist, tau, wantlev=5.5e-7, wanttime=[nymd[it],nhms[it]], /sum, /template
;   nc4readvar, filename, 'ss', tss, wantlev=5.5e-7, wanttime=[nymd[it],nhms[it]], /sum, /template
   varlist = ['duexttau','ocexttau','bcexttau','suexttau']
   nc4readvar, filename, varlist, tau, wanttime=[nymd[it],nhms[it]], /sum, /template
   nc4readvar, filename, 'ssexttau', tss, wanttime=[nymd[it],nhms[it]], /sum, /template

;  Loop over the tuning constants
   for iff = 0, nf-1 do begin

;  Loop over thresholds
   for ir = 0, nr-1 do begin

;   Develop the kernel function
;   only where misr obs and over ocean
    k = mask
    a = where(finite(y_o) ne 1)
    if(a[0] ne -1) then k[a] = 0.
;   And now where the adjusted ss AOD > 80% of total
;    rat = f[iff]*tss / (f[iff]*tss + tau)
    rat = tss / (tss + tau)
    a = where(rat lt rat_thresh[ir])
    if(a[0] ne -1) then k[a] = 0.

;   Now get the cost function
    y_m = alog10((f[iff]*tss + tau) + .01)
    r[iff,it,ir] = total( (y_o - y_m)^2. * k * area, /nan)
;contour, k,title=f[iff]

   endfor

   endfor
   print, nymd[it], ' ', nhms[it], mean(t_o,/nan), mean(tss)

  endfor
  r_ = total(r,2)

; normalize result
  r_ = r_/max(r_)

  save, file='terra.2008.sav', /all

  set_plot, 'ps'
  device, file='ss_minimize.terra_2008.iter01.ps', /helvetica, font_size=12, /color
  !p.font=0

  loadct, 39

; Find min of each curve
  x = fltarr(nr)
  y = fltarr(nr)
  for ir = 0, nr-1 do begin & y[ir] = min(r_[*,ir],i) & x[ir] = f[i] & endfor
   

  plot, f, r_[*,0], /nodata, $
   position = [.1,.1,.95,.9], $
   xtitle = 'tuning constant', ytitle='cost function (normalized)', $
   title = 'Sea salt minimization vs. Terra, R_qf21_23_22 (2008)!Ckernel = step function'
  oplot, f, r_[*,0], color=254
  oplot, f, r_[*,1], color=254, lin=1
  oplot, f, r_[*,2], color=254, lin=2
  oplot, f, r_[*,3], color=208
  oplot, f, r_[*,4], color=208, lin=1
  oplot, f, r_[*,5], color=208, lin=2
  oplot, f, r_[*,6], color=176
  oplot, f, r_[*,7], color=176, lin=1
  oplot, f, r_[*,8], color=176, lin=2
  oplot, f, r_[*,9], color=84
  oplot, x, y, thick=2


  device, /close


end
