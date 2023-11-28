; Get the column size distribution
  wantlon = -22.
  wantlat = 16.
  rhop = 2650.  ; kg m-3

; Get the baseline GOCART
  rminCR_control_aer = [.1,1,1.8,3,6]  ; um
  rmaxCR_control_aer = [1,1.8,3,6,10]  ; um
  rCR_control_aer    = [.73,1.4,2.4,4.5,8] ; um
  r  = rCR_control_aer
  dr = rmaxCR_control_aer - rminCR_control_aer
  filename = '/misc/prc10/colarco/CR_control/tavg3d_aer_v/CR_control.tavg3d_aer_v.monthly.200007.nc4'
  ga_getvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, $
             lev=lev, lon=lon, lat=lat
  delp = reform(delp)
  nz = n_elements(delp)
  nbin = 5
  du = fltarr(nbin,nz)
  duCR_control_aer = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   varwant = 'du'+string(ibin+1,"$(i3.3)")
   ga_getvar, filename, varwant, du_, wantlon=wantlon, wantlat=wantlat
   du[ibin,*] = reform(du_)
   duCR_control_aer[ibin] = total(du[ibin,*]*delp/9.81)
  endfor
; To units of dvdlnr [um] in column
  dvdlnrCR_control_aer = duCR_control_aer/rhop*1e6*r/dr

  set_plot, 'ps'
  device, file='capo_verde_psd.200007.ps', /color, font_size=14, /helvetica, $
   xoff=.5, yoff=.5, xsize=12, ysize=8
  !p.font=0

  loadct, 39
  plot, indgen(10)+1, /nodata, $
   xrange=[.03,20], /xlog, xstyle=9, $
   yrange=[0,.3], ystyle=9

  plot_size, rminCR_control_aer, rmaxCR_control_aer, dvdlnrCR_control_aer, $
             thick=12

; Get the baseline CARMA
  nbin = 8
  rmrat = (100.^3.d)^(1.d/nbin)
  rmin = 0.1d*((1.+rmrat)/2.d)^(1./3.d)
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  filename = '/misc/prc10/colarco/CR_control/tavg3d_carma_v/Y2000/M07/CR_control.tavg3d_carma_v.monthly.200007.nc4'
  du = fltarr(nbin,nz)
  duCR_control_carma = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   varwant = 'dust'+string(ibin+1,"$(i3.3)")
   ga_getvar, filename, varwant, du_, wantlon=wantlon, wantlat=wantlat
   du[ibin,*] = reform(du_)
   duCR_control_carma[ibin] = total(du[ibin,*]*delp/9.81)
  endfor
; To units of dvdlnr [um] in column
  dvdlnrCR_control_carma = duCR_control_carma/rhop*1e6*r/dr

  plot_size, rlow, rup, dvdlnrCR_control_carma, thick=12, lin=2



; Get the free-running GOCART
  rminCF_control_aer = [.1,1,1.8,3,6]  ; um
  rmaxCF_control_aer = [1,1.8,3,6,10]  ; um
  rCF_control_aer    = [.73,1.4,2.4,4.5,8] ; um
  r  = rCF_control_aer
  dr = rmaxCF_control_aer - rminCF_control_aer
  filename = '/misc/prc10/colarco/CF_control/tavg3d_aer_v/CF_control.tavg3d_aer_v.monthly.200007.nc4'
  ga_getvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, $
             lev=lev, lon=lon, lat=lat
  delp = reform(delp)
  nz = n_elements(delp)
  nbin = 5
  du = fltarr(nbin,nz)
  duCF_control_aer = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   varwant = 'du'+string(ibin+1,"$(i3.3)")
   ga_getvar, filename, varwant, du_, wantlon=wantlon, wantlat=wantlat
   du[ibin,*] = reform(du_)
   duCF_control_aer[ibin] = total(du[ibin,*]*delp/9.81)
  endfor
; To units of dvdlnr [um] in column
  dvdlnrCF_control_aer = duCF_control_aer/rhop*1e6*r/dr

  plot_size, rminCF_control_aer, rmaxCF_control_aer, dvdlnrCF_control_aer, $
             thick=12, color=176


