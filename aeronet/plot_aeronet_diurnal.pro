; Colarco
; Read in a yearly file from AERONET and determine diurnal cycle of
; AOT

; E.g.,
  locWant = 'GSFC'
  spawn, 'echo $AERONETDIR', headDir
  aerPath = headDir+'LEV30/'
  lambdabase = '550'
  angstromaeronetIn = 1.
  angstrommodel = 1.
  yyyy = '2007'
  read_aeronet2nc, aerPath, locwant, lambdabase, yyyy, $
                   aotaeronetIn, dateaeronet, $
                   angpair=1, angstrom=angstromaeronetIn, naot=naotaeronet, $
                   /hourly
  dateaeronet = strpad(dateaeronet,100000000L)

; Bring in a model time series
  exppath = ['/misc/prc15/colarco/dR_MERRA-AA-r2a/inst2d_hwl_x/aeronet/', $
             '/misc/prc14/colarco/c180R_H40_acma/inst2d_hwl_x/aeronet/', $
             '/misc/prc13/M2R12K_BETA7/M2R12K_may2005/DATA/0.5000_deg/inst/inst1_2d_hwl_Cx/aeronet/']
  expid = ['dR_MERRA-AA-r2a.inst2d_hwl.aeronet', $
           'c180R_H40_acma.inst2d_hwl.aeronet', $
           'M2R12K.inst2d_hwl.aeronet']
  nexpid = n_elements(expid)
  for iexpid = 0, nexpid-1 do begin
   readmodel, exppath[iexpid], expid[iexpid], yyyy, locwant, lambdabase, ['totexttau'], $
              aotModelIn_, dateModel
   if(iexpid eq 0) then begin
    aotModelIn = aotModelIn_
   endif else begin
    aotModelIn = [aotModelIn,aotModelIn_]
   endelse
  endfor
  aotModelIn = reform(aotModelIn,n_elements(dateModel),nexpid)

; Find the diurnal cycle
  aotAeronet = make_array(24,val=!values.f_nan)
  aotModel   = make_array(24,nexpid,val=!values.f_nan)
  nAeronet   = intarr(24)
  for i = 0, 23 do begin
;   a = where(strmid(dateaeronet,8,2) eq strpad(i,10))
   a = where(strmid(dateaeronet,8,2) eq strpad(i,10) and $
             ( strmid(dateaeronet,4,2) eq '06' or $)
               strmid(dateaeronet,4,2) eq '07' or $)
               strmid(dateaeronet,4,2) eq '08' ))
   b = where(aotaeronetIn[a] gt 0)
   if(b[0] ne -1) then begin
     aotaeronet[i] = total(aotaeronetin[a[b]])/n_elements(b)
     for iexpid = 0, nexpid-1 do begin
      aotmodel[i,iexpid]   = total(aotmodelin[a[b],iexpid])/n_elements(b)
     endfor
     naeronet[i]   = n_elements(b)
   endif
  endfor

  set_plot, 'ps'
  device, file='plot_aeronet_aot_diurnal.'+locWant+'.ps', /color, /helvetica, $
   font_size=14, xoff=.5, yoff=.5, xsize=20, ysize=24
  !p.font=0
  !p.multi=[0,1,2]
  
  plot, findgen(24), /nodata, thick=3, $
   xrange=[0,24], xticks=24, xstyle=9, $
   yrange=[.1,.5], yticks=4, ystyle=9, $
   xtitle='hour (GMT)', ytitle='AOT', title=locwant+' ('+yyyy+')'
  
  loadct, 39
  colors = [254,176,84]
  oplot, findgen(24), aotaeronet, thick=10
  for iexpid = 0, nexpid-1 do begin
   oplot, findgen(24), aotmodel[*,iexpid], thick=8, color=colors[iexpid]
  endfor

  plot, findgen(24), /nodata, thick=3, $
   xrange=[0,24], xticks=24, xstyle=9, $
   yrange=[-.1,.1], yticks=4, ystyle=9, $
   xtitle='hour (GMT)', ytitle='!9D!3AOT', title=locwant+' ('+yyyy+')'
  plots, [0,24], 0, lin=2, thick=.5
  a = where(finite(aotaeronet) eq 1)
  n = n_elements(a)
  oplot, findgen(24), aotaeronet-total(aotaeronet,/nan)/n, thick=10
  for iexpid = 0, nexpid-1 do begin
   oplot, findgen(24), aotmodel[*,iexpid]-total(aotmodel[*,iexpid],/nan)/n, thick=8, color=colors[iexpid]
  endfor


  device, /close


end
