; Read an ODS of MODIS data and make an illustrative map of the
; retrieval locations and the sampling strategy

; Colarco, April 3, 2014
; Modification to illustrate 3 sampling studies conducted

  plotfile = 'map_aqua.eps'
  set_plot, 'ps'
  device, file=plotfile, /color, font_size=10, /helvetica, $
          xsize=36, ysize=22, xoff=.5, yoff=.5, /encap
  !p.font=0


; ----------------------------------------------------------------------
; MODIS along-track sampling
  odsfile = './MYD04_L2_051.aero_tc8.ocean.20100605.ods'
  kx = 311
  kt = 45
  ktqa = 74
  qathresh = 1
  readods, odsfile, kx, kt, lat, lon, lev, time, obs, rc=fail, ks=ks, $
           ktqa=ktqa, qathresh=qathresh, obsq=obsq
  minsyn = 1300
  dt = 90
;  limit = [-4,-140,4,-112]
  limit = [-40,-140,20,-105]

; Limit to a single swath
  a = where(time gt minsyn-dt/2 and time le minsyn+dt/2)
  time = time[a]
  lon = lon[a]
  lat = lat[a]
  ks  = ks[a]

  loadct, 0
  map_set, /cont, limit=limit, position=[.03,.15,.28,.92], /noborder
  polyfill, [-140,-105,-105,-140,-140],[-40,-40,20,20,-40], color=220
; polyfill, [-135.5,-114,-116,-137,-135.5],[-4,-4,4,4,-4], color=255
  polyfill, [-131,-105,-118,-140,-131],[-40,-40,20,20,-40], color=255
  xyouts, -129, 3, 'glint', /data, charsize=2, align=.5
  map_continents

; Make a vector of 16 points, A[i] = 2pi/16:
  A = FINDGEN(17) * (!PI*2/16.)
; Define the symbol to be a unit circle with 16 points, 
; and set the filled flag:
  USERSYM, COS(A), SIN(A), /FILL

  a = where(lev eq 550.)
  plots, lon[a], lat[a], psym=8, noclip=0, color=100, symsize=.5

  loadct, 1
  a = where(lev eq 550. and (ks mod 135) ge 4 and (ks mod 135) le 18)
  plots, lon[a], lat[a], psym=8, color=200, noclip=0, symsize=.5
  a = where(lev eq 550. and (ks-10.)/135. eq long((ks-10)/135))
  plots, lon[a], lat[a], psym=8, color=80, noclip=0, symsize=.5

  loadct, 3
  a = where(lev eq 550. and (ks mod 135) ge 19 and (ks mod 135) le 48)
  plots, lon[a], lat[a], psym=8, color=200, noclip=0, symsize=.5
  a = where(lev eq 550. and (ks-30.)/135. eq long((ks-30)/135))
  plots, lon[a], lat[a], psym=8, color=80, noclip=0, symsize=.5

  loadct, 8
  a = where(lev eq 550. and (ks mod 135) ge 123 and (ks mod 135) le 135)
  plots, lon[a], lat[a], psym=8, color=200, noclip=0, symsize=.5
  a = where(lev eq 550. and (ks-129)/135. eq long((ks-129)/135))
  plots, lon[a], lat[a], psym=8, color=80, noclip=0, symsize=.5

  loadct, 7
  a = where(lev eq 550. and (ks mod 135) ge 49 and (ks mod 135) le 87)
  plots, lon[a], lat[a], psym=8, color=200, noclip=0, symsize=.5
  a = where(lev eq 550. and (ks-67)/135. eq long((ks-67)/135))
  plots, lon[a], lat[a], psym=8, color=80, noclip=0, symsize=.5


  map_grid, /box, londel=5, latdel=5, $
            lons=findgen(8)*5-140, $
            lats=findgen(13)*5-40.



; ----------------------------------------------------------------------
; MODIS across-track sampling

  loadct, 0
  map_set, /cont, limit=limit, position=[.375,.15,.625,.92], /noborder, /noerase
  polyfill, [-140,-105,-105,-140,-140],[-40,-40,20,20,-40], color=220
