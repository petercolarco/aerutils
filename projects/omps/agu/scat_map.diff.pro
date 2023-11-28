; See also aerutils/projects/omps/scat/scat.pro
; Using here also the Gamma Distribution from Zhong Chen's 2018 AMT paper

; yyyymm
  yyyymm = '200508'

; Wavelength
  lambdanm = 675.

; Vertical level
  nz = 1  ; get one level
  iz = 33 ; 20 km
;  iz = 38 ; 15 km

  nmom = 301

; Optics tables
  fileSU = '/share/colarco/fvInput/AeroCom/x/optics_SU.v1_5.nc'
  fileDU = '/share/colarco/fvInput/AeroCom/x/optics_DU.v15_5.nc'
  fileSS = '/share/colarco/fvInput/AeroCom/x/optics_SS.v3_5.nc'
  fileBC = '/share/colarco/fvInput/AeroCom/x/optics_BC.v1_5.nc'
  fileOC = '/share/colarco/fvInput/AeroCom/x/optics_OC.v1_5.nc'
  fileNI = '/share/colarco/fvInput/AeroCom/x/optics_NI.v2_5.nc'

; Wavelength
  lambdanm = 675.

; Get tables
  fill_mie_table, fileSU, strSU, lambdanm=lambdanm
  fill_mie_table, fileDU, strDU, lambdanm=lambdanm
  fill_mie_table, fileSS, strSS, lambdanm=lambdanm
  fill_mie_table, fileBC, strBC, lambdanm=lambdanm
  fill_mie_table, fileOC, strOC, lambdanm=lambdanm
  fill_mie_table, fileNI, strNI, lambdanm=lambdanm

  tables = {strSU:strSU, strDU:strDU, strSS:strSS, strBC:strBC, strOC:strOC, strNI:strNI}

; Background
; ----------
  filename = '/misc/prc18/colarco/c90F_pI33p4_ocs/tavg3d_aer_v/c90F_pI33p4_ocs.tavg3d_aer_v.monthly.clim.ANN.nc4'
  nc4readvar, filename, 'rh', rh, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'so4', su, lev=lev, lon=lon, lat=lat
  subak = su[*,*,iz]

; Get a model profile and set up an altitude grid
  expid = 'MERRA2_GMI'
  filename = '/misc/prc13/MERRA2_GMI/c180/MERRA2_GMI.inst3_3d_aer_Nv.monthly.'+yyyymm+'.nc4'
  nc4readvar, filename, 'rh', rh, wantlon=[1], wantlat=[1], lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=[1], wantlat=[1], lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=[1], wantlat=[1], lev=lev, lon=lon, lat=lat

; Get the model species
  nc4readvar, filename, 'rh', rh, lev=lev, lon=lon, lat=lat, wantlev = [iz]
  nc4readvar, filename, 'delp', delp, lev=lev, lon=lon, lat=lat, wantlev = [iz]
  nc4readvar, filename, 'airdens', rhoa, lev=lev, lon=lon, lat=lat, wantlev = [iz]
  nc4readvar, filename, ['so4','so4v'], su, lev=lev, lon=lon, lat=lat, wantlev = [iz]
  nc4readvar, filename, 'BCP', bc, lev=lev, lon=lon, lat=lat, /tem, wantlev = [iz]
  nc4readvar, filename, 'OCP', oc, lev=lev, lon=lon, lat=lat, /tem, wantlev = [iz]
  nc4readvar, filename, 'DU0', du, lev=lev, lon=lon, lat=lat, /tem, wantlev = [iz]
  nc4readvar, filename, 'SS0', ss, lev=lev, lon=lon, lat=lat, /tem, wantlev = [iz]
  nc4readvar, filename, 'NO3an', ni, lev=lev, lon=lon, lat=lat, /tem, wantlev = [iz]

; Make a grid for a lat-lon map
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

