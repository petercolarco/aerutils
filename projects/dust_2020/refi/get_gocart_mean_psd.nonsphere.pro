goto, jump
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
; Now blow up bin 1 to make 8 bins total
  dub = [0.009*dub[0], 0.081*dub[0], 0.234*dub[0], 0.676*dub[0], dub[1:4]]



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
; Now blow up bin 1 to make 8 bins total
  dubm2 = [0.009*dubm2[0], 0.081*dubm2[0], 0.234*dubm2[0], 0.676*dubm2[0], dubm2[1:4]]

jump:
  dub   = [0.000959046, 0.00863142, 0.0249352, 0.0720350, $
           0.346460,    0.807746,   1.00000,   0.0642142]

  dubm2 = [0.00313924, 0.0282532, 0.0816202, 0.235792, $
           1.00000,    0.881259,  0.474854,  0.146719]

dub = dub/total(dub)
dubm2 = dubm2/total(dubm2)

; Make a plot
  set_plot, 'ps'
  device, file='psd.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=12
  !p.font=0

  plot, indgen(20), /nodata, $
   xrange=[0,9], xstyle=1, xtitle='Bin', $
   xtickn=[' ','1','2','3','4','5','6','7','8',' '], $
   xticks=9, $
   yrange=[0,1.5], ytitle='mFrac', $
   position=[0.05,.1,.45,.9]
  oplot,indgen(8)+1, dub/max(dub), thick=6
  oplot,indgen(8)+1, dubm2/max(dubm2), thick=6, lin=2
device, /close


; Make a plot
  set_plot, 'ps'
  device, file='aod_ssa.nonsphere.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=12
  !p.font=0

  plot, indgen(20), /nodata, $
   xrange=[0.3,3], /xlog, xstyle=1, xtitle='Wavelength [!Mm!Nm]', $
   xtickn=['0.3','0.4','0.5','0.6','0.7','0.8','0.9','1','2','3'], $
   xticks=9, xtickv=[findgen(8)*.1+.3,2,3], $
   yrange=[0,1.5], ytitle='AOD', $
   position=[0.05,.1,.45,.9]

  loadct, 39

; Do for current model size (dub)
  filedir = '/home/colarco/sandbox/radiation/geosMie/DU/'
  filename = 'optics_DU.input.balkanski27.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  jlam = 28
  nlam = n_elements(lambda)
  aod = fltarr(nlam)
  aodm2 = fltarr(nlam)
  for ilam = 0, nlam-1 do begin
   aod[ilam]   = total(bext[ilam,0,*]*dub)
   aodm2[ilam] = total(bext[ilam,0,*]*dubm2)
  end
  aod = aod/aod[jlam]
  aodm2 = aodm2/aodm2[jlam]
  oplot, lambda*1e6, aod, thick=12, color=176
  oplot, lambda*1e6, aodm2, thick=12, color=176, lin=2

  filename = 'optics_DU.input.balkanski.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  jlam = 28
  nlam = n_elements(lambda)
  aod = fltarr(nlam)
  aodm2 = fltarr(nlam)
  for ilam = 0, nlam-1 do begin
   aod[ilam]   = total(bext[ilam,0,*]*dub)
   aodm2[ilam] = total(bext[ilam,0,*]*dubm2)
  end
  aod = aod/aod[jlam]
  aodm2 = aodm2/aodm2[jlam]
  oplot, lambda*1e6, aod, thick=12, color=254
  oplot, lambda*1e6, aodm2, thick=12, color=254, lin=2

  filename = 'optics_DU.input.woodward.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  jlam = 3
  nlam = n_elements(lambda)
  aod = fltarr(nlam)
  aodm2 = fltarr(nlam)
  for ilam = 0, nlam-1 do begin
   aod[ilam]   = total(bext[ilam,0,*]*dub)
   aodm2[ilam] = total(bext[ilam,0,*]*dubm2)
  end
  aod = aod/aod[jlam]
  aodm2 = aodm2/aodm2[jlam]
  oplot, lambda*1e6, aod, thick=12, color=208
  oplot, lambda*1e6, aodm2, thick=12, color=208, lin=2

  filename = 'optics_DU.input.v15_6.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  jlam = 5
  nlam = n_elements(lambda)
  aod = fltarr(nlam)
  aodm2 = fltarr(nlam)
  for ilam = 0, nlam-1 do begin
   aod[ilam]   = total(bext[ilam,0,*]*dub)
   aodm2[ilam] = total(bext[ilam,0,*]*dubm2)
  end
  aod = aod/aod[jlam]
  aodm2 = aodm2/aodm2[jlam]
  oplot, lambda*1e6, aod, thick=12, color=84
  oplot, lambda*1e6, aodm2, thick=12, color=84, lin=2

  filename = 'optics_DU.input.opac.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  jlam = 6
  nlam = n_elements(lambda)
  aod = fltarr(nlam)
  aodm2 = fltarr(nlam)
  for ilam = 0, nlam-1 do begin
   aod[ilam]   = total(bext[ilam,0,*]*dub)
   aodm2[ilam] = total(bext[ilam,0,*]*dubm2)
  end
  aod = aod/aod[jlam]
  aodm2 = aodm2/aodm2[jlam]
  oplot, lambda*1e6, aod, thick=12, color=0
  oplot, lambda*1e6, aodm2, thick=12, color=0, lin=2



  plot, indgen(20), /nodata, /noerase, $
   xrange=[0.3,3], /xlog, xstyle=1, xtitle='Wavelength [!Mm!Nm]', $
   xtickn=['0.3','0.4','0.5','0.6','0.7','0.8','0.9','1','2','3'], $
   xticks=9, xtickv=[findgen(8)*.1+.3,2,3], $
   yrange=[0.7,1], ytitle='SSA', $
   position=[0.55,.1,.95,.9]

