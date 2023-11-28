; Dust particle size distributions from paper

; Here is a default set of sizes for a lognormal
  nbin = 1000
  rmrat = (50.d/.01d)^(3.d/(nbin-1))
  rmin = 0.01d-6
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, r, rup, dr, rlow

; AERONET, Cape Verde, Table 1 in Rob's section
  volume_fraction = [0.094,1.593]
  volume_mean_r   = [0.291,1.797]
  stddev          = [0.481,0.534]
  frac  = volume_fraction/total(volume_fraction)
frac = volume_fraction
  rmed  = volume_mean_r*1e-6
  sigma = exp(stddev)
  lognormal, rmed, sigma, frac, r, dr, dndr, dsdr, dvdr, $
   /vol, rlow=rlow, rup=rup

  set_plot, 'ps'
  device, file='psd2.ps', /color, /helvetica, font_size=14, $
   xsize=20, ysize=14
  !p.font=0

  plot, r*1e6*2, dvdr*r, /xlog, xrange=[0.2,40], /nodata, $
   xstyle=1, xtitle='Diameter [!9m!3m]', ytitle='Volume';, yrange=[0,10]
  oplot, r*1e6*2, dvdr*r, thick=6
  print, total(dvdr*dr)

  loadct, 39
  read_levy, model, rv, sig, vm, nmode
  igood = [0,1,1,1,1,1,1,0,0,1,1,0]
  color = [0,32,96,100,56,56,254,0,0,144,144,0]
  lin   = [0,0,2,3,0,2,0,0,0,0,2,0]
  for imod = 0, n_elements(model)-1 do begin
   if(igood[imod] eq 0) then continue
   rmed  = rv[imod,0:nmode[imod]-1]*1e-6
   sigma = exp(sig[imod,0:nmode[imod]-1])
   frac  = vm[imod,0:nmode[imod]-1]
;   frac  = frac/total(frac)
   lognormal, rmed, sigma, frac, r, dr, dndr, dsdr, dvdr, $
    /vol, rlow=rlow, rup=rup
   oplot, r*1e6*2, dvdr*r, thick=3, color=color[imod], lin=lin[imod]
   print, total(dvdr*dr)
  endfor

  device, /close

end
