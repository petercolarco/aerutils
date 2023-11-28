;  lamWant = '340'
;  stnWant = 'Durban_UKZN'
;  varWant = 'AOD_'+lamWant+'nm'
  ymax = 3
  expid = 'c360R_era5_v10p22p2_aura_baseline'

; Get the list of stations
  cdfid = ncdf_open(expid+'.inst3d_aer_v.aeronet.ext-1020nm.2016.bc.nc')
  id = ncdf_varid(cdfid,'stnName')
  ncdf_varget, cdfid, id, stnName
  stnName = strcompress(string(stnName),/rem)

  for j = 0, n_elements(stnName)-1 do begin

  stnWant = stnName[j]

  getaeronetaod, stnWant, 'AOD_340nm', time, aodo
  a = where(finite(aodo) eq 1)
  if(n_elements(a) lt 4) then continue  

  x = indgen(240)
  print, stnWant, max(aodo[a]), n_elements(aodo)

; Plot the model AOD versus wavelength
  set_plot,'ps'
  device, file=stnWant+'.'+expid+'.ps', /color, /helvetica, font_size=14, $
   xsize=24, ysize=24
  !p.font=0 

  lamWant  = ['340','380','440','500','675','870','1020']
  colors   = [0,40,80,120,176,192,208,254]
  loadct, 39

  aodmEvent = fltarr(n_elements(lamWant))
  aodmbEvent = fltarr(n_elements(lamWant))
  aodmdEvent = fltarr(n_elements(lamWant))
  aodmoEvent = fltarr(n_elements(lamWant))
  aodmsEvent = fltarr(n_elements(lamWant))
  aodmaEvent = fltarr(n_elements(lamWant))
  aodoEvent = fltarr(n_elements(lamWant))
;  event = [180,260]
  event = [0,239] ; september

  xtickv = [0,112,240]
  xtickn = ['Sep 1','Sep 15',' ']

  for i = 0, n_elements(lamWant)-1 do begin
   getmodelaod, expid, stnWant, lamWant[i], aodm
   if(i eq 0) then begin
    plot, x, aodm, thick=6, color=colors[i], /nodata, $
      xrange=[0,max(x)], xstyle=1, yrange=[0,ymax], ystyle=1, $
      xticks=2, xminor=15, xtickv=xtickv, xtickn=xtickn, $
      position=[0.1,0.55,0.95,0.9], ytitle='AOD', title=expid
    oplot, x, aodm, thick=6, color=colors[i]
   endif else begin
    oplot, x, aodm, thick=6, color=colors[i]
   endelse
  endfor

  for i = 0, n_elements(lamWant)-1 do begin
   xyouts, .58+i*.04,.875,string(lamwant[i],format='(i4)'), charsize=.7, /normal, color=colors[i]
  endfor
  xyouts, .56, .85, 'bias', /normal, align=1, charsize=.7  
  xyouts, .56, .83, 'rms', /normal, align=1, charsize=.7  
  xyouts, .56, .81, 'r', /normal, align=1, charsize=.7  
  xyouts, .56, .79, 'skill', /normal, align=1, charsize=.7  
  plots, [.57,.57,.87], [.78,.8725,.8725], /normal

  for i = 0, n_elements(lamWant)-1 do begin
   varWant = 'AOD_'+lamWant[i]+'nm'
   getaeronetaod, stnWant, varWant, time, aod
;check, aod
   getmodelaod,   expid, stnWant, lamWant[i], aodm
   getmodelaod,   expid, stnWant, lamWant[i], aodmb, species='brc'
   getmodelaod,   expid, stnWant, lamWant[i], aodmo, species='oc'
   getmodelaod,   expid, stnWant, lamWant[i], aodmd, species='du'
   getmodelaod,   expid, stnWant, lamWant[i], aodms, species='su'
   getmodelaod,   expid, stnWant, lamWant[i], aodma, species='bc'
   statistics, aod[event[0]:event[1]], aodm[event[0]:event[1]], $
                  xmean, ymean, xstd, ystd, r, bias, rms, skill, $
                  linslope, linoffset, rc=rc
   xyouts, .58+i*.04,.85,string(bias,format='(f5.2)'), charsize=.7, /normal
   xyouts, .58+i*.04,.83,string(rms,format='(f5.2)'), charsize=.7, /normal
   xyouts, .58+i*.04,.81,string(r,format='(f5.2)'), charsize=.7, /normal
   xyouts, .58+i*.04,.79,string(skill,format='(f5.2)'), charsize=.7, /normal

   aodo_ = aod[event[0]:event[1]]
   aodm_ = aodm[event[0]:event[1]]
   aodm_[where(finite(aodo_) ne 1)] = !values.f_nan
   aodmb_ = aodmb[event[0]:event[1]]
   aodmb_[where(finite(aodo_) ne 1)] = !values.f_nan
   aodms_ = aodms[event[0]:event[1]]
   aodms_[where(finite(aodo_) ne 1)] = !values.f_nan
   aodmd_ = aodmd[event[0]:event[1]]
   aodmd_[where(finite(aodo_) ne 1)] = !values.f_nan
   aodmo_ = aodmo[event[0]:event[1]]
   aodmo_[where(finite(aodo_) ne 1)] = !values.f_nan
   aodma_ = aodma[event[0]:event[1]]
   aodma_[where(finite(aodo_) ne 1)] = !values.f_nan
   aodoEvent[i] = mean(aodo_,/nan)
   aodmEvent[i] = mean(aodm_,/nan)
   aodmbEvent[i] = mean(aodmb_,/nan)
   aodmdEvent[i] = mean(aodmd_,/nan)
   aodmsEvent[i] = mean(aodms_,/nan)
   aodmoEvent[i] = mean(aodmo_,/nan)
   aodmaEvent[i] = mean(aodma_,/nan)

   if(i eq 0) then begin
    plot, x, aod, thick=6, color=colors[i], /nodata, $
      xrange=[0,max(x)], xstyle=1, yrange=[0,ymax], ystyle=1, $
      position=[0.1,.1,0.95,0.45], /noerase, $
      xticks=2, xminor=15, xtickv=xtickv, xtickn=xtickn, $
      ytitle='AOD', title='AERONET'
   endif
