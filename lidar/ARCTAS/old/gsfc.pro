; GSFC
  wantlon=-76.
  wantlat=38.
  wanttime=['0z14apr2008','0z20apr2008']

  ga_getvar, 'arctas_totext.ddf', 'tau', tau, $
   lat=lat,lon=lon,lev=lev,time=time, $
   wantlon=wantlon, wantlat=wantlat, wanttime=wanttime

  ga_getvar, 'arctas_dyn.ddf', 'hght', hght, $
   lat=lat,lon=lon,lev=lev,time=time, $
   wantlon=wantlon, wantlat=wantlat, wanttime=wanttime

  nx = n_elements(lon)
  ny = n_elements(lat)
  nz = n_elements(lev)
  nt = n_elements(time)

; Need dz of layer
; One way to do this is...
  dz = fltarr(nx,ny,nz,nt)
  for iz = 0, nz-2 do begin
   dz[*,*,iz,*] = hght[*,*,iz+1,*] - hght[*,*,iz,*]
  endfor
  iz = nz-1
  dz[*,*,iz,*] = hght[*,*,iz,*] - hght[*,*,iz-1,*]
  
; Extinction -- put into units of km-1
  ext = tau/(dz/1000.)

; Reform the arrays
  ext = transpose(reform(ext))
  hght = transpose(reform(hght))
  dz = transpose(reform(dz))

; Make a plot
  set_plot, 'ps'
  fileps  = './gsfc.geos5.total.ext.ps'
  filepng = './gsfc.geos5.total.ext.png'
  device, file=fileps, font_size=14, /helvetica, $
   xoff=.5, yoff=.5, xsize=18, ysize=10, /color
  !p.font=0

  position=[.15,.3,.95,.9]
  contour, ext, findgen(nt)*.25+14, reform(hght[0,*])/1000., /nodata, $
   yrange=[0,12],ythick=3, ystyle=9, $
   xstyle=9,  xthick=3, position=position, $
   xrange=[14,19], xticks=nmajor, xminor=nminor, xtickname=ticklabel
  levelarray = (findgen(10)*.01+.01)
  loadct, 39
  colorarray = [30,64,80,96,144,176,192,199,208,254]
  plotgrid, ext, levelarray, colorarray, findgen(nt)*.25+14, hght/1000., .25, dz/1000.
  contour, ext, findgen(nt)*.25+14, reform(hght[0,*])/1000., /nodata, /noerase, $
   yrange=[0,12], ytitle = 'altitude [km]', ythick=3, ystyle=9, $
   xstyle=9, xtitle='April 2008', xthick=3, position=position, $
   xrange=[14,19], xticks=nmajor, xminor=nminor, xtickname=ticklabel
  xyouts, .15, .92, 'GEOS-5 Aerosol Extinction [532 nm, 1/km] at GSFC', $
          charsize=.8, /normal

  makekey, 0.15, .085, .8, .05, 0, -.05, align=0, charsize=.65, $
   color=colorarray, label=strcompress(string(levelarray,format='(f5.3)'),/rem)

  device, /close

  cmd = 'convert -density 150 '+fileps+' '+filepng
  spawn, cmd



end
