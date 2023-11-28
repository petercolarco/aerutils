; Global, monthly mean dry aerosol PSD by species

  filenames = ['c48F_J32_carma_mx2.tavg3d_carma_v.20060131_0900z.nc4']


  nf = n_elements(filenames)

  for i = 0, nf-1 do begin

  filename = filenames[i]

  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat
  nx = n_elements(lon)
  if(nx eq 144) then grid = 'b'
  if(nx eq 288) then grid = 'c'
  if(nx eq 576) then grid = 'd'

; Get the aerosols
  nc4readvar, filename, 'mxdu0', dus, /template
  nc4readvar, filename, 'mxss0', sss, /template
  nc4readvar, filename, 'su0', sus, /template
  nc4readvar, filename, 'mxsm0', sms, /template
  nc4readvar, filename, 'delp', delp
  nc4readvar, filename, 'mxsu0', sumxs, /template

; Take off mixed group stuff
  sumxs = sumxs-dus-sss-sms

; Do the vertical integration
  sz = size(dus)
  nbin = sz[4]
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  du = fltarr(nx,ny,nbin)
  ss = fltarr(nx,ny,nbin)
  su = fltarr(nx,ny,nbin)
  sm = fltarr(nx,ny,nbin)
  sumx = fltarr(nx,ny,nbin)
  for ibin = 0, nbin-1 do begin
   du[*,*,ibin] = total(dus[*,*,*,ibin]*delp,3)/9.81
   ss[*,*,ibin] = total(sss[*,*,*,ibin]*delp,3)/9.81
   su[*,*,ibin] = total(sus[*,*,*,ibin]*delp,3)/9.81
   sm[*,*,ibin] = total(sms[*,*,*,ibin]*delp,3)/9.81
   sumx[*,*,ibin] = total(sumxs[*,*,*,ibin]*delp,3)/9.81
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
   device, file='plot_psd.mixed.ps', /color, /helvetica, font_size=14, $
    xsize=24, ysize=12
   !p.font=0

   loadct, 39
   plot, r, du[0,0,*]*r/dr, $
    /xlog, /ylog, /nodata, xrange=[.01,20.], yrange=[1e-3,100], charsize=1, $
    xtitle='diameter [um]', ytitle='dMdlnr [Tg]', xstyle=1, ystyle=1, $
    position=[.15,.15,.95,.95]

  endif

  fac = total(area)/1.e9

  oplot, 2.*r, fac*aave(du,area)*r/dr, thick=6, color=208, lin=i
  oplot, 2.*r, fac*aave(ss,area)*r/dr, thick=6, color=84, lin=i
  oplot, 2.*rs, fac*aave(su,area)*rs/drs, thick=6, color=176, lin=i
;print, fac*aave(su,area)*rs/drs
  oplot, 2.*r, fac*aave(sm,area)*r/dr, thick=6, color=254, lin=i
  oplot, 2.*r, fac*aave(sumx,area)*r/dr, thick=6, color=36, lin=i

  endfor

;  plots, [.015,.025], 70, thick=6
;  plots, [.015,.025], 50, thick=6, lin=1
;  plots, [.015,.025], 35, thick=6, lin=2
;  xyouts, .03, 68, 'External', chars=.75
;  xyouts, .03, 45, 'Mixed', chars=.75
;  xyouts, .03, 32, 'Mixed (2)', chars=.75

  xyouts, .2, 68, 'Pure Sulfate', color=176, charsize=.75
  xyouts, .2, 45, 'Smoke', color=254, charsize=.75
  xyouts, .2, 32, 'Dust', color=208, charsize=.75
  xyouts, .2, 22, 'Sea salt', color=84, charsize=.75
  xyouts, .2, 15, 'Mixed group sulfate', color=36, charsize=.75


  device, /close

end
