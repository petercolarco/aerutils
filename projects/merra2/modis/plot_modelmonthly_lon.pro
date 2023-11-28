; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  varwant = [ 'totexttau']

  set_plot, 'ps'
  device, file='merra2.JJA.aot_lon.eps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8, /encap
  !p.font=0
  loadct, 39
  scale = 1
  plot, indgen(10), /nodata, $
        title = 'AOT at 10!Eo!N - 30!Eo!N N', $
        yrange=[0,1*scale], xrange=[-100,0], xstyle=9, ystyle=9, $
        xtitle='longitude', ytitle = 'AOT', thick=3

  plots, [-95,-85], .9*scale, thick=6
  xyouts, -82, .88*scale, 'MERRA-2', charsize=.9

  colorarray=[0, 254,254,254,84,84,208,208,48]
  linarray  =[0, 0,  1,  2,  0, 2,0,1,0]


  loadct, 39

  filename = '/misc/prc13/MERRA2/d5124_m2_jan79/tavg1_2d_aer_Nx/d5124_m2_jan79.tavg1_2d_aer_Nx.monthly.clim.JJA.nc4'
  nc4readvar, filename, varwant, aot, lon=lon, lat=lat, lev=lev, rc=rc

  i = where(lat ge 10 and lat le 30)

  oplot, lon, total(aot[*,i],2)/n_elements(i), color=colorarray[0], lin=linarray[0], thick=6


; Now put the MODIS field on here
;  read_modis, aotsat, lon, lat, '2007', '07', satid='MYD04', res='b',
;  /old, season='JJA'
  filename = '/science/modis/data/Level3/MYD04/hourly/d/GRITAS/clim/MYD04_L2_ocn.aero_tc8_051.qast_qawt.num.clim.JJA.nc4'
  nc4readvar, filename, 'aot', aotocn, lon=lon, lat=lat
  filename = '/science/modis/data/Level3/MYD04/hourly/d/GRITAS/clim/MYD04_L2_lnd.aero_tc8_051.qast3_qawt.num.clim.JJA.nc4'
  nc4readvar, filename, 'aot', aotlnd, lon=lon, lat=lat
  aotsat = aotlnd
  a = where(aotocn lt 1e14)
  aotsat[a] = aotocn[a]
  a = where(aotsat gt 1e14)
  aotsat[a] = !values.f_nan
  aotsat = reform(aotsat)
  i = where(lat ge 10 and lat le 30)
  loadct, 0
  oplot, lon, total(aotsat[*,i],2)/n_elements(i), color=200, thick=8

  plots, [-50,-40], .9*scale, thick=8, color=200
  xyouts, -37, .88*scale, 'MODIS Aqua', charsize=.9



  device, /close

end
