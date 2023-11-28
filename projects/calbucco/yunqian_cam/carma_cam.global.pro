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
  nc4readvar, 'sulfate_dry_mmr.20150429.nc', 'sulfat', sulfate_dry, /tem, $
   time=time, lon=lon, lat=lat, lev=lev, rc=rc
; template read brings in extra variable sulfatre as last index, so:
  sulfate_reff = sulfate_dry[*,*,*,20]
  sulfate_dry  = sulfate_dry[*,*,*,0:19]

; sulfate weight percent
  varwant = 'sulfat'+strpad(string(indgen(20)+1,format='(i2)'),10)+'wt'
  nc4readvar, 'sulfatwt.20150429.nc', varwant, sulfate_wtght, $
   time=time, lon=lon, lat=lat, lev=lev, rc=rc

; nitric acid weight percent
  varwant = 'nitrid'+strpad(string(indgen(20)+1,format='(i2)'),10)+'wt'
  nc4readvar, 'nitridwt.20150429.nc', varwant, nitric_wtght, $
   time=time, lon=lon, lat=lat, lev=lev, rc=rc

; sulfate wet particle radius and temperature
  nc4readvar, 'sulfatro.20150429.nc', 'sulfatro', sulfatro, $
   time=time, lon=lon, lat=lat, lev=lev, rc=rc

  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  vol  = fltarr(nx,ny,nz,nbin)
  dn   = fltarr(nx,ny,nz,nbin)
  rwet = fltarr(nx,ny,nz,nbin)
  reff = fltarr(nx,ny,nz)

  for iz = 0, nz-1 do begin
   for iy = 0, ny-1 do begin
    for ix = 0, nx-1 do begin
;    Calculate the wet radius at this point
     vol[ix,iy,iz,*] = rmass $
       / ( (sulfate_wtght[ix,iy,iz,*]+nitric_wtght[ix,iy,iz,*])/100.) / (sulfatro[ix,iy,iz]*1000.)
     rwet[ix,iy,iz,*] = (vol[ix,iy,iz,*] / (4./3.*!dpi))^(1./3.)
;    Number concentration would be dry mass / rmass (dN)
     dn[ix,iy,iz,*] = (sulfate_dry[ix,iy,iz,*] / rmass)
     reff = total(rwet[ix,iy,iz,*]^3*dn[ix,iy,iz,*]) / total(rwet[ix,iy,iz,*]^2 * dn[ix,iy,iz,*])
    endfor
   endfor
  endfor

; Pick off level and do average
  iz = 49  ; 50 hPa (peak altitude)
  a = where(sulfate_dry[*,*,iz,9] gt 1e-9)
  n = n_elements(a)
  dnave = fltarr(n,nbin)
  rwetave = fltarr(n,nbin)
  for ibin = 0, nbin-1 do begin
   for i = 0, n-1 do begin
    dn_ = dn[*,*,iz,ibin]
    dnave[i,ibin] = dn_[a[i]]
    rwet_ = rwet[*,*,iz,ibin]
    rwetave[i,ibin] = rwet_[a[i]]
   endfor
  endfor

; Mean value over plume
  dnave = mean(dnave,dim=1)
  rwetave = mean(rwetave,dim=1)

; Make a plot
  rat = rwetave[0]/r[0]
  drwetave = dr*rat
  plot, rwetave*1e6, dnave*rwetave/drwetave, /xlog, /ylog

; Pick off peak point
  ix = 130
  iy = 30
  iz = 49
  rat = rwet[ix,iy,iz,0]/r[0]
  drwet = dr*rat
  oplot, rwet[ix,iy,iz,*]*1e6, dn[ix,iy,iz,*]*rwet[ix,iy,iz,*]/drwet, lin=2, thick=6


; Now repeat for period before eruption
; Get a slice of data from one of the files
  nc4readvar, 'sulfate_dry_mmr.20150415.nc', 'sulfat', sulfate_dry, /tem, $
   time=time, lon=lon, lat=lat, lev=lev, rc=rc
; template read brings in extra variable sulfatre as last index, so:
  sulfate_reff = sulfate_dry[*,*,*,20]
  sulfate_dry  = sulfate_dry[*,*,*,0:19]

; sulfate weight percent
  varwant = 'sulfat'+strpad(string(indgen(20)+1,format='(i2)'),10)+'wt'
  nc4readvar, 'sulfatwt.20150415.nc', varwant, sulfate_wtght, $
   time=time, lon=lon, lat=lat, lev=lev, rc=rc

; nitric acid weight percent
  varwant = 'nitrid'+strpad(string(indgen(20)+1,format='(i2)'),10)+'wt'
  nc4readvar, 'nitridwt.20150415.nc', varwant, nitric_wtght, $
   time=time, lon=lon, lat=lat, lev=lev, rc=rc

; sulfate wet particle radius and temperature
  nc4readvar, 'sulfatro.20150415.nc', 'sulfatro', sulfatro, $
   time=time, lon=lon, lat=lat, lev=lev, rc=rc

  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  vol  = fltarr(nx,ny,nz,nbin)
  dn   = fltarr(nx,ny,nz,nbin)
  rwet = fltarr(nx,ny,nz,nbin)
  reff = fltarr(nx,ny,nz)

  for iz = 0, nz-1 do begin
   for iy = 0, ny-1 do begin
    for ix = 0, nx-1 do begin
;    Calculate the wet radius at this point
     vol[ix,iy,iz,*] = rmass $
       / ( (sulfate_wtght[ix,iy,iz,*]+nitric_wtght[ix,iy,iz,*])/100.) / (sulfatro[ix,iy,iz]*1000.)
     rwet[ix,iy,iz,*] = (vol[ix,iy,iz,*] / (4./3.*!dpi))^(1./3.)
;    Number concentration would be dry mass / rmass (dN)
     dn[ix,iy,iz,*] = (sulfate_dry[ix,iy,iz,*] / rmass)
     reff = total(rwet[ix,iy,iz,*]^3*dn[ix,iy,iz,*]) / total(rwet[ix,iy,iz,*]^2 * dn[ix,iy,iz,*])
    endfor
   endfor
  endfor

; Pick off level and do average
  iz = 49  ; 50 hPa (peak altitude)
  a = where(sulfate_dry[*,*,iz,9] gt 1e-9)
  n = n_elements(a)
  dnave = fltarr(n,nbin)
  rwetave = fltarr(n,nbin)
  for ibin = 0, nbin-1 do begin
   for i = 0, n-1 do begin
    dn_ = dn[*,*,iz,ibin]
    dnave[i,ibin] = dn_[a[i]]
    rwet_ = rwet[*,*,iz,ibin]
    rwetave[i,ibin] = rwet_[a[i]]
   endfor
  endfor

; Mean value over plume
  dnave = mean(dnave,dim=1)
  rwetave = mean(rwetave,dim=1)

; Make a plot
  rat = rwetave[0]/r[0]
  drwetave = dr*rat
  oplot, rwetave*1e6, dnave*rwetave/drwetave, lin=1

end
