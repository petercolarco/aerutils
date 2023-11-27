; Simple procedure to consider the particle size distribution of dust
; suggest by Kok 2010. (His equations 5 & 6)

; presumes MKS units (r = [m], rho = [kg m-3])
; returns 

  pro kok_psd, r, rlow, rup, dm, dn, rhod=rhod, rhog=rhog, $
               rlavg=rlavg, rgavg=rgavg, rnavg=rnavg, rmavg=rmavg, rsavg=rsavg

; If optional element densities are not passed then we assume density
; is that of pure dust element with given value
  rho_dust = 2650. ; kg m-3
  if(keyword_set(rhod)) then rho_dust = rhod
  rho_grp = rho_dust
  if(keyword_set(rhog)) then rho_grp = rhog

; At this point it is assumed that the radii passed in go with the
; group density, and so map to the group masses

; units in meters
  ds  = 3.4d-6    ; soil median diameter [m]
  sig = 3.d       ; width of soil distribution
  lambda = 12.d-6 ; side crack propagation length
  cv = 12.62d-6   ; some constants
  cn = 0.9539d-6

; Loop over the major bins and compute values for possibly large
; number of sub-size bins
  nbin = n_elements(r)
  dn   = fltarr(nbin)
  dm   = fltarr(nbin)
  nbin_ = 1000

; Calculate some mean radius values
  if(keyword_set(rlavg)) then rlavg = (rup+rlow)/2.  ; linear average
  if(keyword_set(rgavg)) then rgavg = sqrt(rup*rlow) ; geometric average
  if(keyword_set(rnavg)) then rnavg = make_array(nbin,val=1.)   ; Number weighted average
  if(keyword_set(rmavg)) then rmavg = make_array(nbin,val=1.)   ; Mass weighted average
  if(keyword_set(rsavg)) then rsavg = make_array(nbin,val=1.)   ; Flux form sedimentation weighted

  for ibin = 0, nbin-1 do begin

   rmrat_ = (rup[ibin]/rlow[ibin])^(3./nbin_)
   rmin_  = rlow[ibin]*((1.+rmrat_)/2.)^(1./3.)
   carmabins, nbin_, rmrat_, rmin_, rho_grp, $
              rmass_, rmassup_, r_, rup_, dr_, rlow_

;  The dust particle size distribution is in terms of the radius of
;  dust density particles. The relationship between the group particle
;  masses and the dust element particle masses is written in terms of
;  the radius of the equivalent mass dust particle, which just
;  requires that r_dust^3*rhod = r_grp^3*rhog, so solving for
;  r_dust = r_grp*(rhog/rhod)^(1/3)
   r_  = r_*(rho_grp/rho_dust)^(1./3.)
   dr_ = dr_*(rho_grp/rho_dust)^(1./3.)

   dndr_    = (1./r_) * 1.d/cn/(2.*r_)^2 * (1.d + erf(alog(2.*r_/ds)/sqrt(2.d)/alog(sig)))*exp(-(2*r_/lambda)^3)
   dn[ibin] = total(dndr_*dr_)
   if(keyword_set(rnavg)) then rnavg[ibin] = total(r_*dndr_*dr_)/dn[ibin]
   dmdr_    = (1./r_) * (2.*r_/cv) * (1.d + erf(alog(2.*r_/ds)/sqrt(2.d)/alog(sig)))*exp(-(2.*r_/lambda)^3)
   dm[ibin] = total(dmdr_*dr_)
   if(keyword_set(rmavg)) then rmavg[ibin] = total(r_*dmdr_*dr_)/dm[ibin]
   if(keyword_set(rsavg)) then rsavg[ibin] = sqrt(total(r_^2.*dmdr_*dr_)/dm[ibin])
  endfor
end
