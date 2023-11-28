; Colarco, January 2012
; Purpose is to compare the radiative properties of dust aerosols for
; different assumptions of the radiative database used.

; Calibrate an idealized PSD to give optical depth = 1 for a base case
; of the optics databases.

; Generate uncalibrated PSD
  nbin = 8
  rmrat = (10.d/.1d)^(3.d/nbin)
  rmin = 0.1d-6*((1.+rmrat)/2.d)^(1.d/3.)
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, r, rup, dr, rlow

; sub-bin distribution after Zender 2003 (using Schulz et al. 1998 middle mode)
  r1 = 1.26d-6
  s1 = 2.0
  p1 = 1.
  lognormal, r1, s1, p1, r, dr, dndr, dsdr, dvdr, rlow=rlow, rup=rup, /vol

; How about a model based PSD? From bF_F25b9-base-v1 JJA clim at 16N,
; 22.5W (Capo Verde)
  dv   = [7.75, 452.6, 2707.6, 10870.3, 43827.3, $
          35348.5, 14047.8, 726.36]
  dn = dv/r^3.
  reff = total(r^3*dn)/total(r^2.*dn)
print, reff

; Now read a database to calibrate the PSD
  opticsdir = '/Users/pcolarco/sandbox/radiation/x/'
  filename = opticsdir+'carma_optics_DU.v1.nbin=08.nc'
  readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

  ilam = 6  ; 550 nm
  tau = total(bext[ilam,0,*]*dv)
  dv = dv/tau
; This is now the dv to use in what follows

; Now read and compute the band optical depths
  bandfiles = ['carma_optics_DU.v1.nbin=08.nc', $
               'carma_optics_DU.v5.nbin=08.nc', $
               'carma_optics_DU.v6.nbin=08.nc', $
               'carma_optics_DU.v8.nbin=08.nc', $
               'carma_optics_DU.v10.nbin=08.nc', $
               'carma_optics_DU.v7.nbin=08.nc', $
               'carma_optics_DU.v11.nbin=08.nc', $
               'carma_optics_DU.v12.nbin=08.nc' ]
  bandfiles = opticsdir+bandfiles

  nfile = n_elements(bandfiles)
  readoptics, bandfiles[0], reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  nband = n_elements(lambda)
  tau   = fltarr(nband,nfile)
  ssa   = fltarr(nband,nfile)
  gasym = fltarr(nband,nfile)

  for ifile = 0, nfile-1 do begin
   readoptics, bandfiles[ifile], reff, lambda, qext, qsca, bext, bsca, g, bbck, $
               rh, rmass, refreal, refimag
   for iband = 0, nband-1 do begin
    tau[iband,ifile] = total(bext[iband,0,*]*dv)
   endfor
   for iband = 0, nband-1 do begin
    ssa[iband,ifile] = total(bsca[iband,0,*]*dv)/total(bext[iband,0,*]*dv)
   endfor
   for iband = 0, nband-1 do begin
    gasym[iband,ifile] = total(g[iband,0,*]*bsca[iband,0,*]*dv)/total(tau[iband,ifile]*ssa[iband,ifile])
   endfor
  endfor
print, tau[6,*]
print, ''
print, ssa[6,*]
print, ''
print, gasym[6,*]

; And make a plot
  color = [254,84,84,208,208,254,254]
  linarray = [0,2,0,0,1,2,1]

