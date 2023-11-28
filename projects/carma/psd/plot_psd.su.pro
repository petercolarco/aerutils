; Global, monthly mean dry aerosol PSD by species

  expid = ['c90F_pI33p7_ocs']
  filenames = './'+expid+'.tavg3d_carma_v.monthly.200506.nc4'
print, filenames

  nf = n_elements(filenames)

  for i = 0, nf-1 do begin

  filename = filenames[i]

  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat
  nx = n_elements(lon)
  if(nx eq 144) then grid = 'b'
  if(nx eq 288) then grid = 'c'
  if(nx eq 576) then grid = 'd'

; Get the aerosols
;  nc4readvar, filename, 'du0', dus, /template
;  nc4readvar, filename, 'ss0', sss, /template
  nc4readvar, filename, 'su0', sus, /template
;  nc4readvar, filename, 'sm0', sms, /template
  nc4readvar, filename, 'delp', delp

; Do the vertical integration
  sz = size(sus)
  nbin = sz[4]
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
;  du = fltarr(nx,ny,nbin)
;  ss = fltarr(nx,ny,nbin)
  su = fltarr(nx,ny,nbin)
;  sm = fltarr(nx,ny,nbin)
  for ibin = 0, nbin-1 do begin
;   du[*,*,ibin] = total(dus[*,*,*,ibin]*delp,3)/9.81
;   ss[*,*,ibin] = total(sss[*,*,*,ibin]*delp,3)/9.81
   su[*,*,ibin] = total(sus[*,*,*,ibin]*delp,3)/9.81
;   sm[*,*,ibin] = total(sms[*,*,*,ibin]*delp,3)/9.81
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

; smoke primary group
  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmin = 0.005
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, rsm, rupsm, drsm, rlowsm


  if(i eq 0) then begin
   set_plot, 'ps'
   device, file='plot_psd.su.ps', /color, /helvetica, font_size=14, $
    xsize=24, ysize=12
   !p.font=0

   loadct, 39
   plot, 2.*rs, su[0,0,*]*rs/drs, $
    /xlog, /ylog, /nodata, xrange=[.01,20.], yrange=[1e-3,100], charsize=1.2, $
    xtitle='diameter [um]', ytitle='dMdlnr [Tg]', xstyle=1, ystyle=1, $
    position=[.15,.15,.95,.95]

  endif

  fac = total(area)/1.e9

;  oplot, 2.*r, fac*aave(du,area)*r/dr, thick=6, color=208, lin=i
;  oplot, 2.*r, fac*aave(ss,area)*r/dr, thick=6, color=84, lin=i
  oplot, 2.*rs, fac*aave(su,area)*rs/drs, thick=6, color=176, lin=i
;  oplot, 2.*rsm, fac*aave(sm,area)*rsm/drsm, thick=6, color=254, lin=i

  endfor

; Oplot the GOCART PSD
; smoke parameters
  rmed = 0.0212d
  sigma = 2.12d
  frac = 1.
  lognormal, rmed, sigma, frac, $
                 rsm, drsm, $
                 dNdr, dSdr, dVdr, $
                 volume=volume, $
                 rlow=rlowsm, rup=rupsm
  dvdrsm = dvdr
;  fac_ = max(fac*aave(sm,area)*rsm/drsm)
;  oplot, 2.*rsm, fac_*(dvdr*rsm)/max(dvdr*rsm), thick=10, color=254, lin=2

; sulfate parameters
  rmed = 0.0695d
  sigma = 1.77d
  frac = 1.
  lognormal, rmed, sigma, frac, $
                 rs, drs, $
                 dNdr, dSdr, dVdr, $
                 volume=volume, $
                 rlow=rlows, rup=rups
  fac_ = max(fac*aave(su,area)*rs/drs)
  oplot, 2.*rs, fac_*(dvdr*rs)/max(dvdr*rs), thick=10, color=176, lin=2
  device, /close

end
