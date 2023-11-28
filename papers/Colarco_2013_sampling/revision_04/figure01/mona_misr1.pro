  nc4readvar, 'MYD04_L2_ocn.misr1.aero_tc8_051.qast.20100605.nc4', 'aot', $
              aoto, lon=lon, lat=lat
  nc4readvar, 'MYD04_L2_lnd.misr1.aero_tc8_051.qast3.20100605.nc4', 'aot', $
              aotl, lon=lon, lat=lat

; mask with unobserved points
  aot = fltarr(576,361)
  a = where(aoto gt 1e14)
  aot[a] = 1
  a = where(aotl lt 1e14)
  aot[a] = 0


  set_plot, 'x'
  window, 0, xsize=687,ysize=343
  map_set, /noborder, xmargin=0, ymargin=0, limit=[-50,-180,60,180]
  plotgrid, aot, [1], [120], lon, lat, 0.625, 0.5, /map
  im0 = tvrd(/true)
  red = reform(im0[0,*,*])
  grn = reform(im0[1,*,*])
  blu = reform(im0[2,*,*])
  alp = bytarr(687,343)+255B
  alp[where(red eq 0 and grn eq 0 and blu eq 0)] = 0B
  trans = [[[red]], [[grn]], [[blu]], [[alp]]]
  trans = transpose(trans,[2,0,1])

  write_png, 'misr1.png', trans

  file = 'lisa.jpg'
  im = image(file,image_dimensions=[687,1024], $
                  yrange=[581,923], dimensions=[687,343],margin=0)

;  im2 = image('misr1.png',image_dimensions=[687,343], $
;              /over, image_location=[-1,581])
  im2 = image('misr1.png',image_dimensions=[687,344], $
              /over, image_location=[0,579])


end
