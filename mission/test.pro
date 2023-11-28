; Get the flight track
  datewant= '20070728'
  datadir = '/Users/colarco/Desktop/TC4/data/'
  get_dc8_navtrack, datadir, datewant, lonf, latf, levf, prsf, gmt
  nx = n_elements(gmt)

; Get the model along the track
  model = '/output/tc4/d5_tc4_01/das/tau/Y2007/M07/'+ $
          'd5_tc4_01.total.tau3d.20070728_1800z.hdf'
  get_model_navtrack, model, 'tau', tau, lonf, latf, lev, wanttime=[1]

  model = '/output/tc4/d5_tc4_01/das/tau/Y2007/M07/'+ $
          'd5_tc4_01.dust.tau3d.20070728_1800z.hdf'
  get_model_navtrack, model, 'tau', taudust, lonf, latf, lev, wanttime=[1]

; Correct the dust
  tau = tau - taudust + taudust/2.2


;; Get the model along the track
;  model = '/output/tc4/d5_tc4_01/das/diag/Y2007/M07/'+ $
;          'd5_tc4_01.inst3d_aer_v.20070728_1800z.hdf'
;  get_model_navtrack, model, 'du', du, lonf, latf, lev, wanttime=[1], /template
;  get_model_navtrack, model, 'ss', ss, lonf, latf, lev, wanttime=[1], /template
;  get_model_navtrack, model, 'oc', oc, lonf, latf, lev, wanttime=[1], /template
;  get_model_navtrack, model, 'bc', bc, lonf, latf, lev, wanttime=[1], /template
;  get_model_navtrack, model, 'so4', so4, lonf, latf, lev, wanttime=[1]

;; Correct the dust
;  du = du/2.2
;  tot = du+ss+oc+bc+so4


; Get layer edge heights (geopotential)
  met = '/output/tc4/d5_tc4_01/das/diag/Y2007/M07/'+ $
        'd5_tc4_01.tavg3d_met_e.20070728_1800z.hdf'
  get_model_navtrack, met, 'hghte', hghte, lonf, latf, lev, wanttime=[1]
  nz = n_elements(lev)-1
  dz = hghte[*,1:nz]-hghte[*,0:nz-1]
  hght = hghte[*,0:nz-1]+dz/2.


  ext = tau/dz*1000.
  ext_du = (tau-taudust/2.2)/dz*1000.

; Times
  a = where(gmt gt 49000 and gmt lt 57000)   ; Caribbean
  b = where(gmt gt 61000 and gmt lt 66000)   ; Pacific


  du_carib = total(ext_du[a,*],1)/n_elements(a)
  tot_carib = total(ext[a,*],1)/n_elements(a)
  hght_carib = total(hght[a,*],1)/n_elements(a)

  du_pacif = total(ext_du[b,*],1)/n_elements(b)
  tot_pacif = total(ext[b,*],1)/n_elements(b)
  hght_pacif = total(hght[b,*],1)/n_elements(b)

  set_plot, 'ps'
  device, file='ext.20070728_18z.ps', font_size=14, /helvetica, $
   xoff = 0.5, yoff = 0.5, xsize=16, ysize=12, /color
  !p.font=0

  loadct, 39
  plot, tot_carib, hght_carib/1000, /nodata, $
   yrange=[0,8], thick=3, xrange=[0,0.06], $
   xtitle='Aerosol Extinction [532 nm, km!E-1!N]', $
   ytitle = 'Altitude [km]', xstyle=9, ystyle=9
  oplot, tot_carib, hght_carib/1000, thick=6
  oplot, tot_pacif, hght_pacif/1000, thick=6, lin=1

  device, /close

end
