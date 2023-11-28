;goto, jump
; Get the pressures
  filename = './c48F_asdI10-carma.tavg3d_carma_v.20080304_0900z.nc4'
  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat

; Get the aerosols
  nc4readvar, filename, 'du0', dus, /template
  nc4readvar, filename, 'ss0', sss, /template
  nc4readvar, filename, 'su0', sus, /template
  nc4readvar, filename, 'sm0', sms, /template
  nc4readvar, filename, 'delp', delp

; Do the vertical integration
  nbin = 22
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  du = fltarr(nx,ny,nbin)
  ss = fltarr(nx,ny,nbin)
  su = fltarr(nx,ny,nbin)
  sm = fltarr(nx,ny,nbin)
  for ibin = 0, nbin-1 do begin
   du[*,*,ibin] = total(dus[*,*,*,ibin]*delp,3)/9.81
   ss[*,*,ibin] = total(sss[*,*,*,ibin]*delp,3)/9.81
   su[*,*,ibin] = total(sus[*,*,*,ibin]*delp,3)/9.81
   sm[*,*,ibin] = total(sms[*,*,*,ibin]*delp,3)/9.81
  endfor

; do a size distribution
  nbin  = 22
  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmin = 0.05
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, r, rup, dr, rlow
  nbin  = 22
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.) * 1e6
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, rs, rups, drs, rlows


; Capo Verde
  ix = 63
  iy = 52
  loadct, 39
  plot, r, du[ix,iy,*]*r/dr, $
   /xlog, /ylog, /nodata, xrange=[.2,20.], yrange=[1e-8,1e-3], charsize=1.2, $
   xtitle='diameter [um]', ytitle='dMdlnr [kg m-2]', xstyle=1
  oplot, 2.*r, sm[ix,iy,*]*r/dr, thick=6, color=254
  oplot, 2.*r, du[ix,iy,*]*r/dr, thick=6, color=208
  oplot, 2.*r, ss[ix,iy,*]*r/dr, thick=6, color=84
  oplot, 2.*rs, su[ix,iy,*]*rs/drs, thick=6, color=176

  oplot, 2.*r, aave(sm,area)*r/dr, thick=6, color=254, lin=2
  oplot, 2.*r, aave(du,area)*r/dr, thick=6, color=208, lin=2
  oplot, 2.*r, aave(ss,area)*r/dr, thick=6, color=84, lin=2
  oplot, 2.*rs, aave(su,area)*rs/drs, thick=6, color=176, lin=2

  dmkok = [ 1.44426e-06, 8.10457e-06, 2.30573e-05, 6.21020e-05, $
            0.000158263, 0.000381888, 0.000875892, 0.00189694, $
            0.00390636,  0.00764786,  0.0142532,   0.0253157, $
            0.0429886,   0.0692165,   0.105703,    0.150420, $
            0.191700,    0.200044,    0.139066,    0.0434336, $
            0.00288956,  8.75048e-06]
  oplot, 2.*r, 2.e-4*dmkok*r/dr, thick=6, color=208, lin=1



end
