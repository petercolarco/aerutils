; Colarco
; Test mapping Kok PSD to GOCART

  nbin = 8
  rlow = [0.1,0.18,0.3,0.6,1.,1.8,3.,6.]*1e-6
  rup  = [0.18,0.3,0.6,1.,1.8,3.,6.,10.]*1e-6

  rlavg = make_array(nbin,val=1.)
  rnavg = make_array(nbin,val=1.)
  rgavg = make_array(nbin,val=1.)
  rmavg = make_array(nbin,val=1.)
  rsavg = make_array(nbin,val=1.)

  kok_psd, rlow, rlow, rup, dm, dn, $
       rlavg = rlavg, rgavg = rgavg, rnavg = rnavg, rmavg = rmavg, rsavg = rsavg

end
