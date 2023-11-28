; See also aerutils/projects/omps/scat/scat.pro
; Using here also the Gamma Distribution from Zhong Chen's 2018 AMT paper

; Wavelength
  lambdanm = 675.

  nmom = 301

; Create an example from the Gamma Distribution Zhong Chen had in his
; 2018 paper
; Use CARMA optics table to construct for Zhong's phase function
  fileSU = '/share/colarco/fvInput/AeroCom/x/carma_optics_SU.v1.nbin=22.nc'
  lambdanm = 675.
  fill_mie_table, fileSU, strSU, lambdanm=lambdanm
  tablesOMPS = {strSU:strSU}

  alpha = 2.8
  beta  = 20.5
  nbin = 22
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
; Put rmin in microns
  rmin = rmin * 1e6
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow
  dndr = 1.*beta^alpha*r^(alpha-1)*exp(-r*beta) / gamma(alpha) / dr
  dvdr = 4./3.*!dpi*r^3*dndr
  nz   = 1
  constSU = make_array(nz,nbin,val=0.)
  rh   = make_array(nz,val=0.)
  delp = make_array(nz,val=1.)
  for iz = 0, nz-1 do begin
   constSU[iz,*] = dvdr*dr
  endfor
  constOMPS = {constSU:constSU}
  get_profile_properties, rh, delp, tablesOMPS, constOMPS, ssaomps, tauomps, gomps, pmomomps



; And construct the phase function
  nangles = 1801
  dang    = 180./(nangles-1.)
  angles  = dindgen(nangles)*dang
  mu      = cos(angles*!dpi/180.)
  dmu     = findgen(nangles)
  for iang = 0, nangles-2 do begin
   dmu[iang] = abs(mu[iang]-mu[iang+1])
  endfor
  dmu[nangles-1] = dmu[nangles-2]
  p11omps = dblarr(nangles,nz)
  nmom = nmom-1
  for iz = 0, nz-1 do begin
     for iang = 0, nangles-1 do begin
        x = mu[iang]
        leg = dblarr(nmom+1)
        leg[0] = 1.d
        leg[1] = x
        for imom = 2, nmom do begin
         leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
        endfor
        for imom = 0, nmom do begin
         p11omps[iang,iz] = p11omps[iang,iz] + pmomomps[iz,imom]*leg[imom]
        endfor
     endfor
  endfor

; Make a grid for a lat-lon map
  area, lon, lat, nx, ny, dx, dy, area, grid='d'
; This is the single scattering angle for OMPS from Matt's plot
; Go from 15 at 90 N to 165 at 90 S
  pang = 165. - findgen(ny)*150./(ny-1)
  p11  = fltarr(nx,ny)
  p11_ = interpolate(p11omps,interpol(indgen(n_elements(angles)),angles,pang))
  for ix = 0, nx-1 do begin
   p11[ix,*] = p11_
  endfor


  set_plot, 'ps'
  device, file='scat_map.omps.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0

  map_set, position=[.1,.2,.9,.9], /noborder


  loadct, 51
  levels = [.01,.02,.03,.05,.1,.2,.3,.5,1,2,3,5]
  colors = findgen(12)*20.
  contour, /overplot, p11, lon, lat, levels=levels, c_colors=colors, /cell

  loadct, 0
  map_continents, mlinethick=2
  axis, yaxis=0, yrange=[-90,90], ystyle=1, ytitle='Latitude', yticks=6
  axis, yaxis=1, yrange=[165,15], ystyle=1, ytitle='Scattering Angle', yticks=10
  axis, xaxis=0, xrange=[0,360],  xstyle=1, xtitle='Longitude', xticks=12
  plots, [.1,.9,.9,.1,.1], [.2,.2,.9,.9,.2], /normal, thick=3
  
  makekey, .1, .05, .8, .04, 0, -.04, align=0, $
     colors=make_array(n_elements(levels),val=0), $
     labels=string(levels,format='(f4.2)')
  loadct, 51
  makekey, .1, .05, .8, .04, 0, -.04, /noborder, $
     colors=colors, labels=make_array(n_elements(levels),val=' ')
 
  device, /close

end

