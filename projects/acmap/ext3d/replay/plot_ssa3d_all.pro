; Zonal, annual mean extinction profile

  yrange = [1000,500]
  ytickv = [1000,900,800,700,600,500]
  yrange = [1000,25]
  ytickv = [1000,850,700,500,300,200,100,25]

; Setup the plot
  set_plot, 'ps'
  device, file='plot_ssa3d_all.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=14, xoff=.5, yoff=.5
  !p.font=0
  position = fltarr(4,6)
  for iplot = 0, 2 do begin
   position[*,iplot] = [.075+iplot*.3,.65,.075+iplot*.3+.25,.95]
  endfor
  for iplot = 3, 5 do begin
   position[*,iplot] = [.075+(iplot-3)*.3,0.22,.075+(iplot-3)*.3+.25,.52]
  endfor
  p0 = 0
  p1 = 0
  geolimits = [-90,-180,90,180]
  if(geolimits[1] lt -180. or geolimits[3] gt 180) then p1=180.
  loadct, 0
  makekey, .25, .1, .5, .03, 0, -.04, align=0, charsize=.6, $
           color=make_array(7,val=0), $
           label=['0.86','0.88','0.90','0.92','0.94','0.96','0.98']

  red   = [255,254,254,253,252,227,177, 152, 0]
  green = [255,217,178,141,78,26,0    , 152, 0]
  blue  = [178,178,76,60,42,28,38     , 152, 0]
  tvlct, red, green, blue
  levels = [0,findgen(7)*.02+.86]
  dcolors=indgen(n_elements(levels)-1)
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1
  dcolors=[dcolors,iblack]

  makekey, .25, .1, .5, .03, 0, -.02, /noborder, $
     color=reverse(dcolors[0:6]), label=['','','','','','','','','']

; datafiles
  datafils = ['/misc/prc18/colarco/c180Rreg_H54p3-acma/tavg3d_aerdiag_v/c180Rreg_H54p3-acma.tavg3d_aerdiag_v.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c90Rreg_H54p3-acma/tavg3d_aerdiag_v/c90Rreg_H54p3-acma.tavg3d_aerdiag_v.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c48Rreg_H54p3-acma/tavg3d_aerdiag_v/c48Rreg_H54p3-acma.tavg3d_aerdiag_v.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c180R_H54p3-acma/tavg3d_aerdiag_v/c180R_H54p3-acma.tavg3d_aerdiag_v.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c90R_H54p3-acma/tavg3d_aerdiag_v/c90R_H54p3-acma.tavg3d_aerdiag_v.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c48R_H54p3-acma/tavg3d_aerdiag_v/c48R_H54p3-acma.tavg3d_aerdiag_v.monthly.clim.ANN.nc4' ]


  titles   = ['Rreg!U1/2!S!Eo!N', $
              'Rreg!U1!S!Eo!N', $
              'Rreg!U2!S!Eo!N', $
              'R!U1/2!S!Eo!N', $
              'R!U1!S!Eo!N', $
              'R!U2!S!Eo!N']

  varwant = ['duextcoef','ssextcoef','ocextcoef','suextcoef','bcextcoef','niextcoef']
  varwan2 = ['duscacoef','ssscacoef','ocscacoef','suscacoef','bcscacoef','niscacoef']
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

  for iplot = 0, 5 do begin

   ytitle = ''
   if(iplot eq 0 or iplot eq 3) then ytitle = 'pressure [hPa]'

   datafil = datafils[iplot]

   nc4readvar, datafil, varwant, tau, lon=lon, lat=lat, lev=lev, /sum
   nc4readvar, datafil, varwan2, ta2, lon=lon, lat=lat, lev=lev, /sum
   tau = ta2/tau
check, tau
;  Zonal mean
   nx = n_elements(lon)
   tau = reform(total(tau,1)/nx)
   plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
         xrange=[-90,90], yrange=yrange, color=iblack, $
         xstyle=1, xticks=6, ystyle=1, yticks=7, ytickv=ytickv, charsize=.5, $
         ytitle=ytitle
   contour, tau, lat, p/100., /over, levels=levels, /fill, c_colors=reverse(dcolors)
   plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
         xrange=[-90,90], yrange=yrange, color=iblack, $
         xstyle=1, xticks=6, ystyle=1, yticks=7, ytickv=ytickv, charsize=.5
   title = titles[iplot]
   xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=.6

  endfor

  loadct, 0
  plots, [.25,.75,.75,.25,.25], [.1,.1,.13,.13,.1], color=0, /normal, thick=2

  device, /close

end
