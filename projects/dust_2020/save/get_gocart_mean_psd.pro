  filen = '/misc/prc18/colarco/c180R_J10p17p1dev_aura/inst3d_aer_v/c180R_J10p17p1dev_aura.inst3d_aer_v.monthly.clim.ANN.nc4'
  nc4readvar, filen, 'delp', delp, lon=lon, lat=lat
  nc4readvar, filen, 'ps', ps, lon=lon, lat=lat
  nc4readvar, filen, ['du00'], du, /template

  area, lon, lat, nx, ny, dx, dy, area

; Vertically integrate to get kg m-2
  nx = n_elements(lon)
  ny = n_elements(lat)
  duc = fltarr(nx,ny,5)
  for ibin = 0, 4 do begin
   duc[*,*,ibin] = total(du[*,*,*,ibin]*delp/9.81,3)
  endfor
; find total mass
  dut = total(duc,3)

; Find area and mass weighted mean PSD
  dub = fltarr(5)
  for ibin = 0, 4 do begin
   dub[ibin] = aave(duc[*,*,ibin],area*dut)/total(area*dut)
  endfor


; Get a MERRA-2 example
  filen = '/misc/prc20/colarco/MERRA2/inst3_3d_aer_Nv/Y2007/M06/MERRA2_300.inst3_3d_aer_Nv.20070605.nc4'
  nc4readvar, filen, 'delp', delp, lon=lon, lat=lat
  nc4readvar, filen, 'ps', ps, lon=lon, lat=lat
  nc4readvar, filen, ['du00'], du, /template
; do daily average of MERRA2
  du = mean(du,dim=4)

  area, lon, lat, nx, ny, dx, dy, area

; Vertically integrate to get kg m-2
  nx = n_elements(lon)
  ny = n_elements(lat)
  duc = fltarr(nx,ny,5)
  for ibin = 0, 4 do begin
   duc[*,*,ibin] = total(du[*,*,*,ibin]*delp/9.81,3)
  endfor
; find total mass
  dut = total(duc,3)

; Find area and mass weighted mean PSD
  dubm2 = fltarr(5)
  for ibin = 0, 4 do begin
   dubm2[ibin] = aave(duc[*,*,ibin],area*dut)/total(area*dut)
  endfor


; Can I do the NRL PSD?
  sigma = 2.
  rmed = 1.6
  frac = 1.
  nbin = 44
  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmin = 0.05
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, r, rup, dr, rlow
  lognormal, rmed, sigma, frac, $
             r, dr, dNdr, dSdr, dVdr, /vol
  dm = dvdr*dr
  filename = '/home/colarco/sandbox/radiation/x/carma_optics_DU.v15.nbin=44.nc'
  readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  nlam = n_elements(lambda)
  aodo = fltarr(nlam)
  ssao = fltarr(nlam)
  for ilam = 0, nlam-1 do begin
   aodo[ilam] = total(bext[ilam,0,*]*dm)
   ssao[ilam] = total(bsca[ilam,0,*]*dm)/total(bext[ilam,0,*]*dm)
  endfor
  aodo = aodo/aodo[5]


; Use DUB to get spectral AOD and SSA of dust with GOCART table
  filename = '/home/colarco/sandbox/radiation/x/optics_DU.v15_6.nc'
  readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag

; Make a plot
  set_plot, 'ps'
  device, file='nref.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=12
  !p.font=0

  plot, indgen(20), /nodata, $
   xrange=[0.3,3], /xlog, xstyle=1, xtitle='Wavelength [!Mm!Nm]', $
   xtickn=['0.3','0.4','0.5','0.6','0.7','0.8','0.9','1','2','3'], $
   xticks=9, xtickv=[findgen(8)*.1+.3,2,3], $
   yrange=[1.3,1.7], ytitle='nReal', $
   position=[0.05,.1,.45,.9]
  oplot,lambda*1e6, refreal[*,0,0], thick=6

  plot, indgen(20), /nodata, /noerase, $
   xrange=[0.3,3], /xlog, xstyle=1, xtitle='Wavelength [!Mm!Nm]', $
   xtickn=['0.3','0.4','0.5','0.6','0.7','0.8','0.9','1','2','3'], $
   xticks=9, xtickv=[findgen(8)*.1+.3,2,3], $
   yrange=[0,.01], ytitle='nImag', $
   position=[0.55,.1,.95,.9]
  oplot,lambda*1e6, -refimag[*,0,0], thick=6

  device, /close



  nlam = n_elements(lambda)
  aod = fltarr(nlam)
  ssa = fltarr(nlam)
  aodm2 = fltarr(nlam)
  ssam2 = fltarr(nlam)
  for ilam = 0, nlam-1 do begin
   aod[ilam] = total(bext[ilam,0,*]*dub)
   ssa[ilam] = total(bsca[ilam,0,*]*dub)/total(bext[ilam,0,*]*dub)
   aodm2[ilam] = total(bext[ilam,0,*]*dubm2)
   ssam2[ilam] = total(bsca[ilam,0,*]*dubm2)/total(bext[ilam,0,*]*dubm2)
  endfor

; Normalize AOD to 550 nm
  aod = aod/aod[5]
  aodm2 = aodm2/aodm2[5]

; Make a plot
  set_plot, 'ps'
  device, file='psd.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=12
  !p.font=0

  plot, indgen(20), /nodata, $
   xrange=[0,6], xstyle=1, xtitle='Bin', $
   xtickn=[' ','1','2','3','4','5',' '], $
   xticks=6, $
   yrange=[0,1.5], ytitle='mFrac', $
   position=[0.05,.1,.45,.9]
  oplot,indgen(5)+1, dub/max(dub), thick=6
  oplot,indgen(5)+1, dubm2/max(dubm2), thick=6, lin=2
device, /close


; Make a plot
  set_plot, 'ps'
  device, file='aod_ssa.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=12
  !p.font=0

  plot, indgen(20), /nodata, $
   xrange=[0.3,3], /xlog, xstyle=1, xtitle='Wavelength [!Mm!Nm]', $
   xtickn=['0.3','0.4','0.5','0.6','0.7','0.8','0.9','1','2','3'], $
   xticks=9, xtickv=[findgen(8)*.1+.3,2,3], $
   yrange=[0,1.5], ytitle='AOD', $
   position=[0.05,.1,.45,.9]
  oplot,lambda*1e6, aod, thick=6
  oplot,lambda*1e6, aodm2, thick=6, lin=2
  oplot,lambda*1e6, aodo, thick=6, lin=1



  plot, indgen(20), /nodata, /noerase, $
   xrange=[0.3,3], /xlog, xstyle=1, xtitle='Wavelength [!Mm!Nm]', $
   xtickn=['0.3','0.4','0.5','0.6','0.7','0.8','0.9','1','2','3'], $
   xticks=9, xtickv=[findgen(8)*.1+.3,2,3], $
   yrange=[0.7,1], ytitle='SSA', $
   position=[0.55,.1,.95,.9]
  oplot,lambda*1e6, ssa, thick=6
  oplot,lambda*1e6, ssam2, thick=6, lin=2
  oplot,lambda*1e6, ssao, thick=6, lin=1


  device, /close

end
