; Read
  fdir = 'output/data/'
;  fdir = 'virginie/'
;  fdir = '/home/colarco/ftp/for_daniel/'
;fdir = '/home/colarco/'

  filename = fdir+'/dR_MERRA-AA-r2.calipso_355nm-v10.20090715.nc'
print, filename
  backscat_355 = 1
  extinction_355  = 1
  read_curtain, filename, lon, lat, time, z, dz, $
                backscat_du=backscat_355, extinction_du=extinction_355
;                backscat_tot=backscat_355, extinction_tot=extinction_355

  filename = fdir+'/dR_MERRA-AA-r2.calipso_532nm-v10.20090715.nc'
print, filename
  backscat_532 = 1
  extinction_532  = 1
  read_curtain, filename, lon, lat, time, z, dz, $
                backscat_du=backscat_532, extinction_du=extinction_532
;                backscat_tot=backscat_532, extinction_tot=extinction_532

  z  = transpose(z)  / 1000. ; km
  dz = transpose(dz) /1000. ; km
  backscat_532 = transpose(backscat_532) ; km
  backscat_355 = transpose(backscat_355) ; km
  extinction_532 = transpose(extinction_532) ; km
  extinction_355 = transpose(extinction_355) ; km

  a = where(extinction_532 gt 0.02 and extinction_355 gt .05)

;  window, xsize=800, ysize=800
set_plot, 'ps'
device, /color, xsize=12, ysize=20, font_size=16, /helvetica
!p.font=0

  !P.multi=[0,1,3]
  loadct, 39
  plot, findgen(2), /nodata, $
   yrange=[0,5], xrange=[0,.02], title = 'backscatter', ytitle='altitude [km]'
  plots, backscat_532[a], z[a], psym=3, color=176, noclip=0
  plots, backscat_355[a], z[a], psym=3, color=84, noclip=0

  plot, findgen(2), /nodata, $
   yrange=[0,5], xrange=[0,4], title = 'backscatter ratio 355/532', ytitle='altitude [km]'
  plots, backscat_355[a]/backscat_532[a], z[a], psym=3, color=176, noclip=0
;  plots, backscat_355[a], z[a], psym=3, color=84, noclip=0

  plot, findgen(2), /nodata, $
   yrange=[0,5], xrange=[0,1], title = 'extinction', ytitle='altitude [km]'
  plots, extinction_532[a], z[a], psym=3, color=176, noclip=0
  plots, extinction_355[a], z[a], psym=3, color=84, noclip=0
device, /close 

end