; polyfill, [-135.5,-114,-116,-137,-135.5],[-4,-4,4,4,-4], color=255
  polyfill, [-131,-105,-118,-140,-131],[-40,-40,20,20,-40], color=255
  xyouts, -129, 3, 'glint', /data, charsize=2, align=.5
  map_continents

  a = where(lev eq 550.)
  plots, lon[a], lat[a], psym=8, noclip=0, color=100, symsize=.5

  loadct, 1
  a = where(lev eq 550. and ((ks-1) mod (135*135)) le 134)
  plots, lon[a], lat[a], psym=8, color=200, noclip=0, symsize=.5

  loadct, 3
  a = where(lev eq 550. and ((ks+(135.*135.)-(4.*27*135.)-1) mod (135*135)) le 134)
  plots, lon[a], lat[a], psym=8, color=200, noclip=0, symsize=.5

  loadct, 8
  a = where(lev eq 550. and ((ks+(135.*135.)-(3.*27*135.)-1) mod (135*135)) le 134)
  plots, lon[a], lat[a], psym=8, color=200, noclip=0, symsize=.5

  loadct, 7
  a = where(lev eq 550. and ((ks+(135.*135.)-(2.*27*135.)-1) mod (135*135)) le 134)
  plots, lon[a], lat[a], psym=8, color=200, noclip=0, symsize=.5

  loadct, 39
  a = where(lev eq 550. and ((ks+(135.*135.)-(1.*27*135.)-1) mod (135*135)) le 134)
  plots, lon[a], lat[a], psym=8, color=254, noclip=0, symsize=.5


  map_grid, /box, londel=5, latdel=5, $
            lons=findgen(8)*5-140, $
            lats=findgen(13)*5-40.



; ----------------------------------------------------------------------
; Model along-track sampling
  loadct, 0
  limit = [-40,-140,20,-105]
  map_set, /cont, limit=limit, position=[.72,.15,.97,.92], /noborder, /noerase
  map_continents

; Get the MODIS full swath
  fdir = '/Volumes/bender/prc15/colarco/dR_MERRA-AA-r2/inst2d_hwl_x/Y2010/M06/'
  nc4readvar, fdir+'/dR_MERRA-AA-r2.inst2d_hwl_x.modis_aqua.20100605.times.nc4', $
              'totexttau', aot, lon=lon, lat=lat
  a = where(aot ge 1e14)
  aot[a] = !values.f_nan
  dx = 0.625
  dy = 0.5
  plotgrid, aot[*,*,22], [0.], [100], lon, lat, dx, dy
  plotgrid, aot[*,*,23], [0.], [100], lon, lat, dx, dy

  loadct, 1
  nc4readvar, fdir+'/dR_MERRA-AA-r2.inst2d_hwl_x.misr_aqua.20100605.nc4', $
              'totexttau', aot, lon=lon, lat=lat
  a = where(aot ge 1e14)
  aot[a] = !values.f_nan
  plotgrid, aot, [0.], [200], lon, lat, dx, dy

  nc4readvar, fdir+'/dR_MERRA-AA-r2.inst2d_hwl_x.calipso.20100605.nc4', $
              'totexttau', aot, lon=lon, lat=lat
  a = where(aot ge 1e14)
  aot[a] = !values.f_nan
  plotgrid, aot, [0.], [80], lon, lat, dx, dy


  loadct, 3
  nc4readvar, fdir+'/dR_MERRA-AA-r2.inst2d_hwl_x.misr_calipso.20100605.nc4', $
              'totexttau', aot, lon=lon, lat=lat
  a = where(aot ge 1e14)
  aot[a] = !values.f_nan
  plotgrid, aot, [0.], [200], lon, lat, dx, dy

  nc4readvar, fdir+'/dR_MERRA-AA-r2.inst2d_hwl_x.calipso_calipso.20100605.nc4', $
              'totexttau', aot, lon=lon, lat=lat
  a = where(aot ge 1e14)
  aot[a] = !values.f_nan
  plotgrid, aot, [0.], [80], lon, lat, dx, dy

  loadct, 1
  nc4readvar, fdir+'/dR_MERRA-AA-r2.inst2d_hwl_x.calipso.20100605.nc4', $
              'totexttau', aot, lon=lon, lat=lat
  a = where(aot ge 1e14)
  aot[a] = !values.f_nan
  plotgrid, aot, [0.], [80], lon, lat, dx, dy

