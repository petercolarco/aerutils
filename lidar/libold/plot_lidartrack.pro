  read_lidartrack, 'dust', hyai, hybi, time, date, lon, lat, mmr_du, ssa, tau_du, backscat
  read_lidartrack, 'sulfate', hyai, hybi, time, date, lon, lat, mmr_su, ssa, tau_su, backscat
  read_lidartrack, 'ocarbon', hyai, hybi, time, date, lon, lat, mmr_oc, ssa, tau_oc, backscat
  read_lidartrack, 'bcarbon', hyai, hybi, time, date, lon, lat, mmr_bc, ssa, tau_bc, backscat
  read_lidartrack, 'seasalt', hyai, hybi, time, date, lon, lat, mmr_ss, ssa, tau_ss, backscat
  read_lidartrack_met, hyai, hybi, lon, lat, time, date, $
                      surfp, pblh, phis, airdens, h, hghte, relhum, t, delp

; reduce fields to column integrated amounts
  gravit = 9.8  ; m / s^2
  taucol_du = reform(sum(tau_du,0))
  masscol_du = reform(sum(mmr_du*delp/gravit,0))

  taucol_su = reform(sum(tau_su,0))
  masscol_su = reform(sum(mmr_su*delp/gravit,0))

  taucol_ss = reform(sum(tau_ss,0))
  masscol_ss = reform(sum(mmr_ss*delp/gravit,0))

  taucol_bc = reform(sum(tau_bc,0))
  masscol_bc = reform(sum(mmr_bc*delp/gravit,0))

  taucol_oc = reform(sum(tau_oc,0))
  masscol_oc = reform(sum(mmr_oc*delp/gravit,0))

; Now get to mass extinction efficiency; note conversion to m^2/g
  mee_du = taucol_du / masscol_du / 1000.
  mee_su = taucol_su / masscol_su / 1000.
  mee_ss = taucol_ss / masscol_ss / 1000.
  mee_oc = taucol_oc / masscol_oc / 1000.
  mee_bc = taucol_bc / masscol_bc / 1000.

  mee_cc = (taucol_bc+taucol_oc) / (masscol_bc+masscol_oc) / 1000.


  set_plot, 'ps'
  device, file='mee_plot.ps', /helvetica, font_size=14, /color
  !p.font=0

  a = where(date/100 eq 20061004L)
  a = where(date eq 2006100400L)
  map_set, /continents
  plots, lon[a], lat[a], thick=3

  loadct, 39
  plot, mee_su[a], thick=6, /nodata, $
   ytitle = 'Column MEE [m^2 / g]', xtitle = '...time...', $
   title = 'Column Integrated'
  oplot, mee_su[a], thick=6, color=176
  oplot, mee_ss[a], thick=6, color=90
  oplot, mee_cc[a], thick=6, color=254
  oplot, mee_du[a], thick=6, color=208

  taucol_su_ = reform(sum(tau_su[0,*],0))
  masscol_su_ = reform(sum(mmr_su[0,*]*delp[0,*]/gravit,0))
  mee_su_ = taucol_su_ / masscol_su_ / 1000.

  taucol_du_ = reform(sum(tau_du[0,*],0))
  masscol_du_ = reform(sum(mmr_du[0,*]*delp[0,*]/gravit,0))
  mee_du_ = taucol_du_ / masscol_du_ / 1000.

  taucol_ss_ = reform(sum(tau_ss[0,*],0))
  masscol_ss_ = reform(sum(mmr_ss[0,*]*delp[0,*]/gravit,0))
  mee_ss_ = taucol_ss_ / masscol_ss_ / 1000.

  taucol_bc_ = reform(sum(tau_bc[0,*],0))
  masscol_bc_ = reform(sum(mmr_bc[0,*]*delp[0,*]/gravit,0))
  mee_bc_ = taucol_bc_ / masscol_bc_ / 1000.

  taucol_oc_ = reform(sum(tau_oc[0,*],0))
  masscol_oc_ = reform(sum(mmr_oc[0,*]*delp[0,*]/gravit,0))
  mee_oc_ = taucol_oc_ / masscol_oc_ / 1000.

  mee_cc_ = (taucol_bc_+taucol_oc_) / (masscol_bc_+masscol_oc_) / 1000.
  plot, mee_su_[a], thick=6, /nodata, $
   ytitle = 'Surface MEE [m^2 / g]', xtitle = '...time...', $
   title = 'Surface Level'
  oplot, mee_su_[a], thick=6, color=176
  oplot, mee_ss_[a], thick=6, color=90
  oplot, mee_cc_[a], thick=6, color=254
  oplot, mee_du_[a], thick=6, color=208


  plot, relhum[0,a], mee_su_[a], /nodata, thick=6, $
   ytitle = 'Surface MEE [m^2 / g]', xtitle = 'RH [%]', $
   title = 'Surface RH dependence of MEE'
  usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=176
  plots, relhum[0,a], mee_su_[a], psym=8

  usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=254
  plots, relhum[0,a], mee_cc_[a], psym=8

  usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=90
  plots, relhum[0,a], mee_ss_[a], psym=8

  usersym, 0.5*[-1,0,1,0,-1], 0.5*[0,-1,0,1,0], /fill, color=208
  plots, relhum[0,a], mee_du_[a], psym=8


  device, /close


;  taucol_su = reform(sum(tau_su[20:30,*],0))
;  masscol_su = reform(sum(mmr_su[20:30,*]*delp[20:30,*]/gravit,0))
;  mee_su = taucol_su / masscol_su / 1000.
  plot, mee_su[a]

end
