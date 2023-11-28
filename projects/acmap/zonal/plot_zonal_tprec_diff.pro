; Zonal, seasonal mean column AOD

; Setup the plot
  set_plot, 'ps'
  device, file='plot_zonal_tprec_diff.ps', /color, /helvetica, font_size=16, $
          xsize=24, ysize=16, xoff=.5, yoff=.5

  loadct, 39
  !p.font=0
  position = fltarr(4,4)
  position = [ [.1,.62,.475,.95], [.6,.62,.975,.95], $
               [.1,.17,.475,.475], [.6,.17,.975,.475]]

  expids = ['c180R_H40_acma', 'c48F_H40_acma', 'c48R_H40_acma', 'c48Rreg_H40_acma', $
            'c180F_H40_acma', 'c180Rreg_H40_acma', $
            'c48c_acma' ]
  nexpid = n_elements(expids)
  color  = [76, 254, 254, 254, 76, 76, 208]
  lins   = [1,  0,   1,   2,   0,  2,  1]
  seasons = ['DJF', 'MAM', 'JJA', 'SON']
;  seasons = ['M01','M02','M03','M04']

  for iseas = 0, 3 do begin

   plot, findgen(10), /nodata, thick=3, /noerase, $
         xrange=[-90,90], xtitle='Latitude', xticks=6, xstyle=9, $
         yrange=[-2,2], ytitle='!9D!3Precipitation [mm day!E-1!N]', yticks=4, ystyle=9, $
         position=position[*,iseas]

   for iexpid = 0, nexpid-1 do begin
    expid = expids[iexpid]
    datafil = '/misc/prc14/colarco/'+expid+'/geosgcm_surf/'+ $
              expid+'.geosgcm_surf.monthly.clim.'+seasons[iseas]+'.nc4'
    nc4readvar, datafil, 'tprec', prec, lon=lon, lat=lat, lev=lev
    prec = reform(total(prec,1))/n_elements(lon)*86400
    if(iexpid eq 0) then begin
     prec_base = prec
    endif else begin
     prec_base_use = prec_base
     if(n_elements(lat) eq 91) then begin
      prec_base_use = fltarr(91)
      prec_base_use[0] = prec_base[0]
      for iy = 1, 90 do begin
       prec_base_use[iy] = total(prec_base[(iy-1)*4+1:(iy-1)*4+4])/4.
      endfor
     endif
     oplot, lat, prec-prec_base_use, thick=6, color=color[iexpid], lin=lins[iexpid]
    endelse
   endfor
   xyouts, -85, .0325*2/.04, seasons[iseas]
  endfor

  device, /close

end
