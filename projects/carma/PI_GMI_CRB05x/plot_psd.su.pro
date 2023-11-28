; Global, monthly mean dry aerosol PSD by species

  color=findgen(12)*20+30

  expid = 'PI_GMI_CRB05x'
  filenames = './'+expid+'.tavg24_3d_carma_Nv.monthly.2084'+$
              ['01','02','03','04','05','06','07','08','09','10','11','12']+'.nc4'
  filenamessfc = './'+expid+'.tavg24_2d_carma_Nx.monthly.2084'+$
              ['01','02','03','04','05','06','07','08','09','10','11','12']+'.nc4'

  nf = n_elements(filenames)

  for i = 0, 11 do begin ;nf-1 do begin

  filename = filenames[i]
  filenamesfc = filenamessfc[i]

  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

; Get the aerosols
  nc4readvar, filename, 'su0', sus, /template

; get the aot
  nc4readvar, filenamesfc, 'suexttau', suext

; Do the vertical integration
  sz = size(sus)
  nbin = sz[4]
  area, lon, lat, nx, ny, dx, dy, area
  su = fltarr(nx,ny,nbin)

; Column integral of particle size distribution
  for ibin = 0, nbin-1 do begin
   su[*,*,ibin] = total(sus[*,*,*,ibin]*delp,3)/9.81
  endfor

; sulfate primary group
  rmrat = (3.25d/0.0002d)^(3.d/22)  ; based on older 22 bin
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.) * 1e6
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, rs, rups, drs, rlows

  if(i eq 0) then begin
   set_plot, 'ps'
   device, file='plot_psd.su.ps', /color, /helvetica, font_size=14, $
    xsize=24, ysize=12
   !p.font=0

   loadct, 0
   plot, 2.*rs, su[0,0,*]*rs/drs, $
    /xlog, /ylog, /nodata, xrange=[.01,20.], yrange=[1e-3,10000], charsize=1.2, $
    xtitle='diameter [um]', ytitle='dMdlnr [Tg]', xstyle=1, ystyle=1, $
    position=[.15,.15,.95,.95]

  endif

  fac = total(area)/1.e9

; compute the effective radius
  mee = fltarr(nx,ny)
  for iy = 0, ny-1 do begin
   for ix = 0, nx-1 do begin
    mee[ix,iy] = suext[ix,iy]/total(su[ix,iy,*])
   endfor
  endfor
  mee = aave(mee*suext,area)/aave(suext,area)
  num = aave(su,area)/rs^3
  reff = total(rs^3*num)/total(rs^2*num)

  loadct, 65
  oplot, 2.*rs, fac*aave(su,area)*rs/drs, thick=6, color=color[i]
print, filenames[i], max(fac*aave(su,area)*rs/drs), reff, mee
  if(i eq 8 or i eq 11) then begin
   print, num/drs
  endif
  endfor

; Oplot the GOCART PSD

; sulfate parameters
  loadct, 39
  rmed = 0.35d
  sigma = 1.59d
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
