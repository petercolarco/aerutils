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
   device, file='plot_psd_zonal.su.ps', /color, /helvetica, font_size=14, $
    xsize=24, ysize=36
   !p.font=0
   !p.multi=[0,3,5]
  endif


   loadct, 0
   contour, reff, lat, z/1000., /nodata, yrange=[0,60], $
    xtitle='latitude', xrange=[-90,90], ytitle='altitude [km]', title=i
   loadct, 62
   contour, reff, lat, z/1000., /over, $
    levels=[.2,.4,.6,.8,1,1.2], /cell, c_colors=findgen(6)*40+20
   loadct, 0
   contour, mass*1e9, lat, z/1000., /over, levels=[10,20,50,100,200,500,1000]
   contour, suextcoef*1e6, lat, z/1000., /over, levels=[10,20,50,100,200,500,1000], $
    c_linestyle=make_array(7,val=1)

   endfor

  loadct, 0
  makekey, .1, .1, .8, .05, 0., -0.02, colors=make_array(6,val=0), $
   label=string([.2,.4,.6,.8,1,1.2],format='(f3.1)')
  loadct, 62
  makekey, .1, .1, .8, .05, 0., -0.02, colors=findgen(6)*40+20, label=make_array(8,val=' ')

  device, /close

end
