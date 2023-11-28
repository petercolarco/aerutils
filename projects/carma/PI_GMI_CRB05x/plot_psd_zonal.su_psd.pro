; Global, monthly mean dry aerosol PSD by species

  color=findgen(12)*20+30

  expid = 'PI_GMI_CRB05x'
  filenames = './'+expid+'.tavg24_3d_carma_Nv.monthly.2084'+$
              ['01','02','03','04','05','06','07','08','09','10','11','12']+'.nc4'
  filenamessfc = './'+expid+'.tavg24_2d_carma_Nx.monthly.2084'+$
              ['01','02','03','04','05','06','07','08','09','10','11','12']+'.nc4'

  nf = n_elements(filenames)

  for i = 0, 11 do begin ;nf-1 do begin
print, i
  filename = filenames[i]
  filenamesfc = filenamessfc[i]

  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat
  nc4readvar, filename, 'zl', z, lon=lon, lat=lat
  nc4readvar, filename, 'suextcoef', suextcoef, lon=lon, lat=lat
  nx = n_elements(lon)
  ny = n_elements(lat)
  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

; Get the aerosols
  nc4readvar, filename, 'su0', sus, /template
  sz = size(sus)
  nz = sz[3]
  nbin = sz[4]
  area, lon, lat, nx, ny, dx, dy, area

; get the aot
  nc4readvar, filenamesfc, 'suexttau', suext

; sulfate primary group
  rmrat = (3.25d/0.0002d)^(3.d/22)  ; based on older 22 bin
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.) * 1e6
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, rs, rups, drs, rlows

; Do the zonal average - result is number
  su = fltarr(ny,nz,nbin)
  mass = fltarr(ny,nz,nbin)
  for ibin = 0, nbin-1 do begin
   su[*,*,ibin] = total(sus[*,*,*,ibin],1)/nx/rs[ibin]^3.
   mass[*,*,ibin] = total(sus[*,*,*,ibin],1)/nx
  endfor
  mass = total(mass,3)
  z = mean(z,dim=1)
  suextcoef = mean(suextcoef,dim=1)

  reff = fltarr(ny,nz) ; in microns
  for iy = 0, ny-1 do begin
   for iz = 0, nz-1 do begin
    reff[iy,iz] = total(su[iy,iz,*]*rs^3.)/total(su[iy,iz,*]*rs^2.)
   endfor
  endfor

  if(i eq 0) then begin
   set_plot, 'ps'
   device, file='plot_psd_zonal.su_psd.20n.ps', /color, /helvetica, font_size=14, $
    xsize=24, ysize=36
   !p.font=0
   !p.multi=[0,3,5]
  endif


   loadct, 39
   plot, rs, su[110,43,*]*rs/drs, /nodata, yrange=[1.e-12,10], /ylog, $
    xtitle='radius [!Mm!Nm]', xrange=[0.0001, 10], /xlog, ystyle=1, $
    ytitle='dNdlnr, dMdlnr (dashed)', title=i
   oplot, rs, su[110,43,*]*rs/drs, color=0, thick=4   ; 10 km
   oplot, rs, su[110,33,*]*rs/drs, color=80, thick=4  ; 20 km
   oplot, rs, su[110,18,*]*rs/drs, color=254, thick=4 ; 40 km
   oplot, rs, 1e4*rs^3*su[110,43,*]*rs/drs, color=0, thick=4, lin=2   ; 10 km
   oplot, rs, 1e4*rs^3*su[110,33,*]*rs/drs, color=80, thick=4, lin=2  ; 20 km
   oplot, rs, 1e4*rs^3*su[110,18,*]*rs/drs, color=254, thick=4, lin=2 ; 40 km

   xyouts, .0005, 1e-8, '40 km, reff='+string(reff[110,18],format='(f5.3)'), color=254, charsize=.6
   xyouts, .0005, 1e-9, '20 km, reff='+string(reff[110,33],format='(f5.3)'), color=80, charsize=.6
   xyouts, .0005, 1e-10, '10 km, reff='+string(reff[110,43],format='(f5.3)'), color=0, charsize=.6

   endfor

  device, /close

end
