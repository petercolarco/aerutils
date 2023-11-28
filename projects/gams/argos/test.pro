; Colarco
; Grab a profile from a prior CARMA run to produce the vertical levels
; of reff, loading of sulfate

; This is from an OCS-only run

  filename = '/misc/prc18/colarco/c90F_pI33p9_ocs/c90F_pI33p9_ocs.tavg3d_carma_v.monthly.201204.nc4'

  nc4readvar, filename, 'su0', su, wantlon=[0.1,0.1], wantlat=[40,40], /tem, /sum
  nc4readvar, filename, 'sureff', reff, wantlon=[0.1,0.1], wantlat=[40,40]
  nc4readvar, filename, 'delp', delp, wantlon=[0.1,0.1], wantlat=[40,40]

; Use level 33 for 20 km
  print, reff[33]*1e6
  print, su[33]
  print, total(su*delp/9.8)

end
