; Zonal, annual mean scainction profile

  yrange = [1000,500]
  ytickv = [1000,900,800,700,600,500]
  yrange = [1000,100]
  ytickv = [1000,800,600,450,300,100]

; Setup the plot
  set_plot, 'ps'
  device, file='plot_sca3d_all.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=12, xoff=.5, yoff=.5
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
           color=make_array(7,val=0), label=['1','2','4','8','16','32','64']
  xyouts, .75, .06, 'Mm!E-1!N', charsize=.6, /normal

  red   = [255,254,254,253,252,227,177, 152, 0]
  green = [255,217,178,141,78,26,0    , 152, 0]
  blue  = [178,178,76,60,42,28,38     , 152, 0]
  tvlct, red, green, blue
  levels = [1,2,4,8,16,32,64]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .1, .5, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','']

; datafiles
  datafils = ['/misc/prc14/colarco/c48R_H40_acma/tavg3d_aerdiag_v/c48R_H40_acma.tavg3d_aerdiag_v.monthly.clim.ANN.nc4', $
              '/misc/prc14/colarco/c48Rreg_H40_acma/tavg3d_aerdiag_v/c48Rreg_H40_acma.tavg3d_aerdiag_v.monthly.clim.ANN.nc4', $
              '/misc/prc14/colarco/c48F_H40_acma/tavg3d_aerdiag_v/c48F_H40_acma.tavg3d_aerdiag_v.monthly.clim.ANN.nc4', $
              '/misc/prc14/colarco/c48Rf_H40_acma/tavg3d_aerdiag_v/c48Rf_H40_acma.tavg3d_aerdiag_v.monthly.clim.ANN.nc4', $
              '/misc/prc14/colarco/c48Rfreg_H40_acma/tavg3d_aerdiag_v/c48Rfreg_H40_acma.tavg3d_aerdiag_v.monthly.clim.ANN.nc4', $
              '/misc/prc14/colarco/c48Ff_H40_acma/tavg3d_aerdiag_v/c48Ff_H40_acma.tavg3d_aerdiag_v.monthly.clim.ANN.nc4']


  titles   = ['R!U2!S!Eo!N', $
              'Rreg!U2!S!Eo!N', $
              'F!U2!S!Eo!N', $
              'Rf!U2!S!Eo!N', $
              'Rfreg!U2!S!Eo!N', $
              'Ff!U2!S!Eo!N']

  varwant = ['duscacoef','ssscacoef','ocscacoef','suscacoef','bcscacoef']
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa

  for iplot = 0, 5 do begin

   ytitle = ''
   if(iplot eq 0 or iplot eq 3) then ytitle = 'pressure [hPa]'

   datafil = datafils[iplot]

   nc4readvar, datafil, varwant, tau, lon=lon, lat=lat, lev=lev, /sum
;  Zonal mean
   nx = n_elements(lon)
   tau = reform(total(tau,1)/nx)
   plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
         xrange=[-90,90], yrange=yrange, color=iblack, $
         xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=ytickv, charsize=.8, $
         ytitle=ytitle
   contour, tau*1e6, lat, p/100., /over, levels=levels, /fill, c_colors=dcolors
   plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
         xrange=[-90,90], yrange=yrange, color=iblack, $
         xstyle=1, xticks=6, ystyle=1, yticks=5, ytickv=ytickv, charsize=.8
   title = titles[iplot]
   xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=.6

  endfor

  loadct, 0
  plots, [.25,.75,.75,.25,.25], [.1,.1,.13,.13,.1], color=0, /normal, thick=2

  device, /close

end
