; Colarco, November 2018
; Read GEOS optical lookup tables and generate needed information for
; plotting the phase functions at selected channels.

; Access contents of tables by looking at structure "tableSU"
; Phase matrix elements are returned as expansion coefficients of
; legendre series for each of 6 elements: P11, P12, P33, P34, P22, P44


; Specify the wavelength desired for what follows:
  lambdanm = 354.

  fileDir = './'
;  fileDir = '/share/colarco/fvInput/AeroCom/x/'

;--------------------------------------------------------------------
; Sulfate example
; For sulfate we are calculating the optical properties assuming Mie
; theory, OPAC refractive indices and hygroscopic growth
  fileSU = fileDir+'optics_SU.v3_3.nc'
  fill_mie_table, fileSU, tableSU, lambdanm=lambdanm

; Dimensions of returned tables are nRH (=36),nBin (=2), and for pmom
; (nRH,nBin,nMom,nP) where nP is each of the 6 matrix elements and
; nMom is the number of moments 

; For sulfate we ignore the second size bin, not used in MERRA-2, and
; here is the example code to compute the P11 phase function as a
; function of angle at RH=0:
  iRH = 0
  iBin = 0
  nangles = 1801
  dang    = 180./(nangles-1.)
  angles  = dindgen(nangles)*dang
  mu      = cos(angles*!dpi/180.)
  dmu     = findgen(nangles)
  for iang = 0, nangles-2 do begin
   dmu[iang] = abs(mu[iang]-mu[iang+1])
  endfor
  dmu[nangles-1] = dmu[nangles-2]
  p11SU     = dblarr(nangles)
  nmom = tableSU.nmom-1
  for iang = 0, nangles-1 do begin
     x = mu[iang]
     leg = dblarr(nmom+1)
     leg[0] = 1.d
     leg[1] = x
     for imom = 2, nmom do begin
      leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
     endfor
     for imom = 0, nmom do begin
      p11SU[iang] = p11SU[iang] + tableSU.pmom[iRH,iBin,imom,0]*leg[imom]
; e.g.p12SU[iang] = p12SU[iang] + tableSU.pmom[iRH,iBin,imom,1]*leg[imom] and so on...
     endfor
  endfor


;--------------------------------------------------------------------
; Black Carbon example
; For black carbon we are calculating the optical properties assuming Mie
; theory, OPAC refractive indices and hygroscopic growth
  fileBC = fileDir+'optics_BC.v1_3.nc'
  fill_mie_table, fileBC, tableBC, lambdanm=lambdanm

; Dimensions of returned tables are nRH (=36),nBin (=2), and for pmom
; (nRH,nBin,nMom,nP) where nP is each of the 6 matrix elements and
; nMom is the number of moments 

; For black carbon bin 1 is hydrophobic and bin 2 is hygroscopic
; (i.e., bin 2 optical properties are sensitive to RH), and
; here is the example code to compute the P11 phase function as a
; function of angle at RH=80%. Need to integrate too across the two
; size bins
; Figure out integrated effective SSA, TAU, and moments of phase
; matrices
  iRH = 16
  nBin = 2
  fBin = [0.5,0.5]    ; assumed partitioning of total BC mass between two size bins
  tau = 0.
  ssa = 0.
  g   = 0.
  nmom = tableBC.nmom-1
  pmom = make_array(nMom+1,6, val=0.)
  for ibin = 0, nBin-1 do begin
   tau_ = fBin[ibin]*tableBC.bext[iRH,iBin]
   ssa_ = tableBC.bsca[iRH,iBin] / tableBC.bext[iRH,iBin]
   tau  = tau + tau_
   ssa  = ssa + ssa_*tau_
   g    = g + tableBC.g*ssa_*tau_
   for im = 0, 5 do begin
    for imom = 0, nmom do begin
     pmom[imom,im] = pmom[imom,im] + tableBC.pmom[iRH,ibin,imom,im]*ssa_*tau_
    endfor
   endfor
  endfor
; Normalize
  ssa = ssa / tau
  g   = g / (ssa*tau)
  pmom = pmom / (ssa*tau)



  nangles = 1801
  dang    = 180./(nangles-1.)
  angles  = dindgen(nangles)*dang
  mu      = cos(angles*!dpi/180.)
  dmu     = findgen(nangles)
  for iang = 0, nangles-2 do begin
   dmu[iang] = abs(mu[iang]-mu[iang+1])
  endfor
  dmu[nangles-1] = dmu[nangles-2]
  p11BC     = dblarr(nangles)
  for iang = 0, nangles-1 do begin
     x = mu[iang]
     leg = dblarr(nmom+1)
     leg[0] = 1.d
     leg[1] = x
     for imom = 2, nmom do begin
      leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
     endfor
     for imom = 0, nmom do begin
      p11BC[iang] = p11BC[iang] + pmom[imom,0]*leg[imom]
     endfor
  endfor


