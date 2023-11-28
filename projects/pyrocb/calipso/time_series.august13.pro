  fileout = 'august13.ps'

  cdfid = ncdf_open('calipso_august13.nc')
   id = ncdf_varid(cdfid,'TOTBRCEC')
   ncdf_varget, cdfid, id, brc
   id = ncdf_varid(cdfid,'H')
   ncdf_varget, cdfid, id, z
   id = ncdf_varid(cdfid,'TROPPB')
   ncdf_varget, cdfid, id, trb
   id = ncdf_varid(cdfid,'AIRDENS')
   ncdf_varget, cdfid, id, airdens
   id = ncdf_varid(cdfid,'delp')
   ncdf_varget, cdfid, id, delp
   id = ncdf_varid(cdfid,'ps')
   ncdf_varget, cdfid, id, ps
   id = ncdf_varid(cdfid,'TH')
   ncdf_varget, cdfid, id, th
   id = ncdf_varid(cdfid,'DTDTRAD')
   ncdf_varget, cdfid, id, dtdtrad
   id = ncdf_varid(cdfid,'trjLon')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid,'trjLat')
   ncdf_varget, cdfid, id, lat
  ncdf_close, cdfid

  dtdt = dtdtrad*86400.
  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(delp[*,0])

  cdfid = ncdf_open('calipso_ze_august13.nc')
   id = ncdf_varid(cdfid,'HE')
   ncdf_varget, cdfid, id, ze
  ncdf_close, cdfid

; Make a vertical pressure coordinate
  p = fltarr(nz,nx)
  ple = fltarr(nz+1,nx)
  ple[nz,*] = ps
  for k = nz-1, 1, -1 do begin
   ple[k,*] = ple[k+1,*] - delp[k,*]
   p[k,*]   = 10^((alog10(ple[k+1,*])+alog10(ple[k,*]))/2.)
  endfor


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
  th  = transpose(th)
  dtdt = transpose(dtdt)

; Make a plot
  set_plot, 'ps'
  device, file=fileout, /color, font_size=10, /helvetica, $
   xsize=36, ysize=18
  !p.font=0  
  loadct, 0
  levels = [1,2,5,10,20,50,100,200,500,1000,2000,5000]/1000.
  xtickn = string(lat[0:1300:260],format='(f5.2)')+'!Eo!N N!C'+string(abs(lon[0:1300:260]),format='(f7.2)')+'!Eo!N W'
;  xtickn = string(lat[1900:3200:260],format='(f5.2)')+'!Eo!N N!C'+string(abs(lon[1900:3200:260]),format='(f7.2)')+'!Eo!N W'
  contour, brc*1e3, x, p/100., /nodata, $
   yrange=[500,100], levels=levels, /cell, /ylog, ystyle=1, ytickn=[' ',' '], yticks=1, $
   xrange=[0,1300], xstyle=1, xticks=5, xtickn=xtickn, $
;   xrange=[1900,3200], xstyle=1, xticks=5, xtickn=xtickn, $
   position=[.1,.1,.95,.95]
  xyouts, -60, 250, 'Altitude [km]', orient=90, /data, chars=1.5, align=.5
;  xyouts, 1900-60, 250, 'Altitude [km]', orient=90, /data, chars=1.5, align=.5
  loadct, 56
  contour, brc*1e3, x, p/100., /over, /cell, levels=levels, c_col=10+indgen(12)*20
  loadct, 0
  contour, brc*1e3, x, p/100., /nodata, /noerase, $
   yrange=[500,100], levels=levels, /cell, /ylog, ystyle=1, ytickn=[' ',' '], yticks=1, $
   xrange=[0,1300], xstyle=1, xticks=5, xtickn=xtickn, $
;   xrange=[1900,3200], xstyle=1, xticks=5, xtickn=xtickn, $
   position=[.1,.1,.95,.95]
  oplot, x[*,0], trb/100., thick=8, lin=2
  for k = nz, 0, -1 do begin
   oplot, x[*,0], ple[*,k]/100., thick=3
  endfor
  loadct, 39
;  contour, th, x, p/100., /over, c_thick=5, c_color=72, levels=290+findgen(30)*5.
  contour, dtdt, x, p/100., /over, c_thick=1, c_color=0, levels=2+findgen(13)*2, c_label=[1,0,1,0,1,0,1,0,1,0,1,0,1]
  for k = 49,38, -1 do begin
;   polyfill, [1,50,50,1,1], [.99,.99,.95,.95,.99]*ple[1,k]/100., color=255, /data
   xyouts, -45, 1.01*ple[1,k]/100., string(ze[0,k],format='(f6.1)'), /data, noclip=1, chars=1.1
;   xyouts, 1900-45, 1.01*ple[1,k]/100., string(ze[0,k],format='(f6.1)'), /data, noclip=1, chars=1.1
  endfor

  loadct, 0
  makekey, .15, .85, .35, .05, 0., -0.02, $
   color=make_array(12,val=0), label=string(levels*1000,format='(i4)'), align=0
  loadct, 56
  makekey, .15, .85, .35, .05, 0., -0.02, color=indgen(12)*20+10, label=make_array(n_elements(levels),val=' ')


  device, /close

end
