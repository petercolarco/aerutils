; Example code to read the phase function moments and plot

  filedir = '../../x/'
  filedir = './'
  filename = 'optics_SU.v_OMPS.nc'
  readoptics, filedir+filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag, pmoments=pmoments, pback=pback

; pmoments is the phase matrix parameters after 
; Liou, eq. 5.2.118 - 5.2.122
; The way the phase quantities are defined follows from Wiscombe's 
; documentation (MIEV.doc) and Liou, eq. 5.2.112:
; pmom1 -> S1 * conj(S1)          = i1 in Liou
; pmom2 -> S2 * conj(S2)          = i2 in Liou
; pmom3 -> Re( S1 * conj(S2) )    = (i3 + i4)/2. in Liou
; pmom4 -> -Im( S1 * conj(S2) )   = -(i4 - i3)/2. in Liou
; pmoments is dimensioned (nLam,nRH,nBin,nMom,nPol)
; where nPol = 0 corresponds to pmom11
; where nPol = 1 corresponds to pmom12
; where nPol = 2 corresponds to pmom33
; where nPol = 3 corresponds to pmom34

; Pick a wavelength and rh
  iLam = 4
  iRH  = 0
  iBin = 0

  pmom11 = reform(pmoments[iLam,iRH,ibin,*,0])
  pmom12 = reform(pmoments[iLam,iRH,ibin,*,1])
  pmom33 = reform(pmoments[iLam,iRH,ibin,*,2])
  pmom34 = reform(pmoments[iLam,iRH,ibin,*,3])
  pmom22 = reform(pmoments[iLam,iRH,ibin,*,4])
  pmom44 = reform(pmoments[iLam,iRH,ibin,*,5])
  nmom = n_elements(pmom11)-1

; Create the angles to plot over
  numang = 500
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
  mu     = cos(angles*!dpi/180.d)

  p11 = dblarr(numang)
  p12 = dblarr(numang)
  p33 = dblarr(numang)
  p34 = dblarr(numang)
  p22 = dblarr(numang)
  p44 = dblarr(numang)
  for iang = 0, numang-1 do begin
   x = mu[iang]
   leg = dblarr(nmom+1)
   leg[0] = 1.d
   leg[1] = x
   for imom = 2, nmom do begin
    leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
   endfor
   for imom = 0, nmom do begin
    p11[iang] = p11[iang] + pmom11[imom]*leg[imom]
    p12[iang] = p12[iang] + pmom12[imom]*leg[imom]
    p33[iang] = p33[iang] + pmom33[imom]*leg[imom]
    p34[iang] = p34[iang] + pmom34[imom]*leg[imom]
    p22[iang] = p22[iang] + pmom22[imom]*leg[imom]
    p44[iang] = p44[iang] + pmom44[imom]*leg[imom]
   endfor
  endfor

; E.g
  set_plot, 'ps'
  device, filename='./sulfate_pmoments.'+filename+'.ps', /helvetica, font_size=14, $
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

  oangle = -cos(angles/180.d*!dpi)
  p11int = total((oangle[1:numang-1]-oangle[0:numang-2])*( (p11[1:numang-1]+p11[0:numang-2])/2.))
  print, 'Total(P11*dmu) over '+string(numang)+' angles = ', p11int


; Overplot for reduced set of moments

  nmom = 300

  p11 = dblarr(numang)
  p12 = dblarr(numang)
  p33 = dblarr(numang)
  p34 = dblarr(numang)
  p22 = dblarr(numang)
  p44 = dblarr(numang)
  for iang = 0, numang-1 do begin
   x = mu[iang]
   leg = dblarr(nmom+1)
   leg[0] = 1.d
   leg[1] = x
   for imom = 2, nmom do begin
    leg[imom] =  1.d0/imom*((2.d0*imom-1.)*x*leg[imom-1]-(imom-1.)*leg[imom-2])
   endfor
   for imom = 0, nmom do begin
    p11[iang] = p11[iang] + pmom11[imom]*leg[imom]
    p12[iang] = p12[iang] + pmom12[imom]*leg[imom]
    p33[iang] = p33[iang] + pmom33[imom]*leg[imom]
    p34[iang] = p34[iang] + pmom34[imom]*leg[imom]
    p22[iang] = p22[iang] + pmom22[imom]*leg[imom]
    p44[iang] = p44[iang] + pmom44[imom]*leg[imom]
   endfor
  endfor

; E.g
  !p.multi=[6,2,3]
  plot, acos(mu)/!dpi*180., p11, /ylog, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P11', title='P11', $
   xrange=[0,180], xstyle=9, yrange=[1.e-2,1.e3], ystyle=9, thick=3, lin=2
  plot, acos(mu)/!dpi*180., p12/p11, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P12/P11', title='P12/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9, thick=3, lin=2
  plot, acos(mu)/!dpi*180., p22/p11, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P22/P11', title='P22/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9, thick=3, lin=2
  plot, acos(mu)/!dpi*180., p33/p11, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P33/P11', title='P33/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9, thick=3, lin=2
  plot, acos(mu)/!dpi*180., p34/p11, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P34/P11', title='P34/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9, thick=3, lin=2
  plot, acos(mu)/!dpi*180., p44/p11, $
   xtitle='Scattering Angle [degrees]', ytitle='Phase Function P44/P11', title='P44/P11', $
   xrange=[0,180], xstyle=9, yrange=[-1,1], ystyle=9, thick=3, lin=2

  oangle = -cos(angles/180.d*!dpi)
  p11int = total((oangle[1:numang-1]-oangle[0:numang-2])*( (p11[1:numang-1]+p11[0:numang-2])/2.))
  print, 'Total(P11*dmu) over '+string(numang)+' angles = ', p11int


; print the linear depolarization ratio
  depol_unp =  (p11[numang-1] + (sqrt(0.5)-1.)*p12[numang-1] - sqrt(0.5)*p22[numang-1]) $
             / (p11[numang-1] + (sqrt(0.5)+1.)*p12[numang-1] + sqrt(0.5)*p22[numang-1]) 
  depol_lin =  (p11[numang-1] - p22[numang-1]) $
             / (p11[numang-1] + 2.*p12[numang-1] + p22[numang-1]) 
  depol_lin_ =  (p11[numang-1] - p22[numang-1]) $
              / (p11[numang-1] + p22[numang-1]) 
print, depol_unp
print, depol_lin
print, depol_lin_

device, /close

; open a file and write P11
  openw, lun, 'sulfate_p11.txt', /get
  for iang = 0, numang-1 do begin
   printf, lun, acos(mu[iang])/!dpi*180., p11[iang], format='(2f10.6)'
endfor
  free_lun, lun


end

