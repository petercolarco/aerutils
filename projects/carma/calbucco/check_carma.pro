;goto, jump
; Get the pressures
  filename = './c48R_G40v3_carma.tavg3d_carma_v.monthly.200707.nc4'
  filename = './c48R_calbucco.tavg3d_carma_v.20150404_2230z.nc4'
  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat

; Get integrated dust (core element)
  nc4readvar, filename, 'du0', dus, /template
  du = total(dus,4)

; Get integrated seasalt (core element)
  nc4readvar, filename, 'ss0', sss, /template
  ss = total(sss,4)

; Get integrated sulfate (core element)
  nc4readvar, filename, 'mxsu0', mxsus, /template
  mxsu = total(mxsus,4)

; Get integrated mixed group (pc element)
  nc4readvar, filename, 'mx0', mxs, /template
  mx = total(mxs,4)

; Get integrated sulfate group (pc element)
  nc4readvar, filename, 'su0', sus, /template
  su = total(sus,4)

; Now do some global averaging
  area, lon, lat, nx, ny, dx, dy, area, grid='b'

  dut   = total(du*delp,3)/9.81
  sst   = total(ss*delp,3)/9.81
  mxsut = total(mxsu*delp,3)/9.81
  mxt   = total(mx*delp,3)/9.81
  sut   = total(su*delp,3)/9.81

  save, file='check_carma.sav', /all
jump:
restore, 'check_carma.sav'
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
  ix = 72
  iy = 28
  ducs = fltarr(nbin)
  sscs = fltarr(nbin)
  mxsucs = fltarr(nbin)
  sucs = fltarr(nbin)
  mxcs = fltarr(nbin)
  for ibin = 0, nbin-1 do begin
   ducs[ibin] = reform(total(dus[ix,iy,*,ibin]*delp[ix,iy,*]))/9.81
   sscs[ibin] = reform(total(sss[ix,iy,*,ibin]*delp[ix,iy,*]))/9.81
   mxsucs[ibin] = reform(total(mxsus[ix,iy,*,ibin]*delp[ix,iy,*]))/9.81
   sucs[ibin] = reform(total(sus[ix,iy,*,ibin]*delp[ix,iy,*]))/9.81
   mxcs[ibin] = reform(total(mxs[ix,iy,*,ibin]*delp[ix,iy,*]))/9.81
  endfor

  loadct, 39
  plot, r, ducs*r/dr, $
   /xlog, /ylog, /nodata, xrange=[.001,100], yrange=[1e-12,1e-2], charsize=1.2, $
   xtitle='radius [um]', ytitle='dMdlnr [kg m-2]'
  oplot, r, ducs*r/dr, thick=6, color=254
  oplot, r, sscs*r/dr, thick=6, color=84
  oplot, r, mxsucs*r/dr, thick=6, color=176
  oplot, r, mxcs*r/dr, thick=6, color=255, lin=2
  oplot, rs, sucs*rs/drs, thick=6, color=176, lin=2


end
