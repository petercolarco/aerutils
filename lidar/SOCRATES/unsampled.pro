; Set up bins in latitude
  nlatbin = 24
  dlatbin = 120 / nlatbin
  latbin0 = -60.             + findgen(nlatbin)*dlatbin
  latbin1 = -60. + dlatbin   + findgen(nlatbin)*dlatbin
  latbin  = -60. + dlatbin/2.+ findgen(nlatbin)*dlatbin

  zbin  = fltarr(nlatbin,72)
  dzbin = fltarr(nlatbin,72)
  bcbin = fltarr(nlatbin,72)
  nobs  = fltarr(nlatbin)

; Read the model (unsampled) profile
  filename = '/misc/prc15/colarco/dR_Fortuna-2-4-b4/inst3d_aer_v/' + $
             '/Y2009/dR_Fortuna-2-4-b4.inst3d_aer_v.2009.nc4'
  nc4readvar, filename, ['bcphobic','bcphilic'], bc, lat=lat, /sum
; zonal mean
  bc = transpose(total(bc,1)/576.)

; And get the altitude profile
  filename = '/misc/prc15/colarco/dR_Fortuna-2-4-b4/geosgcm_surf/' + $
             '/Y2009/dR_Fortuna-2-4-b4.geosgcm_surf.2009.nc4'
  nc4readvar, filename, ['phis'], z0, lat=lat
; put z0 into m
  z0 = z0/9.8

  filename = '/misc/prc15/colarco/dR_Fortuna-2-4-b4/inst3d_prog_v/' + $
             '/Y2009/dR_Fortuna-2-4-b4.inst3d_prog_v.2009.nc4'
  nc4readvar, filename, ['h'], z, lat=lat
; zonal mean
  z0 = reform(total(z0,1)/576.)
  z  = transpose(total(z,1)/576.)
  dz = z
  nz = 72
  dz[71,*] = 2. * (z[71,*]-z0)
  for iz = 70, 0, -1 do begin
   dz[iz,*] = 2.*(z[iz,*]-(z[iz+1,*]+dz[iz+1,*]/2.))
  endfor


; and units in ng kg-1
  bc = bc*1.e12

; Bin into coarser latitude bins
  for i = 0, nlatbin-1 do begin
    b = where(lat ge latbin0[i] and lat lt latbin1[i])
    zbin[i,*]  = total(z[*,b],2)
    dzbin[i,*] = total(dz[*,b],2)
    bcbin[i,*] = total(bc[*,b],2)
    nobs[i]    = n_elements(b)
  endfor

; Now form the average
  for i = 0, nlatbin-1 do begin
   zbin[i,*]  = zbin[i,*] / nobs[i]
   dzbin[i,*] = dzbin[i,*] / nobs[i]
   bcbin[i,*] = bcbin[i,*] / nobs[i]
  endfor
; put in km
  zbin  = zbin / 1000.
  dzbin = dzbin / 1000.

  set_plot, 'ps'
  device, file = 'geos5.ps', /color, /helvetica, $
   xsize=18, ysize=12, xoff=.5, yoff=.5, font_size=14
  !p.font=0

  plot, indgen(10), /nodata, thick=3, $
   xrange = [-60,60], xtitle = 'latitude', $
   yrange = [0,30], ytitle = 'altitude [km]', ystyle = 9, $
   position = [.1, .25, .85, .95]

  level = [1,2,5,10,20,50,100]
  color = 220 - findgen(7)*30
  plotgrid, bcbin, level, color, latbin, zbin, dlatbin, dzbin

  plot, indgen(10), /nodata, /noerase, thick=3, $
   xrange = [-60,60], yrange = [0,30], ystyle = 9, $
   position = [.1, .25, .85, .95]

  axis, yaxis=1, yrange=[1000,10], /ylog, ythick=3, ytitle='pressure [hPa]'

  makekey, .1, .075, .75, .05, 0, -.05, align = 0, $
   color=color, label=['1','2','5','10','20','50','100']

  device, /close

end