; Thin the model results
  nx = 144
  ny = 91
  rh = congrid(rh,nx,ny)
  delp = congrid(delp,nx,ny)
  su = congrid(su,nx,ny,2)
  du = congrid(du,nx,ny,5)
  ss = congrid(ss,nx,ny,5)
  oc = congrid(oc,nx,ny,2)
  bc = congrid(bc,nx,ny,2)
  ni = congrid(ni,nx,ny,3)
  lon = congrid(lon,nx)
  lat = congrid(lat,ny)
  subak = congrid(subak,nx,ny)
  su[*,*,0] = su[*,*,0]+subak



; This is the single scattering angle for OMPS from Matt's plot
; Go from 15 at 90 N to 165 at 90 S
  pang = 165. - findgen(ny)*150./(ny-1)
  p11  = fltarr(nx,ny)
  
; Now get optical properties and do a loop on lat/lon grid to get pmom
; and then phase function
  nmom = nmom-1
  for iy = 0,ny-1 do begin
;  Compute the phase function
   x   = cos(pang[iy]*!dpi/180.)
   leg = dblarr(nmom+1)
   leg[0] = 1.d
   leg[1] = x
   for imom = 2, nmom do begin
    leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
   endfor
   for ix = 0,nx-1 do begin
    print, ix,iy
    const = {constSU:reform(su[ix,iy,*],1,2), constDU:reform(du[ix,iy,*],1,5), $
             constBC:reform(bc[ix,iy,*],1,2), constOC:reform(oc[ix,iy,*],1,2), $
             constNI:reform(ni[ix,iy,*],1,3), constSS:reform(ss[ix,iy,*],1,5) }
    get_profile_properties, rh[ix,iy], delp[ix,iy], tables, const, ssa, tau, g, pmom
    for imom = 0, nmom do begin
     p11[ix,iy] = p11[ix,iy] + pmom[0,imom]*leg[imom]
    endfor
   endfor
  endfor


; Get the OMPS P11
; ----------------
; Create an example from the Gamma Distribution Zhong Chen had in his
; 2018 paper
; Use CARMA optics table to construct for Zhong's phase function
  fileSU = '/share/colarco/fvInput/AeroCom/x/carma_optics_SU.v1.nbin=22.nc'
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

; This is the single scattering angle for OMPS from Matt's plot
; Go from 15 at 90 N to 165 at 90 S
  pang = 165. - findgen(ny)*150./(ny-1)
  p11o = fltarr(nx,ny)
  p11_ = interpolate(p11omps,interpol(indgen(n_elements(angles)),angles,pang))
  for ix = 0, nx-1 do begin
   p11o[ix,*] = p11_
  endfor


  set_plot, 'ps'
  device, file='scat_map.diff.'+yyyymm+'.ps', /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=24, ysize=12
  !p.font=0

  map_set, position=[.1,.2,.9,.9], /noborder

  loadct, 67
  levels = [-1000,-30,-20,-10,-5,5,10,20,30]
;  levels = [-1000,-75,-50,-25,-5,5,25,50,75]
  dcolors = findgen(9)*25+25
; percent differences...
  diff = (p11o-p11)/p11o*100.
  contour, /overplot, diff, lon, lat, levels=levels, c_colors=dcolors, /cell

  loadct, 0
  map_continents, mlinethick=2
  axis, yaxis=0, yrange=[-90,90], ystyle=1, ytitle='Latitude', yticks=6
  axis, yaxis=1, yrange=[165,15], ystyle=1, ytitle='Scattering Angle', yticks=10
  axis, xaxis=0, xrange=[0,360],  xstyle=1, xtitle='Longitude', xticks=12
  plots, [.1,.9,.9,.1,.1], [.2,.2,.9,.9,.2], /normal, thick=3
  
  labels = string(levels,format='(i4)')
  labels[0] = ' '
  makekey, .1, .05, .8, .04, 0, -.04, align=.5, $
     colors=make_array(n_elements(levels),val=0), $
     labels=labels
  loadct, 67
  makekey, .1, .05, .8, .04, 0, -.04, /noborder, $
     colors=dcolors, labels=make_array(n_elements(levels),val=' ')
 
  device, /close

end