; Tau
  set_plot, 'ps'
  device, file='tau.eps', /color, font_size=10, /helvetica, $
   xoff=.5, yoff=.5, xsize=12, ysize=16, /encap
  !p.font=0
  !P.multi = [0,1,2]
  loadct, 0
  x = lambda*1e6
  plot, x, tau[*,0], /nodata, $
        thick=3, xtitle='wavelength [um]', ytitle='AOT', $
        title='Aerosol Optical Thickness', $
        xrange=[.2,40], yrange=[0,2], xstyle=1, /xlog
  loadct, 39
  for ifile = 0, nfile-2 do begin
   oplot, x, tau[*,ifile], color=color[ifile], lin=linarray[ifile], thick=6
  endfor
  a = where(x ge .3 and x le 3.5)
  oplot, x[a], tau[a,nfile-1], color=26, thick=6

  fac = 2/1.5
  plots, [.5,.7], fac*1.4, thick=6, color=254
  plots, [.5,.7], fac*1.3, thick=6, color=254, lin=1
  plots, [.5,.7], fac*1.2, thick=6, color=254, lin=2
  plots, [5,7], fac*1.4, thick=6, color=84
  plots, [5,7], fac*1.3, thick=6, color=84, lin=2
  plots, [5,7], fac*1.2, thick=6, color=208
  plots, [5,7], fac*1.1, thick=6, color=208, lin=1
  plots, [5,7], fac*1.0, thick=6, color=26
  xyouts, .8, fac*1.38, 'OPAC Spheres'
  xyouts, .8, fac*1.28, 'OPAC Spheroids'
  xyouts, .8, fac*1.18, 'OPAC Ellipsoids'
  xyouts, 8, fac*1.38, 'SF Spheres'
  xyouts, 8, fac*1.28, 'SF Ellipsoids'
  xyouts, 8, fac*1.18, 'OBS Spheres'
  xyouts, 8, fac*1.08, 'OBS Spheroids'
  xyouts, 8, fac*0.98, 'Haapanala et al.'
  xyouts, 8, fac*0.88, '(2012) Table 1'

  loadct, 0
  plot, indgen(nband)+1, tau[*,0], /nodata, $
        thick=3, xtitle='wavelength [um]', ytitle='!9D!XAOT', $
        title='Difference in AOT from OPAC-Spheres', $
        xrange=[.2,40], yrange=[-1,.5], /xlog, xstyle=1
  loadct, 39
  for ifile = 0, nfile-2 do begin
   oplot, x, tau[*,ifile]-tau[*,0], color=color[ifile], lin=linarray[ifile], thick=6
  endfor
  a = where(x ge .3 and x le 3.5)
  oplot, x[a], tau[a,nfile-1]-tau[a,0], color=26, thick=6

  device, /close

  print, 'AOT'
  print, 'OPAC', tau[ilam,0], format='(a-20,2x,f10.3)'
  print, 'Levoni', tau[ilam,2], format='(a-20,2x,f10.3)'
  print, 'Levoni-ellipse', tau[ilam,1], format='(a-20,2x,f10.3)'
  print, 'Colarco', tau[ilam,3], format='(a-20,2x,f10.3)'
  print, 'Colarco-ellipse', tau[ilam,4], format='(a-20,2x,f10.3)'

; SSA
  set_plot, 'ps'
  device, file='ssa.eps', /color, font_size=10, /helvetica, $
   xoff=.5, yoff=.5, xsize=12, ysize=16, /encap
  !p.font=0
  !P.multi = [0,1,2]
  loadct, 39
  loadct, 0
  plot, x, ssa[*,0], /nodata, $
        thick=3, xtitle='wavelength [um]', ytitle='SSA', $
        title='Single Scattering Albedo', $
        xrange=[.2,40], yrange=[0,1.5], /xlog, xstyle=1
  loadct, 39
  for ifile = 0, nfile-2 do begin
   oplot, x, ssa[*,ifile], color=color[ifile], lin=linarray[ifile], thick=6
   print, bandfiles[ifile], ssa[6,ifile], lambda[6]
  endfor
  a = where(x ge .3 and x le 3.5)
  oplot, x[a], ssa[a,nfile-1], color=26, thick=6
fac = 1
  plots, [.5,.7], fac*1.4, thick=6, color=254
  plots, [.5,.7], fac*1.3, thick=6, color=254, lin=1
  plots, [.5,.7], fac*1.2, thick=6, color=254, lin=2
  plots, [5,7], fac*1.4, thick=6, color=84
  plots, [5,7], fac*1.3, thick=6, color=84, lin=2
  plots, [5,7], fac*1.2, thick=6, color=208
  plots, [5,7], fac*1.1, thick=6, color=208, lin=1
  plots, [5,7], fac*1.0, thick=6, color=26
  xyouts, .8, fac*1.38, 'OPAC Spheres'
  xyouts, .8, fac*1.28, 'OPAC Spheroids'
  xyouts, .8, fac*1.18, 'OPAC Ellipsoids'
  xyouts, 8, fac*1.38, 'SF Spheres'
  xyouts, 8, fac*1.28, 'SF Ellipsoids'
  xyouts, 8, fac*1.18, 'OBS Spheres'
  xyouts, 8, fac*1.08, 'OBS Spheroids'
  xyouts, 8, fac*0.98, 'Haapanala et al.'
  xyouts, 8, fac*0.88, '(2012) Table 1'

  loadct, 0
  plot, x, tau[*,0], /nodata, $
        thick=3, xtitle='wavelength [um]', ytitle='!9D!XSSA', $
        title='Difference in SSA from OPAC-Spheres', $
        xrange=[.2,40], yrange=[-.3,.3], /xlog, xstyle=1
  loadct, 39
  for ifile = 0, nfile-2 do begin
   oplot, x, ssa[*,ifile]-ssa[*,0], color=color[ifile], lin=linarray[ifile], thick=6
  endfor
  a = where(x ge .3 and x le 3.5)
  oplot, x[a], ssa[a,nfile-1]-ssa[a,0], color=26, thick=6

  device, /close
  print, 'SSA'
  print, 'OPAC', ssa[ilam,0], format='(a-20,2x,f10.3)'
  print, 'Levoni', ssa[ilam,2], format='(a-20,2x,f10.3)'
  print, 'Levoni-ellipse', ssa[ilam,1], format='(a-20,2x,f10.3)'
  print, 'Colarco', ssa[ilam,3], format='(a-20,2x,f10.3)'
  print, 'Colarco-ellipse', ssa[ilam,4], format='(a-20,2x,f10.3)'


