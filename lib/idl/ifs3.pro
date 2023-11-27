; Colarco
; Test mapping Kok PSD to SILAM

  nbin = 3
  rlow = [0.06,1.1,1.8]*1e-6
  rup  = [1.1,1.8,40.]*1e-6

  rlavg = make_array(nbin,val=1.)
  rnavg = make_array(nbin,val=1.)
  rgavg = make_array(nbin,val=1.)
  rmavg = make_array(nbin,val=1.)
  rsavg = make_array(nbin,val=1.)

  kok_psd, rlow, rlow, rup, dm, dn, $
       rlavg = rlavg, rgavg = rgavg, rnavg = rnavg, rmavg = rmavg, rsavg = rsavg

end
