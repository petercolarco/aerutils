; Procedure here gloms model profiles of aerosol mass distributions
; together with optical property tables to generate an integrated set
; of quantities, and produces a table of spectral extinction, single
; scattering albedo, and phase function

; See also aerutils/projects/omps/scat/scat.pro

; Using here also the Gamma Distribution from Zhong Chen's 2018 AMT paper

; Optics tables
  fileSU = '/share/colarco/fvInput/AeroCom/x/carma_optics_SU.v6.nbin=24.nc'

; Create the output netcdf files to hold all this...
  nz   =  72 ; 72 level output
  nlam =   8
  nang = 500 ; 500 angles for phase matrices
;  cdfid = ncdf_create('phase.parker.19910615.nc',/clobber)
;  cdfid = ncdf_create('phase.c90Fc_I10pa3_anth.nc',/clobber)
  cdfid = ncdf_create('phase.c90F_pI33p9_sulf.nc',/clobber)
;  cdfid = ncdf_create('phase.nc',/clobber)
  idnLam = NCDF_DIMDEF(cdfid,'lambda',nLam)
  idnZ   = ncdf_dimdef(cdfid,'altitude',nz)
  idnAng = ncdf_dimdef(cdfid,'angles',nang)

  idTau  = NCDF_VARDEF(cdfid,'tau',[idnLam,idnZ])
    ncdf_attput, cdfid, idTau, 'long_name', 'layer extinction optical thickness'
    ncdf_attput, cdfid, idTau, 'units', 'dimensionless'

  idSSA  = NCDF_VARDEF(cdfid,'ssa',[idnLam,idnZ])
    ncdf_attput, cdfid, idSSA, 'long_name', 'layer single scattering albedo'
    ncdf_attput, cdfid, idSSA, 'units', 'dimensionless'

  idH    = NCDF_VARDEF(cdfid,'altitude',[idnZ])
    ncdf_attput, cdfid, idH, 'long_name', 'mid-layer altitude'
    ncdf_attput, cdfid, idH, 'units', '[m]'

  idDZ   = NCDF_VARDEF(cdfid,'dz',[idnZ])
    ncdf_attput, cdfid, idDZ, 'long_name', 'level thickness'
    ncdf_attput, cdfid, idDZ, 'units', '[m]'

  idLam  = NCDF_VARDEF(cdfid,'lambda',[idnLam])
    ncdf_attput, cdfid, idLam, 'long_name', 'wavelength'
    ncdf_attput, cdfid, idLam, 'units', '[m]'

  idAng  = NCDF_VARDEF(cdfid,'angles',[idnAng])
    ncdf_attput, cdfid, idAng, 'long_name', 'angles for phase functions'
    ncdf_attput, cdfid, idAng, 'units', 'degrees'

  idP11  = NCDF_VARDEF(cdfid,'p11',[idnLam,idnZ,idnAng])
    ncdf_attput, cdfid, idP11, 'long_name', 'P11 phase function'
    ncdf_attput, cdfid, idP11, 'units', 'dimensionless'

  idP12  = NCDF_VARDEF(cdfid,'p12',[idnLam,idnZ,idnAng])
    ncdf_attput, cdfid, idP12, 'long_name', 'P12 phase function'
    ncdf_attput, cdfid, idP12, 'units', 'dimensionless'

  idP22  = NCDF_VARDEF(cdfid,'p22',[idnLam,idnZ,idnAng])
    ncdf_attput, cdfid, idP22, 'long_name', 'P22 phase function'
    ncdf_attput, cdfid, idP22, 'units', 'dimensionless'

  idP33  = NCDF_VARDEF(cdfid,'p33',[idnLam,idnZ,idnAng])
    ncdf_attput, cdfid, idP33, 'long_name', 'P33 phase function'
    ncdf_attput, cdfid, idP33, 'units', 'dimensionless'

  idP34  = NCDF_VARDEF(cdfid,'p34',[idnLam,idnZ,idnAng])
    ncdf_attput, cdfid, idP34, 'long_name', 'P34 phase function'
    ncdf_attput, cdfid, idP34, 'units', 'dimensionless'

  idP44  = NCDF_VARDEF(cdfid,'p44',[idnLam,idnZ,idnAng])
    ncdf_attput, cdfid, idP44, 'long_name', 'P44 phase function'
    ncdf_attput, cdfid, idP44, 'units', 'dimensionless'

  NCDF_CONTROL, cdfid, /endef

  lambdam = [353,430,510,600,675,745,869,997]*1.e-9
  angles = [0.00,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.10,0.11,0.12,0.13,0.14,0.15, $
            0.16,0.17,0.18,0.19,0.20,0.21,0.22,0.23,0.24,0.25,0.26,0.27,0.28,0.29,0.30,0.31, $
            0.32,0.33,0.34,0.35,0.36,0.37,0.38,0.39,0.40,0.41,0.42,0.43,0.44,0.45,0.46,0.47, $
            0.48,0.49,0.50,0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59,0.60,0.61,0.62,0.63, $
            0.64,0.65,0.66,0.67,0.68,0.69,0.70,0.71,0.72,0.73,0.74,0.75,0.76,0.77,0.78,0.79, $
            0.80,0.81,0.82,0.83,0.84,0.85,0.86,0.87,0.88,0.89,0.90,0.91,0.92,0.93,0.94,0.95, $
            0.96,0.97,0.98,0.99,1.00,1.01,1.02,1.03,1.04,1.05,1.06,1.07,1.08,1.09,1.10,1.11, $
            1.12,1.13,1.14,1.15,1.16,1.17,1.18,1.19,1.20,1.21,1.22,1.23,1.24,1.25,1.26,1.27, $
            1.28,1.29,1.30,1.31,1.32,1.33,1.34,1.35,1.36,1.37,1.38,1.39,1.40,1.41,1.42,1.43, $
            1.44,1.45,1.46,1.47,1.48,1.49,1.50,1.51,1.52,1.53,1.54,1.55,1.56,1.57,1.58,1.59, $
            1.60,1.61,1.62,1.63,1.64,1.65,1.66,1.67,1.68,1.69,1.70,1.71,1.72,1.73,1.74,1.75, $
            1.76,1.77,1.78,1.79,1.80,1.81,1.82,1.83,1.84,1.85,1.86,1.87,1.88,1.89,1.90,1.91, $
            1.92,1.93,1.94,1.95,1.96,1.97,1.98,1.99,2.00,2.05,2.10,2.15,2.20,2.25,2.30,2.35, $
            2.40,2.45,2.50,2.55,2.60,2.65,2.70,2.75,2.80,2.85,2.90,2.95,3.00,3.05,3.10,3.15, $
            3.20,3.25,3.30,3.35,3.40,3.45,3.50,3.55,3.60,3.65,3.70,3.75,3.80,3.85,3.90,3.95, $
            4.00,4.05,4.10,4.15,4.20,4.25,4.30,4.35,4.40,4.45,4.50,4.55,4.60,4.65,4.70,4.75, $
            4.80,4.85,4.90,4.95,5.00,5.10,5.20,5.30,5.40,5.50,5.60,5.70,5.80,5.90,6.00,6.10, $
            6.20,6.30,6.40,6.50,6.60,6.70,6.80,6.90,7.00,7.10,7.20,7.30,7.40,7.50,7.60,7.70, $
            7.80,7.90,8.00,8.10,8.20,8.30,8.40,8.50,8.60,8.70,8.80,8.90,9.00,9.10,9.20,9.30, $
            9.40,9.50,9.60,9.70,9.80,9.90,10.00,10.50,11.00,11.50,12.00,12.50,13.00,13.50,14.00, $
            14.50,15.00,16.00,17.00,18.00,19.00,20.00,21.00,22.00,23.00,24.00,25.00,26.00,27.00, $
            28.00,29.00,30.00,31.00,32.00,33.00,34.00,35.00,36.00,37.00,38.00,39.00,40.00,41.00, $
            42.00,43.00,44.00,45.00,46.00,47.00,48.00,49.00,50.00,51.00,52.00,53.00,54.00,55.00, $
            56.00,57.00,58.00,59.00,60.00,61.00,62.00,63.00,64.00,65.00,66.00,67.00,68.00,69.00, $
            70.00,71.00,72.00,73.00,74.00,75.00,76.00,77.00,78.00,79.00,80.00,81.00,82.00,83.00, $
            84.00,85.00,86.00,87.00,88.00,89.00,90.00,91.00,92.00,93.00,94.00,95.00,96.00,97.00, $
            98.00,99.00,100.00,101.00,102.00,103.00,104.00,105.00,106.00,107.00,108.00,109.00,110.00, $
            111.00,112.00,113.00,114.00,115.00,116.00,117.00,118.00,119.00,120.00,121.00,122.00,123.00, $
            124.00,125.00,126.00,127.00,128.00,129.00,130.00,131.00,132.00,133.00,134.00,135.00,136.00, $
            137.00,138.00,139.00,140.00,141.00,142.00,143.00,144.00,145.00,146.00,147.00,148.00,149.00, $
            150.00,151.00,152.00,153.00,154.00,155.00,156.00,157.00,158.00,159.00,160.00,161.00,162.00, $
            163.00,164.00,165.00,166.00,167.00,168.00,169.00,170.00,171.00,172.00,173.00,174.00,175.00, $
            175.50,175.75,176.00,176.25,176.50,176.75,177.00,177.25,177.50,177.75,178.00,178.25,178.50, $
            178.75,179.00,179.25,179.50,179.75,180.00]
  angles = double(angles)

