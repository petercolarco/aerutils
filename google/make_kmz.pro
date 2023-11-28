  pro make_kmz, input, lon, lat, $
      scalefac=scalefac, $
      levelarray=levelarray, colortable=colortable, colorarray=colorarray, $
      resolution=resolution, $
      dir=dir, image=image, title=title, formatstr=formatstr, $
      mapcontinents=mapcontinents


  plot_png, input, lon, lat, scalefac=scalefac, $
      levelarray=levelarray, colortable=colortable, colorarray=colorarray, $
      resolution=resolution, $
      dir=dir, image=image, title=title, formatstr=formatstr, $
      mapcontinents=mapcontinents


  nx = n_elements(lon)
  ny = n_elements(lat)
  x0 = lon[0]
  x1 = lon[nx-1]
  y0 = lat[0]
  y1 = lat[ny-1]

  openw, lun, dir+'.kml', /get_lun
   kml_header, lun, title, dir
   printf, lun, '<GroundOverlay>'
   printf, lun, ' <name>'+title+'</name>'
   printf, lun, ' <Icon>'
   printf, lun, '  <href>'+dir+'/image.png</href>'
   printf, lun, ' </Icon>'
   printf, lun, ' <LatLonBox>'
   printf, lun, '  <north>'+string(y1)+'</north>'
   printf, lun, '  <south>'+string(y0)+'</south>'
   printf, lun, '  <east>'+string(x1)+'</east>'
   printf, lun, '  <west>'+string(x0)+'</west>'
   printf, lun, ' </LatLonBox>'
   printf, lun, '</GroundOverlay>'
  printf, lun, '</Folder>'
  printf, lun, '</Folder>'
  printf, lun, '</kml>'
  free_lun, lun

  spawn, 'zip '+dir+'.kmz '+dir+'.kml '+dir+'/*'
  spawn, 'rm -f '+dir+'.kml'
  spawn, 'rm -rf '+dir

end

