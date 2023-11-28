  expdir = '/misc/prc15/colarco/dR_MERRA-AA-r2/inst2d_hwl_x/'
  site   = 'Chiang_Mai_Met_Sta'
  years  = ['2003','2004','2005','2006','2007','2008','2009','2010','2011']
  ny     = n_elements(years)
  for iy = 0, ny-1 do begin
   file   = expdir + 'dR_MERRA-AA-r2.inst2d_hwl.aeronet.'+site+'.'+years[iy]+'.nc4'
   nc4readvar, file, 'totexttau', aot_, nymd=nymd_
   nc4readvar, file, 'duexttau', du_, nymd=nymd_
   nc4readvar, file, 'suexttau', su_, nymd=nymd_
   nc4readvar, file, 'ssexttau', ss_, nymd=nymd_
   nc4readvar, file, 'ocexttau', oc_, nymd=nymd_
   nc4readvar, file, 'bcexttau', bc_, nymd=nymd_
   if(iy eq 0) then begin
    aot  = aot_
    du   = du_
    su   = su_
    cc   = oc_+bc_
    ss   = ss_
    nymd = nymd_
   endif else begin
    aot  = [aot,aot_]
    du  = [du,du_]
    su  = [su,su_]
    ss  = [ss,ss_]
    cc  = [cc,bc_+oc_]
    nymd = [nymd,nymd_]
   endelse
  endfor

; Now make monthly means
  nym  = strmid(nymd[uniq(strmid(nymd,0,6))],0,6)
  aotm = fltarr(n_elements(nym))
  dum  = fltarr(n_elements(nym))
  sum  = fltarr(n_elements(nym))
  ccm  = fltarr(n_elements(nym))
  ssm  = fltarr(n_elements(nym))
  for iym = 0, n_elements(nym)-1 do begin
   aotm[iym] = mean(aot[where(strmid(nymd,0,6) eq nym[iym])])
   dum[iym]  = mean(du[where(strmid(nymd,0,6) eq nym[iym])])
   sum[iym]  = mean(su[where(strmid(nymd,0,6) eq nym[iym])])
   ssm[iym]  = mean(ss[where(strmid(nymd,0,6) eq nym[iym])])
   ccm[iym]  = mean(cc[where(strmid(nymd,0,6) eq nym[iym])])
  endfor

  loadct, 39
  plot, aotm
  polyfill, [indgen(108),107,0,0], [aotm,0,0,aotm[0]], color=254
  y = aotm-ccm
  polyfill, [indgen(108),107,0,0], [y,0,0,y[0]], color=176
  y = aotm-ccm-sum
  polyfill, [indgen(108),107,0,0], [y,0,0,y[0]], color=208
  y = aotm-ccm-sum-dum
  polyfill, [indgen(108),107,0,0], [y,0,0,y[0]], color=84

end
