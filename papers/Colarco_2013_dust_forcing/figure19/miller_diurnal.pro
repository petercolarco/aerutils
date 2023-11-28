; Want to try to investigate diurnal relationships in Miller et
; al. (2004), e.g., Figure 6

; Get the grid cell area
  area, lon, lat, nx, ny, dx, dy, area, grid='b'

; Get the baseline (no forcing) run dust emissions (40 year annual average)
  filename = '/Volumes/bender/prc14/colarco/b_F25b9-base-v1/tavg2d_carma_x/b_F25b9-base-v1.tavg2d_carma_x.2011_2050.nc4'
  nc4readvar, filename, 'duem', duem_0, lon=lon, lat=lat
  duem_0 = duem_0*area*365*86400.*1e-9  ; Tg yr-1

; total emissions
  etot = total(duem_0)

; ord is the sorting order based on dust emission magnitude
  ord = reverse(sort(duem_0)) ; sort high to low

;;;;;
; Now get some radiative stuff
  filename = '/Volumes/bender/prc14/colarco/b_F25b9-base-v1/geosgcm_surf/diurnal/b_F25b9-base-v1.geosgcm_surf.diurnal.clim.JJA.nc4'
  nc4readvar, filename, 'swgnetc', swgnet
  nc4readvar, filename, 'flnsc', lwgnet
  nc4readvar, filename, 'shfx', shfx_0
  nc4readvar, filename, 'pblh', pblh_0
  nc4readvar, filename, 'ustar', ustar_0
  nc4readvar, filename, 'u10m', u10m
  nc4readvar, filename, 'v10m', v10m
  w10m_0 = sqrt(u10m^2 + v10m^2)
  totgnet_0 = swgnet + lwgnet
  filename = '/Volumes/bender/prc14/colarco/b_F25b9-base-v1/tavg2d_carma_x/diurnal/b_F25b9-base-v1.tavg2d_carma_x.diurnal.clim.JJA.nc4'
  nc4readvar, filename, 'duem', duem_0

; Perturbation experiment - base-v1
  filename = '/Volumes/bender/prc14/colarco/bF_F25b9-base-v1/geosgcm_surf/diurnal/bF_F25b9-base-v1.geosgcm_surf.diurnal.clim.JJA.nc4'
  nc4readvar, filename, 'swgnetc', swgnet
  nc4readvar, filename, 'flnsc', lwgnet
  nc4readvar, filename, 'swgnetcna', swgnetna
  nc4readvar, filename, 'flnscna', lwgnetna
  nc4readvar, filename, 'shfx', shfx_1
  nc4readvar, filename, 'pblh', pblh_1
  nc4readvar, filename, 'ustar', ustar_1
  nc4readvar, filename, 'u10m', u10m
  nc4readvar, filename, 'v10m', v10m
  w10m_1 = sqrt(u10m^2 + v10m^2)
  totgnet_1 = swgnet + lwgnet
  sforce_1  = (swgnet-swgnetna) + (lwgnet-lwgnetna)
  filename = '/Volumes/bender/prc14/colarco/bF_F25b9-base-v1/tavg2d_carma_x/diurnal/bF_F25b9-base-v1.tavg2d_carma_x.diurnal.clim.JJA.nc4'
  nc4readvar, filename, 'duem', duem_1

; Perturbation experiment - noir-v1
  filename = '/Volumes/bender/prc14/colarco/bF_F25b9-noir-v1/geosgcm_surf/diurnal/bF_F25b9-noir-v1.geosgcm_surf.diurnal.clim.JJA.nc4'
  nc4readvar, filename, 'swgnetc', swgnet
  nc4readvar, filename, 'flnsc', lwgnet
  nc4readvar, filename, 'swgnetcna', swgnetna
  nc4readvar, filename, 'flnscna', lwgnetna
  nc4readvar, filename, 'shfx', shfx_2
  nc4readvar, filename, 'pblh', pblh_2
  nc4readvar, filename, 'ustar', ustar_2
  nc4readvar, filename, 'u10m', u10m
  nc4readvar, filename, 'v10m', v10m
  w10m_2 = sqrt(u10m^2 + v10m^2)
  totgnet_2 = swgnet + lwgnet
  sforce_2  = (swgnet-swgnetna) + (lwgnet-lwgnetna)
  filename = '/Volumes/bender/prc14/colarco/bF_F25b9-noir-v1/tavg2d_carma_x/diurnal/bF_F25b9-noir-v1.tavg2d_carma_x.diurnal.clim.JJA.nc4'
  nc4readvar, filename, 'duem', duem_2

