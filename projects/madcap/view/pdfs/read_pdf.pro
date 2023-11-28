  pro read_pdf, file, n, lon, lat, psza, pvza, psaa, pvaa, psca

  openr, lun, file, /get
  readf, lun, n, nsza, nvza, nsaa, nvaa, nsca
  lon = fltarr(n)
  lat = fltarr(n)
  readf, lun, lon
  readf, lun, lat
  psza = lonarr(nsza)
  pvza = lonarr(nvza)
  psaa = lonarr(nsaa)
  pvaa = lonarr(nvaa)
  psca = lonarr(nsca)
  readf, lun, psza
  readf, lun, pvza
  readf, lun, psaa
  readf, lun, pvaa
  readf, lun, psca

  free_lun, lun

end
