; Get the number of obs in a year and regrid to 1 deg
  read_diurnal_num_nc, 'preccon.nadir045', lon, lat, nx,ny,nt, n_n45
  read_diurnal_num_nc, 'preccon.nadir050', lon, lat, nx,ny,nt, n_n50
  read_diurnal_num_nc, 'preccon.nadir055', lon, lat, nx,ny,nt, n_n55
  read_diurnal_num_nc, 'preccon.nadir060', lon, lat, nx,ny,nt, n_n60
  read_diurnal_num_nc, 'preccon.nadir065', lon, lat, nx,ny,nt, n_n65
  read_diurnal_num_nc, 'preccon.wide045', lon, lat, nx,ny,nt, n_w45
  read_diurnal_num_nc, 'preccon.wide050', lon, lat, nx,ny,nt, n_w50
  read_diurnal_num_nc, 'preccon.wide055', lon, lat, nx,ny,nt, n_w55
  read_diurnal_num_nc, 'preccon.wide060', lon, lat, nx,ny,nt, n_w60
  read_diurnal_num_nc, 'preccon.wide065', lon, lat, nx,ny,nt, n_w65

  lat0 = -90.+findgen(181)
  lon0 = -180.+findgen(361)
  n1_n45 = lonarr(360,180)
  n1_n50 = lonarr(360,180)
  n1_n55 = lonarr(360,180)
  n1_n60 = lonarr(360,180)
  n1_n65 = lonarr(360,180)
  n1_w45 = lonarr(360,180)
  n1_w50 = lonarr(360,180)
  n1_w55 = lonarr(360,180)
  n1_w60 = lonarr(360,180)
  n1_w65 = lonarr(360,180)
  for ix = 0, 359 do begin
   for iy = 0, 179 do begin
    a = where(lon ge lon0[ix] and lon lt lon0[ix+1] and $
              lat ge lat0[iy] and lat lt lat0[iy+1])
    if(a[0] ne -1) then n1_n45[ix,iy] = total(n_n45[a,*])
    if(a[0] ne -1) then n1_n50[ix,iy] = total(n_n50[a,*])
    if(a[0] ne -1) then n1_n55[ix,iy] = total(n_n55[a,*])
    if(a[0] ne -1) then n1_n60[ix,iy] = total(n_n60[a,*])
    if(a[0] ne -1) then n1_n65[ix,iy] = total(n_n65[a,*])
    if(a[0] ne -1) then n1_w45[ix,iy] = total(n_w45[a,*])
    if(a[0] ne -1) then n1_w50[ix,iy] = total(n_w50[a,*])
    if(a[0] ne -1) then n1_w55[ix,iy] = total(n_w55[a,*])
    if(a[0] ne -1) then n1_w60[ix,iy] = total(n_w60[a,*])
    if(a[0] ne -1) then n1_w65[ix,iy] = total(n_w65[a,*])
   endfor
  endfor

  n_n45 = 0.
  n_n50 = 0.
  n_n55 = 0.
  n_n60 = 0.
  n_n65 = 0.
  n_w45 = 0.
  n_w50 = 0.
  n_w55 = 0.
  n_w60 = 0.
  n_w65 = 0.


  save, /variables, filename='numbers.sav'

end