; G
  set_plot, 'ps'
  device, file='gasym.eps', /color, font_size=10, /helvetica, $
   xoff=.5, yoff=.5, xsize=12, ysize=16, /encap
  !p.font=0
  !P.multi = [0,1,2]
  loadct, 39
  loadct, 0
  plot, x, ssa[*,0], /nodata, $
        thick=3, xtitle='wavelength [um]', ytitle='g', $
        title='Asymmetry Parameter', $
        xrange=[.2,40], yrange=[0,1.5], /xlog, xstyle=1
  loadct, 39
  for ifile = 0, nfile-2 do begin
   oplot, x, gasym[*,ifile], color=color[ifile], lin=linarray[ifile], thick=6
  endfor
  a = where(x ge .3 and x le 3.5)
  oplot, x[a], gasym[a,nfile-1], color=26, thick=6

  plots, [.5,.7], fac*1.4, thick=6, color=254
  plots, [.5,.7], fac*1.3, thick=6, color=254, lin=1
  plots, [.5,.7], fac*1.2, thick=6, color=254, lin=2
  plots, [5,7], fac*1.4, thick=6, color=84
  plots, [5,7], fac*1.3, thick=6, color=84, lin=2
  plots, [5,7], fac*1.2, thick=6, color=208
  plots, [5,7], fac*1.1, thick=6, color=208, lin=1
  plots, [5,7], fac*1.0, thick=6, color=26
  xyouts, .8, fac*1.38, 'OPAC Spheres'
  xyouts, .8, fac*1.28, 'OPAC Spheroids'
  xyouts, .8, fac*1.18, 'OPAC Ellipsoids'
  xyouts, 8, fac*1.38, 'SF Spheres'
  xyouts, 8, fac*1.28, 'SF Ellipsoids'
  xyouts, 8, fac*1.18, 'OBS Spheres'
  xyouts, 8, fac*1.08, 'OBS Spheroids'
  xyouts, 8, fac*0.98, 'Haapanala et al.'
  xyouts, 8, fac*0.88, '(2012) Table 1'
  loadct, 0
  plot, x, tau[*,0], /nodata, $
        thick=3, xtitle='wavelength [um]', ytitle='!9D!Xg', $
        title='Difference in g from OPAC-Spheres', $
        xrange=[.2,40], yrange=[-.1,.2], /xlog, xstyle=1
  loadct, 39
  for ifile = 0, nfile-2 do begin
   oplot, x, gasym[*,ifile]-gasym[*,0], color=color[ifile], lin=linarray[ifile], thick=6
  endfor
  a = where(x ge .3 and x le 3.5)
  oplot, x[a], gasym[a,nfile-1]-gasym[a,0], color=26, thick=6
  print, 'ASYM'
  print, 'OPAC', gasym[ilam,0], format='(a-20,2x,f10.3)'
  print, 'Levoni', gasym[ilam,2], format='(a-20,2x,f10.3)'
  print, 'Levoni-ellipse', gasym[ilam,1], format='(a-20,2x,f10.3)'
  print, 'Colarco', gasym[ilam,3], format='(a-20,2x,f10.3)'
  print, 'Colarco-ellipse', gasym[ilam,4], format='(a-20,2x,f10.3)'

  device, /close

end
