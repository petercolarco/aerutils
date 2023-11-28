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
   nc4readvar, filename, '', t_o, wanttime=[nymd[it],nhms[it]]

;  Read the model
   filename = strtemplate(dset_m,nymd[it],nhms[it])
;   varlist = ['du','SO4','BC','OC']
;   nc4readvar, filename, varlist, tau, wantlev=5.5e-7, wanttime=[nymd[it],nhms[it]], /sum, /template
;   nc4readvar, filename, 'ss', tss, wantlev=5.5e-7, wanttime=[nymd[it],nhms[it]], /sum, /template
;   varlist = ['duexttau','ocexttau','bcexttau','suexttau']
;   nc4readvar, filename, '', tau, wanttime=[nymd[it],nhms[it]], /sum, /template
;   nc4readvar, filename, '', tss, wanttime=[nymd[it],nhms[it]], /sum, /template

   print, nymd[it], ' ', nhms[it]
  endfor

end
