; Colarco
; From pressure mass files plot the pressure altitude
; above which half the dust mass resides as a function
; of longitude


  expids = ['b_F25b9-base-v1', $
            'bF_F25b9-base-v1', 'bF_F25b9-base-v11', 'bF_F25b9-base-v7', $
            'bF_F25b9-base-v6', 'bF_F25b9-base-v5', $
            'bF_F25b9-base-v8', 'bF_F25b9-base-v10', 'bF_F25b9-kok-v1' ]
  color=[0, 254, 254, 254, 84, 84, 208, 208, 48]
  lin  =[0, 0,   1,   2,   0,  2,  0,   1, 0]

  set_plot, 'ps'
  device, file='du_mid_height.eps', /color, /helvetica, $
          font_size=10, xoff=.5, yoff=.5, xsize=12, ysize=8, /encap
  !p.font=0
  loadct, 39
  plot, findgen(2), xrange=[-100,0], yrange=[1000,600], $
        ytitle='Altitude [hPa]', ystyle=9, xstyle=9, $
        xtitle='longitude', /nodata, thick=3, $
        title='Dust Mass Median Altitude [hPa]'

  for iexpid = 0, n_elements(expids)-2 do begin
   expid = expids[iexpid]
   filename = '/Volumes/bender/prc14/colarco/'+expid+'/tavg3d_carma_p/'+ $
              expid+'.tavg3d_carma_p.monthly.clim.JJA.nc4'
print, filename
   du_mid_height, filename, dulev, lon=lon

   oplot, lon, dulev, thick=6, color=color[iexpid], lin=lin[iexpid]
  endfor

; Legend hard wired
  loadct, 39
  scale = 200.
  plots, [-50,-40], 1020-.2*scale, thick=6
  plots, [-50,-40], 1020-.5*scale, thick=6, color=254
  plots, [-50,-40], 1020-.7*scale, thick=6, color=254, lin=1
  plots, [-50,-40], 1020-.6*scale, thick=6, color=254, lin=2
  plots, [-50,-40], 1020-.8*scale, thick=6, color=84
  plots, [-50,-40], 1020-.9*scale, thick=6, color=84, lin=2
  plots, [-50,-40], 1020-.3*scale, thick=6, color=208
  plots, [-50,-40], 1020-.4*scale, thick=6, color=208, lin=1
  xyouts, -38, 1020-.16*scale, 'No Forcing', charsize=.9
  xyouts, -38, 1020-.46*scale, 'OPAC-Spheres', charsize=.9
  xyouts, -38, 1020-.66*scale, 'OPAC-Spheroids', charsize=.9
  xyouts, -38, 1020-.56*scale, 'OPAC-Ellipsoids', charsize=.9
  xyouts, -38, 1020-.76*scale, 'SF-Spheres', charsize=.9
  xyouts, -38, 1020-.86*scale, 'SF-Ellipsoids', charsize=.9
  xyouts, -38, 1020-.26*scale, 'OBS-Spheres', charsize=.9
  xyouts, -38, 1020-.36*scale, 'OBS-Spheroids', charsize=.9

  xyouts, -2, 1020-.16*scale, '0', charsize=.9, align=1
  xyouts, -2, 1020-.46*scale, '8.96', charsize=.9, align=1
  xyouts, -2, 1020-.66*scale, '11.26', charsize=.9, align=1
  xyouts, -2, 1020-.56*scale, '10.07', charsize=.9, align=1
  xyouts, -2, 1020-.76*scale, '12.44', charsize=.9, align=1
  xyouts, -2, 1020-.86*scale, '13.03', charsize=.9, align=1
  xyouts, -2, 1020-.26*scale, '3.53', charsize=.9, align=1
  xyouts, -2, 1020-.36*scale, '4.85', charsize=.9, align=1
  xyouts, -2, 1020-1*scale, 'W m!E-2!N', charsize=.9, align=1
  plots, [-10,-2], 1020-.96*scale

  device, /close

end
