; Colarco, November 2018
; Contour the zonal mean sulfate aerosol extinction

; Intended to be used for annual mean climatology, but here use what
; we have

  filename='/misc/prc13/MERRA2_GMI/c90/M2G_c90/tavg24_3d_adf_Nv/M2G_c90.tavg24_3d_adf_Nv.monthly.clim.ANN.nc4'
;  filename='/misc/prc13/MERRA2_GMI/c180/MERRA2_GMI/tavg24_3d_adf_Nv/MERRA2_GMI.tavg24_3d_adf_Nv.monthly.clim.ANN.nc4'
  nc4readvar, filename, ['duextcoef','ocextcoef','bcextcoef','niextcoef','ssextcoef','suextcoef'], suext, lon=lon, lev=lev, lat=lat, /sum
;  nc4readvar, filename, 'suextcoef', suext, lon=lon, lev=lev, lat=lat, /sum
  suext = mean(suext,dim=1,/nan)

; Get atmosphere for a vertical altitude coordinate
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

  zu = z/1000.


; Now make a plot
  set_plot, 'ps'
  device, file='contour_extinction.m2gmi_c90_1990.ps', /color, /helvetica, font_size=12, $
;  device, file='contour_extinction.m2gmi.ps', /color, /helvetica, font_size=12, $
   xsize=24, ysize=12, xoff=.5, yoff=.5
  !p.font=0

;  red   = [0, 246,208,166,103,54,2,1]
;  blue  = [0, 239,209,189,169,144,129]
;  green = [0, 247,230,219,207,192,138,80]
;  tvlct, red, green, blue
;  dcolors=indgen(n_elements(red)-1)+1
;  levels = [1,5,10,20,30,40,60]/100.

  loadct, 52
  levels = findgen(11)*.08
  dcolors = indgen(11)*25

  contour, suext, lat, zu, /nodata, $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle=' ', xticks=6, $
   ystyle=9, yrange=[15,35], ytitle = ' '

  contour, suext*1e6, lat, zu, /over, $
   levels=levels, c_color=dcolors, /cell

  loadct, 0
  contour, suext, lat, zu, /nodata, /noerase, $
   title = 'Aerosol Extinction Coefficient [Mm!E-1!N]', $
   position=[.1,.2,.9,.9], $
   xstyle=1, xrange=[-90,90], xtitle='latitude (degrees)', xticks=6, $
   ystyle=9, yrange=[15,35], ytitle = 'Altitude [km]'

  axis, yaxis=1, yrange=[120,5], /ylog, /save, ystyle=1, ytitle='pressure [hPa]'

  makekey, .1, .05, .8, .04, 0, -.04, align=0, $
     colors=make_array(n_elements(levels),val=0), $
     labels=string(levels,format='(f4.2)')
  loadct, 52
  makekey, .1, .05, .8, .04, 0, -.04, /noborder, $
     colors=dcolors, labels=make_array(n_elements(levels),val=' ')

  device, /close

end

