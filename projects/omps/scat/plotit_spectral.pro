; Get a standard atmosphere profile
  atmosphere, p, pe, dep, z, ze, delz, t, te, rhoa

; Make up some latitudes
  ny  = 24
  nz  = 72
  nl  = 8
  lat = -90. + findgen(ny)*7.5

  extstr = ['385','449','521','602','676','756','869','1020']

  extcarma  = fltarr(nz,ny,nl)
  extgocart = fltarr(nz,ny,nl)
  extomps   = fltarr(nz,ny,nl)
  gcarma    = fltarr(nz,ny,nl)
  ggocart   = fltarr(nz,ny,nl)
  gomps     = fltarr(nz,ny,nl)

  for iext = 0, 7 do begin
  filename = 'G41prcR2010.ext_'+extstr[iext]+'nm.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'ext')
  ncdf_varget, cdfid, id, ext
  id = ncdf_varid(cdfid,'g')
  ncdf_varget, cdfid, id, g
  ncdf_close, cdfid
  extcarma[*,*,iext] = ext
  gcarma[*,*,iext]   = g


  filename = './carma_add/G41prcR2010.ext_'+extstr[iext]+'nm.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'ext')
  ncdf_varget, cdfid, id, ext
  id = ncdf_varid(cdfid,'g')
  ncdf_varget, cdfid, id, g
  ncdf_close, cdfid
  extomps[*,*,iext] = ext
  gomps[*,*,iext]   = g


  filename = './carma_gocart/G41prcR2010.ext_'+extstr[iext]+'nm.nc'
  cdfid = ncdf_open(filename)
  id = ncdf_varid(cdfid,'ext')
  ncdf_varget, cdfid, id, ext
  id = ncdf_varid(cdfid,'g')
  ncdf_varget, cdfid, id, g
  ncdf_close, cdfid
  extgocart[*,*,iext] = ext
  ggocart[*,*,iext]   = g

  endfor

  set_plot, 'ps'
  device, file='plotit_spectral.ps', /helvetica, font_size=10, /color, $
   xoff=.5, yoff=.5, xsize=12, ysize=20
  !p.font=0

  loadct, 39

  iz = 43 ;; 10km
  plot, float(extstr), extgocart[iz,12,*]*1e6, /nodata, $
   xtitle='Wavelength [nm]', ytitle='Extinction [Mm!E-1!N]', $
   position=[.15,.05,.9,.19], xrange=[350,1050], xstyle=9, $
   yrange=[0,300], ystyle=9, ymin=1, xmin=1
  oplot, float(extstr), extgocart[iz,12,*]*1e6, thick=6, color=176
  oplot, float(extstr), extomps[iz,12,*]*1e6, thick=6, color=84
  oplot, float(extstr), extcarma[iz,12,*]*1e6, thick=6, color=0
  xyouts, 900, 250, '10 km', charsize=1.25
  plots, [895,1005,1005,895,895], [235,235,300,300,235]

  iz = 38 ;; 15km
  plot, float(extstr), extgocart[iz,12,*]*1e6, /nodata, $
   xtitle='', ytitle='Extinction [Mm!E-1!N]', $
   position=[.15,.24,.9,.38], xrange=[350,1050], xstyle=9, $
   yrange=[0,300], ystyle=4, /noerase, ymin=1, xmin=1
  axis, yaxis=1, ytitle='Extinction [Mm!E-1!N]', yrange=[0,300], ystyle=9, ymin=1
  oplot, float(extstr), extgocart[iz,12,*]*1e6, thick=6, color=176
  oplot, float(extstr), extomps[iz,12,*]*1e6, thick=6, color=84
  oplot, float(extstr), extcarma[iz,12,*]*1e6, thick=6, color=0
  xyouts, 900, 250, '15 km', charsize=1.25
  plots, [895,1005,1005,895,895], [235,235,300,300,235]

  iz = 33 ;; 20km
  plot, float(extstr), extgocart[iz,12,*]*1e6, /nodata, $
   xtitle='', ytitle='Extinction [Mm!E-1!N]', $
   position=[.15,.43,.9,.57], xrange=[350,1050], xstyle=9, $
   yrange=[0,300], ystyle=9, /noerase, ymin=1, xmin=1
  oplot, float(extstr), extgocart[iz,12,*]*1e6, thick=6, color=176
  oplot, float(extstr), extomps[iz,12,*]*1e6, thick=6, color=84
  oplot, float(extstr), extcarma[iz,12,*]*1e6, thick=6, color=0
  xyouts, 900, 250, '20 km', charsize=1.25
  plots, [895,1005,1005,895,895], [235,235,300,300,235]

  iz = 29 ;; 25km
  plot, float(extstr), extgocart[iz,12,*]*1e6, /nodata, $
   xtitle='', ytitle='Extinction [Mm!E-1!N]', $
   position=[.15,.62,.9,.75], xrange=[350,1050], xstyle=9, $
   yrange=[0,300], ystyle=4, /noerase, ymin=1, xmin=1
  axis, yaxis=1, ytitle='Extinction [Mm!E-1!N]', yrange=[0,300], ystyle=9, ymin=1
  oplot, float(extstr), extgocart[iz,12,*]*1e6, thick=6, color=176
  oplot, float(extstr), extomps[iz,12,*]*1e6, thick=6, color=84
  oplot, float(extstr), extcarma[iz,12,*]*1e6, thick=6, color=0
  xyouts, 900, 250, '25 km', charsize=1.25
  plots, [895,1005,1005,895,895], [235,235,300,300,235]

  iz = 25 ;; 30km
  plot, float(extstr), extgocart[iz,12,*]*1e6, /nodata, $
   xtitle='', ytitle='Extinction [Mm!E-1!N]', $
   position=[.15,.8,.9,.94], xrange=[350,1050], xstyle=9, $
   yrange=[0,300], ystyle=9, /noerase, ymin=1, xmin=1
  oplot, float(extstr), extgocart[iz,12,*]*1e6, thick=6, color=176
  oplot, float(extstr), extomps[iz,12,*]*1e6, thick=6, color=84
  oplot, float(extstr), extcarma[iz,12,*]*1e6, thick=6, color=0
  xyouts, 900, 250, '30 km', charsize=1.25
  plots, [895,1005,1005,895,895], [235,235,300,300,235]


  device, /close


end
