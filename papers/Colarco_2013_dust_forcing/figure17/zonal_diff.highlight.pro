; Colarco, March 2013
; Make a plot of the difference in the wind speeds between two simulations

  expid = ['bF_F25b9-base-v8','bF_F25b9-base-v7']
  diffs = ['!4OBS-Spheres - No Forcing !415!Eo!NW - 0!Eo!NW!3', $
           '!4OPAC-Spheres - No Forcing !415!Eo!NW - 0!Eo!NW!3']

;  expid = ['bF_F25b9-base-v7','bF_F25b9-base-v11']
;  diffs = ['!4OPAC-Ellipsoids - OPAC-Spheres !415!Eo!NW - 0!Eo!NW!3', $
;           '!4OPAC-Spheroids - OPAC-Spheres !415!Eo!NW - 0!Eo!NW!3']


  for iexp = 0,1 do begin

; Get the forcing for first experiment
  expid0 = expid[iexp]
  difftitle = diffs[iexp]
  filen = '/Volumes/bender/prc14/colarco/'+expid0+'/geosgcm_prog/'+expid0+ $
          '.geosgcm_prog.monthly.clim.JJA.nc4'

  nc4readvar, filen, 't', t, lon=lon, lat=lat, lev=lev
  nc4readvar, filen, 'u', u, lon=lon, lat=lat, lev=lev
  a = where(t ge 1e12)
  t[a] = !values.f_nan
  u[a] = !values.f_nan

  filen = '/Volumes/bender/prc14/colarco/'+expid0+'/tavg3d_carma_p/'+expid0+ $
          '.tavg3d_carma_p.monthly.clim.JJA.nc4'
  nc4readvar, filen, 'duconc', duconc, lon=lon, lat=lat, lev=lev2
  a = where(duconc ge 1e12)
  duconc[a] = !values.f_nan


; Get the forcing for baseline experiment
  expid1 = 'b_F25b9-base-v1'
;  expid1 = 'bF_F25b9-base-v1'
  filen = '/Volumes/bender/prc14/colarco/'+expid1+'/geosgcm_prog/'+expid1+ $
          '.geosgcm_prog.monthly.clim.JJA.nc4'
  nc4readvar, filen, 't', tb, lon=lon, lat=lat
  nc4readvar, filen, 'u', ub, lon=lon, lat=lat
  a = where(tb ge 1e12)
  tb[a] = !values.f_nan
  ub[a] = !values.f_nan

  dt = t-tb
  du = u-ub

; Now do the zonal averaging
  a = where(lon ge -15 and lon le 0)
  dt = mean(dt[a,*,*], dimension=1,/nan)
  du = mean(du[a,*,*], dimension=1,/nan)
  duconc = mean(duconc[a,*,*], dimension=1,/nan)



  dlevels=findgen(60)*.1-3
  dlevels[0] = -2000.

;  Create a cool - warm color table
   ncolor = n_elements(dlevels)
   red    = fltarr(ncolor)
   green  = fltarr(ncolor)
   blue   = fltarr(ncolor)
;  find levels lt 0
   a = where(dlevels lt 0)
   n = n_elements(a)
   blue[0:n-1] = 255
   green[0:n-1] = findgen(n)/(n)*255
   green[n-1] = 255
   red[n-1] = 255
   nt = ncolor-n
   red[n:ncolor-1] = 255
   green[n:ncolor-1] = reverse(findgen(nt)/(nt)*255)
   red = [0,red]
   blue = [0,blue]
   green = [0,green]
   tvlct, red, green, blue
   dcolors=indgen(ncolor)+1

  set_plot, 'ps'
  device, file = expid0+'.tprofile_15W.highlight.eps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=10, /encap
  !p.font=0

  tickv = 1000-findgen(8)*100
  contour, dt, lat, lev, $
   xrange=[-10,40], yrange=[1000,270], /ylog, $
   levels=dlevels, c_colors=dcolors, /cell, $
   xticks=5, yticks=7, ytickv=tickv, $
   ystyle=5, xstyle=9, $
   xtitle = 'latitude', ytitle='pressure [hPa]', $
   position=[.15,.25,.95,.90]
  contour, du, lat, lev, /over, $
   level=findgen(10)*.5, c_thick=3, c_label=make_array(10,val=1), c_charsize=1.25
  contour, du, lat, lev, /over, $
   level=-5+findgen(10)*.5, c_thick=3, c_lin=2, c_label=make_array(10,val=1), c_charsize=1.25

  contour, duconc, lat, lev2, /over, $
   level=1.e-7, c_thick=8
; Put an altitude axis
  axis, yaxis=0, yticks=5, yrange=[0,10], ytitle='Altitude [km]', ylog=0

    makekey, .15, .075, .8, .035, 0, -.035, color=dcolors, $
     label=[-3,-2,-1,0,1,2,3], $
     align=.5, /no, charsize=.75


  device, /close

  endfor

end
