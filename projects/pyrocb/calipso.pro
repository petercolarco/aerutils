  cdfid = ncdf_open('calipso_ze.nc')
   id = ncdf_varid(cdfid,'HE')
   ncdf_varget, cdfid, id, ze
  ncdf_close, cdfid
  cdfid = ncdf_open('calipso.nc')
   id = ncdf_varid(cdfid,'TROPPB')
   ncdf_varget, cdfid, id, trb
   id = ncdf_varid(cdfid,'AIRDENS')
   ncdf_varget, cdfid, id, airdens
   id = ncdf_varid(cdfid,'delp')
   ncdf_varget, cdfid, id, delp
   id = ncdf_varid(cdfid,'BRCphobic')
   ncdf_varget, cdfid, id, brcphobic
   id = ncdf_varid(cdfid,'BRCphilic')
   ncdf_varget, cdfid, id, brcphilic
   brc = brcphobic+brcphilic
   id = ncdf_varid(cdfid,'H')
   ncdf_varget, cdfid, id, z
   id = ncdf_varid(cdfid,'trjLon')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid,'trjLat')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,'ps')
   ncdf_varget, cdfid, id, ps
  ncdf_close, cdfid
  nx = n_elements(lon)
  nz = n_elements(z[*,0])

; Make a vertical pressure coordinate
  p   = fltarr(nz,nx)
  ple = fltarr(nz+1,nx)
  ple[nz,*] = ps
  for k = nz-1, 1, -1 do begin
   ple[k,*] = ple[k+1,*] - delp[k,*]
   p[k,*]   = 10^((alog10(ple[k+1,*])+alog10(ple[k,*]))/2.)
  endfor

; Make an x coordinate
  x  = findgen(nx,nz)
  for i = 0, nx-1 do begin
   x[i,*] = i
  endfor

; Transpose
  brc = transpose(brc)
  z   = transpose(z)
  p   = transpose(p)
  ple = transpose(ple)
  ze  = transpose(ze)/1000.

; Make a plot
  set_plot, 'ps'
  device, file='calipso.ps', /color, font_size=10, /helvetica, $
   xsize=36, ysize=18
  !p.font=0  
  loadct, 0
  levels = [1,2,5,10,20,50,100,200]
  contour, brc*1e9, x, p/100., /nodata, $
   yrange=[1000,100], levels=levels, /cell, /ylog, $
   xrange=[nx-1,0], xstyle=1, $;, xticks=nx-1, $
   position=[.1,.1,.95,.95], xtickn=[' ',' ',' ',' ',' ']
  xyouts, 99, 1100, string(lat[99],format='(f6.2)')+'!Eo!NN!C'+string(-lon[99],format='(f6.2)')+'!Eo!NW', align=.5
  xyouts, 80, 1100, string(lat[80],format='(f6.2)')+'!Eo!NN!C'+string(-lon[80],format='(f6.2)')+'!Eo!NW', align=.5
  xyouts, 60, 1100, string(lat[60],format='(f6.2)')+'!Eo!NN!C'+string(-lon[60],format='(f6.2)')+'!Eo!NW', align=.5
  xyouts, 40, 1100, string(lat[40],format='(f6.2)')+'!Eo!NN!C'+string(-lon[40],format='(f6.2)')+'!Eo!NW', align=.5
  xyouts, 20, 1100, string(lat[20],format='(f6.2)')+'!Eo!NN!C'+string(-lon[20],format='(f6.2)')+'!Eo!NW', align=.5
  xyouts,  0, 1100, string(lat[00],format='(f6.2)')+'!Eo!NN!C'+string(-lon[00],format='(f6.2)')+'!Eo!NW', align=.5
  loadct, 56
  contour, brc*1e9, x, p/100., /over, /cell, levels=levels
  loadct, 0
  oplot, x[*,0], trb/100., thick=6, lin=2
  for k = nz, 0, -1 do begin
   oplot, x[*,0], ple[*,k]/100.
  endfor
  for k = 46,38, -1 do begin
   xyouts, 97, .99*ple[1,k]/100., string(ze[0,k],format='(f6.3)'), /data, noclip=1
  endfor

  device, /close

end
