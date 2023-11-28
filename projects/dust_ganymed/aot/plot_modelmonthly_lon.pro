; Colarco, December, 2010
; Plot the model AOT for some geographic region similar to how
; satellite plotted

  expid = ['c48_aG40-base-v1',$      ; no forcing
           'c48F_aG40-base-v1', $    ; OPAC-Spheres
           'c48F_aG40-base-v11', $    ; OPAC-Spheroids
           'c48F_aG40-base-v15', $   ; OBS-Spheroids
           'c48F_aG40-kok-v15']      ; OBS-Spheroids/Kok

  nexpid = n_elements(expid)
  colorarray=[0, 254,254,208,84]
  linarray  =[0, 0,  2,  0,  0]

  varwant = [ 'totexttau']

  set_plot, 'ps'
  device, file=expid[0]+'.JJA.aot_lon.eps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8, /encap
  !p.font=0
  loadct, 39
  scale = 1
  plot, indgen(10), /nodata, $
        title = 'AOT at 10!Eo!N - 30!Eo!N N', $
        yrange=[0,1*scale], xrange=[-100,0], xstyle=9, ystyle=9, $
        xtitle='longitude', ytitle = 'AOT', thick=3

  plots, [-95,-85], .9*scale, thick=6
  plots, [-95,-85], .82*scale, thick=6, color=254
  plots, [-95,-85], .74*scale, thick=6, color=254, lin=2
  plots, [-95,-85], .66*scale, thick=6, color=208
  plots, [-95,-85], .58*scale, thick=6, color=84
  xyouts, -82, .88*scale, 'No Forcing', charsize=.9
  xyouts, -82, .8*scale, 'OPAC Spheres', charsize=.9
  xyouts, -82, .72*scale, 'OPAC Spheroids', charsize=.9
  xyouts, -82, .64*scale, 'OBS Spheroids', charsize=.9
  xyouts, -82, .56*scale, 'OBS Spheroids/Kok', charsize=.9

  loadct, 39

  for iexpid = 0, nexpid-1 do begin

   filetemplate = '/misc/prc14/colarco/'+expid[iexpid]+'/tavg2d_carma_x/'+expid[iexpid]+'.tavg2d_carma_x.monthly.clim.JJA.nc4'
   filename = strtemplate(filetemplate,nymd,nhms)
   nc4readvar, filename, varwant, aot, lon=lon, lat=lat, lev=lev, rc=rc

   i = where(lat ge 10 and lat le 30)

   oplot, lon, total(aot[*,i],2)/n_elements(i), color=colorarray[iexpid], lin=linarray[iexpid], thick=6

  endfor

; Now put the MODIS field on here
  read_modis, aotsat, lon, lat, '2007', '07', satid='MYD04', res='b', /old, season='JJA'
  aotsat = reform(aotsat)
  i = where(lat ge 10 and lat le 30)
  loadct, 0
  oplot, lon, total(aotsat[*,i],2)/n_elements(i), color=200, thick=8

  plots, [-50,-40], .9*scale, thick=8, color=200
  xyouts, -37, .88*scale, 'MODIS Aqua', charsize=.9



  device, /close

end
