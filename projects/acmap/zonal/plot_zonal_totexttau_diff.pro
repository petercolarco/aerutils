; Zonal, seasonal mean column AOD

; Setup the plot
  set_plot, 'ps'
  device, file='plot_zonal_totexttau_diff.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=16, xoff=.5, yoff=.5

  loadct, 39
  !p.font=0
  position = fltarr(4,4)
  position = [ [.1,.62,.475,.95], [.6,.62,.975,.95], $
               [.1,.17,.475,.475], [.6,.17,.975,.475]]

  expids = ['c180R_H40_acma', 'c48F_H40_acma', 'c48R_H40_acma', 'c48Rreg_H40_acma', $
            'c180F_H40_acma', 'c180Rreg_H40_acma', $
            'c48c_acma', 'c48c_acma_inst' ]
  nexpid = n_elements(expids)
  color  = [76, 254, 254, 254, 76, 76, 208, 176]
  lins   = [1,  0,   1,   2,   0,  2,  1,   1]
  seasons = ['DJF', 'MAM', 'JJA', 'SON']
;  seasons = ['M01','M02','M03','M04']

  for iseas = 0, 3 do begin

   plot, findgen(10), /nodata, thick=3, /noerase, $
         xrange=[-90,90], xtitle='Latitude', xticks=6, xstyle=9, $
         yrange=[-.05,.07], ytitle='!9D!3AOD', yticks=6, ystyle=9, $
         position=position[*,iseas]

   for iexpid = 0, nexpid-1 do begin
    expid = expids[iexpid]
    datafil = '/misc/prc14/colarco/'+expid+'/tavg2d_aer_x/'+ $
              expid+'.tavg2d_aer_x.monthly.clim.'+seasons[iseas]+'.nc4'
    nc4readvar, datafil, 'totexttau', tau, lon=lon, lat=lat, lev=lev
    tau = reform(total(tau,1))/n_elements(lon)
    if(iexpid eq 0) then begin
     tau_base = tau
    endif else begin
     tau_base_use = tau_base
     if(n_elements(lat) eq 91) then begin
      tau_base_use = fltarr(91)
      tau_base_use[0] = tau_base[0]
      for iy = 1, 90 do begin
       tau_base_use[iy] = total(tau_base[(iy-1)*4+1:(iy-1)*4+4])/4.
      endfor
     endif
     oplot, lat, tau-tau_base_use, thick=6, color=color[iexpid], lin=lins[iexpid]
    endelse
   endfor
   xyouts, -85, .06, seasons[iseas]
  endfor

  device, /close

end
