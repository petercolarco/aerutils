; Compare files
  filename0 = '../dR_MERRA-AA-r2.calipso_1064nm-v10.20090715.nc'
  filename1 = 'dR_MERRA-AA-r2.calipso_1064nm-v10.20090715.nc'

  extt0 = 1
  extdu0 = 1
  extbc0 = 1
  extss0 = 1
  extsu0 = 1
  extoc0 = 1
  ssass0 = 1
  bckoc0 = 1

  extt1 = 1
  extdu1 = 1
  extbc1 = 1
  extss1 = 1
  extsu1 = 1
  extoc1 = 1
  ssass1 = 1
  bckoc1 = 1


  read_curtain, filename0, lon, lat, time, z, dz, $
                extinction_tot = extt0, extinction_du = extdu0, $
                extinction_su = extsu0, extinction_ss = extss0, $
                extinction_oc = extoc0, extinction_bc = extbc0, $
                ssa_oc = ssass0, backscat_oc = bckoc0

  read_curtain, filename1, lon, lat, time, z, dz, $
                extinction_tot = extt1, extinction_du = extdu1, $
                extinction_su = extsu1, extinction_ss = extss1, $
                extinction_oc = extoc1, extinction_bc = extbc1, $
                ssa_oc = ssass1, backscat_oc = bckoc1

  check, extt0-extt1
  check, extdu0-extdu1
  check, extss0-extss1
  check, extsu0-extsu1
  check, extbc0-extbc1
  check, extoc0-extoc1
  check, ssass0-ssass1
  check, bckoc0-bckoc1
end
