  read_glastrack, 'dust', hyai, hybi, time, date, lon, lat, mmr, ssa, tau, backscateff
  read_glastrack_met, hyai, hybi, lon, lat, time, date, $
                      surfp, pblh, phis, airdens, h, hghte, relhum, t, delp

; backscat is the backscatter efficiency [m2 kg-1 sr-1]
; I think what Judd wants is the actually backscatter [m-1 sr-1]
; so multiply by the mass concentration (mmr*airdens)
  massconc = mmr*airdens
  backscat = backscateff * massconc

; To get back to extinction, tau / dust kg m-2 in layer
  gravit = 9.8  ; m / s^2

  a = where(tau gt .01)
  ext = tau[a] / (mmr[a] * delp[a]/gravit)

  ext2back = ext / backscat[a]

end
