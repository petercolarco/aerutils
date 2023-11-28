  datestr = '20151022'

; Get the VIRGAS file so2 vmr
  fileinp = 'virgas_'+datestr+'.csv'
  openr, lun, fileinp, /get
; count line
  i = 0
  str = 'a'
  while(not(eof(lun))) do begin
   readf, lun, str
   i = i+1
  endwhile
; reopen file and extract data
  free_lun, lun
  openr, lun, fileinp, /get
; get header line
  readf, lun, str
  data = fltarr(i-1,5)   ; 5 columns
  for j = 0, i-2 do begin
   readf, lun, str
   data[j,*] = float(strsplit(str,',',/extract))
  endfor
  free_lun, lun
  fltalt = data[*,3]
  fltso2 = data[*,4]


; Check the generated file
  cdfid = ncdf_open('GEOS5_virgas_'+datestr+'.nc')
  id = ncdf_varid(cdfid,'time')
  ncdf_varget, cdfid, id, time
  id = ncdf_varid(cdfid,'trjLon')
  ncdf_varget, cdfid, id, lon
  id = ncdf_varid(cdfid,'trjLat')
  ncdf_varget, cdfid, id, lat
  id = ncdf_varid(cdfid,'H')
  ncdf_varget, cdfid, id, h
  id = ncdf_varid(cdfid,'SO2')
  ncdf_varget, cdfid, id, so2
  id = ncdf_varid(cdfid,'AIRDENS')
  ncdf_varget, cdfid, id, rhoa
  ncdf_close, cdfid

  so2_vmr = so2/64.*28.*1e12

; Make a map of the traj
  set_plot, 'ps'
  device, file='virgas.'+datestr+'.ps', /color, /helvetica, font_size=12, $
   xoff=.5, yoff=.5, xsize=16, ysize=12
  !p.font=0

  map_set, /cont, limit=[0,-120,40,-60], /usa, $
   title = 'VIRGAS Flight: '+datestr
  plots, lon, lat, thick=6


; Curtain

  x = so2
  for iz = 0, 71 do begin
   x[iz,*] = time
  endfor
  loadct, 0
  contour, transpose(so2_vmr), transpose(time), transpose(h)/1000., $
   yrange=[0,20], /nodata, $
   xtitle='minutes of flight', ytitle='altitude [km]', $
   title='VIRGAS Flight: '+datestr+' (GEOS-5 SO2vmr [pptv] curtain)', $
   position=[.15,.25,.95,.9]

  loadct, 63

  levels = [1,2,5,10,20,50,100,200,500,1000]
  colors = findgen(10)*25+25
  contour, /over, transpose(so2_vmr), transpose(time), transpose(h)/1000., $
   levels=levels, c_col=colors, /cell

  loadct, 0
  oplot, x[0,*], fltalt/1000., thick=6
  contour, transpose(so2_vmr), transpose(time), transpose(h)/1000., $
   yrange=[0,20], /nodata, /noerase, $
   position=[.15,.25,.95,.9]

  makekey, .15, .1, .8, .05, 0, -.035, align=0, $
   colors=make_array(10,val=255), labels=string(levels,format='(i4)')
  loadct, 63
  makekey, .15, .1, .8, .05, 0, -.035, $
   colors=colors, labels=make_array(10,val=' ')

; Line plot at altitude
  loadct, 0
  fltso2[where(fltso2 lt 0 or finite(fltso2) ne 1)] = !values.f_nan
  plot, x[0,*], fltso2, /nodata, $
   xtitle='minutes of flight', ytitle='SO2 [pptv]', $
   title='VIRGAS Flight: '+datestr, $
   yrange=[.1,10000], /ylog, $
   position=[.15,.25,.95,.9]

; Pull the model values at altitude
  loadct, 63
  nx = n_elements(x[0,*])
  nz = 72
  ymod   = fltarr(nx)
  ymodm1 = fltarr(nx)
  ymodp1 = fltarr(nx)
  for ix = 0, nx-1 do begin
   iz = interpol(indgen(nz),h[*,ix],fltalt[ix])
   ymod[ix] = interpolate(so2_vmr[*,ix],iz)
   ymodm1[ix] = interpolate(so2_vmr[*,ix],iz-1)
   ymodp1[ix] = interpolate(so2_vmr[*,ix],iz+1)
  endfor
; make something suitable for polyfill
  xx = [reform(x[0,*]),max(x[0,*]),(reverse(reform(x[0,*]))),min(x[0,*])]
  yy = fltarr(2*nx+2)
  for ix = 0, nx-1 do begin
   yy[ix] = max([ymodm1[ix],ymodp1[ix],ymod[ix]])
  endfor
  yy[nx] = min([ymodm1[nx-1],ymodp1[nx-1]])
  yy_ = fltarr(nx)
  for ix = 0, nx-1 do begin
   yy_[ix] = min([ymodm1[ix],ymodp1[ix],ymod[ix]])
  endfor
  yy[nx+1:2*nx] = reverse(yy_)
  yy[2*nx+1] = max([ymodm1[0],ymodp1[0]])
  polyfill, xx, yy, color=100

  oplot, x[0,*], yy[0:nx-1], color=140, thick=6
  oplot, reverse(reform(x[0,*])), yy[nx:2*nx-1], color=140, thick=6

  oplot, x[0,*], ymod, lin=0, thick=8, color=200

  loadct, 0
  oplot, x[0,*], fltso2

  device, /close 

end
