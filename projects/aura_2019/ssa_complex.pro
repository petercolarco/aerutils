  strout = 't_p25day'

  brcoptics = ['/home/colarco/sandbox/radiation/x/optics_BRC.v1_6.nc', $
               '/home/colarco/sandbox/radiation_v2/pygeosmie/x/integ-brc_schill-raw.nc', $
               '/home/colarco/sandbox/radiation_v2/pygeosmie/integ-brc_oracles-raw.nc', $
               '/home/colarco/sandbox/radiation_v2/pygeosmie/integ-brc_oracles_bcgf-raw.nc']

  brctag = ['base','schill','oracles','oracles_bcgf']

  ssatraj = fltarr(8,4,4)

  for iii = 0, 3 do begin

  bcoptics  = '/home/colarco/sandbox/radiation/x/optics_BC.v1_6.nc'

  suoptics  = '/home/colarco/sandbox/radiation/x/optics_SU.v1_6.nc'

  nioptics  = '/home/colarco/sandbox/radiation/x/optics_NI.v2_5.nc'


  brc = 15.
  bc  = 1.
  su  = 2.

  case strout of
   't_inf': tsd_ = 4.63e-16
   't_25day': tsd_ = 4.63e-6
   't_p25day': tsd_ = 4.63e-7
  endcase

  fbrc = 0.5 ; initial fraction hydrophobic
  fbc  = 0.8 ; initial fraction hydrophobic
  ts = 4.63e-6 ; s-1 (lifetime = 2.5 days) for hydrophobic to hydrophilic
  tsd = tsd_ ; s-1 (lifetime = 2.5 days) for destruction of OA
  tsd0 = 4

  set_plot, 'ps'
  filename = 'ssa_complex.'+brctag[iii]+'.'+strout+'.ps'
  device, file=filename, /color, /helvetica, font_size=14, $
   xsize=24, ysize=20
  !p.font=0


; Read the tables and reduce to 550 nm
  readoptics, brcoptics[iii], reff, lambda, qext, qsca, bext_brc, bsca_brc, g, bbck, $
              rh, rmass, refreal, refimag
if(iii eq 1) then stop
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
  readoptics, nioptics, reff, lambda, qext, qsca, bext_ni, bsca_ni, g, bbck, $
              rh, rmass, refreal, refimag
  bext_ni = reform(bext_ni[6,*,*])
  bsca_ni = reform(bsca_ni[6,*,*])
 
 
; Dimension of calculation
  ssa = fltarr(8,11,4) ; days/SU/RH
  zrh = [0,8,16,31]
  ni  = findgen(11)*.5
;ni[*] = 0.
; ratio of BRC/BC
  rat = fltarr(8)
  for i = 0, 7 do begin
   if(i eq 0) then begin
    brco = fbrc*brc
    brcl = (1.-fbrc)*brc
    bco  = fbc*bc
    bcl  = (1.-fbc)*bc
   endif
   rat[i] = (brco+brcl)/(bco+bcl)
   for j = 0, 10 do begin
    for k = 0, 3 do begin
     tauext = brco*bext_brc[zrh[k],0]+brcl*bext_brc[zrh[k],1] + $
              bco*bext_bc[zrh[k],0]+bcl*bext_bc[zrh[k],1] + $
              su*bext_su[zrh[k],0] + $
              ni[j]*bext_ni[zrh[k],0]
     tausca = brco*bsca_brc[zrh[k],0]+brcl*bsca_brc[zrh[k],1] + $
              bco*bsca_bc[zrh[k],0]+bcl*bsca_bc[zrh[k],1] + $
              su*bsca_su[zrh[k],0] + $
              ni[j]*bsca_ni[zrh[k],0]
     ssa[i,j,k] = tausca/tauext
    endfor  
   endfor
   for l = 0, 191 do begin
    dbrc = brco*(1.-exp(-ts*450.))
    brco = brco-dbrc
    brcl = brcl+dbrc
