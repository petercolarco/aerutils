; Here, select ocean when land and ocean together
  function merge_land_ocean, aoto, aotl, lon, lat

  nx = n_elements(lon)
  ny = n_elements(lat)

  a = where(aoto gt 1.e14)
  aoto[a] = !values.f_nan
  a = where(aotl gt 1.e14)
  aotl[a] = !values.f_nan

  aot = aotl
  a = where(finite(aoto) eq 1)
  if(a[0] ne -1) then aot[a] = aoto[a]

  return, aot

end
