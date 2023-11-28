  wantlat = [10.]
  wantlon = [-180.,0]

  filename = '/Volumes/misc004/dao_ops/GEOS-4_INTEXB/a_flk_04C/chem/' $
            +'a_flk_04C.chem_diag.eta.20060716_20060731mean.hdf'
  ga_getvar, filename, 'dumass', dumass, lon=lon, lat=lat, lev=lev, $
             wantlon=wantlon, wantlat=wantlat
  ga_getvar, filename, 'surfp', surfp, lon=lon, lat=lat, lev=lev, $
             wantlon=wantlon, wantlat=wantlat
  nz = n_elements(lev)
  set_eta, hyai, hybi, nz=nz
  pressure_levels, surfp, hyai, hybi, p, delp
end
