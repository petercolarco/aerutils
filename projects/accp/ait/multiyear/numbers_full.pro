; Get the number of obs in a year and regrid to 1 deg
  read_diurnal_num_nc, 'preccon.full', lon, lat, nx,ny,nt, n_full

  lat0 = -90.+findgen(181)
  lon0 = -180.+findgen(361)
  n1_full = lonarr(360,180)
  for ix = 0, 359 do begin
   for iy = 0, 179 do begin
    a = where(lon ge lon0[ix] and lon lt lon0[ix+1] and $
              lat ge lat0[iy] and lat lt lat0[iy+1])
    if(a[0] ne -1) then n1_full[ix,iy] = total(n_full[a,*])
   endfor
  endfor

  n_full = 0.

  save, /variables, filename='numbers_full.sav'

end
