; Colarco
; Test mapping Kok PSD to SILAM

  nbin = 1
  rlow = [0.05]*1e-6
  rup  = [20.]*1e-6

  rlavg = make_array(nbin,val=1.)
  rnavg = make_array(nbin,val=1.)
  rgavg = make_array(nbin,val=1.)
  rmavg = make_array(nbin,val=1.)
  rsavg = make_array(nbin,val=1.)

  kok_psd, rlow, rlow, rup, dm, dn, rhod = 2500., $
       rlavg = rlavg, rgavg = rgavg, rnavg = rnavg, rmavg = rmavg, rsavg = rsavg

end
