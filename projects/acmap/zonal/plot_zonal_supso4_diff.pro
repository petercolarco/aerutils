; Zonal, seasonal mean column AOD

; Setup the plot
  set_plot, 'ps'
  device, file='plot_zonal_supso4_diff.ps', /color, /helvetica, font_size=16, $
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
         yrange=[-.2,.2], ytitle='!9D!3Production [Tg mon!E-1!N]', yticks=4, ystyle=9, $
         position=position[*,iseas]

   for iexpid = 0, nexpid-1 do begin
    expid = expids[iexpid]
    datafil = '/misc/prc14/colarco/'+expid+'/tavg2d_aer_x/'+ $
              expid+'.tavg2d_aer_x.monthly.clim.'+seasons[iseas]+'.nc4'
    nc4readvar, datafil, ['supso4aq','supso4g','supso4wt'], pso4, lon=lon, lat=lat, lev=lev, /sum
    area, lon, lat, nx, ny, dx, dy, area
    pso4 = reform(total(pso4*area,1))*86400.*30.*1e-9  ; Tg mon-1
;   if high resolution integrate to the low resolution grid
;   since we're plotting totals...
    if(ny eq 361) then begin
     pso4_ = pso4
     pso4  = fltarr(91)
     pso4[0] = pso4_[0]
     for iy = 0, 89 do begin
      pso4[iy+1] = total(pso4_[iy*4+1:iy*4+4])
     endfor
     lat = findgen(91)*2-90.
    endif
    if(iexpid eq 0) then begin
     pso4_base = pso4
    endif else begin
     oplot, lat, pso4-pso4_base, thick=6, color=color[iexpid], lin=lins[iexpid]
    endelse
   endfor
   xyouts, -85, .16, seasons[iseas]
  endfor

  device, /close

end
