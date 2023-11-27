; Demonstrate the settling calculation for some initial distribution
; of mixing ratio and a nominal fall velocity.
; Colarco, February 2011


; Set up the system
  vfall = 0.01     ; fall velocity in m s-1
  grav  = 9.8      ; acceleration of gravity, m s-1
  loadct, 39

; Get an atmosphere
  nz = 55
  atmosphere, p, pe, delp, z, ze, delz, t, te, rhoa, nz=nz

; Define a profile of particle concentration in a gaussian
  pcmax = 10000.    ; maxmimum concentration, arbitrary unit
  z0  = 5000.       ; Initial height [m]
  sig = 2000.       ; width [km]
  pc0 = fltarr(nz)
  pc0 = pcmax/(2.*!pi*sig^2.) * exp(-((z-z0)^2.)/(2.*sig^2.))

; Change from concentration to mmr
  q0 = pc0/rhoa

  q_tld  = q0
  q_prc  = q0
  load0  = total(q0*delp/grav)
  nsteps = 1000
  dtime  = 1800.  ; time step in seconds
  time   = findgen(nsteps)*dtime
  load_tld = fltarr(nsteps)
  load_prc = fltarr(nsteps)

  for istep = 0, nsteps-1 do begin
;  Settling calculation Thomas Diehl's way
   q_tld[0] = q_tld[0] / (1.+dtime*vfall/delz[0])
   for iz = 1, nz-1 do begin
    q_tld[iz] = 1./(1.+dtime*vfall/delz[iz]) $
                 * (q_tld[iz] + dtime*vfall/delz[iz-1]*q_tld[iz-1])
   endfor
;  Return to pc
   load_tld[istep] = total(q_tld*delp/grav)
   pc_tld = q_tld * rhoa

;  Settling calculation Pete Colarco's way
   q_save = q_prc[0]
   q_prc[0] = q_prc[0] / (1.+dtime*vfall/delz[0])
   for iz = 1, nz-1 do begin
    pdog   = delp[iz]/grav
    pdogm1 = delp[iz-1]/grav
    q_before = q_prc[iz]
    q_prc[iz] = 1./(1.+dtime*vfall/delz[iz]) $
                 * (q_prc[iz] + (dtime*vfall/delz[iz-1]*q_save*pdogm1/pdog))
    q_save = q_before
   endfor
;  Return to pc
   load_prc[istep] = total(q_prc*delp/grav)
   pc_prc = q_prc * rhoa

   !P.multi=[0,1,2]
   plot, pc0, z/1000., yrange=[0,20], /nodata, $
    title='t='+string(istep*dtime)+' seconds', $
    xtitle='particle concentration [mass/volume]', $
    ytitle='altitude [km]'
   oplot, pc0, z/1000., thick=6
   oplot, pc_tld, z/1000., thick=6, color=84
   oplot, pc_prc, z/1000., thick=6, color=254

   plot, time, /nodata, $
    title = 'load (relative)', xtitle='time [sec]', yrange = [0,2], $
    xrange=[0,max(time)], ytitle='load relative to initial'
   oplot, time, make_array(nsteps,val=1.), thick=6
   oplot, time[0:istep], load_tld[0:istep]/load0, thick=6, color=84
   oplot, time[0:istep], load_prc[0:istep]/load0, thick=6, color=254

   wait, 0.1

   

  endfor

end
