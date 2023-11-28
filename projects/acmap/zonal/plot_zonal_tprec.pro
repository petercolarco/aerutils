; Zonal, seasonal mean column AOD

; Setup the plot
  set_plot, 'ps'
  device, file='plot_zonal_tprec.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=16, xoff=.5, yoff=.5

  loadct, 39
  !p.font=0
  position = fltarr(4,4)
  position = [ [.1,.62,.475,.95], [.6,.62,.975,.95], $
               [.1,.17,.475,.475], [.6,.17,.975,.475]]

  expids = ['c48F_H40_acma', 'c48R_H40_acma', 'c48Rreg_H40_acma', $
            'c180F_H40_acma', 'c180R_H40_acma', 'c180Rreg_H40_acma', $
            'c48c_acma' ]
  nexpid = n_elements(expids)
  color  = [254, 254, 254, 76, 76, 76, 208]
  lins   = [0,   1,   2,   0,  1,  2,  1]
  seasons = ['DJF', 'MAM', 'JJA', 'SON']
;  seasons = ['M01','M02','M03','M04']

  for iseas = 0, 3 do begin

   plot, findgen(10), /nodata, thick=3, /noerase, $
         xrange=[-90,90], xtitle='Latitude', xticks=6, xstyle=9, $
         yrange=[0,10], ytitle='Precipitation [mm day!E-1!N]', yticks=4, ystyle=9, $
         position=position[*,iseas]

   for iexpid = 0, nexpid-2 do begin
    expid = expids[iexpid]
    datafil = '/misc/prc14/colarco/'+expid+'/geosgcm_surf/'+ $
              expid+'.geosgcm_surf.monthly.clim.'+seasons[iseas]+'.nc4'
    nc4readvar, datafil, 'tprec', prec, lon=lon, lat=lat, lev=lev
    prec = reform(total(prec,1))/n_elements(lon)*86400    ; average mm day-1
    oplot, lat, prec, thick=6, color=color[iexpid], lin=lins[iexpid]
   endfor
   xyouts, -85, 1.8*10/2, seasons[iseas]
  endfor

  device, /close

end
