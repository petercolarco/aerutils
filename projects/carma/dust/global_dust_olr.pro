  expid = ['c48F_asdI10-dust22', $
           'c48F_asdI10-L132-dust22', $
           'c90F_asdI10-dust22', $
;           'c48F_asdI10-dust22d', $
           'c48F_asdI10-dust11', $
           'c48F_asdI10-dust44']

  aerf = '/misc/prc18/colarco/'+expid+'/tavg2d_carma_x/'+expid+'.tavg2d_carma_x.monthly.clim.ANN.nc4'
  srff = '/misc/prc18/colarco/'+expid+'/geosgcm_surf/'+expid+'.geosgcm_surf.monthly.clim.ANN.nc4'

  gexpid = ['c48F_asdI10a1-acma','c48F_asdI10a1-kok','c48F_asdI10a1-nomaring']
  aerg = '/misc/prc18/colarco/'+gexpid+'/tavg2d_aer_x/'+gexpid+'.tavg2d_aer_x.monthly.clim.ANN.nc4'
  srfg = '/misc/prc18/colarco/'+gexpid+'/geosgcm_surf/'+gexpid+'.geosgcm_surf.monthly.clim.ANN.nc4'

  nf = n_elements(expid)
  ng = n_elements(gexpid)
  olr = fltarr(nf+ng)
  tau = fltarr(nf+ng)

  for i = 0, nf-1 do begin
   nc4readvar, srff[i], ['olr','olrna'], olr_, lon=lon, lat=lat
   olr_ = olr_[*,*,0]-olr_[*,*,1]
   nx = n_elements(lon)
   if(nx eq 144) then grid = 'b'
   if(nx eq 288) then grid = 'c'
   if(nx eq 576) then grid = 'd'
   area, lon, lat, nx, ny, dx, dy, area, grid=grid
   olr[i] = aave(olr_,area)
   nc4readvar, aerf[i], 'totexttau', tau_, lon=lon, lat=lat
   tau[i] = aave(tau_,area)
 endfor

  for i = 0, ng-1 do begin
   nc4readvar, srfg[i], ['olr','olrna'], olr_, lon=lon, lat=lat
   olr_ = olr_[*,*,0]-olr_[*,*,1]
   nx = n_elements(lon)
   if(nx eq 144) then grid = 'b'
   if(nx eq 288) then grid = 'c'
   if(nx eq 576) then grid = 'd'
   area, lon, lat, nx, ny, dx, dy, area, grid=grid
   olr[i+nf] = aave(olr_,area)
   nc4readvar, aerg[i], ['duexttau','ssexttau'], tau_, lon=lon, lat=lat, /sum
   tau[i+nf] = aave(tau_,area)
  endfor

  set_plot, 'ps'
  device, file='global_dust_olr.ps', /color, /helvetica, font_size=14
  !p.font=0

  plot, indgen(10), /nodata, xstyle=9, ystyle=9, $
   yrange=[0,ng+nf+1], ytitle = 'Model', $
   xrange=[4,6], xtitle='Aerosol OLR per unit AOD [W m!E-2!N tau!E-1!N]'

  loadct, 39
  plots, abs(olr[0:nf-1]/tau[0:nf-1]), indgen(nf)+1, psym=sym(1), color=208
  plots, abs(olr[nf:nf+ng-1]/tau[nf:nf+ng-1]), nf+indgen(ng)+1, psym=sym(1), color=254
  device, /close

end