;--------------------------------------------------------------------
; Organic Carbon example
; For organic carbon we are calculating the optical properties assuming Mie
; theory, OPAC refractive indices and hygroscopic growth
  fileOC = fileDir+'optics_OC.v1_3.nc'
  fill_mie_table, fileOC, tableOC, lambdanm=lambdanm

; Dimensions of returned tables are nRH (=36),nBin (=2), and for pmom
; (nRH,nBin,nMom,nP) where nP is each of the 6 matrix elements and
; nMom is the number of moments 

; For organic carbon bin 1 is hydrophobic and bin 2 is hygroscopic
; (i.e., bin 2 optical properties are sensitive to RH), and
; here is the example code to compute the P11 phase function as a
; function of angle at RH=80%. Need to integrate too across the two
; size bins
; Figure out integrated effective SSA, TAU, and moments of phase
; matrices
  iRH = 16
  nBin = 2
  fBin = [0.2,0.8]    ; assumed partitioning of total OC mass between two size bins
  tau = 0.
  ssa = 0.
  g   = 0.
  nmom = tableOC.nmom-1
  pmom = make_array(nMom+1,6, val=0.)
  for ibin = 0, nBin-1 do begin
   tau_ = fBin[ibin]*tableOC.bext[iRH,iBin]
   ssa_ = tableOC.bsca[iRH,iBin] / tableOC.bext[iRH,iBin]
   tau  = tau + tau_
   ssa  = ssa + ssa_*tau_
   g    = g + tableOC.g*ssa_*tau_
   for im = 0, 5 do begin
    for imom = 0, nmom do begin
     pmom[imom,im] = pmom[imom,im] + tableOC.pmom[iRH,ibin,imom,im]*ssa_*tau_
    endfor
   endfor
  endfor
; Normalize
  ssa = ssa / tau
  g   = g / (ssa*tau)
  pmom = pmom / (ssa*tau)



  nangles = 1801
  dang    = 180./(nangles-1.)
  angles  = dindgen(nangles)*dang
  mu      = cos(angles*!dpi/180.)
  dmu     = findgen(nangles)
  for iang = 0, nangles-2 do begin
   dmu[iang] = abs(mu[iang]-mu[iang+1])
  endfor
  dmu[nangles-1] = dmu[nangles-2]
  p11OC     = dblarr(nangles)
  for iang = 0, nangles-1 do begin
     x = mu[iang]
     leg = dblarr(nmom+1)
     leg[0] = 1.d
     leg[1] = x
     for imom = 2, nmom do begin
      leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
     endfor
     for imom = 0, nmom do begin
      p11OC[iang] = p11OC[iang] + pmom[imom,0]*leg[imom]
     endfor
  endfor


;--------------------------------------------------------------------
; Dust example
; For dust we are calculating the optical properties assuming
; non-spherical optics and using refractive indices  after Colarco et
; al. 2014 
  fileDU = fileDir+'optics_DU.v15_3.nc'
  fill_mie_table, fileDU, tableDU, lambdanm=lambdanm

; Dimensions of returned tables are nRH (=36),nBin (=5), and for pmom
; (nRH,nBin,nMom,nP) where nP is each of the 6 matrix elements and
; nMom is the number of moments 

; For organic carbon bin 1 is hydrophobic and bin 2 is hygroscopic
; (i.e., bin 2 optical properties are sensitive to RH), and
; here is the example code to compute the P11 phase function as a
; function of angle at RH=80%. Need to integrate too across the two
; size bins
; Figure out integrated effective SSA, TAU, and moments of phase
; matrices
  iRH = 16
  nBin = 2
  fBin = [0.1,.25,.25,.25,.25]    ; assumed partitioning of total DU mass between five size bins as in emissions
  tau = 0.
  ssa = 0.
  g   = 0.
  nmom = tableDU.nmom-1
  pmom = make_array(nMom+1,6, val=0.)
  for ibin = 0, nBin-1 do begin
   tau_ = fBin[ibin]*tableDU.bext[iRH,iBin]
   ssa_ = tableDU.bsca[iRH,iBin] / tableDU.bext[iRH,iBin]
   tau  = tau + tau_
   ssa  = ssa + ssa_*tau_
   g    = g + tableDU.g*ssa_*tau_
   for im = 0, 5 do begin
    for imom = 0, nmom do begin
     pmom[imom,im] = pmom[imom,im] + tableDU.pmom[iRH,ibin,imom,im]*ssa_*tau_
    endfor
   endfor
  endfor