; Fill in extraneous points from other orbits
  loadct, 0
  polyfill, [-140,-135,-135,-140,-140], [16,16,20,20,16], color=100
  polyfill, [-110,-105,-105,-110,-110], [5,5,20,20,5], color=255




  map_grid, /box, londel=5, latdel=5, $
            lons=findgen(8)*5-140, $
            lats=findgen(13)*5-40.

; Labeling
  xyouts, .03, .96, '!4(a)!3 MODIS Along-Track Sampling', /normal, charsize=1.5
  xyouts, .375, .96, '!4(b)!3 MODIS Across-Track Sampling', /normal, charsize=1.5
  xyouts, .72, .96, '!4(c)!3 MERRAero Along-Track Sampling', /normal, charsize=1.5

; Legend
  loadct, 0
  plots, [.03,.07], .11, color=100, thick=8, /normal
  xyouts, .08, .105, 'Full!CSwath', charsize=1.2, color=100, /normal
  loadct, 1
  plots, [.12,.16], .11, color=200, thick=8, /normal
  xyouts, .17, .105, 'N1', charsize=1.2, color=200, /normal
  plots, [.21,.25], .11, color=80, thick=8, /normal
  xyouts, .26, .105, 'C1', charsize=1.2, color=80, /normal
  loadct, 3
  plots, [.12,.16], .09, color=200, thick=8, /normal
  xyouts, .17, .085, 'N2', charsize=1.2, color=200, /normal
  plots, [.21,.25], .09, color=80, thick=8, /normal
  xyouts, .26, .085, 'C2', charsize=1.2, color=80, /normal
  loadct, 8
  plots, [.12,.16], .07, color=200, thick=8, /normal
  xyouts, .17, .065, 'N3', charsize=1.2, color=200, /normal
  plots, [.21,.25], .07, color=80, thick=8, /normal
  xyouts, .26, .065, 'C3', charsize=1.2, color=80, /normal
  loadct, 7
  plots, [.12,.16], .05, color=200, thick=8, /normal
  xyouts, .17, .045, 'N4', charsize=1.2, color=200, /normal
  plots, [.21,.25], .05, color=80, thick=8, /normal
  xyouts, .26, .045, 'C4', charsize=1.2, color=80, /normal
  xyouts, .03, .025, 'Mid-Width Swath (MW) is union of N1 & N2', /normal, charsize=1.2

  loadct, 0
  plots, [.375,.415], .11, color=100, thick=8, /normal
  xyouts, .425, .105, 'Full!CSwath', charsize=1.2, color=100, /normal
  loadct, 1
  plots, [.465,.505], .11, color=200, thick=8, /normal
  xyouts, .515, .105, 'L1', charsize=1.2, color=200, /normal
  loadct, 3
  plots, [.465,.505], .09, color=200, thick=8, /normal
  xyouts, .515, .085, 'L2', charsize=1.2, color=200, /normal
  loadct, 8
  plots, [.465,.505], .07, color=200, thick=8, /normal
  xyouts, .515, .065, 'L3', charsize=1.2, color=200, /normal
  loadct, 7
  plots, [.465,.505], .05, color=200, thick=8, /normal
  xyouts, .515, .045, 'L4', charsize=1.2, color=200, /normal
  loadct, 39
  plots, [.465,.505], .03, color=200, thick=8, /normal
  xyouts, .515, .025, 'L5', charsize=1.2, color=254, /normal

  loadct, 0
  plots, [.72,.76], .11, color=100, thick=8, /normal
  xyouts, .77, .105, 'Full!CSwath', charsize=1.2, color=100, /normal
  loadct, 1
  plots, [.81,.85], .11, color=200, thick=8, /normal
  xyouts, .86, .105, 'Narrow (Aqua)', charsize=1.2, color=200, /normal
  plots, [.81,.85], .09, color=80, thick=8, /normal
  xyouts, .86, .085, 'Curtain (Aqua)', charsize=1.2, color=80, /normal
  loadct, 3
  plots, [.81,.85], .07, color=200, thick=8, /normal
  xyouts, .86, .065, 'Narrow (CALIPSO)', charsize=1.2, color=200, /normal
  plots, [.81,.85], .05, color=80, thick=8, /normal
  xyouts, .86, .045, 'Curtain (CALIPSO)', charsize=1.2, color=80, /normal


  device, /close


end
