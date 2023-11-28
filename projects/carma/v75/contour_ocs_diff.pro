; Colarco, November 2018
; Make a difference plot of the model versus some standard

; Intended to be used for annual mean climatology

  expid = 'c90F_pI33p4_ocs'
  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_aer_p/'+expid+'.tavg3d_aer_p.monthly.clim.ANN.nc4'
  nc4readvar, filename, 'ocs', ocs, lon=lon, lev=lev, lat=lat

; zonal mean and unit conversion
  ocs[where(ocs gt 1e14)] = !values.f_nan
  ocs = mean(ocs,dim=1,/nan) * 1.e12 ; pptv

; Get the ACE OCS
  get_ace_ocs, ocs_ace, lat_ace, lev_ace

; Interpolate the model to the ACE grid
  iy = interpol(indgen(n_elements(lat)),lat,lat_ace)
  iz = interpol(indgen(n_elements(lev)),lev,lev_ace)
  ocs = bilinear(ocs,iy,iz)

; Make the differene
  diff = ocs_ace - ocs


; Get atmosphere for a vertical altitude coordinate
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

; Interpolate lev to a height
  iz = interpol(indgen(n_elements(p)),p/100.,lev_ace)
  zu = interpolate(z/1000.,iz)

; Now make a plot
  set_plot, 'ps'
  device, file='contour_ocs.diff.'+expid+'.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

  loadct, 67
  levels = [-1000,-50,-20,-10,-1,1,10,20,50]
  dcolors = findgen(9)*25+25

  contour, diff, lat_ace, zu, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle=' ', xticks=6, $
   ystyle=9, yrange=[15,35], ytitle = ' '

  contour, diff, lat_ace, zu, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, diff, lat_ace, zu, /nodata, /noerase, $
   title = 'Difference ACE - Model OCS mixing ratio [pptv]', $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle='latitude (degrees)', xticks=6, $
   ystyle=9, yrange=[15,35], ytitle = 'Altitude [km]'

  axis, yaxis=1, yrange=[120,5], /ylog, /save, ystyle=1, ytitle='pressure [hPa]'

  labels = string(levels,format='(i4)')
  labels[0] = ' '
  makekey, .1, .05, .8, .04, 0, -.04, align=.5, $
     colors=make_array(n_elements(levels),val=0), $
     labels=labels
  loadct, 67
  makekey, .1, .05, .8, .04, 0, -.04, /noborder, $
     colors=dcolors, labels=make_array(n_elements(levels),val=' ')

  device, /close



end

  
