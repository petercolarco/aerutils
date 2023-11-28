; Get Kok's PSD from Nature 2017, Figure 2b
  read_psd_load, diam, dmdlnd, dmdlndm2, dmdlndp2
  x = [diam,reverse(diam),diam[0]]
  y = [dmdlndp2,reverse(dmdlndm2),dmdlndp2[0]]

  filename = 'test.tavg3d_carma_e.20170812_2130z.nc4'

  nc4readvar, filename, 'mxvf0', dus, lon=lon, lat=lat, /template
  nx = n_elements(lon)
  if(nx eq 144) then grid = 'b'
  if(nx eq 288) then grid = 'c'
  if(nx eq 576) then grid = 'd'

; do a size distribution
  nbin = 22
  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmin = 0.05
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, r, rup, dr, rlow

  set_plot, 'ps'
  device, file='global_dust_vfall.ps', /color, /helvetica, font_size=14
  !p.font=0

   loadct, 39
   plot, r, $
    position = [.2,.15,.85,.95], $
    /xlog, /ylog, /nodata, xrange=[.2,20.], yrange=[1e-2,100], charsize=1.2, $
    xstyle=5, ystyle=5
   polyfill, x, y, color=193, noclip=0
   oplot, diam, dmdlnd, thick=8, color=0, lin=2
   plot, r, /noerase, $
    position = [.2,.15,.85,.95], $
    /xlog, /ylog, /nodata, xrange=[.2,20.], yrange=[1e-4,10], charsize=1.2, $
    xtitle='diameter [um]', ytitle='Fall Speed [cm s!E-1!N]', xstyle=1, ystyle=9

;  iz = 45 = ~10km
;  iz = 51 = ~5 km

   oplot, 2.*r, dus[0,45,72,*]*100., thick=6
   oplot, 2.*r, dus[0,45,45,*]*100., thick=6, lin=1
;  Find the fall speeds that correspond to falling 1 km in some time
   daystofall = [1./24,1.,7.,30.,365.,3650.]
   ytickv = 1.e5/daystofall/86400.
   axis, yaxis=1, yrange=[1e-4,10], ystyle=1, /ylog, /save, $
    ytitle='Time to fall 1 km', yticks=5, ytickv=ytickv, $
    ytickn=['1 hour','1 day','1 week', '1 month', '1 year','1 decade']

  device, /close

end
