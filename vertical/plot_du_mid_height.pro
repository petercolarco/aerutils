; Colarco
; From pressure mass files plot the pressure altitude
; above which half the dust mass resides as a function
; of longitude


  expids = ['b_F25b9-base-v1', $
            'b_G40b10-base-v1', $
            'bF_F25b9-base-v1', $
            'bF_G40b10-base-v1', $
            'bF_F25b9-base-v10', $
            'bF_G40b10-base-v15']
  color=[0, 0, 254, 254, 208, 84]
  lin  =[0, 2,   0,   2,   0,  2]

  set_plot, 'ps'
  device, file='du_mid_height.eps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8, /encap
  !p.font=0
  loadct, 39
  plot, findgen(2), xrange=[-100,0], yrange=[1000,600], $
        ytitle='Altitude [hPa]', ystyle=9, xstyle=9, $
        xtitle='longitude', /nodata, thick=3, $
        title='Dust Mass Median Altitude [hPa]'

  for iexpid = 0, n_elements(expids)-1 do begin
   expid = expids[iexpid]
   filename = '/misc/prc14/colarco/'+expid+'/tavg3d_carma_p/'+ $
              expid+'.tavg3d_carma_p.monthly.clim.JJA.nc4'
print, filename
   du_mid_height, filename, dulev, lon=lon

   oplot, lon, dulev, thick=6, color=color[iexpid], lin=lin[iexpid]
  endfor

; Legend hard wired
  loadct, 39
  scale = 200.
  plots, [-40,-30], 1000-.9*scale, thick=6
  plots, [-40,-30], 1000-.8*scale, thick=6, color=0, lin=2
  plots, [-40,-30], 1000-.7*scale, thick=6, color=254
  plots, [-40,-30], 1000-.6*scale, thick=6, color=254, lin=2
  plots, [-40,-30], 1000-.5*scale, thick=6, color=208
  plots, [-40,-30], 1000-.4*scale, thick=6, color=84, lin=2
  xyouts, -28, 1000-.86*scale, 'No Forcing', charsize=.9
  xyouts, -28, 1000-.76*scale, 'No Forcing (G)', charsize=.9
  xyouts, -28, 1000-.66*scale, 'OPAC-Spheres', charsize=.9
  xyouts, -28, 1000-.56*scale, 'OPAC-Spheres (G)', charsize=.9
  xyouts, -28, 1000-.46*scale, 'OBS-Spheroids', charsize=.9
  xyouts, -28, 1000-.36*scale, 'v15-Spheroids (G)', charsize=.9

  device, /close

end
