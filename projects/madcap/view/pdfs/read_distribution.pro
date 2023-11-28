  pro read_distribution, file, lon, lat, $
                         vza, sza, vaa, saa, scat, $
                         pvza, psza, pvaa, psaa, pscat

  openr, lun, file, /get
  readf, lun, n, nsza, nvza, nsaa, nvaa, nsca
  lon = fltarr(n)
  lat = fltarr(n)
  vza = fltarr(n)
  sza = fltarr(n)
  vaa = fltarr(n)
  saa = fltarr(n)
  scat = fltarr(n)
  readf, lun, lon
  readf, lun, lat
  readf, lun, vza
  readf, lun, sza
  readf, lun, vaa
  readf, lun, saa
  readf, lun, scat

  psza = lonarr(nsza)
  pvza = lonarr(nvza)
  psaa = lonarr(nsaa)
  pvaa = lonarr(nvaa)
  pscat = lonarr(nsca)
  readf, lun, psza
  readf, lun, pvza
  readf, lun, psaa
  readf, lun, pvaa
  readf, lun, pscat

end