;   plots, x, aod, psym=0, symsize=.7, color=colors[i], lin=2
   plots, x, aod, psym=sym(3), symsize=.7, color=colors[i]

  endfor

  loadct, 0
  plot, x, aod, /noerase, /nodata, position=[.15,.325,.5,.425], $
   xrange=[event[0],event[1]+1], xstyle=9, yrange=[0,ymax], ystyle=9, $
   xticks=2, xtickv=[0,112,240], xtickn=['Sep 1','Sep 15',' '], charsize=.7, $
   title='500 nm AOD', xminor=15
  loadct,39
  getmodelaod,   expid, stnWant, '500', aodm
  oplot, x, aodm, thick=2
  getaeronetaod, stnWant, 'AOD_500nm', time, aod
  plots, x, aod, psym=sym(3), noclip=0, symsize=.65, color=254

  loadct, 0
  plot, fix(lamwant),aodmevent,/noerase, /nodata, position=[.18,.73,.38,.88], $
   xrange=[300,1200], xstyle=1, /xlog, xticks=[8], $
   xtickv=[300,400,500,600,700,800,900,1000,1200], $
   xtickn=['300',' ','500',' ','700',' ','900',' ',' '], $
   yrange=[0,1.5], ytitle='AOD', xtitle='Wavelength [nm]', charsize=.7
  oplot, fix(lamwant), aodmevent, lin=2
  plots, fix(lamwant), aodmevent, psym=sym(1)
  oplot, fix(lamwant), aodoevent, lin=2
  plots, fix(lamwant), aodoevent, psym=sym(3)
  oplot, fix(lamwant), aodmbevent, lin=2, color=120
  plots, fix(lamwant), aodmbevent, psym=sym(1), symsize=.6, color=90

  plots, 500, 1.20, psym=sym(3), symsize=.75
  plots, 500, 1.05, psym=sym(1), symsize=.75
  plots, 500, 0.9, psym=sym(1), symsize=.5, color=120
  xyouts, 525,1.15, 'AERONET', charsize=.7
  xyouts, 525,1.00, 'Model', charsize=.7
  xyouts, 525,0.85, 'Model (BrC)', charsize=.7
  xyouts, 800, 1.35, 'AE!D440-870!N', charsize=.7
  xyouts, 900, 1.15, string(-alog(aodoevent[2]/aodoevent[5])/alog(440/870.),format='(f4.2)'), charsize=.7
  xyouts, 900, 1.00, string(-alog(aodmevent[2]/aodmevent[5])/alog(440/870.),format='(f4.2)'), charsize=.7
  xyouts, 900, 0.85, string(-alog(aodmbevent[2]/aodmbevent[5])/alog(440/870.),format='(f4.2)'), charsize=.7

; Plot the fractional AOD
  loadct, 39
  plot, indgen(2), /nodata, /noerase, position=[.38,.73,.45,.88], $
   xrange=[0,1], xticks=2, xstyle=1, xtickn=['0','0.5','1'], charsize=.7, $
   yrange=[340,1020], ystyle=5
  axis,yaxis=1,/save, yticks=6, /ylog, yrange=[340,1020], $
   ytickv=[340,380,440,500,675,870,1020], charsize=.6, $
   ytickn=['340','380','440','500','675','870','1020']
  x = (aodmbevent+aodmoevent+aodmsevent+aodmdevent+aodmaevent)/aodmevent
  polyfill, [0,x,0,0], [340,fix(lamwant),1020,340], color=208
  x = (aodmbevent+aodmoevent+aodmsevent+aodmaevent)/aodmevent
  polyfill, [0,x,0,0], [340,fix(lamwant),1020,340], color=176
  x = (aodmbevent+aodmoevent+aodmaevent)/aodmevent
  polyfill, [0,x,0,0], [340,fix(lamwant),1020,340], color=254
  x = (aodmbevent+aodmaevent)/aodmevent
  polyfill, [0,x,0,0], [340,fix(lamwant),1020,340], color=84
  x = (aodmaevent)/aodmevent
  polyfill, [0,x,0,0], [340,fix(lamwant),1020,340], color=0


  xyouts, .1, .95, stnWant, charsize=1.5, /normal

  device, /close

  endfor

end