; Do for current model size (dub)
  filename = 'optics_DU.input.balkanski27.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  jlam = 28
  nlam = n_elements(lambda)
  ssa = fltarr(nlam)
  ssam2 = fltarr(nlam)
  for ilam = 0, nlam-1 do begin
   ssa[ilam]   = total(bsca[ilam,0,*]*dub)/total(bext[ilam,0,*]*dub)
   ssam2[ilam] = total(bsca[ilam,0,*]*dubm2)/total(bext[ilam,0,*]*dubm2)
  end
  oplot, lambda*1e6, ssa, thick=12, color=176
  oplot, lambda*1e6, ssam2, thick=12, color=176, lin=2

  filename = 'optics_DU.input.balkanski.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  jlam = 28
  nlam = n_elements(lambda)
  ssa = fltarr(nlam)
  ssam2 = fltarr(nlam)
  for ilam = 0, nlam-1 do begin
   ssa[ilam]   = total(bsca[ilam,0,*]*dub)/total(bext[ilam,0,*]*dub)
   ssam2[ilam] = total(bsca[ilam,0,*]*dubm2)/total(bext[ilam,0,*]*dubm2)
  end
  oplot, lambda*1e6, ssa, thick=12, color=254
  oplot, lambda*1e6, ssam2, thick=12, color=254, lin=2

  filename = 'optics_DU.input.woodward.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  jlam = 3
  nlam = n_elements(lambda)
  ssa = fltarr(nlam)
  ssam2 = fltarr(nlam)
  for ilam = 0, nlam-1 do begin
   ssa[ilam]   = total(bsca[ilam,0,*]*dub)/total(bext[ilam,0,*]*dub)
   ssam2[ilam] = total(bsca[ilam,0,*]*dubm2)/total(bext[ilam,0,*]*dubm2)
  end
  oplot, lambda*1e6, ssa, thick=12, color=208
  oplot, lambda*1e6, ssam2, thick=12, color=208, lin=2

  filename = 'optics_DU.input.v15_6.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  jlam = 5
  nlam = n_elements(lambda)
  ssa = fltarr(nlam)
  ssam2 = fltarr(nlam)
  for ilam = 0, nlam-1 do begin
   ssa[ilam]   = total(bsca[ilam,0,*]*dub)/total(bext[ilam,0,*]*dub)
   ssam2[ilam] = total(bsca[ilam,0,*]*dubm2)/total(bext[ilam,0,*]*dubm2)
  end
  oplot, lambda*1e6, ssa, thick=12, color=84
  oplot, lambda*1e6, ssam2, thick=12, color=84, lin=2

  filename = 'optics_DU.input.opac.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  jlam = 6
  nlam = n_elements(lambda)
  ssa = fltarr(nlam)
  ssam2 = fltarr(nlam)
  for ilam = 0, nlam-1 do begin
   ssa[ilam]   = total(bsca[ilam,0,*]*dub)/total(bext[ilam,0,*]*dub)
   ssam2[ilam] = total(bsca[ilam,0,*]*dubm2)/total(bext[ilam,0,*]*dubm2)
  end
  oplot, lambda*1e6, ssa, thick=12, color=0
  oplot, lambda*1e6, ssam2, thick=12, color=0, lin=2




  device, /close

end
