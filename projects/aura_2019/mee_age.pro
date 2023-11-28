  brcoptics = '/home/colarco/sandbox/radiation/x/optics_BRC.v1_6.nc'
;brcoptics = '/home/colarco/sandbox/radiation_v2/pygeosmie/integ-brc_schill-raw.nc'
  bcoptics  = '/home/colarco/sandbox/radiation/x/optics_BC.v1_6.nc'
;bcoptics = '/home/colarco/sandbox/radiation_v2/pygeosmie/integ-bc_density-raw.nc'
  suoptics  = '/home/colarco/sandbox/radiation/x/optics_SU.v1_6.nc'
;suoptics = '/home/colarco/sandbox/radiation_v2/pygeosmie/integ-su_schill-raw.nc'

  brc = 1.
  bc  = .08

  fbrc = 0.5 ; initial fraction hydrophobic
  fbc  = 0.8 ; initial fraction hydrophobic
  ts = 4.63e-6 ; s-1 (lifetime = 2.5 days) for hydrophobic to hydrophilic

  set_plot, 'ps'
  filename = 'mee_age.bc=08.ps'
  device, file=filename, /color, /helvetica, font_size=14, $
   xsize=24, ysize=20
  !p.font=0


; Read the tables and reduce to 550 nm
  readoptics, brcoptics, reff, lambda, qext, qsca, bext_brc, bsca_brc, g, bbck, $
              rh, rmass, refreal, refimag
  bext_brc = reform(bext_brc[6,*,*])
  bsca_brc = reform(bsca_brc[6,*,*])
  readoptics, bcoptics, reff, lambda, qext, qsca, bext_bc, bsca_bc, g, bbck, $
              rh, rmass, refreal, refimag
  bext_bc = reform(bext_bc[6,*,*])
  bsca_bc = reform(bsca_bc[6,*,*])
  readoptics, suoptics, reff, lambda, qext, qsca, bext_su, bsca_su, g, bbck, $
              rh, rmass, refreal, refimag
  bext_su = reform(bext_su[6,*,*])
  bsca_su = reform(bsca_su[6,*,*])
 
; Dimension of calculation
  mee = fltarr(8,11,4) ; days/SU/RH
  zrh = [0,8,16,31]
  su  = findgen(11)*.05

  for i = 0, 7 do begin
   if(i eq 0) then begin
    brco = fbrc*brc
    brcl = (1.-fbrc)*brc
    bco  = fbc*bc
    bcl  = (1.-fbc)*bc
   endif
   for j = 0, 10 do begin
    for k = 0, 3 do begin
     tauext = brco*bext_brc[zrh[k],0]+brcl*bext_brc[zrh[k],1] + $
              bco*bext_bc[zrh[k],0]+bcl*bext_bc[zrh[k],1] + $
              su[j]*bext_su[zrh[k],0]
     tausca = brco*bsca_brc[zrh[k],0]+brcl*bsca_brc[zrh[k],1] + $
              bco*bsca_bc[zrh[k],0]+bcl*bsca_bc[zrh[k],1] + $
              su[j]*bsca_su[zrh[k],0]
     mee[i,j,k] = tauext / (brco+brcl+bco+bcl+su[j])/1000. ; m2 kg-1
    endfor  
   endfor
   for l = 0, 191 do begin
    dbrc = brco*(1.-exp(-ts*450.))
    brco = brco-dbrc
    brcl = brcl+dbrc
    dbc = bco*(1.-exp(-ts*450.))
    bco = bco-dbc
    bcl = bcl+dbc
   endfor
  endfor

  levels = 3.+findgen(10)
  colors = indgen(10)*25
  x = findgen(8)
  y = su
  col_ = intarr(4)
;  for i = 0, 3 do begin
;   a = where(levels lt mee_[0,i])
;   col_[i] = colors(max(a))
;  endfor

  loadct, 38
  contour, mee[*,*,0], x, y, levels=levels, c_color=colors, /fill, $
   xrange=[0,7], xtitle='age [days]', xstyle=1, $
   yrange=[0,0.5], ytitle = 'SU fraction', ystyle=1, $
   position=[.1,.65,.45,.95], title='RH = 0%'

  contour, mee[*,*,1], x, y, levels=levels, c_color=colors, /fill, $
   xrange=[0,7], xtitle='age [days]', xstyle=1, $
   yrange=[0,0.5], ytitle = 'SU fraction', ystyle=1, $
   position=[.6,.65,.95,.95], title='RH = 40%', /noerase

  contour, mee[*,*,2], x, y, levels=levels, c_color=colors, /fill, $
   xrange=[0,7], xtitle='age [days]', xstyle=1, $
   yrange=[0,0.5], ytitle = 'SU fraction', ystyle=1, $
   position=[.1,.25,.45,.55], title='RH = 80%', /noerase

  contour, mee[*,*,3], x, y, levels=levels, c_color=colors, /fill, $
   xrange=[0,7], xtitle='age [days]', xstyle=1, $
   yrange=[0,0.5], ytitle = 'SU fraction', ystyle=1, $
   position=[.6,.25,.95,.55], title='RH = 95%', /noerase

  makekey, .15, .1, .7, .05, 0., -0.035, $
   label = string(levels,format='(i2)'), colors=colors, align=0
  xyouts, .5, .16, 'Mass Extinction Efficiency [m!E2!N kg!E-1!N, 550 nm]',$
   /normal, align=.5

  device, /close


end
