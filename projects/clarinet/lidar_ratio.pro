; Make a plot of the lidar ratio as function of initial particle size
; distribution

; File to use for optics
  opticsfile = '/home/colarco/sandbox/radiation/x/carma_optics_DU.v15.nbin=44.nc'
  readoptics, opticsfile, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

  nbin = 44
  rmrat = (15.d/.05d)^(3.d/nbin)
  rmin = 0.05d-6
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, r, rup, dr, rlow, masspart

  set_plot, 'ps'
  device, file='lidar_ratio.ps', /color, /helvetica, font_size=14
  !p.font=0
  loadct, 39

  nlam = 3
  bextv = fltarr(nbin,nlam)
  bbckv = fltarr(nbin,nlam)

; 354 nm
  bextV[*,0] = reform(bext[2,0,*])
  bbckV[*,0] = reform(bbck[2,0,*])

; 550 nm
  bextV[*,1] = reform(bext[5,0,*])
  bbckV[*,1] = reform(bbck[5,0,*])

; 1020
  bextV[*,2] = reform(bext[8,0,*])
  bbckV[*,2] = reform(bbck[8,0,*])

  plot, findgen(10), /nodata, $
   xrange=[0.5,5], xstyle=1, yrange=[0,200], ystyle=9, thick=3, $
   ytitle='lidar ratio', xtitle='volume median radius [um]', $
   title='lidar ratio for lognormal distribution', $
   position=[.1,.1,.9,.9]

;  Foreach of three width distributions compute the spectral lidar
;  ratio
   sigma = 2.

;  Normalize to tau = 1 at 550 nm
   color=[48,176,254]
   ns = 11
   rat2    = fltarr(ns,nlam)
   for ilam = 0, nlam-1 do begin
    r1 = findgen(11)*.5 + .5
    rat     = fltarr(ns)
    for i = 0, ns-1 do begin

     r1_ = r1[i]*1.e-6
     s1 = sigma
     p1 = 1.
     lognormal, r1_, s1, p1, r, dr, dndr, dsdr, dvdr, rlow=rlow, rup=rup, /vol
     dv  = dvdr*dr
     tau = total(bext[*,1]*dv)
     dv  = dv / tau

     rat[i] = total(bextv[*,ilam]*dv)/total(bbckv[*,ilam]*dv)
     rat2[i,ilam] = total(bbckv[*,ilam]*dv)/total(bbckv[*,1]*dv)
    endfor
    oplot, r1, rat, thick=5, color=color[ilam]
   endfor

;  Now some special cases
;  Schulz et al. 1998
   r1 = 1.26d-6
   s1 = 2.0
   p1 = 1.
   lognormal, r1, s1, p1, r, dr, dndr, dsdr, dvdr, rlow=rlow, rup=rup, /vol
   dv  = dvdr*dr
   tau = total(bext[*,1]*dv)
   dv  = dv / tau
   reff = total(r^3*dndr*dr)/total(r^2*dndr*dr)
   dndr = dndr/tau
   psym = 4
   for ilam = 0, 2 do begin
    plots, reff*1e6, total(bextv[*,ilam]*dv)/total(bbckv[*,ilam]*dv), color=color[ilam], psym=sym(1)
   endfor

;  D'Almedia background dust 1987 (from Zender 2003 Table 1)
   r1 = [.832,4.82,19.38]*0.5*1.e-6  ; radius in m
   s1 = [2.1,1.9,1.6]
   p1 = [.036,.957,.007]
   lognormal, r1, s1, p1, r, dr, dndr, dsdr, dvdr, rlow=rlow, rup=rup, /vol
   dv  = dvdr*dr
   tau = total(bext[*,1]*dv)
   dv  = dv / tau
   reff = total(r^3*dndr*dr)/total(r^2*dndr*dr)
   dndr = dndr/tau
   psym = 5
   for ilam = 0, 2 do begin
    plots, reff*1e6, total(bextv[*,ilam]*dv)/total(bbckv[*,ilam]*dv), color=color[ilam], psym=sym(2)
   endfor

;  Kok PSD 
   r_  = r*1d6
   dr_ = dr*1d6
   kok_psd, r_, dr_, dvdr, dndr
   dv  = dvdr*dr
   tau = total(bext[*,1]*dv)
   dv  = dv / tau
   reff = total(r^3*dndr*dr)/total(r^2*dndr*dr)
   dndr = dndr/tau
   psym = 5
   for ilam = 0, 2 do begin
    plots, reff*1e6, total(bextv[*,ilam]*dv)/total(bbckv[*,ilam]*dv), color=color[ilam], psym=sym(5)
   endfor


; Ratio of backscatter at lambda to 550 nm
   r1 = findgen(11)*.5 + .5
   axis, yaxis=1, yrange=[0,2], ytitle='Back_lam/Back_550 (dashed)', /save
   oplot, r1, rat2[*,0], color=color[0], lin=2, thick=5
   oplot, r1, rat2[*,1], color=color[1], lin=2, thick=5
   oplot, r1, rat2[*,2], color=color[2], lin=2, thick=5


;  Now some special cases
;  Schulz et al. 1998
   r1 = 1.26d-6
   s1 = 2.0
   p1 = 1.
   lognormal, r1, s1, p1, r, dr, dndr, dsdr, dvdr, rlow=rlow, rup=rup, /vol
   dv  = dvdr*dr
   tau = total(bext[*,1]*dv)
   dv  = dv / tau
   reff = total(r^3*dndr*dr)/total(r^2*dndr*dr)
   dndr = dndr/tau
   psym = 4
   for ilam = 0, 2 do begin
    plots, reff*1e6, total(bbckv[*,ilam]*dv)/total(bbckv[*,1]*dv), color=color[ilam], psym=sym(6)
   endfor

;  D'Almedia background dust 1987 (from Zender 2003 Table 1)
   r1 = [.832,4.82,19.38]*0.5*1.e-6  ; radius in m
   s1 = [2.1,1.9,1.6]
   p1 = [.036,.957,.007]
   lognormal, r1, s1, p1, r, dr, dndr, dsdr, dvdr, rlow=rlow, rup=rup, /vol
   dv  = dvdr*dr
   tau = total(bext[*,1]*dv)
   dv  = dv / tau
   reff = total(r^3*dndr*dr)/total(r^2*dndr*dr)
   dndr = dndr/tau
   psym = 5
   for ilam = 0, 2 do begin
    plots, reff*1e6, total(bbckv[*,ilam]*dv)/total(bbckv[*,1]*dv), color=color[ilam], psym=sym(7)
   endfor

;  Kok PSD 
   r_  = r*1d6
   dr_ = dr*1d6
   kok_psd, r_, dr_, dvdr, dndr
   dv  = dvdr*dr
   tau = total(bext[*,1]*dv)
   dv  = dv / tau
   reff = total(r^3*dndr*dr)/total(r^2*dndr*dr)
   dndr = dndr/tau
   psym = 5
   for ilam = 0, 2 do begin
    plots, reff*1e6, total(bbckv[*,ilam]*dv)/total(bbckv[*,1]*dv), color=color[ilam], psym=sym(10)
   endfor

device, /close

end
