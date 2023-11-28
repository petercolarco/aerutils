; Colarco
; Procedure to do something with Yunqian Zhu CARMA CAM simulations of
; Calbuco eruption

; Three files:
;  - SULFAT_Calbuco_emissiontest_Volcanicinit.nc - mmr of dry radius
;    sulfate particles
;  - SULFATWT_Calbuco_emissiontest_Volcanicinit.nc  - weight percent
;    of H2SO4 in particles
;  - NITRIDWT_Calbuco_emissiontest_Volcanicinit.nc - weight percent of
;    HNO3 in particles
;
; File dimensions 144 lon x 96 lat x 88 levels (hybrid sigma)
; 30 times (every 2 days for April 1 - May 30, 2015) 

; Dry particle bin sizes (inferred from Yunqian's file)
  nbin = 20
  rmin = 0.3432e-9  ; m
  rmrat = ((0.2247e-4/rmin)^3.)^(1./(nbin-1))
  rhop = 1923.
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow

; Get a slice of data from one of the files
  nc4readvar, 'sulfate_dry_mmr.nc', 'sulfat', sulfate_dry, /tem, $
   time=time, lon=lon, lat=lat, lev=lev, rc=rc
; template read brings in extra variable sulfatre as last index, so:
  sulfate_reff = sulfate_dry[*,*,*,20]
  sulfate_dry  = sulfate_dry[*,*,*,0:19]

; sulfate weight percent
  varwant = 'sulfat'+strpad(string(indgen(20)+1,format='(i2)'),10)+'wt'
  nc4readvar, 'sulfatwt.nc', varwant, sulfate_wtght, $
   time=time, lon=lon, lat=lat, lev=lev, rc=rc

; nitric acid weight percent
  varwant = 'nitrid'+strpad(string(indgen(20)+1,format='(i2)'),10)+'wt'
  nc4readvar, 'nitridwt.nc', varwant, nitric_wtght, $
   time=time, lon=lon, lat=lat, lev=lev, rc=rc

; sulfate wet particle radius and temperature
  nc4readvar, 'sulfatro.nc', 'sulfatro', sulfatro, $
   time=time, lon=lon, lat=lat, lev=lev, rc=rc

; Per Yunqian the wet particle mass mixing ratio is
  su = sulfate_dry / ( (sulfate_wtght+nitric_wtght)/100.) ; to get percent right

; Pick a maximum point (y = 30, z = 49)
  ix = 130
  iy = 30
  iz = 49

; Calculate the wet radius at this point
  vol = rmass / ( (sulfate_wtght[ix,iy,iz,*]+nitric_wtght[ix,iy,iz,*])/100.) / (sulfatro[ix,iy,iz]*1000.)
  rwet = (vol / (4./3.*!dpi))^(1./3.)

; Pick off your point
; Number concentration would be dry mass / rmass (dN)
  dn = (sulfate_dry[ix,iy,iz,*] / rmass)

  reff = total(rwet^3*dn) / total(rwet^2 * dn)

print, reff*1e6
print, sulfate_reff[ix,iy,iz]

  rat = rwet[0]/r[0]
  drwet = dr*rat

  plot, rwet*1e6, dn/drwet*rwet, /xlog, /ylog


end
