; Colarco
; Test mapping Kok PSD to CARMA bins for mixed and pure groups,
; accounting for differences in densities between elements

; Mixed group case
  rho_mix  = 1923.  ; density kg m-3 of sulfate
  rho_dust = 2650.  ; density kg m-3 of pur dust

; Set up some default CARMA bins
  nbin  = 22
  rmrat = 2.2587828d
  rmin  = 5.d-8
  carmabins, nbin, rmrat, rmin, rho_mix, $
             rmass, rmassup, r, rup, dr, rlow

  rlavg = make_array(nbin,val=1.)
  rnavg = make_array(nbin,val=1.)
  rgavg = make_array(nbin,val=1.)
  rmavg = make_array(nbin,val=1.)

  kok_psd, r, rlow, rup, dm, dn, rhod=rho_dust, rhog=rho_mix, $
           rlavg = rlavg, rgavg = rgavg, rnavg = rnavg, rmavg = rmavg

end