; Get a "climatological" background stratospheric aerosol
; -------------------------------------------------------
;  filename = '/misc/prc18/colarco/c90F_pI33p9_ocs/tavg3d_carma_v/c90F_pI33p9_ocs.tavg3d_carma_v.monthly.clim.JJA.nc4'
  filename = '/misc/prc18/colarco/c90F_pI33p9_sulf/tavg3d_carma_v/c90F_pI33p9_sulf.tavg3d_carma_v.monthly.201006.nc4'
;  filename = 'c90Fc_I10pacs12_radact.tavg3d_carma_v.19910615_1200z.nc4'
;  expid = 'c90Fc_I10pa3_anth'
;  filename = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.clim.JJA.nc4'
  wantlon = -105.
  wantlat = 41.
  nc4readvar, filename, 'rh', rh, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'delp', delp, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'airdens', rhoa, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat
  nc4readvar, filename, 'su0', su, wantlon=wantlon, wantlat=wantlat, lev=lev, lon=lon, lat=lat, /tem
  filename = 'GEOS.fp.asm.inst3_3d_asm_Nv.20200605_0000.V01.nc4'
  nc4readvar, filename, 'h', z, wantlon=wantlon, wantlat=wantlat

  const = {constSU:su}
  nz = n_elements(rh)
  nmom = 301

  tau  = fltarr(nz)
  ssa  = fltarr(nz)
  g    = fltarr(nz)
  pmom = fltarr(nz,nmom)

  grav = 9.81

  ncdf_varput, cdfid, idH, z
  ncdf_varput, cdfid, idDZ, delp/grav/rhoa
  ncdf_varput, cdfid, idAng, angles
  ncdf_varput, cdfid, idLam, lambdam

  for ilam = 0, nlam-1 do begin
