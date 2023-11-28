  filen = 'M2R12K.const_2d_asm_Nx.20060101_0000z.nc4'
  nc4readvar, filen,'FROCEAN',frocean,lon=lon,lat=lat


  mm = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nd = [ 31,  28,  31,  30,  31,  30,  31,  31,  30,  31,  30,  31 ]

  for im = 0, 11 do begin

   filehead = 'preccon.nadir045.2014'+mm[im]
   read_diurnal_txt, filehead, nx, ny, nt, var, nn
   save_diurnal_nc,  filehead, nx, ny, nt, lon, lat, var, 'preccon', nn
  endfor

end
