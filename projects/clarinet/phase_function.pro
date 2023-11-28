; Optics tables
  opticsfile = '/home/colarco/sandbox/radiation/x/carma_optics_DU.v15.nbin=44.nc'
  readoptics, opticsfile, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag, pmoments=pmoments, pback=pback

  ilam = 5 ;; 550 nm

; nz here is the particle size distribution
; First 11 are particles of mode radius r1 below between 0.5 - 5 um
; 12 is Shultz
; 13 is d'Almeida
; 14 is Kok
  nz = 14
  nmom = 301

  tau  = fltarr(nz)
  ssa  = fltarr(nz)
  g    = fltarr(nz)
  pmom = fltarr(nz,nmom)

; Size bins
  nbin = 44
  rmrat = (15.d/.05d)^(3.d/nbin)
  rmin = 0.05d-6
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, r, rup, dr, rlow, masspart

; Handle DU, normalize to tau = 1
  r1 = findgen(11)*.5 + .5
  sigma = 2.
; Loop over sizes
  for iz = 0, nz-1 do begin
   if(iz le 10) then begin
    r1_ = r1[iz]*1.e-6
    s1 = sigma
    p1 = 1.
    lognormal, r1_, s1, p1, r, dr, dndr, dsdr, dvdr, rlow=rlow, rup=rup, /vol
   endif else begin
    case iz of
     11: begin
;        Schulz et al. 1998
         r1 = 1.26d-6
         s1 = 2.0
         p1 = 1.
         lognormal, r1, s1, p1, r, dr, dndr, dsdr, dvdr, rlow=rlow, rup=rup, /vol
         dv  = dvdr*dr
         end
     12: begin
;        D'Almedia background dust 1987 (from Zender 2003 Table 1)
         r1 = [.832,4.82,19.38]*0.5*1.e-6  ; radius in m
         s1 = [2.1,1.9,1.6]
         p1 = [.036,.957,.007]
         lognormal, r1, s1, p1, r, dr, dndr, dsdr, dvdr, rlow=rlow, rup=rup, /vol
         dv  = dvdr*dr
         end
     13: begin
;        Kok
         r_  = r*1d6
         dr_ = dr*1d6
         kok_psd, r_, dr_, dvdr, dndr
         dv  = dvdr*dr
         end
    endcase
   endelse

   dv  = dvdr*dr
   tau = total(bext[ilam,0,*]*dv)
   dv  = dv / tau
   tau = total(bext[ilam,0,*]*dv)
   ssa = total(bsca[ilam,0,*]*dv)/tau
   for ibin = 0, nbin-1 do begin
    tau_ = dv[ibin]*bext[ilam,0,ibin]
    ssa_ = bsca[ilam,0,ibin]/bext[ilam,0,ibin]
    for imom = 0, nmom-1 do begin
     pmom[iz,imom] = pmom[iz,imom] + pmoments[ilam,0,ibin,imom,0]*ssa_*tau_
    endfor
   endfor
  endfor

; Normalize
  ssa  = ssa / tau
  for imom = 0, nmom-1 do begin
   pmom[*,imom] = pmom[*,imom] / (ssa*tau)
  endfor

; And construct the phase function
  angles = dindgen(181)*1.
  mu     = cos(angles*!dpi/180.d)
  p11 = dblarr(181,nz)
  nmom = nmom-1
  for iz = 0, nz-1 do begin
     for iang = 0, 180 do begin
        x = mu[iang]
        leg = dblarr(nmom+1)
        leg[0] = 1.d
        leg[1] = x
        for imom = 2, nmom do begin
         leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
        endfor
        for imom = 0, nmom do begin
         p11[iang,iz] = p11[iang,iz] + pmom[iz,imom]*leg[imom]
        endfor
     endfor
  endfor

  set_plot, 'ps'
  device, file='p11.ps', /color, /helvetica, font_size=14
  !p.font=0
  loadct, 0
  plot, p11[*,0], /nodata, thick=3, $
        xrange=[0,180], xstyle=9, xtitle='angle', $
        yrange=[0.1,1000], ystyle=9, /ylog, ytitle='P11'
  for iz = 0, 10 do begin
   oplot, p11[*,iz], thick=1, color=180
  endfor
  loadct, 39
  oplot, p11[*,11], thick=8, color=0
  oplot, p11[*,12], thick=8, color=254
  oplot, p11[*,13], thick=8, color=84

  
  device, /close
end

