; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  expid = ['b_F25b9-base-v1', $
           'bF_F25b9-base-v1', $
           'bF_F25b9-base-v11', $
           'bF_F25b9-base-v7', $
           'bF_F25b9-base-v6', $
           'bF_F25b9-base-v5', $
           'bF_F25b9-base-v8', $
           'bF_F25b9-base-v10' ]

  varwant = [ 'totexttau']

  wantlat = '-20'

  scale = 1.
  if(abs(fix(wantlat)) gt 50) then scale = .5

  set_plot, 'ps'
  device, file='b_F25b9-base-v1.JJA.aot_'+wantlat+'.ps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8
  !p.font=0
  loadct, 39
  plot, indgen(10), /nodata, $
        title = 'AOT at '+strpad(abs(fix(wantlat)),10)+'!Eo!N W', $
        yrange=[0,1*scale], xrange=[-10,60], xstyle=9, ystyle=9, $
        xtitle='latitude', ytitle = 'AOT', xthick=3, ythick=3

  plots, [35,41], .9*scale, thick=6
  plots, [35,41], .82*scale, thick=6, color=254
  plots, [35,41], .74*scale, thick=6, color=254, lin=1
  plots, [35,41], .66*scale, thick=6, color=254, lin=2
  plots, [35,41], .58*scale, thick=6, color=84
  plots, [35,41], .5*scale, thick=6, color=84, lin=2
  plots, [35,41], .42*scale, thick=6, color=208
  plots, [35,41], .34*scale, thick=6, color=208, lin=1
  xyouts, 43, .88*scale, 'No Forcing', charsize=.9
  xyouts, 43, .8*scale, 'OPAC-Spheres', charsize=.9
  xyouts, 43, .72*scale, 'OPAC-Spheroids', charsize=.9
  xyouts, 43, .64*scale, 'OPAC-Ellipsoids', charsize=.9
  xyouts, 43, .56*scale, 'SF-Spheres', charsize=.9
  xyouts, 43, .48*scale, 'SF-Ellipsoids', charsize=.9
  xyouts, 43, .4*scale, 'OBS-Spheres', charsize=.9
  xyouts, 43, .32*scale, 'OBS-Spheroids', charsize=.9

  colorarray=[0, 254,254,254, 84,84,208,208]
  linarray  =[0, 0,  1, 2,  0, 2, 0,  1]


  loadct, 39

  for iexpid = 0, 7 do begin

   filetemplate = '/misc/prc14/colarco/'+expid[iexpid]+'/tavg2d_carma_x/'+expid[iexpid]+'.tavg2d_carma_x.monthly.clim.JJA.nc4'
   filename = strtemplate(filetemplate,nymd,nhms)
   nc4readvar, filename, varwant, aot, lon=lon, lat=lat, lev=lev, rc=rc

   i = where(lon eq fix(wantlat))

   oplot, lat, aot[i,*], color=colorarray[iexpid], lin=linarray[iexpid], thick=9

  endfor

; Now put the MODIS field on here
  read_modis, aotsat, lon, lat, '2007', '07', satid='MYD04', res='b', /old, season='JJA'
  aotsat = reform(aotsat)
  loadct, 0
  oplot, lat, aotsat[i,*], color=200, thick=9

  plots, [-6,0], .9*scale, thick=6, color=200
  xyouts, 2, .88*scale, 'MODIS Aqua', charsize=.9

  device, /close

end
