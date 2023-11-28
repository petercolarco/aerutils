; Plot the size bins used in the ICAP models

  names = ['GEOS','MODELe', 'IFS','SILAM','MONARCH','MASINGER',$
           'UM','NAAPS','AM4']
  nbins  = [8,8,3,4,8,10,2,1,5]
  colors = [48,176,48,48,208,48,48,48,254]

  set_plot, 'ps'
  device, file='dust_ssa.ps', /color, /helvetica, font_size=18, $
   xsize=24, ysize=13.5, xoff=.5, yoff=.5
  !p.font=0

  loadct, 0
  plot, indgen(10), /nodata, $
   xrange=[0.1,40], /xlog, xstyle=9, xtitle='diameter [!Mm!Nm]', xthick=3, $
   yrange=[0.6,1], ystyle=9, ytitle='SSA!D550 nm!N', ythick=3, yminor=5, $
   position=[.1,.12,.85,.92]

  loadct, 39

  plots, [10,25], 10^(alog10(3.)), thick=18, color=48
  plots, [10,25], 10^(alog10(3.)-.1), thick=18, color=254
  plots, [10,25], 10^(alog10(3.)-.2), thick=18, color=208
  plots, [10,25], 10^(alog10(3.)-.3), thick=18, color=176
  plots, [10,25], 10^(alog10(3.)+.1), thick=1, color=0
  plots, 16, 10^(alog10(3.)-.4), psym=sym(4), symsize=1.5

  xyouts, 30, 10^(alog10(3.)+.07), 'CARMA'
  xyouts, 30, 10^(alog10(3.)-.03), 'GEOS'
  xyouts, 30, 10^(alog10(3.)-.13), 'AM4'
  xyouts, 30, 10^(alog10(3.)-.23), 'MONARCH'
  xyouts, 30, 10^(alog10(3.)-.33), 'ModelE'
  xyouts, 30, 10^(alog10(3.)-.43), 'NAAPS'


; overplot the CARMA optics
  filename = '/home/colarco/sandbox/radiation/x/carma_optics_DU.v15.nbin=44.nc'
  readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  ilam = 5
  nbin = 44
  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmin = 0.05d-6
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, r, rup, dr, rlow
;  oplot, 2.*r*1e6, bsca[ilam,0,*]/bext[ilam,0,*]


; GEOS
  imod = 0
  y = 8-imod
  xmin=[0.2,2,3.6,6,12]
  xmax=20
  mee =[2.016,0.644,0.334,0.167,0.084]
  ssa =[0.964,0.918,0.886,0.833,0.767]

; 8 bin
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
; I'm not sure the origin of these two lines; not consistent
; with other calculations I'm doing
;  mee =[4.466,5.155,2.948,1.273,0.644,0.334,0.167,0.084]
;  ssa =[0.984,0.984,0.970,0.940,0.918,0.886,0.833,0.767]
  mee = [3.018,4.262,3.013,1.229,0.615,0.320,0.165,0.084]
  ssa = [0.983,0.985,0.977,0.947,0.918,0.878,0.824,0.758]

  nbin=nbins[imod]
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], ssa[ibin], thick=18, color=colors[imod]
   plots,[xmin[ibin+1],xmin[ibin+1]], [ssa[ibin],ssa[ibin+1]], thick=18, color=colors[imod]
  endfor
  plots, [xmin[nbin-1],xmax], ssa[nbin-1], thick=18, color=colors[imod]

; MONARCH
  imod = 4
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,3.6,6,12]
  xmax=20
  mee =[1.90,3.24,2.93,1.55,0.73,0.41,0.22,0.11]
  ssa =[0.98,0.99,0.99,0.97,0.95,0.93,0.90,0.85]
  nbin=nbins[imod]
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], ssa[ibin], thick=18, color=colors[imod]
   plots,[xmin[ibin+1],xmin[ibin+1]], [ssa[ibin],ssa[ibin+1]], thick=18, color=colors[imod]
  endfor
  plots, [xmin[nbin-1],xmax], ssa[nbin-1], thick=18, color=colors[imod]

; AM4
  imod = 8
  y = 8-imod
  xmin=[0.2,2,3.6,6,12]
  xmax=20
  mee =[1.86,0.54,0.28,0.15,0.08]
  ssa =[0.97,0.91,0.86,0.79,0.7]
  nbin=nbins[imod]
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], ssa[ibin], thick=18, color=colors[imod]
   plots,[xmin[ibin+1],xmin[ibin+1]], [ssa[ibin],ssa[ibin+1]], thick=18, color=colors[imod]
  endfor
  plots, [xmin[nbin-1],xmax], ssa[nbin-1], thick=18, color=colors[imod]

; NAAPS
  imod = 7
  y = 8-imod
  mee = 0.59
  ssa = 0.88
;  plots, 5, ssa, psym=sym(4), color=0, symsize=3
  loadct, 0
  plots, [.4,10], ssa, thick=18, color=100
  loadct, 39