; Perturbation experiment - kok-v1
  filename = '/Volumes/bender/prc14/colarco/bF_F25b9-kok-v1/geosgcm_surf/diurnal/bF_F25b9-kok-v1.geosgcm_surf.diurnal.clim.JJA.nc4'
  nc4readvar, filename, 'swgnetc', swgnet
  nc4readvar, filename, 'flnsc', lwgnet
  nc4readvar, filename, 'swgnetcna', swgnetna
  nc4readvar, filename, 'flnscna', lwgnetna
  nc4readvar, filename, 'shfx', shfx_3
  nc4readvar, filename, 'pblh', pblh_3
  nc4readvar, filename, 'ustar', ustar_3
  nc4readvar, filename, 'u10m', u10m
  nc4readvar, filename, 'v10m', v10m
  w10m_3 = sqrt(u10m^2 + v10m^2)
  totgnet_3 = swgnet + lwgnet
  sforce_3  = (swgnet-swgnetna) + (lwgnet-lwgnetna)
  filename = '/Volumes/bender/prc14/colarco/bF_F25b9-kok-v1/tavg2d_carma_x/diurnal/bF_F25b9-kok-v1.tavg2d_carma_x.diurnal.clim.JJA.nc4'
  nc4readvar, filename, 'duem', duem_3

; Reform the variables
  nt = 8
  nn = nx*ny*1L
  totgnet_0 = reform(totgnet_0,nn,nt)
  shfx_0 = reform(shfx_0,nn,nt)
  pblh_0 = reform(pblh_0,nn,nt)
  ustar_0 = reform(ustar_0,nn,nt)
  w10m_0 = reform(w10m_0,nn,nt)
  duem_0 = reform(duem_0,nn,nt)
  totgnet_1 = reform(totgnet_1,nn,nt)
  shfx_1 = reform(shfx_1,nn,nt)
  pblh_1 = reform(pblh_1,nn,nt)
  w10m_1 = reform(w10m_1,nn,nt)
  duem_1 = reform(duem_1,nn,nt)
  totgnet_2 = reform(totgnet_2,nn,nt)
  shfx_2 = reform(shfx_2,nn,nt)
  pblh_2 = reform(pblh_2,nn,nt)
  w10m_2 = reform(w10m_2,nn,nt)
  duem_2 = reform(duem_2,nn,nt)
  totgnet_3 = reform(totgnet_3,nn,nt)
  shfx_3 = reform(shfx_3,nn,nt)
  pblh_3 = reform(pblh_3,nn,nt)
  w10m_3 = reform(w10m_3,nn,nt)
  duem_3 = reform(duem_3,nn,nt)
  sforce_1 = reform(sforce_1,nn,nt)
  sforce_2 = reform(sforce_2,nn,nt)
  sforce_3 = reform(sforce_3,nn,nt)
  ustar_0 = reform(ustar_0,nn,nt)
  ustar_1 = reform(ustar_1,nn,nt)
  ustar_2 = reform(ustar_2,nn,nt)
  ustar_3 = reform(ustar_3,nn,nt)
  lons = fltarr(nx,ny)
  for iy = 0,ny-1 do begin
   lons[*,iy] = lon
  endfor
  lats = fltarr(nx,ny)
  for ix = 0,nx-1 do begin
   lats[ix,*] = lat
  endfor
; define a box
  a = where(lons ge -15 and lons le 5 and lats ge 16 and lats le 24)
;  a = where(lons ge -5 and lons le 5 and lats ge 16 and lats le 20)
  totgnet_0 = mean(totgnet_0[a,*],dim=1)
  shfx_0 = mean(shfx_0[a,*],dim=1)
  pblh_0 = mean(pblh_0[a,*],dim=1)
  w10m_0 = mean(w10m_0[a,*],dim=1)
  duem_0 = mean(duem_0[a,*],dim=1)
  totgnet_1 = mean(totgnet_1[a,*],dim=1)
  shfx_1 = mean(shfx_1[a,*],dim=1)
  pblh_1 = mean(pblh_1[a,*],dim=1)
  w10m_1 = mean(w10m_1[a,*],dim=1)
  duem_1 = mean(duem_1[a,*],dim=1)
  totgnet_2 = mean(totgnet_2[a,*],dim=1)
  shfx_2 = mean(shfx_2[a,*],dim=1)
  pblh_2 = mean(pblh_2[a,*],dim=1)
  w10m_2 = mean(w10m_2[a,*],dim=1)
  duem_2 = mean(duem_2[a,*],dim=1)
  totgnet_3 = mean(totgnet_3[a,*],dim=1)
  shfx_3 = mean(shfx_3[a,*],dim=1)
  pblh_3 = mean(pblh_3[a,*],dim=1)
  w10m_3 = mean(w10m_3[a,*],dim=1)
  duem_3 = mean(duem_3[a,*],dim=1)

  sforce_1 = mean(sforce_1[a,*],dim=1)
  sforce_2 = mean(sforce_2[a,*],dim=1)
  sforce_3 = mean(sforce_3[a,*],dim=1)
  ustar_0 = mean(ustar_0[a,*],dim=1)
  ustar_1 = mean(ustar_1[a,*],dim=1)
  ustar_2 = mean(ustar_2[a,*],dim=1)
  ustar_3 = mean(ustar_3[a,*],dim=1)



  set_plot, 'ps'
  device, file='miller_diurnal.eps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=16, ysize=16, /encap
  !p.font=0
  !p.multi = [0,2,2]
  loadct, 39
  hour = findgen(8)*3+1.5

  plot, hour, totgnet_0, /nodata, $
   ytitle='Net Surface Forcing  [w m-2]', $
   xrange=[0,24], yrange=[-100,100], xtitle='Local Hour', $
   xstyle=1, ystyle=1, xticks=8