; Normalize
  ssa = ssa / tau
  g   = g / (ssa*tau)
  pmom = pmom / (ssa*tau)



  nangles = 1801
  dang    = 180./(nangles-1.)
  angles  = dindgen(nangles)*dang
  mu      = cos(angles*!dpi/180.)
  dmu     = findgen(nangles)
  for iang = 0, nangles-2 do begin
   dmu[iang] = abs(mu[iang]-mu[iang+1])
  endfor
  dmu[nangles-1] = dmu[nangles-2]
  p11DU     = dblarr(nangles)
  for iang = 0, nangles-1 do begin
     x = mu[iang]
     leg = dblarr(nmom+1)
     leg[0] = 1.d
     leg[1] = x
     for imom = 2, nmom do begin
      leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
     endfor
     for imom = 0, nmom do begin
      p11DU[iang] = p11DU[iang] + pmom[imom,0]*leg[imom]
     endfor
  endfor


;--------------------------------------------------------------------
; Sea salt example
; For sea salt we are calculating the optical properties assuming
; Mie optics, OPAC refractive indices, and hygroscopic growth after
; Gerber 1985
  fileSS = fileDir+'optics_SS.v3_3.nc'
  fill_mie_table, fileSS, tableSS, lambdanm=lambdanm

; Dimensions of returned tables are nRH (=36),nBin (=5), and for pmom
; (nRH,nBin,nMom,nP) where nP is each of the 6 matrix elements and
; nMom is the number of moments 

; For organic carbon bin 1 is hydrophobic and bin 2 is hygroscopic
; (i.e., bin 2 optical properties are sensitive to RH), and
; here is the example code to compute the P11 phase function as a
; function of angle at RH=80%. Need to integrate too across the two
; size bins
; Figure out integrated effective SSA, TAU, and moments of phase
; matrices
  iRH = 16
  nBin = 2
  fBin = [0.000336,0.010991,0.116981,0.49787,0.373822]    ; assumed partitioning of total SS mass between five size bins as in emissions
  tau = 0.
  ssa = 0.
  g   = 0.
  nmom = tableSS.nmom-1
  pmom = make_array(nMom+1,6, val=0.)
  for ibin = 0, nBin-1 do begin
   tau_ = fBin[ibin]*tableSS.bext[iRH,iBin]
   ssa_ = tableSS.bsca[iRH,iBin] / tableSS.bext[iRH,iBin]
   tau  = tau + tau_
   ssa  = ssa + ssa_*tau_
   g    = g + tableSS.g*ssa_*tau_
   for im = 0, 5 do begin
    for imom = 0, nmom do begin
     pmom[imom,im] = pmom[imom,im] + tableSS.pmom[iRH,ibin,imom,im]*ssa_*tau_
    endfor
   endfor
  endfor
; Normalize
  ssa = ssa / tau
  g   = g / (ssa*tau)
  pmom = pmom / (ssa*tau)



  nangles = 1801
  dang    = 180./(nangles-1.)
  angles  = dindgen(nangles)*dang
  mu      = cos(angles*!dpi/180.)
  dmu     = findgen(nangles)
  for iang = 0, nangles-2 do begin
   dmu[iang] = abs(mu[iang]-mu[iang+1])
  endfor
  dmu[nangles-1] = dmu[nangles-2]
  p11SS     = dblarr(nangles)
  for iang = 0, nangles-1 do begin
     x = mu[iang]
     leg = dblarr(nmom+1)
     leg[0] = 1.d
     leg[1] = x
     for imom = 2, nmom do begin
      leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
     endfor
     for imom = 0, nmom do begin
      p11SS[iang] = p11SS[iang] + pmom[imom,0]*leg[imom]
     endfor
  endfor

; Plot the phase functions
  set_plot, 'ps'
  device, file='phase_function.ps', /color, /helvetica, font_size=12
  !p.font=0
  plot, angles, p11SS, /nodata, $
   xtitle='Scattering Angle', xrange=[0,180], xstyle=1, $
   ytitle='P11', /ylog, yrange=[.05,500], ystyle=1
  loadct, 39
  oplot, angles, p11BC, thick=6
  oplot, angles, p11SU, thick=6, color=176
  oplot, angles, p11OC, thick=6, color=254
  oplot, angles, p11DU, thick=6, color=208
  oplot, angles, p11SS, thick=6, color=74
  xyouts, 10, 100, 'Dust', color=208
  xyouts, 30, 100, 'Sea Salt', color=74
  xyouts, 60, 100, 'Sulfate', color=176
  xyouts, 80, 100, 'Black Carbon'
  xyouts, 120, 100, 'Organic Carbon', color=254
  device, /close

end
