; Zonal, annual mean extinction profile

  yrange = [1000,500]
  ytickv = [1000,900,800,700,600,500]
  yrange = [1000,25]
  ytickv = [1000,850,700,500,300,200,100,25]

; Setup the plot
  set_plot, 'ps'
  device, file='plot_omega_all_diff.ps', /color, /helvetica, font_size=16, $
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
  makekey, .075, .615, .25, .03, 0, -.04, align=.5, charsize=.6, $
          color=make_array(11,val=0), label=[' ','-20','-10','-5','-2','-1','1','2','5','10','20']
  xyouts, .325, .575, 'hPa day!E-1!N', charsize=.6, /normal

  red   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
  green = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
  blue  = [162,189,165,164,152,255,139,97,67,79,66  ,152,0]
  tvlct, red, green, blue
  levels = [-2000,-20,-10,-5,-2,-1,1,2,5,10,20]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .075, .615, .25, .03, 0, -.02, /noborder, $
     color=dcolors, label=['','','','','','','','','','','','','']


  datafils = ['/misc/prc18/colarco/c180Rreg_H54p3-acma/geosgcm_prog/c180Rreg_H54p3-acma.geosgcm_prog.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c90Rreg_H54p3-acma/geosgcm_prog/c90Rreg_H54p3-acma.geosgcm_prog.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c48Rreg_H54p3-acma/geosgcm_prog/c48Rreg_H54p3-acma.geosgcm_prog.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c180F_H54p3-acma/geosgcm_prog/c180F_H54p3-acma.geosgcm_prog.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c90F_H54p3-acma/geosgcm_prog/c90F_H54p3-acma.geosgcm_prog.monthly.clim.ANN.nc4', $
              '/misc/prc18/colarco/c48F_H54p3-acma/geosgcm_prog/c48F_H54p3-acma.geosgcm_prog.monthly.clim.ANN.nc4' ]


  titles   = ['Rreg!U1/2!S!Eo!N', $
              'Rreg!U1!S!Eo!N', $
              'Rreg!U2!S!Eo!N', $
              'F!U1/2!S!Eo!N', $
              'F!U1!S!Eo!N', $
              'F!U2!S!Eo!N']

  varwant = 'omega'

; Baseline
  iplot = 0
  datafil = datafils[iplot]
  nc4readvar, datafil, varwant, omega, lon=lon, lat=lat, lev=lev
  a = where(omega gt 1e14)
  omega[a] = !values.f_nan
  omega = omega*86400./100.  ; hPa day-1
  omega = mean(omega,dim=1,/nan)

; Zonal mean
  nx = n_elements(lon)
  omega_base = omega
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=yrange, color=iblack, $
        xtickn=[' ',' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytickv=ytickv, charsize=.5, $
        ytitle='pressure [hPa]'
  contour, omega, lat, lev, /over, levels=levels, /cell, c_colors=dcolors
  plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
        xrange=[-90,90], yrange=yrange, color=iblack, $
        xtickn=[' ',' ',' ',' ',' ',' ',' '], $
        xstyle=1, xticks=6, ystyle=1, yticks=7, ytickv=ytickv, charsize=.5
  title = titles[iplot]
  xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=.6

; Get the b-resolution
  datafil = '/misc/prc18/colarco/c180Rreg_H54p3-acma/geosgcm_prog/c180Rreg_H54p3-acma.geosgcm_prog.monthly.clim.ANN.b.nc4'
  nc4readvar, datafil, varwant, omega_b, lon=lon, lat=lat, lev=lev, /sum
  nx = n_elements(lon)
  a = where(omega_b gt 1e14)
  omega_b[a] = !values.f_nan
  omega_b = omega_b*86400./100.  ; hPa day-1
  omega_b = mean(omega_b,dim=1,/nan)
  omega_base_b = omega_b

; Get the c-resolution
  datafil = '/misc/prc18/colarco/c180Rreg_H54p3-acma/geosgcm_prog/c180Rreg_H54p3-acma.geosgcm_prog.monthly.clim.ANN.c.nc4'
  nc4readvar, datafil, varwant, omega_c, lon=lon, lat=lat, lev=lev, /sum
  nx = n_elements(lon)
  a = where(omega_c gt 1e14)
  omega_c[a] = !values.f_nan
  omega_c = omega_c*86400./100.  ; hPa day-1
  omega_c = mean(omega_c,dim=1,/nan)
  omega_base_c = omega_c


; DIFFERENCE PLOT
  omega_base = omega
  loadct, 0
  makekey, .25, .1, .5, .03, 0, -.04, align=.5, charsize=.6, $
           color=make_array(11,val=0), label=[' ','-5','-2','-1','-0.5','-0.1','0.1','0.5','1','2','5']
  xyouts, .75, .06, 'hPa day!E-1!N', charsize=.6, /normal
  red   = [94,50,102,171,230,255,254,253,244,213,158,152,0]
  green = [79,136,194,221,245,255,224,174,109,62,1  ,152,0]
  blue  = [162,189,165,164,152,255,139,97,67,79,66  ,152,0]
  tvlct, red, green, blue
  levels = [-2000,-5,-2,-1,-0.5,-.1,.1,0.5,1,2,5]
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

  makekey, .25, .1, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','','','','']

  for iplot = 1, 5 do begin

   ytitle=''
   if(iplot eq 3) then ytitle = 'pressure [hPa]'

   datafil = datafils[iplot]
   nc4readvar, datafil, varwant, omega, lon=lon, lat=lat, lev=lev
   a = where(omega gt 1e14)
   omega[a] = !values.f_nan
   omega = omega*86400./100.  ; hPa day-1
   omega = mean(omega,dim=1,/nan)

;  Zonal mean
   nx = n_elements(lon)
   if(nx eq 576) then begin
    omega = omega-omega_base
   endif else begin
    if(nx eq 288) then begin
     omega = omega-omega_base_c
    endif else begin
     omega = omega-omega_base_b
    endelse
   endelse
   plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
         xrange=[-90,90], yrange=yrange, color=iblack, $
         xstyle=1, xticks=6, ystyle=1, yticks=7, ytickv=ytickv, charsize=.5, $
        ytitle=ytitle
   contour, omega, lat, lev, /over, levels=levels, /cell, c_colors=dcolors
   plot, indgen(2), /nodata, position=position[*,iplot], /noerase, $
         xrange=[-90,90], yrange=yrange, color=iblack, $
         xstyle=1, xticks=6, ystyle=1, yticks=7, ytickv=ytickv, charsize=.5, $
        ytitle=ytitle
   title = titles[iplot]
   xyouts, position[0,iplot], position[3,iplot]+.01, title, color=iblack, /normal, charsize=.6
  endfor

  loadct, 0
  plots, [.25,.75,.75,.25,.25], [.1,.1,.13,.13,.1], color=0, /normal, thick=2

  device, /close

end
