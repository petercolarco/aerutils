; Aertype is one of 'du' or 'ss'
  aertype = 'du'

; Get some GOCART fields and plot the global mass size fraction by bin
  filename = 'c48R_pI33p7.tavg3d_aer_v.monthly.201606.nc4'
  aertype_ = aertype
  nc4readvar, filename, aertype_, aer, /template, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp
  filename = 'c48R_pI33p7.tavg3d_aer_v.monthly.201612.nc4'
  nc4readvar, filename, aertype_, aer_, /template, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp_

; Get the area
  area, lon, lat, nx, ny, dx, dy, area, grid='b'

; Do vertical integration
  grav = 9.81
  cmass = fltarr(nx,ny,5,2)
  for ibin = 0, 4 do begin
   cmass[*,*,ibin,0] = total(aer[*,*,*,ibin]*delp/grav,3)
   cmass[*,*,ibin,1] = total(aer_[*,*,*,ibin]*delp/grav,3)
  endfor

; Do the global average
  bin = fltarr(5,2)
  for ibin = 0, 4 do begin
   bin[ibin,0] = total(cmass[*,*,ibin,0]*area)/total(area)
   bin[ibin,1] = total(cmass[*,*,ibin,1]*area)/total(area)
  endfor

; Get the budget items
  filename = 'c48R_pI33p7.tavg2d_aer_x.monthly.201606.nc4'
  aertype_ = aertype
  nc4readvar, filename, aertype_+'sd', sd, /template, lon=lon, lat=lat
  aertype_ = aertype
  nc4readvar, filename, aertype_+'wt', wt, /template, lon=lon, lat=lat
  aertype_ = aertype
  nc4readvar, filename, aertype_+'dp', dp, /template, lon=lon, lat=lat
  aertype_ = aertype
  nc4readvar, filename, aertype_+'sv', sv, /template, lon=lon, lat=lat
  filename = 'c48R_pI33p7.tavg2d_aer_x.monthly.201612.nc4'
  aertype_ = aertype
  nc4readvar, filename, aertype_+'sd', sd_, /template, lon=lon, lat=lat
  aertype_ = aertype
  nc4readvar, filename, aertype_+'wt', wt_, /template, lon=lon, lat=lat
  aertype_ = aertype
  nc4readvar, filename, aertype_+'dp', dp_, /template, lon=lon, lat=lat
  aertype_ = aertype
  nc4readvar, filename, aertype_+'sv', sv_, /template, lon=lon, lat=lat


; Do the global average
  sdbin = fltarr(5,2)
  dpbin = fltarr(5,2)
  wtbin = fltarr(5,2)
  svbin = fltarr(5,2)
  fac = 86400.   ; seconds per day
  for ibin = 0, 4 do begin
   sdbin[ibin,0] = total(sd[*,*,ibin]*area)/total(area)*fac
   sdbin[ibin,1] = total(sd_[*,*,ibin]*area)/total(area)*fac
   dpbin[ibin,0] = total(dp[*,*,ibin]*area)/total(area)*fac
   dpbin[ibin,1] = total(dp_[*,*,ibin]*area)/total(area)*fac
   wtbin[ibin,0] = total(wt[*,*,ibin]*area)/total(area)*fac
   wtbin[ibin,1] = total(wt_[*,*,ibin]*area)/total(area)*fac
   svbin[ibin,0] = total(sv[*,*,ibin]*area)/total(area)*fac
   svbin[ibin,1] = total(sv_[*,*,ibin]*area)/total(area)*fac
  endfor

; Losses are the integral of components
  lossbin = sdbin + dpbin + wtbin + svbin

; Lifetime is burden over loss flux
  lifebin = bin / lossbin

; Across all bins
  life = total(bin,1) / total(lossbin,1)

; Loss Rates
  lossdry = bin / (sdbin+dpbin)
  losswet = bin / (wtbin+svbin)

; Make a plot
  set_plot, 'ps'
  device, file='lifetime_size.'+aertype+'.ps', /color, font_size=12
  !p.font=0

  case aertype of
   'du': begin
         color=208
         yrange=[0,12]
         yticks=12
         end
   'ss': begin
         color=74
         yrange=[0,2]
         yticks=10
         end
  endcase


  plot, findgen(7), /nodata, $
   xrange=[0,6], xtitle='bin #', xticks=6, xstyle=1, $
   xtickn=[' ','1','2','3','4','5',' '], $
   yrange=yrange, ytitle='lifetime [days]', yticks=yticks, ystyle=1

  loadct, 39
  oplot, indgen(5)+1, lifebin[*,0], thick=6, color=color
  oplot, indgen(5)+1, lifebin[*,1], thick=6, color=color, lin=2

  device, /close
 

end
