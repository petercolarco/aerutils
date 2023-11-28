;goto, jump
; Get the pressures

  gexpid = ['c180F_pI20p1-acma_spher','c180F_pI20p1-acma_gocart']
  gfilenames = '/misc/prc18/colarco/'+gexpid+'/'+gexpid+'.tavg3d_aer_v.20080716_0900z.nc4'
  color     = [254, 208]
  lin       = [  0,   0]


  nf = n_elements(gfilenames)

; Get Kok's PSD from Nature 2017, Figure 2b
  read_psd_load, diam, dmdlnd, dmdlndm2, dmdlndp2


  for i = 0, nf-1 do begin

  filename = gfilenames[i]

  nc4readvar, filename, 'delp', delp, lon=lon, lat=lat
  nx = n_elements(lon)
  if(nx eq 144) then grid = 'b'
  if(nx eq 288) then grid = 'c'
  if(nx eq 576) then grid = 'd'

; Get the aerosols
  nc4readvar, filename, 'du0', dus, /template

; Do the vertical integration
  sz = size(dus)
  nbin = sz[4]
  area, lon, lat, nx, ny, dx, dy, area, grid=grid
  du = fltarr(nx,ny,nbin)
  for ibin = 0, nbin-1 do begin
   du[*,*,ibin] = total(dus[*,*,*,ibin]*delp,3)/9.81
  endfor

; do a size distribution
  rmrat = (15.d/.05d)^(3.d/(nbin-1))
  rmin = 0.05
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, r, rup, dr, rlow

  if(i eq 0) then begin
   set_plot, 'ps'
   device, file='global_dust_psd.simple.ps', /color, /helvetica, font_size=14
   !p.font=0

   loadct, 0
   plot, r, du[0,0,*]*r/dr, $
    /xlog, /ylog, /nodata, xrange=[.2,20.], yrange=[1e-2,100], charsize=1.2, $
    xtitle='diameter [um]', ytitle='dMdlnr [Tg]', xstyle=1, ystyle=1

  loadct, 39
   x = [diam,reverse(diam),diam[0]]
   y = [dmdlndp2,reverse(dmdlndm2),dmdlndp2[0]]
   polyfill, x, y, color=193, noclip=0
   oplot, diam, dmdlnd, thick=8, color=0, lin=2


  endif

  loadct, 39
  rlow = [.1,1,1.6,3,6]
  rup  = [1,1.6,3,6,10]
  fac  = total(area)/1.e9
  r    = [.73,1.4,2.4,4.5,8.]
  dr   = rup-rlow
  dufac = fltarr(5)
  for ibin = 0, nbin-1 do begin
   dufac[ibin] = fac*aave(du[*,*,ibin],area)*r[ibin]/dr[ibin]
;   plots, [rlow[ibin],rup[ibin]]*2., $
;          [fac*aave(du[*,*,ibin],area)*r[ibin]/dr[ibin], $
;           fac*aave(du[*,*,ibin],area)*r[ibin]/dr[ibin]], $
;          thick=12, color=color[i], lin=lin[i], noclip=0
;   if(ibin lt nbin-1) then $
;    plots, rup[ibin]*2., fac*[aave(du[*,*,ibin],area)*r[ibin]/dr[ibin],$
;                              aave(du[*,*,ibin+1],area)*r[ibin+1]/dr[ibin+1]], $
;                         thick=12, color=color[i], lin=lin[i], noclip=0
  endfor

  oplot, r*2., dufac, thick=12, color=color[i], lin=lin[i]

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
  oplot, 2.*r, fac*2.e-4*dmkok*r/dr, thick=10, color=84, lin=0


  device, /close

end
