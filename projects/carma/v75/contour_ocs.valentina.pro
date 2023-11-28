; Colarco, November 2018
; Contour the zonal mean OCS abundance [pptv] and overplot with the
; zonal mean pSO2_OCS rate

; Intended to be used for annual mean climatology

  expid = 'H43F2000param'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_aer_p/'+expid+'.tavg3d_aer_p.monthly.clim.ANN.nc4'
  nc4readvar, filename, 'ocs', ocs, lon=lon, lev=lev, lat=lat
  nc4readvar, filename, 'pso2_ocs', pso2_ocs, lon=lon, lev=lev

; zonal mean and unit conversion
  ocs[where(ocs gt 1e14)] = !values.f_nan
  pso2_ocs[where(pso2_ocs gt 1e14)] = !values.f_nan
  ocs = mean(ocs,dim=1,/nan) * 1.e12 ; pptv
  pso2_ocs = mean(pso2_ocs,dim=1,/nan)*86400*1e12*28./64. ; pptv day-1

; Get atmosphere for a vertical altitude coordinate
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

; Interpolate lev to a height
  iz = interpol(indgen(n_elements(p)),p/100.,lev)
  zu = interpolate(z/1000.,iz)

; Now make a plot
  set_plot, 'ps'
  device, file='contour_ocs.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 74
  levels = [0,100,150,200,250,300,350,400,425,450,475]
  dcolors = 155 + indgen(11)*10

  contour, ocs, lat, zu, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle=' ', xticks=6, $
   ystyle=9, yrange=[15,35], ytitle = ' '

  contour, ocs, lat, zu, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, ocs, lat, zu, /nodata, /noerase, $
   title = 'OCS mixing ratio [pptv] (shading); pSO2 from OCS [pptv day!E-1!N] (contours)', $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle='latitude (degrees)', xticks=6, $
   ystyle=9, yrange=[15,35], ytitle = 'Altitude [km]'

; plot the pso2
  clevels = [.1,.2,.5,.8,1,1.2,1.5]
  contour, pso2_ocs, lat, zu, levels=clevels, /overplot, $
   c_thick=2, c_label=[1,1,1,1,1,1,1]

  axis, yaxis=1, yrange=[120,5], /ylog, /save, ystyle=1, ytitle='pressure [hPa]'

  makekey, .1, .05, .8, .04, 0, -.04, align=0, $
     colors=make_array(n_elements(levels),val=0), $
     labels=string(levels,format='(i3)')
  loadct, 74
  makekey, .1, .05, .8, .04, 0, -.04, /noborder, $
     colors=dcolors, labels=make_array(n_elements(levels),val=' ')

  device, /close



end

  
