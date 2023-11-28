; Read
  filename = './dR_MERRA-AA-r2.calipso_532nm.20090715.nc'
  backscat_532 = 1
  extinction_532  = 1
  read_curtain, filename, lon, lat, time, z, dz, $
                backscat_du=backscat_532, extinction_du=extinction_532

; Read
  filename = './dR_MERRA-AA-r2.calipso_355nm.20090715.nc'
  backscat_355 = 1
  extinction_355  = 1
  read_curtain, filename, lon, lat, time, z, dz, $
                backscat_du=backscat_355, extinction_du=extinction_355

  z  = transpose(z)  / 1000. ; km
  dz = transpose(dz) /1000. ; km
  backscat_532 = transpose(backscat_532) ; km
  backscat_355 = transpose(backscat_355) ; km
  extinction_532 = transpose(extinction_532) ; km
  extinction_355 = transpose(extinction_355) ; km

  a = where(extinction_532 gt 0.2)

  !P.multi=[0,1,2]
  loadct, 39
  plot, findgen(2), /nodata, $
   yrange=[0,5], xrange=[0,.02]
  plots, backscat_532[a], z[a], psym=3, color=176, noclip=0
  plots, backscat_355[a], z[a], psym=3, color=84, noclip=0

  plot, findgen(2), /nodata, $
   yrange=[0,5], xrange=[0,1]
  plots, extinction_532[a], z[a], psym=3, color=176, noclip=0
  plots, extinction_355[a], z[a], psym=3, color=84, noclip=0
 

end
