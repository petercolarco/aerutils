; Colarco, November 2018
; Contour the zonal mean OCS abundance [pptv] and overplot with the
; zonal mean pSO2_OCS rate

; Intended to be used for annual mean climatology

  expid = 'c90F_pI33p4_ocs'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_aer_p/'+expid+'.tavg3d_aer_p.monthly.200412.nc4'
print, filename
  nc4readvar, filename, 'so2', so2, lon=lon, lev=lev, lat=lat

; zonal mean and unit conversion
  so2[where(so2 gt 1e14)] = !values.f_nan
  so2 = mean(so2,dim=1,/nan)*29./64. * 1.e12 ; pptv

; Get atmosphere for a vertical altitude coordinate
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

; Interpolate lev to a height
  iz = interpol(indgen(n_elements(p)),p/100.,lev)
  zu = interpolate(z/1000.,iz)

; Now make a plot
  set_plot, 'ps'
  device, file='contour_so2.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 39
; levels and colors similar to Pengfei
  levels = [0,3.25,6.9,14.6,31.1,65.9,140,297,630,1340,2840,6020,12800,27100,57500,122000,259000,550000]*1e-3
  dcolors = reverse(255-findgen(18)*14)

  contour, so2, lat, lev, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle=' ', xticks=6, $
   ystyle=9, yrange=[1000,2], ytitle = ' ', /ylog

  contour, so2, lat, lev, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, so2, lat, lev, /nodata, /noerase, $
   title = 'SO2 mixing ratio [pptv], February 2004', $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle='latitude (degrees)', xticks=6, $
   ystyle=9, yrange=[1000,2], ytitle = 'pressure [hPa]', /ylog

  axis, yaxis=1, yrange=[0,45], /save, ystyle=1, ytitle='Altitude [km]', ylog=0

  slevels = string(levels,format='(f5.1)')
  a = where(levels gt .001)
  slevels[a] = string(levels[a],format='(f5.3)')
  a = where(levels gt 1)
  slevels[a] = string(levels[a],format='(f5.2)')
  a = where(levels gt 10)
  slevels[a] = string(levels[a],format='(f5.1)')
  a = where(levels gt 100)
  slevels[a] = string(levels[a],format='(i3)')

  makekey, .1, .05, .8, .04, 0, -.04, align=0, $
     colors=make_array(n_elements(levels),val=0), $
     labels=slevels, chars=.75
  loadct, 39
  makekey, .1, .05, .8, .04, 0, -.04, /noborder, $
     colors=dcolors, labels=make_array(n_elements(levels),val=' ')

  device, /close



end

  
