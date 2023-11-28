;goto, jump
; Get the pressures

  expid = ['c48F_asdI10-dust22', $
           'c48F_asdI10-L132-dust22', $
           'c90F_asdI10-dust22', $
;           'c48F_asdI10-dust22d', $
           'c48F_asdI10-dust11', $
           'c48F_asdI10-dust44']

  filenames = '/misc/prc18/colarco/'+expid+'/tavg3d_carma_v/'+expid+'.tavg3d_carma_v.monthly.clim.ANN.nc4'

  gexpid = ['c48F_asdI10a1-acma','c48F_asdI10a1-kok','c48F_asdI10a1-nomaring']
  gfilenames = '/misc/prc18/colarco/'+gexpid+'/inst3d_aer_v/'+gexpid+'.inst3d_aer_v.monthly.clim.ANN.nc4'


  nf = n_elements(filenames)

; Get Kok's PSD from Nature 2017, Figure 2b
  read_psd_load, diam, dmdlnd, dmdlndm2, dmdlndp2


  for i = 0, nf-1 do begin

  filename = filenames[i]

  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat
  nx = n_elements(lon)
  if(nx eq 144) then grid = 'b'
  if(nx eq 288) then grid = 'c'
  if(nx eq 576) then grid = 'd'

; Get the aerosols
  nc4readvar, filename, 'du0', dus, /template
;  nc4readvar, filename, 'ss0', sss, /template
;  nc4readvar, filename, 'su0', sus, /template
;  nc4readvar, filename, 'sm0', sms, /template
  nc4readvar, filename, 'delp', delp

; Do the vertical integration
  sz = size(dus)
  nbin = sz[4]
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  du = fltarr(nx,ny,nbin)
;  ss = fltarr(nx,ny,nbin)
;  su = fltarr(nx,ny,nbin)
;  sm = fltarr(nx,ny,nbin)
  for ibin = 0, nbin-1 do begin
   du[*,*,ibin] = total(dus[*,*,*,ibin]*delp,3)/9.81
;   ss[*,*,ibin] = total(sss[*,*,*,ibin]*delp,3)/9.81
;   su[*,*,ibin] = total(sus[*,*,*,ibin]*delp,3)/9.81
;   sm[*,*,ibin] = total(sms[*,*,*,ibin]*delp,3)/9.81
  endfor

; do a size distribution
  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmin = 0.05
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, r, rup, dr, rlow
; sulfate
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.) * 1e6
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, rs, rups, drs, rlows


  if(i eq 0) then begin
   set_plot, 'ps'
   device, file='global_dust_psd.ps', /color, /helvetica, font_size=14
   !p.font=0

   loadct, 39
   plot, r, du[0,0,*]*r/dr, $
    /xlog, /ylog, /nodata, xrange=[.2,20.], yrange=[1e-2,100], charsize=1.2, $
    xtitle='diameter [um]', ytitle='dMdlnr [Tg]', xstyle=1, ystyle=1

   x = [diam,reverse(diam),diam[0]]
   y = [dmdlndp2,reverse(dmdlndm2),dmdlndp2[0]]
   polyfill, x, y, color=193, noclip=0
   oplot, diam, dmdlnd, thick=8, color=0, lin=2


  endif

  fac = total(area)/1.e9

  oplot, 2.*r, fac*aave(du,area)*r/dr, thick=6, color=208, lin=i
;  oplot, 2.*r, fac*aave(ss,area)*r/dr, thick=6, color=84, lin=i

  endfor

  nbin = 22
  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmin = 0.05
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, r, rup, dr, rlow
  dmkok = [ 1.44426e-06, 8.10457e-06, 2.30573e-05, 6.21020e-05, $
            0.000158263, 0.000381888, 0.000875892, 0.00189694, $
            0.00390636,  0.00764786,  0.0142532,   0.0253157, $
            0.0429886,   0.0692165,   0.105703,    0.150420, $
            0.191700,    0.200044,    0.139066,    0.0434336, $
            0.00288956,  8.75048e-06]
  oplot, 2.*r, fac*2.e-4*dmkok*r/dr, thick=8, color=84, lin=0


; Now get the GOCART results from an experiment
  for i = 0, n_elements(gexpid)-1 do begin

  gocartfile = gfilenames[i]
  nc4readvar, gocartfile, 'du0', dus, lon=lon, lat=lat, /template
  nc4readvar, filename, 'delp', delp
  nx = n_elements(lon)
  if(nx eq 144) then grid = 'b'
  if(nx eq 288) then grid = 'c'
  if(nx eq 576) then grid = 'd'
  sz = size(dus)
  nbin = sz[4]
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  du = fltarr(nx,ny,nbin)
  for ibin = 0, nbin-1 do begin
   du[*,*,ibin] = total(dus[*,*,*,ibin]*delp,3)/9.81
  endfor
  rlow = [.1,1,1.6,3,6]
  rup  = [1,1.6,3,6,10]
  fac  = total(area)/1.e9
  r    = [.73,1.4,2.4,4.5,8.]
  dr   = rup-rlow
  for ibin = 0, nbin-1 do begin
   plots, [rlow[ibin],rup[ibin]]*2., $
          [fac*aave(du[*,*,ibin],area)*r[ibin]/dr[ibin], $
           fac*aave(du[*,*,ibin],area)*r[ibin]/dr[ibin]], $
          thick=8, color=254, lin=i
   if(ibin lt nbin-1) then $
    plots, rup[ibin]*2., fac*[aave(du[*,*,ibin],area)*r[ibin]/dr[ibin],$
                              aave(du[*,*,ibin+1],area)*r[ibin+1]/dr[ibin+1]], $
                         thick=8, color=254, lin=i
  endfor

  endfor

  device, /close

end
