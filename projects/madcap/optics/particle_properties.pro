; BC particle properties
  r0 = 0.0118e-6
  s0 = 2.0
  rho0 = 1000.

  nbin = 1000
  rmrat = (1.d-6/1.d-10)^(3.d/(nbin-1))
  rmin = 1.d-10
  carmabins, nbin, rmrat, rmin, rho0, $
                 rmass, rmassup, rsm, rupsm, drsm, rlowsm
  frac = 1.
  lognormal, r0, s0, frac, $
                 rsm, drsm, $
                 dNdrbc, dSdrbc, dVdrbc


; OC particle properties
  r1 = 0.0212e-6
  s1 = 2.2
  rho1 = 1800.
  lognormal, r1, s1, frac, $
                 rsm, drsm, $
                 dNdroc, dSdroc, dVdroc

; Compute and normalize the total masses
;  mbc_ = total(4./3.*!dpi*rsm^3*rho0*dndrbc*drsm)
;  moc  = total(4./3.*!dpi*rsm^3*rho1*dndroc*drsm)
  mbc_ = total(dVdrbc*rho0*drsm)
  moc  = total(dVdroc*rho1*drsm)
  fac_ = moc/mbc_
  dNdrbc = dNdrbc*fac_/6.  ; 6:1 OC:BC mass
  dSdrbc = dSdrbc*fac_/6. 
  dVdrbc = dVdrbc*fac_/6.
  mbc  = total(4./3.*!dpi*rsm^3*rho0*dndrbc*drsm)
print, moc/mbc

; test against the known OC PSD. NB: A0 comes out not quite right...
x = alog(rsm)
y = rsm*dNdroc
res = gaussfit(x,y,a,nterms=3)
print, a[0], alog(s1)/sqrt(2.*!dpi)
print, a[1], alog(r1)
print, a[2], alog(s1)
  r2 = exp(a[1])
  s2 = exp(a[2])
 
  lognormal, r2, s2, frac, $
                 rsm, drsm, $
                 dNdr, dSdr, dVdr

  plot, rsm, rsm*(dndroc), /xlog
  oplot, rsm, rsm*dNdr, thick=3, lin=3
;stop

; test against the known BC PSD. NB: A0 comes out not quite right...
x = alog(rsm)
y = rsm*dNdrbc
res = gaussfit(x,y,a,nterms=3)
print, a[0], alog(s0)/sqrt(2.*!dpi)
print, a[1], alog(r0)
print, a[2], alog(s0)
  r2 = exp(a[1])
  s2 = exp(a[2])
 
  lognormal, r2, s2, frac, $
                 rsm, drsm, $
                 dNdr, dSdr, dVdr

  plot, rsm, rsm*(dndrbc), /xlog
  oplot, rsm, rsm*dNdr, thick=3, lin=3
;stop


; Test against the summed PSD
  x = alog(rsm)
  y = rsm*(dNdroc+dNdrbc)
  res = gaussfit(x,y,a,nterms=3)
  r2 = exp(a[1])
  s2 = exp(a[2])
 
  lognormal, r2, s2, frac, $
                 rsm, drsm, $
                 dNdr, dSdr, dVdr

  plot, rsm, rsm*(dndroc+dndrbc), /xlog
  oplot, rsm, 4.25*rsm*dNdr, thick=3, lin=3

print, r2, s2

; Volume weight refractive index
  nr_bc = 1.75
  ni_bc = -0.44
  nr_oc = 1.53
  ni_oc = -0.006

  vbc = total(dvdrbc*drsm)
  voc = total(dvdroc*drsm)

  nr = (vbc*nr_bc + voc*nr_oc) / (vbc+voc)
  ni = (vbc*ni_bc + voc*ni_oc) / (vbc+voc)

print, nr, ni
; Read the default BC refractive index
  filename = '/home/colarco/sandbox/radiation/x/optics_BC.v1_6.nc'
  readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  nr_bc = refreal[*,0,0]
  ni_bc = refimag[*,0,0]
  filename = '/home/colarco/sandbox/radiation/x/optics_OC.v1_6.nc'
  readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  nr_oc = refreal[*,0,0]
  ni_oc = refimag[*,0,0]

  nr = (vbc*nr_bc + voc*nr_oc) / (vbc+voc)
  ni = (vbc*ni_bc + voc*ni_oc) / (vbc+voc)

  lam = lambda*1e6

; print out
  openw, lun, 'ri-mix_wide.wsv', /get
  printf, lun, '# lambda[um] m_real m_imaginary'
  for i = 0, n_elements(lam)-1 do begin
   printf, lun, lam[i], nr[i], ni[i], $
    format='(E9.3,1x,f5.3,1x,f10.6)'
endfor
  free_lun, lun

end
