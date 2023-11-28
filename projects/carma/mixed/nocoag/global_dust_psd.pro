; Global, monthly mean dry aerosol PSD by species

  filenames = ['c90_pI10p1_pina10md.tavg3d_carma_v.19910615_2345z.nc4', $
               'c90_pI10p1_pina10.tavg3d_carma_v.19910615_2345z.nc4']

  nf = n_elements(filenames)

  for i = 0, nf-1 do begin

  filename = filenames[i]

  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat
  nx = n_elements(lon)
  if(nx eq 144) then grid = 'b'
  if(nx eq 288) then grid = 'c'
  if(nx eq 576) then grid = 'd'

; Get the aerosols
  nc4readvar, filename, 'du0', dus, /template, rc=rc
  if(rc ne 0) then dus = 0.
  nc4readvar, filename, 'su0', sus, /template, rc=rc
  if(rc ne 0) then sus = 0.
  nc4readvar, filename, 'sumx0', sms, /template, rc=rc
  if(rc ne 0) then sms = sus
  if(rc ne 0) then sms[*,*,*,*] = 0.
  nc4readvar, filename, 'delp', delp

; Do the vertical integration
  sz = size(dus)
  nbin = sz[4]
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  du = fltarr(nx,ny,nbin)
  su = fltarr(nx,ny,nbin)
  sm = fltarr(nx,ny,nbin)
  for ibin = 0, nbin-1 do begin
   du[*,*,ibin] = total(dus[*,*,*,ibin]*delp,3)/9.81
   su[*,*,ibin] = total(sus[*,*,*,ibin]*delp,3)/9.81
   sm[*,*,ibin] = total(sms[*,*,*,ibin]*delp,3)/9.81
  endfor

; do a size distribution - species or mixed group
  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmin = 0.05
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, r, rup, dr, rlow
; sulfate primary group
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.) * 1e6
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, rs, rups, drs, rlows


  if(i eq 0) then begin
   set_plot, 'ps'
   device, file='global_psd.nocoag.19910615_2345z.ps', /color, /helvetica, font_size=14
   !p.font=0

   loadct, 39
   plot, r, du[0,0,*]*r/dr, $
    /xlog, /ylog, /nodata, xrange=[.01,20.], yrange=[1e-3,100], charsize=1.2, $
    xtitle='diameter [um]', ytitle='dMdlnr [Tg]', xstyle=1, ystyle=1

  endif

  fac = total(area)/1.e9

  oplot, 2.*r, fac*aave(du,area)*r/dr, thick=6*(i+1), color=208, lin=i
print, i, 'du', fac*aave(du,area)*r/dr
  oplot, 2.*rs, fac*aave(su,area)*rs/drs, thick=6*(i+1), color=176, lin=i
print, i, 'su', fac*aave(su,area)*rs/drs
;  oplot, 2.*r, fac*aave(sm,area)*r/dr, thick=6*(i+1), color=254, lin=i
;print, i, 'mx', fac*aave(sm,area)*r/dr
;  oplot, 2.*r, fac*aave(sm-du,area)*r/dr, thick=6*(i+1), color=222, lin=i
;print, i, 'mxsu', fac*aave(sm-du,area)*r/dr

  endfor

  device, /close

end