;  for ilam = nlam-1, nlam-1 do begin

; Wavelength
  lambdanm = lambdam[ilam]*1.e9
  print, lambdanm

; Get tables
  fill_mie_table, fileSU, strSU, lambdanm=lambdanm

  tables = {strSU:strSU}

; Get the aerosol properties
; --------------------------
  get_profile_properties, rh, delp, tables, const, ssa, tau, g, pmom

; And construct the phase function
  mu     = cos(angles*!dpi/180.d)
  phase  = dblarr(nang,nz,6)
  nmom   = nmom-1
  for iz = 0, nz-1 do begin
     for iang = 0, nang-1 do begin
        x = mu[iang]
        leg = dblarr(nmom+1)
        leg[0] = 1.d
        leg[1] = x
        for imom = 2, nmom do begin
         leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
        endfor
        for ivec = 0, 5 do begin
         for imom = 0, nmom do begin
          phase[iang,iz,ivec] = phase[iang,iz,ivec] + pmom[iz,imom,ivec]*leg[imom]
         endfor
        endfor
     endfor
  endfor

  iz  = 33
  p11 = phase[*,iz,0]
  p12 = phase[*,iz,1]
  p22 = phase[*,iz,2]
  p33 = phase[*,iz,3]
  p34 = phase[*,iz,4]
  p44 = phase[*,iz,5]

; Dump to file
  ncdf_varput, cdfid, idTau, tau, offset=[iLam,0], count=[1,nz]
  ncdf_varput, cdfid, idSSA, ssa, offset=[iLam,0], count=[1,nz]
  ncdf_varput, cdfid, idP11, transpose(phase[*,*,0]), offset=[iLam,0,0], count=[1,nz,nang]
  ncdf_varput, cdfid, idP12, transpose(phase[*,*,1]), offset=[iLam,0,0], count=[1,nz,nang]
  ncdf_varput, cdfid, idP22, transpose(phase[*,*,2]), offset=[iLam,0,0], count=[1,nz,nang]
  ncdf_varput, cdfid, idP33, transpose(phase[*,*,3]), offset=[iLam,0,0], count=[1,nz,nang]
  ncdf_varput, cdfid, idP34, transpose(phase[*,*,4]), offset=[iLam,0,0], count=[1,nz,nang]
  ncdf_varput, cdfid, idP44, transpose(phase[*,*,5]), offset=[iLam,0,0], count=[1,nz,nang]


  endfor  ; ilam
  ncdf_close, cdfid

stop

; E.g
  set_plot, 'ps'
  device, filename='./phase.ps', /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=12, ysize=16, /color
  !P.font=0


  !p.multi=[0,2,3]
  plot, acos(mu)/!dpi*180., p11, /ylog, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P11', title='P11', $
   xrange=[0,180], xstyle=9, yrange=[1.e-2,1.e3], ystyle=9
  plot, acos(mu)/!dpi*180., p12/p11, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P12/P11', title='P12/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9
  plot, acos(mu)/!dpi*180., p22/p11, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P22/P11', title='P22/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9
  plot, acos(mu)/!dpi*180., p33/p11, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P33/P11', title='P33/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9
  plot, acos(mu)/!dpi*180., p34/p11, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P34/P11', title='P34/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9
  plot, acos(mu)/!dpi*180., p44/p11, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P44/P11', title='P44/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9


  device, /close

end

