; Test the swelling parameterizations (Gerber 1985
; and Fitzgerald 1975)
; Colarco, Feb. 2011

; Select particle size and density
  radius = 1.e-6
  rhop   = 2200.
  rhow   = 1000.

; "Sat" is the relative humidity
  rh  = findgen(100)*.01
  nrh = n_elements(rh)

; Fitzgerald (1975)
  epsilon = 1.
  alphaNaCl = 1.35
  r_fitz = fltarr(nrh)
  rhop_fitz = fltarr(nrh)
  for i = 0, nrh-1 do begin
   sat = min([rh[i],.995])
   if(sat lt .8) then begin
    r_fitz[i]    = radius
    rhop_fitz[i] = rhop
   endif else begin
;   Calculate the alpha and beta parameters for the wet particle
;   relative to amonium sulfate
    beta = exp( (0.00077*sat) / (1.009-sat) )
    if(sat le 0.97) then theta = 1.058 else $
                         theta = 1.058 - (0.0155*(sat-0.97)) /(1.02-sat^1.4)
    alpha1 = 1.2*exp( (0.066*sat) / (theta-sat) )
    f1 = 10.2 - 23.7*sat + 14.5*sat^2.
    f2 = -6.7 + 15.5*sat - 9.2*sat^2.
    alpharat = 1. - f1*(1.-epsilon) - f2*(1.-epsilon^2.)
    alpha = alphaNaCl * (alpha1*alpharat)
;   r_fitz is the radius of the wet particle
    r_fitz[i]    = alpha * radius^beta
    rrat         = (radius/r_fitz[i])^3.
    rhop_fitz[i] = rrat*rhop + (1.-rrat)*rhow
   endelse
  endfor

; Gerber 1985
  c1=0.7674
  c2=3.079
  c3=2.573e-11
  c4=-1.424
  r_gerber    = fltarr(nrh)
  rhop_gerber = fltarr(nrh)
  for i = 0, nrh-1 do begin
   sat = min([rh[i],.995])
   rcm = radius*100.
   r_gerber[i]    = 0.01 * (   c1*rcm^c2 / (c3*rcm^c4-alog10(sat)) $
                             + rcm^3.)^(1./3.)
   rrat           = (radius/r_gerber[i])^3.
   rhop_gerber[i] = rrat*rhop + (1.-rrat)*rhow
  endfor

; Opac SSCM
  rh_opac = [0,.5,.7,.8,.9,.95,.98,.99]
  r_sscm  = [1.75, 2.82, 3.17, 3.49, 4.18, 5.11, 6.84, 8.59]*1e-6
  r_ssam  = [.209, .336, .378, .416, .497, .605, .801, .995]*1e-6



; plot growth factors
  plot, rh, r_gerber/r_gerber[0], thick=6
  oplot, rh, r_fitz/r_fitz[0], lin=2, thick=6
  plots, rh_opac, r_sscm/r_sscm[0], psym=4
  plots, rh_opac, r_ssam/r_ssam[0], psym=2


end
