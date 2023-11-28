; Zonal, seasonal mean column AOD

; Setup the plot
  set_plot, 'ps'
  device, file='plot_zonal_so4cmass.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=16, xoff=.5, yoff=.5

  loadct, 39
  !p.font=0
  position = fltarr(4,4)
  position = [ [.1,.62,.475,.95], [.6,.62,.975,.95], $
               [.1,.17,.475,.475], [.6,.17,.975,.475]]

  expids = ['c48F_H40_acma', 'c48R_H40_acma', 'c48Rreg_H40_acma', $
            'c48Ff_H40_acma', 'c48Rf_H40_acma', 'c48Rfreg_H40_acma', $
            'c48c_acma' ]
  nexpid = n_elements(expids)
  color  = [254, 254, 254, 76, 76, 76, 208]
  lins   = [0,   1,   2,   0,  1,  2,  1]
  seasons = ['DJF', 'MAM', 'JJA', 'SON']
;  seasons = ['M01','M02','M03','M04']

  area, lon, lat, nx, ny, dx, dy, area, grid='b'

  for iseas = 0, 3 do begin

   plot, findgen(10), /nodata, thick=3, /noerase, $
         xrange=[-90,90], xtitle='Latitude', xticks=6, xstyle=9, $
         yrange=[0,.08], ytitle='SO4 Loading (Tg)', yticks=4, ystyle=9, $
         position=position[*,iseas]

   for iexpid = 0, nexpid-1 do begin
    expid = expids[iexpid]
    datafil = '/misc/prc14/colarco/'+expid+'/tavg2d_aer_x/'+ $
              expid+'.tavg2d_aer_x.monthly.clim.'+seasons[iseas]+'.nc4'
    nc4readvar, datafil, 'so4cmass', tau, lon=lon, lat=lat, lev=lev
    tau = reform(total(tau*area,1))/1e9
    oplot, lat, tau, thick=6, color=color[iexpid], lin=lins[iexpid]
   endfor
   xyouts, -85, .1375*.08/.15, seasons[iseas]
  endfor

  device, /close

end