; ModelE
  imod = 1
  y = 8-imod
  xmin=[0.2,0.36,0.6,1.2,2,4,8,16]
  xmax=32
  mee =[ 4.41328223, 4.50481353, 2.91262658, 1.37943336, $
         0.64098967, 0.30904944, 0.1748042,  0.10046726]
  ssa =[ 0.96982508, 0.97209664, 0.95649694, 0.92296147, $
         0.88139104, 0.82315414, 0.75583888, 0.69754465]
  nbin=nbins[imod]
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], ssa[ibin], thick=18, color=colors[imod]
   plots,[xmin[ibin+1],xmin[ibin+1]], [ssa[ibin],ssa[ibin+1]], thick=18, color=colors[imod]
  endfor
  plots, [xmin[nbin-1],xmax], ssa[nbin-1], thick=18, color=colors[imod]


; IFS
  imod = 2
  y = 8-imod
  xmin=[.06,1.1,1.8]
  xmax=40
  mee = [2.5,0.95,0.4]
  ssa = [0.96,0.90,0.83]
  nbin=nbins[imod]
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], ssa[ibin], thick=18, color=84, noclip=0
   plots,[xmin[ibin+1],xmin[ibin+1]], [ssa[ibin],ssa[ibin+1]], thick=18, color=84
  endfor
  plots, [xmin[nbin-1],xmax], ssa[nbin-1], thick=18, color=84



; SILAM
  imod = 3
  y = 8-imod
  xmin=[.0103,1,2.5,10]
  xmax=30
  nbin=nbins[imod]
  mee = [2.497,0.827,0.240,0.067]
  ssa = [0.968,0.893,0.778,0.700]
  loadct, 0
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], ssa[ibin], thick=18, color=160, noclip=0
   plots,[xmin[ibin+1],xmin[ibin+1]], [ssa[ibin],ssa[ibin+1]], thick=18, color=160
  endfor
  plots, [xmin[nbin-1],xmax], ssa[nbin-1], thick=18, color=160

; UM
  imod = 6
  y = 8-imod
  xmin=[0.2,4]
  xmax=20
  nbin=nbins[imod]
  mee = [0.702,0.141]
  ssa = [0.962,0.871]
  loadct, 0
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], ssa[ibin], thick=18, color=160, noclip=0, lin=2
   plots,[xmin[ibin+1],xmin[ibin+1]], [ssa[ibin],ssa[ibin+1]], thick=18, color=160, lin=2
  endfor
  plots, [xmin[nbin-1],xmax], ssa[nbin-1], thick=18, color=160, lin=2

device, /close
stop

; MASINGAR
  imod = 5
  y = 8-imod
  xmin=[0.2,0.32,0.5,0.8,1.3,2,3.2,5,8,13]
  xmax=20
  nbin=nbins[imod]
  colors=50+findgen(nbin)*200/(nbin-1.)
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], y, thick=48, color=colors[ibin]
  endfor
  plots, [xmin[nbin-1],xmax], y, thick=48, color=colors[nbin-1]

; UM
  imod = 6
  y = 8-imod
  xmin=[0.4,4]
  xmax=20
  nbin=nbins[imod]
  colors=50+findgen(nbin)*200/(nbin-1.)
  for ibin = 0, nbin-2 do begin
   plots,[xmin[ibin],xmin[ibin+1]], y, thick=48, color=colors[ibin]
  endfor
  plots, [xmin[nbin-1],xmax], y, thick=48, color=colors[nbin-1]

  loadct, 0
  for imod = 0, n_elements(names)-1 do begin
   xyouts, 0.0045, 7.9-imod, '!4'+names[imod], align=1
   xyouts, 0.005, 7.9-imod, 'n = '+string(nbins[imod],format='(i2)')+'!3', chars=.6
  endfor

; Plot the Kok PSD at emission over this
; Create a series of size bins
  nbin = 44
  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmin = 0.05d-6
  carmabins, nbin, rmrat, rmin, 2650., $
             rmass, rmassup, r, rup, dr, rlow
  kok_psd, r, rlow, rup, dv, dn

  dvdr = dv/dr
  dndr = dn/dr

; normalize
  dv = dvdr*dr
  dv = dv/total(dv)
  dvdr = dv/dr

  dndlnd = dndr*r
  dvdlnd = dvdr*r
  d  = 2.*r*1e6
  dd = 2.*dr*1e6

  dvdlnd = dvdlnd/max(dvdlnd)

  axis, yaxis=1, yrange=[.0005,2], /ylog, ystyle=9, /save
  xyouts, .95, .52, 'Normalized Volume Size Distribution dV/d(ln d) [Kok 2011]!C'+$
                    'Normalized AOD Distribution d!Mt!N/d(ln d)', $
                     chars=.8, align=.5, orient=270, /normal
  oplot, d, dvdlnd, thick=6

; Get the optical table from CARMA run
  filename = '/home/colarco/sandbox/radiation/x/carma_optics_DU.v15.nbin=44.nc'
  readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
              rh, rmass, refreal, refimag
  ilam = 5

; normalize to the mass distribution
  y = dv*bext[ilam,0,*]*r/dr
  y = y/max(y)

  oplot, 2.*r*1e6, y, thick=6, lin=2
  device, /close

end
