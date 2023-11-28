; Colarco
; From pressure mass files plot the pressure altitude
; above which half the dust mass resides as a function
; of longitude


  expids = ['b_F25b9-base-v1', $
            'bF_F25b9-base-v1', $
            'bF_F25b9-base-v6', $
            'bF_F25b9-base-v8']
  color=[0, 208, 254, 84]
  lin  =[0,   0,   0,  0]

  set_plot, 'ps'
  device, file='du_mid_height.eps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8, /encap
  !p.font=0
  loadct, 39
  plot, findgen(2), xrange=[-100,0], yrange=[0,4], $
        ytitle='Altitude [km]', ystyle=9, xstyle=9, yticks=4, $
        xtitle='Longitude West of 0!Eo!N', /nodata, thick=3, $
        xticks=5, xtickname=['100!Eo!N W','80!Eo!N W','60!Eo!N W','40!Eo!N W','20!Eo!N W','0!Eo!N'] 

  for iexpid = 0, n_elements(expids)-1 do begin
   expid = expids[iexpid]
   filename = '/Volumes/bender/prc14/colarco/'+expid+'/tavg3d_carma_p/'+ $
              expid+'.tavg3d_carma_p.monthly.clim.JJA.nc4'
print, filename
   du_mid_height, filename, dulev, lon=lon
   presaltnew, dulev, z, rhoa, t, 99999.
   oplot, lon, z, thick=6, color=color[iexpid], lin=lin[iexpid]
  endfor


; Legend hard wired
  loadct, 39
  scale = 4.
  xyouts, -50, 4-.66*scale, '!4No Absorption', charsize=1.3
  xyouts, -50, 4-.74*scale, '!4Weak Absorption', charsize=1.3, color=84
  xyouts, -50, 4-.82*scale, '!4Moderate Absorption', charsize=1.3, color=208
  xyouts, -50, 4-.90*scale, '!4Strong Absorption', charsize=1.3, color=254

  map_set, /noerase, position=[.2,.66,.45,.9], /cont, limit=[-10,-110,40,20]
  loadct, 2
  polyfill, [-100,0,0,-100,-100], [10,10,30,30,10], color=240
  loadct, 0
  plots, [-100,0,0,-100,-100], [10,10,30,30,10]
  map_continents

  device, /close

end
