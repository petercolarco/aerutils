; Colarco, November 2018
; Contour the zonal mean OCS abundance [pptv] and overplot with the
; zonal mean pSO2_OCS rate

; Intended to be used for annual mean climatology

  expid = 'ace'
  get_ace_ocs, ocs, lat, lev

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
   title = 'OCS mixing ratio [pptv] (shading)', $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle='latitude (degrees)', xticks=6, $
   ystyle=9, yrange=[15,35], ytitle = 'Altitude [km]'

  axis, yaxis=1, yrange=[120,5], /ylog, /save, ystyle=1, ytitle='pressure [hPa]'

  makekey, .1, .05, .8, .04, 0, -.04, align=0, $
     colors=make_array(n_elements(levels),val=0), $
     labels=string(levels,format='(i3)')
  loadct, 74
  makekey, .1, .05, .8, .04, 0, -.04, /noborder, $
     colors=dcolors, labels=make_array(n_elements(levels),val=' ')

  device, /close



end

  
