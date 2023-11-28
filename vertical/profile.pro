; Colarco
; Plot the mass loading and zonal wind for a model run

  expids = ['b_F25b9-base-v1', $
            'bF_F25b9-base-v1', 'bF_F25b9-base-v11', 'bF_F25b9-base-v7', $
            'bF_F25b9-base-v6', 'bF_F25b9-base-v5', $
            'bF_F25b9-base-v8', 'bF_F25b9-base-v10' ]

  lons = [-80,-60,-40,-20]

  loadct, 39

  for iexpid = 0, n_elements(expids)-1 do begin

   expid = expids[iexpid]

   for ilon = 0, n_elements(lons)-1 do begin

    dir = '/misc/prc14/colarco/'+expid
    dufile = dir+'/tavg3d_carma_p/'+expid+'.tavg3d_carma_p.monthly.clim.JJA.nc4'
    ufile  = dir+'/geosgcm_prog/'+expid+'.geosgcm_prog.monthly.clim.JJA.nc4'

    nc4readvar, dufile, 'du', du, lon=lon, lat=lat, lev=lev
    nc4readvar,  ufile,  'u',  u, lon=lon, lat=lat, lev=lev

    a = where(du gt 1e14)
    du[a] = !values.f_nan
    a = where(u gt 1e14)
    u[a]  = !values.f_nan

    a = where(lon eq lons[ilon])
    du = reform(du[a,*,*])
    u  = reform(u[a,*,*])

    set_plot, 'ps'
    lonstr = strpad(abs(lons[ilon]),10)+'W'
    device, file=expid+'.profile_'+lonstr+'.ps', /color, /helvetica, $
            font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8
    !p.font=0

    levelarray = [5, 10, 20, 50, 100, 150, 200, 250, 300, 350, 400]
    colorArray = [30,64,80,96,144,176,192,199,208,254,10]
    contour, du*1e9, lat, lev, level=levelarray, /cell, $
             yrange=[1000,500], /ylog, xrange=[-10,60], xstyle=1, ystyle=1, $
             xtitle='latitude', ytitle='pressure [hPa]', $
             yticks=10, ytickv=findgen(11)*50+500, $
             position=[.15,.25,.95,.95], c_color=colorarray

    loadct, 0
    contour, u, lat, lev, level=[-15,-12,-9,-6,-3,0,3,6,9,12,15], $
             c_thick=3, /overplot, c_label=[0,1,0,1,0,1,0,1,0,1,0], $
             c_lin=[2,2,2,2,2,0,0,0,0,0,0,0], c_color=80, c_charsize=1.25
    loadct, 39
    makekey, .15, .075, .8, .035, 0, -.035, color=colorarray, $
     label=string(levelarray,format='(i3)'), $
     align=0, /no, charsize=.75
    device, /close

   endfor
  endfor


end