;   remove OA after i >= tsd0
    if(i ge tsd0) then begin
     brco = brco*exp(-tsd*450.)
     brcl = brcl*exp(-tsd*450.)
    endif
    dbc = bco*(1.-exp(-ts*450.))
    bco = bco-dbc
    bcl = bcl+dbc
   endfor
  endfor

  levels = .8 + findgen(10)*.02
  colors = indgen(10)*25
  x = findgen(8)
  y = ni
  col_ = intarr(4)
;  for i = 0, 3 do begin
;   a = where(levels lt ssa_[0,i])
;   col_[i] = colors(max(a))
;  endfor

  loadct, 38
  contour, ssa[*,*,0], x, y, levels=levels, c_color=colors, /fill, $
   xrange=[0,7], xtitle='age [days]', xstyle=1, $
   yrange=[0,5], ytitle = 'NI:BC ratio', ystyle=1, $
   position=[.1,.65,.45,.95], title='RH = 0%'

  contour, ssa[*,*,1], x, y, levels=levels, c_color=colors, /fill, $
   xrange=[0,7], xtitle='age [days]', xstyle=1, $
   yrange=[0,5], ytitle = 'NI:BC ratio', ystyle=1, $
   position=[.6,.65,.95,.95], title='RH = 40%', /noerase

  contour, ssa[*,*,2], x, y, levels=levels, c_color=colors, /fill, $
   xrange=[0,7], xtitle='age [days]', xstyle=1, $
   yrange=[0,5], ytitle = 'NI:BC ratio', ystyle=1, $
   position=[.1,.25,.45,.55], title='RH = 80%', /noerase

  contour, ssa[*,*,3], x, y, levels=levels, c_color=colors, /fill, $
   xrange=[0,7], xtitle='age [days]', xstyle=1, $
   yrange=[0,5], ytitle = 'NI:BC ratio', ystyle=1, $
   position=[.6,.25,.95,.55], title='RH = 95%', /noerase

  makekey, .15, .1, .7, .05, 0., -0.035, $
   label = string(levels,format='(f4.2)'), colors=colors, align=0
  xyouts, .5, .16, 'Single Scattering Albedo [550 nm]',$
   /normal, align=.5

  device, /close

  niind = [6,6,6,6,6,0,0,0]
  for jjj = 0, 7 do begin
   ssatraj[jjj,*,iii] = ssa[jjj,niind[jjj],*]
  endfor
  endfor

  case strout of
   't_inf': color = 0
   't_25day': color=254
   't_p25day': color=146
  endcase
  device, file='oabc_ratio.'+strout+'.ps', /color, /helvetica, font_size=24
  !p.font=0
  loadct, 39
  plot, indgen(8), rat, /nodata, xtitle='age [days]', ytitle='OA:BC', $
   yrange=[4,16]
  oplot, indgen(8), rat, thick=12, color=color
  device, /close

  device, file='ssa_complex.traj.'+strout+'.ps', /color, /helvetica, font_size=24
  !p.font=0
  loadct, 39
  plot, indgen(8), rat, /nodata, xtitle='age [days]', ytitle='SSA [550 nm]', $
   yrange=[0.8,1]
  oplot, indgen(8), ssatraj[*,1,0], thick=12, color=0
  oplot, indgen(8), ssatraj[*,1,1], thick=12, color=254
  oplot, indgen(8), ssatraj[*,1,2], thick=12, color=146
  oplot, indgen(8), ssatraj[*,1,3], thick=12, color=80
  oplot, indgen(8), ssatraj[*,0,0], thick=1, color=0
  oplot, indgen(8), ssatraj[*,0,1], thick=1, color=254
  oplot, indgen(8), ssatraj[*,0,2], thick=1, color=146
  oplot, indgen(8), ssatraj[*,0,3], thick=1, color=80
  oplot, indgen(8), ssatraj[*,2,0], thick=1, color=0, lin=2
  oplot, indgen(8), ssatraj[*,2,1], thick=1, color=254, lin=2
  oplot, indgen(8), ssatraj[*,2,2], thick=1, color=146, lin=2
  oplot, indgen(8), ssatraj[*,2,3], thick=1, color=80, lin=2
  device, /close


end
