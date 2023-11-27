; Colarco
; Test mapping Kok PSD to SILAM

  nbin = 4
  rlow = [0.0103,1.,2.5,10.]*1e-6
  rup  = [1.,2.5,10.,30.]*1e-6

  rlavg = make_array(nbin,val=1.)
  rnavg = make_array(nbin,val=1.)
  rgavg = make_array(nbin,val=1.)
  rmavg = make_array(nbin,val=1.)
  rsavg = make_array(nbin,val=1.)

  kok_psd, rlow, rlow, rup, dm, dn, $
       rlavg = rlavg, rgavg = rgavg, rnavg = rnavg, rmavg = rmavg, rsavg = rsavg

end
