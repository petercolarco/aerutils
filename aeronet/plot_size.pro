  aeronetPath = './output/aeronet2nc/'
  lambdawant = '550'
  yyyyInp = ['2007']

  sitewant = 'Capo_Verde'
  lon0 = -22.
  lat0 =  16.

;  sitewant = 'Ras_El_Ain'
;  lon0 = -7.5
;  lat0 =  31.5

  sitewant = 'Cape_San_Juan'
  lon0 = -65.5
  lat0 =  18.5

  sitewant = 'La_Parguera'
  lon0 = -67.
  lat0 =  17.

  read_aeronet_inversions2nc, aeronetPath, sitewant, lambdawant, yyyyInp, $
      tauext, tauabs, date, /monthly, r=r, dr=dr, dvdlnr=dvdlnr

; Now read from the model file
  filename = '/misc/prc15/colarco/dR_MERRA-AA-r2/inst3d_aer_v/Y2007/M07/' + $
             'dR_MERRA-AA-r2.inst3d_aer_v.monthly.200707.nc4'
  nc4readvar, filename, 'du', du, /template, wantlon=[lon0], wantlat=[lat0]
  nc4readvar, filename, 'delp', delp, /template, wantlon=[lon0], wantlat=[lat0]
; column integral
  nz = 72
  nbin = 5
  ducm = fltarr(nbin)
  bccm = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   ducm[ibin] = total(du[*,ibin]*delp/9.8)  ; kg m-2
  endfor

; plot
  plot, r, dvdlnr, /nodata, $
   xrange=[.05,15], /xlog, xstyle=9, xtitle = 'radius [um]', $
   yrange=[0,0.35], ystyle=9, ytitle = 'dV/d(ln r) [um]'
  oplot, r, dvdlnr[*,6], thick=3

; plot the model result
  rlow = [.1,1,1.6,3,6]
  rup  = [1.,1.6,3,6,10]
  reff = [.73,1.4,2.4,4.5,8]
  dr = rup-rlow
  rhop = 2650.
  dvdlnr_mod = ducm / rhop * 1e6 * reff/dr
  loadct, 39
  for ibin = 0, nbin-2 do begin
   plots, [rlow[ibin],rup[ibin]], dvdlnr_mod[ibin], thick=3, color=254
   plots, rup[ibin], [dvdlnr_mod[ibin],dvdlnr_mod[ibin+1]], thick=3, color=254
  endfor
  ibin = 4
  plots, [rlow[ibin],rup[ibin]], dvdlnr_mod[ibin], thick=3, color=254

; Now normalize AOT and adjust size
  bext = [1887., 611., 321., 162., 82.]  ; v10 at 550 nm
  aot  = total(ducm*bext)
  dvdlnr_mod2 = [1.,.5,1.75,1,1]*dvdlnr_mod
  aot2 = total(dvdlnr_mod2*rhop/1e6*dr/reff*bext)
  dvdlnr_mod2 = dvdlnr_mod2 * aot/aot2
  for ibin = 0, nbin-2 do begin
   plots, [rlow[ibin],rup[ibin]], dvdlnr_mod2[ibin], thick=3, lin=2, color=254
   plots, rup[ibin], [dvdlnr_mod2[ibin],dvdlnr_mod2[ibin+1]], thick=3, lin=2, color=254
  endfor
  ibin = 4
  plots, [rlow[ibin],rup[ibin]], dvdlnr_mod2[ibin], thick=3, lin=2, color=254

end