; Get the free-running CARMA
  nbin = 8
  rmrat = (100.^3.d)^(1.d/nbin)
  rmin = 0.1d*((1.+rmrat)/2.d)^(1./3.d)
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  filename = '/misc/prc10/colarco/CF_control/tavg3d_carma_v/Y2000/M07/CF_control.tavg3d_carma_v.monthly.200007.nc4'
  du = fltarr(nbin,nz)
  duCR_control_carma = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   varwant = 'dust'+string(ibin+1,"$(i3.3)")
   ga_getvar, filename, varwant, du_, wantlon=wantlon, wantlat=wantlat
   du[ibin,*] = reform(du_)
   duCR_control_carma[ibin] = total(du[ibin,*]*delp/9.81)
  endfor
; To units of dvdlnr [um] in column
  dvdlnrCR_control_carma = duCR_control_carma/rhop*1e6*r/dr

  plot_size, rlow, rup, dvdlnrCR_control_carma, thick=12, lin=2, color=176


; Get the free-running GOCART (more bins)
  filename = '/misc/prc10/colarco/CF_g8cart/tavg3d_aer_v/CF_g8cart.tavg3d_aer_v.monthly.200007.nc4'
  ga_getvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, $
             lev=lev, lon=lon, lat=lat
  delp = reform(delp)
  nz = n_elements(delp)
  nbin = 8
  du = fltarr(nbin,nz)
  duCF_control_aer = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   varwant = 'du'+string(ibin+1,"$(i3.3)")
   ga_getvar, filename, varwant, du_, wantlon=wantlon, wantlat=wantlat
   du[ibin,*] = reform(du_)
   duCF_control_aer[ibin] = total(du[ibin,*]*delp/9.81)
  endfor
; To units of dvdlnr [um] in column
  dvdlnrCF_control_aer = duCF_control_aer/rhop*1e6*r/dr

  plot_size, rlow, rup, dvdlnrCF_control_aer, $
             thick=12, color=254


; Get the free-running CARMA
  filename = '/misc/prc10/colarco/CF_g8cart/tavg3d_carma_v/Y2000/M07/CF_g8cart.tavg3d_carma_v.monthly.200007.nc4'
  du = fltarr(nbin,nz)
  duCR_control_carma = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   varwant = 'dust'+string(ibin+1,"$(i3.3)")
   ga_getvar, filename, varwant, du_, wantlon=wantlon, wantlat=wantlat
   du[ibin,*] = reform(du_)
   duCR_control_carma[ibin] = total(du[ibin,*]*delp/9.81)
  endfor
; To units of dvdlnr [um] in column
  dvdlnrCR_control_carma = duCR_control_carma/rhop*1e6*r/dr

  plot_size, rlow, rup, dvdlnrCR_control_carma, thick=12, lin=2, color=254


; Get the free-running CARMA (16 bin)
  nbin = 16
  rmrat = (100.^3.d)^(1.d/nbin)
  rmin = 0.1d*((1.+rmrat)/2.d)^(1./3.d)
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  filename = '/misc/prc10/colarco/CF_carma16/tavg3d_carma_v/Y2000/M07/CF_carma16.tavg3d_carma_v.monthly.200007.nc4'
  du = fltarr(nbin,nz)
  duCR_control_carma = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   varwant = 'dust'+string(ibin+1,"$(i3.3)")
   ga_getvar, filename, varwant, du_, wantlon=wantlon, wantlat=wantlat
   du[ibin,*] = reform(du_)
   duCR_control_carma[ibin] = total(du[ibin,*]*delp/9.81)
  endfor
; To units of dvdlnr [um] in column
  dvdlnrCR_control_carma = duCR_control_carma/rhop*1e6*r/dr

  plot_size, rlow, rup, dvdlnrCR_control_carma, thick=12, lin=2, color=84



; Overplot AERONET
; Capo Verde July 15, 2000
  nbin = 22
  rmrat = ((15./.05)^3.d)^(1.d/(nbin-1))
  rmin = .05
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow
  dvdlnr = [0.001309,0.005191,0.011556,0.015357,0.014633,0.013641,0.016547,$
            0.026708,0.043813,0.059888,0.084403,0.149074,0.245214,0.219061,$
            0.100455,0.033286,0.010891,0.004206,0.002043,0.001245,0.000932,$
            0.000848]
  loadct, 0
  plot_size, rlow, rup, dvdlnr, thick=12, color=100
  
  device, /close

end
