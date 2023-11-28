filename = '/misc/prc10/MIPAS/MIPAS_Level1/v8.03/2002/07/04/MIP_NL__1PYDSI20020704_011830_000060462007_00232_01789_0000.N1'
filename = '/misc/prc10/MIPAS/MIPAS_Level1/v8.03/2009/03/27/MIP_NL__1PYDSI20090327_002634_000060122077_00346_36973_0000.N1'
mipas_level_1b, filename, lon=lon, lat=lat, alt=alt, $
  band_a=rad_a, band_b=rad_b, bandab=rad_ab, band_c=rad_c, band_d=rad_d

; there are 17 altitudes in a scan; for this file equates to 73 scans
; in vertical; reform arrays
;;  lon = reform(lon,17,73)
;;  lat = reform(lat,17,73)
;;  alt = reform(alt,17,73)
;;  band_a = reform(band_a,11801,17,73)
;;  band_b = reform(band_b,12201,17,73)

; I think I cannot count on regularity -- later period (2009) has
;                                         different number of MDS and
;                                         different spectral
;                                         resolution
; For comparison with paper use this range
  lat = lat[545:573]
  lon = lon[545:573]
  alt = alt[545:573]
  rad_a  = rad_a[*,545:573]
  rad_b  = rad_b[*,545:573]
  rad_ab = rad_ab[*,545:573]
  rad_c  = rad_c[*,545:573]
  rad_d  = rad_d[*,545:573]

  band_a  = 685.+0.0625*findgen(n_elements(rad_a[*,0]))
  band_ab = 1010.+0.0625*findgen(n_elements(rad_ab[*,0]))
  band_b  = 1205.+0.0625*findgen(n_elements(rad_b[*,0]))
  band_c  = 1560.+0.0625*findgen(n_elements(rad_c[*,0]))
  band_d  = 1810.+0.0625*findgen(n_elements(rad_d[*,0]))

  band = [band_a,band_ab,band_b,band_c,band_d]

; Make a plot
  set_plot, 'ps'
  device, file='test.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=24
  !p.font=0

  !p.multi=[0,2,2]
  plot, band_ab, rad_ab[*,4]*1e9, xrange=[1030,1060], $
   xtitle='wavenumber [cm!E-1!N]', ytitle='radiance [nW/(cm!E2!N sr cm!E-1!N)]'
  x = !x.crange[0]+0.7*(!x.crange[1]-!x.crange[0])
  y = !y.crange[0]+0.9*(!y.crange[1]-!y.crange[0])
  xyouts, x, y, string(alt[4],format='(f4.1)')+' km', /data
  plot, band_ab, rad_ab[*,13]*1e9, xrange=[1030,1060], $
   xtitle='wavenumber [cm!E-1!N]', ytitle='radiance [nW/(cm!E2!N sr cm!E-1!N)]'
  x = !x.crange[0]+0.7*(!x.crange[1]-!x.crange[0])
  y = !y.crange[0]+0.9*(!y.crange[1]-!y.crange[0])
  xyouts, x, y, string(alt[13],format='(f4.1)')+' km', /data
  plot, band_ab, rad_ab[*,17]*1e9, xrange=[1030,1060], $
   xtitle='wavenumber [cm!E-1!N]', ytitle='radiance [nW/(cm!E2!N sr cm!E-1!N)]'
  x = !x.crange[0]+0.7*(!x.crange[1]-!x.crange[0])
  y = !y.crange[0]+0.9*(!y.crange[1]-!y.crange[0])
  xyouts, x, y, string(alt[17],format='(f4.1)')+' km', /data
  plot, band_a, rad_a[*,20]*1e9, xrange=[685,800], $
   xtitle='wavenumber [cm!E-1!N]', ytitle='radiance [nW/(cm!E2!N sr cm!E-1!N)]'
  x = !x.crange[0]+0.7*(!x.crange[1]-!x.crange[0])
  y = !y.crange[0]+0.9*(!y.crange[1]-!y.crange[0])
  xyouts, x, y, string(alt[20],format='(f4.1)')+' km', /data
  
  device, /close

  device, file='test2.ps', /color, /helvetica, font_size=12, $
   xsize=36, ysize=14
  !p.multi=0
  !p.font=0

  rad = [rad_a[*,27],rad_ab[*,27],rad_b[*,27],rad_c[*,27],rad_d[*,27]]
  plot, band, rad*1e9, /ylog, yrange=[.1,10000], $
   xtitle='wavenumber [cm!E-1!N]', ytitle='radiance [nW/(cm!E2!N sr cm!E-1!N)]'
  device, /close

  device, file='test3.ps', /color, /helvetica, font_size=12, $
   xsize=36, ysize=14
  !p.multi=0
  !p.font=0

  rad = [rad_a[*,24],rad_ab[*,24],rad_b[*,24],rad_c[*,24],rad_d[*,24]]
  plot, band, rad*1e9, /ylog, yrange=[.1,10000], $
   xtitle='wavenumber [cm!E-1!N]', ytitle='radiance [nW/(cm!E2!N sr cm!E-1!N)]'
  device, /close

end

