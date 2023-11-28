; Colarco
; From pressure mass files plot the pressure altitude
; above which half the dust mass resides as a function
; of longitude


  expids = ['merra2gmi','c180F_pI20p1-acma', $
            'c180F_pI20p1-acma_nodu', $
            'c180F_pI20p1-acma_spher','c180F_pI20p1-acma_gocart', $
            'c180F_pI20p1-acma_spher_noir']

  color     = [140, 0, 176, 254, 208, 254]
  lin       = [  2, 0,   0,   0,   0,   1]

  set_plot, 'ps'
  device, file='du_mid_height.ps', /color, /helvetica, $
          font_size=12, xoff=.5, yoff=.5, xsize=16, ysize=10
  !p.font=0

  plot, findgen(2), xrange=[-100,0], yrange=[1000,600], $
        position=[.15,.15,.95,.9], $
        ytitle='Altitude [hPa]', ystyle=9, xstyle=9, $
        xtitle='longitude', /nodata, thick=3, $
        title='Dust Mass Median Altitude [hPa]'

  for iexpid = 0, n_elements(expids)-1 do begin
   expid = expids[iexpid]
   loadct, 39
   filename = '/misc/prc18/colarco/'+expid+'/tavg3d_aer_p/'+ $
              expid+'.tavg3d_aer_p.monthly.200807.nc4'
   if(expid eq 'merra2gmi') then filename = 'MERRA2_GMI.tavg24_3d_aer_Np.monthly.200807.nc4'
   if(expid eq 'merra2gmi') then loadct, 0
print, filename
   du_mid_height, filename, dulev, lon=lon

   oplot, lon, dulev, thick=12, color=color[iexpid], lin=lin[iexpid]
  endfor

; Legend hard wired
  scale = 200.
  loadct, 0
  plots, [-40,-30], 1000-.9*scale, thick=12, color=120, lin=2
  loadct, 39
  plots, [-40,-30], 1000-.6*scale, thick=12, color=0
  plots, [-40,-30], 1000-.7*scale, thick=12, color=254
  plots, [-40,-30], 1000-.5*scale, thick=12, color=176
  plots, [-40,-30], 1000-.8*scale, thick=12, color=208
  xyouts, -28, 1000-.86*scale, 'MERRA-2 GMI', charsize=.9
  xyouts, -28, 1000-.56*scale, 'Kok (Old)', charsize=.9
  xyouts, -28, 1000-.66*scale, 'Kok', charsize=.9
  xyouts, -28, 1000-.46*scale, 'No Forcing', charsize=.9
  xyouts, -28, 1000-.76*scale, 'GOCART', charsize=.9

  device, /close

end
