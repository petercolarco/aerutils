; Colarco
; Find the frequency of sample monthly means exceeding some absolute
; and relative difference from the full swath monthly mean for our
; selected regions

  pro frequency_caliop, res

  regtitle = ['South America', 'Southern Africa', 'African Dust', 'Nile Valley', $
              'Indogangetic Plain', 'China', 'Southeast Asia', 'Asian Outflow']
  ymax   = [1,.6,.8,.8,.8,1,.8,.5]
  regstr = ['sam','saf','naf','nrv','igp','chn','sea','npac']
  lon0 = [-75,-15,-30,30,75,100,95,135]
  lon1 = [-45,35,-15,36,95,125,110,165]
  lat0 = [-20,-20,10,22,20,25,10,30]
  lat1 = [0,0,30,32,30,42,25,55]
  nreg = n_elements(lon0)

  yyyy = strpad(indgen(9)+2003,1000L)
;  yyyy = ['2010']
  ny   = n_elements(yyyy)
  mm   = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nm   = 12


  samples = [' ','caliop1', 'caliop2', 'caliop3', 'caliop4','misr1','misr2','misr3','misr4','supermisr']
  nsam = n_elements(samples)

  reg = fltarr(ny,nm,nreg,2,nsam)

  for isam = 0, nsam-1 do begin
print, isam
   for iy = 0, ny-1 do begin
   for im = 0, nm-1 do begin

    if(isam eq 0) then begin
     read_monthly, 'MYD04', samples[isam], yyyy[iy], mm[im], aotsat, lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, res=res
     reg[iy,im,*,0,isam] = reg_aot
     reg[iy,im,*,1,isam] = reg_aot
    endif else begin
;    Pick only where sample visits
;     read_monthly, 'MYD04', samples[isam], yyyy[iy], mm[im], aotsat, lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, /exclude, res=res
;     reg[iy,im,*,0,isam] = reg_aot
     read_monthly, 'MYD04', samples[isam], yyyy[iy], mm[im], aotsat, lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, /exclude, /inverse, res=res
     reg[iy,im,*,1,isam] = reg_aot
    endelse

   endfor
   endfor

  endfor

; Multi-year
  if(ny eq 1) then begin
   ystr = yyyy[0]
  endif else begin
   ystr = yyyy[0]+'_'+yyyy[ny-1]
  endelse

; Absolute difference
  thresh = [0.01, 0.05, 0.1, 0.2]
  nt = n_elements(thresh)
  absv = fltarr(nsam,nreg,nt)
  for isam = 1, nsam-1 do begin
   for ireg = 0, nreg-1 do begin
    diff = (reg[*,*,ireg,1,isam] - reg[*,*,ireg,0,0])
    for it = 0, nt-1 do begin
     a = where(abs(diff) gt thresh[it])
     if(a[0] ne -1) then $
      absv[isam,ireg,it] = n_elements(a) * 1. / n_elements(where(finite(diff) eq 1))
    endfor
   endfor
  endfor

; Relative difference
  thresh = [0.1, 0.2, 0.5]
  nt = n_elements(thresh)
  relv = fltarr(nsam,nreg,nt)
  nv = intarr(nsam,nreg)
  for isam = 1, nsam-1 do begin
   for ireg = 0, nreg-1 do begin
    diff = (reg[*,*,ireg,1,isam] - reg[*,*,ireg,0,0]) / reg[*,*,ireg,0,0]
    nv[isam,ireg] = n_elements(where(finite(diff) eq 1))
    for it = 0, nt-1 do begin
     a = where(abs(diff) gt thresh[it])
     if(a[0] ne -1) then $
      relv[isam,ireg,it] = n_elements(a) * 1. / n_elements(where(finite(diff) eq 1))
    endfor
   endfor
  endfor

; Now print results
  print, res
  for ireg = 0, nreg - 1 do begin
   print, regtitle[ireg]
   for isam = 1,nsam-1 do begin
    print, samples[isam], absv[isam,ireg,*], relv[isam,ireg,*], nv[isam,ireg], $
           format='(a10,7(2x,f5.3),2x,i3)'
   endfor
  endfor
  print, ' '

end