;  oplot, hour, totgnet_0, thick=8            ; b_v1
  plotw, hour, sforce_1, 10, 75   ; bF_v1
  plotw, hour, sforce_2, 8, 254   ; noir
;  oplot, hour, sforce_3, thick=8, color=208 ; kok

  plots, [1,3], 90, thick=8
  plots, [1,3], 80, thick=8, color=75
  plots, [1,3], 70, thick=8, color=254
;  plots, [1,3], 60, thick=8, color=208
  xyouts, 3.5, 88, 'No Forcing', charsize=.5
  xyouts, 3.5, 78, 'OPAC-Spheres', charsize=.5
  xyouts, 3.5, 68, 'OPAC-Spheres (No IR)', charsize=.5
;  xyouts, 3.5, 58, 'OPAC-Spheres (Kok)', charsize=.5



  plot, hour, shfx_0, /nodata, $
   ytitle='Sensible Heat Flux [w m-2]', $
   xrange=[0,24], yrange=[-50, 300], xtitle='Local Hour', $
   xstyle=1, ystyle=1, xticks=8
  plotw, hour, shfx_0, 12, 0    ; b_v1
  plotw, hour, shfx_1, 10, 75   ; bF_v1
  plotw, hour, shfx_2, 8, 254   ; noir
;  oplot, hour, shfx_3, thick=8, color=208 ; kok

;  plot, hour, pblh_0, /nodata, $
;   ytitle='Planetary Boundary Layer Depth [m]', $
;   xrange=[0,24], yrange=[0,4000], xtitle='Local Hour', $
;   xstyle=1, ystyle=1
;  oplot, hour, pblh_0, thick=8            ; b_v1
;  oplot, hour, pblh_1, thick=8, color=75  ; bF_v1
;  oplot, hour, pblh_2, thick=8, color=254 ; noir
;  oplot, hour, pblh_3, thick=8, color=208 ; kok

;  plot, hour, w10m_0, /nodata, $
;   ytitle='Surface Wind Speed [m s-1]', $
;   xrange=[0,24], yrange=[0,4], xtitle='Local Hour', $
;   xstyle=1, ystyle=1
;  oplot, hour, w10m_0, thick=8            ; b_v1
;  oplot, hour, w10m_1, thick=8, color=75  ; bF_v1
;  oplot, hour, w10m_2, thick=8, color=254 ; noir
;  oplot, hour, w10m_3, thick=8, color=208 ; kok

  plot, hour, ustar_0, /nodata, $
   ytitle='Friction Speed [m s-1]', $
   xrange=[0,24], yrange=[0,0.5], xtitle='Local Hour', $
   xstyle=1, ystyle=1, xticks=8
  plotw, hour, ustar_0, 12, 0    ; b_v1
  plotw, hour, ustar_1, 10, 75   ; bF_v1
  plotw, hour, ustar_2, 8, 254   ; noir
;  oplot, hour, ustar_3, thick=8, color=208 ; kok

  factor = 1000*86400.
  plot, hour, duem_0, /nodata, $
   ytitle='Emissions [g m-2 d-1]', $
   xrange=[0,24], yrange=[0,1], xtitle='Local Hour', $
   xstyle=1, ystyle=1, xticks=8
  plotw, hour, duem_0*factor, 12, 0    ; b_v1
  plotw, hour, duem_1*factor, 10, 75   ; bF_v1
  plotw, hour, duem_2*factor, 8, 254   ; noir
;  oplot, hour, duem_3*factor, thick=8, color=208 ; kok


;  plot, hour, totgnet_0, /nodata, $
;   ytitle='Net Surface Flux  [w m-2]', $
;   xrange=[0,24], yrange=[-200,500], xtitle='Local Hour', $
;   xstyle=1, ystyle=1
;  oplot, hour, totgnet_0, thick=8            ; b_v1
;  oplot, hour, totgnet_1, thick=8, color=75  ; bF_v1
;  oplot, hour, totgnet_2, thick=8, color=254 ; noir
;  oplot, hour, totgnet_3, thick=8, color=208 ; kok



  device, /close

end

