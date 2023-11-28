  expid = 'dR_Fortuna-M-1-1'
  yearwant = ['2004','2005','2006','2007','2008','2009']
  read_mon_mean, expid, yearwant, locations, lat, lon, date, $
                     dusmass, sssmass, so4smass, bcsmass, ocsmass, $
                     dusmassStd, sssmassStd, so4smassStd, bcsmassStd, ocsmassStd, $
                     dusm25, dusm25Std, sssm25, sssm25Std, $
                     duaeroce, duaerocestd, ssaeroce, ssaerocestd, $
                     so4emep, so4emepstd, $
                     so4improve, so4improvestd, ssimprove, ssimprovestd, $
                     bcimprove, bcimprovestd, ocimprove, ocimprovestd

; Now massage the fields to come up with an array of annual averages

; dust
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   if(ifirst) then begin
     dudata = mean(duaeroce[*,iloc],/nan)
     dumod  = mean(dusmass[*,iloc],/nan)
     ifirst = 0
   endif else begin
     dudata = [dudata, mean(duaeroce[*,iloc],/nan)]
     dumod  = [dumod,  mean(dusmass[*,iloc],/nan)]
   endelse
  endfor

; black carbon
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   if(ifirst) then begin
     bcdata = mean(bcimprove[*,iloc],/nan)
     bcmod  = mean(bcsmass[*,iloc],/nan)
     ifirst = 0
   endif else begin
     bcdata = [bcdata, mean(bcimprove[*,iloc],/nan)]
     bcmod  = [bcmod,  mean(bcsmass[*,iloc],/nan)]
   endelse
  endfor

; organic carbon
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   if(ifirst) then begin
     ocdata = mean(ocimprove[*,iloc],/nan)
     ocmod  = mean(ocsmass[*,iloc],/nan)
     ifirst = 0
   endif else begin
     ocdata = [ocdata, mean(ocimprove[*,iloc],/nan)]
     ocmod  = [ocmod,  mean(ocsmass[*,iloc],/nan)]
   endelse
  endfor

; sulfate (improve)
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
    if(ifirst) then begin
     so4data_imp = mean(so4improve[*,iloc],/nan)
     so4mod_imp  = mean(so4smass[*,iloc],/nan)
     ifirst = 0
    endif else begin
     so4data_imp = [so4data_imp, mean(so4improve[*,iloc],/nan)]
     so4mod_imp  = [so4mod_imp,  mean(so4smass[*,iloc],/nan)]
    endelse
  endfor

; sulfate (emep)
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
    if(ifirst) then begin
     so4data_emep = mean(so4emep[*,iloc],/nan)
     so4mod_emep  = mean(so4smass[*,iloc],/nan)
     ifirst = 0
    endif else begin
     so4data_emep = [so4data_emep, mean(so4emep[*,iloc],/nan)]
     so4mod_emep  = [so4mod_emep,  mean(so4smass[*,iloc],/nan)]
    endelse
  endfor

; seasalt (improve)
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
    if(ifirst) then begin
     ssdata_imp = mean(ssimprove[*,iloc],/nan)
;     ssmod_imp  = mean(sssm25[*,iloc],/nan)
     ssmod_imp  = mean(sssmass[*,iloc],/nan)
     ifirst = 0
    endif else begin
     ssdata_imp = [ssdata_imp, mean(ssimprove[*,iloc],/nan)]
;     ssmod_imp  = [ssmod_imp,  mean(sssm25[*,iloc],/nan)]
     ssmod_imp  = [ssmod_imp,  mean(sssmass[*,iloc],/nan)]
    endelse
  endfor

; seasalt (aeroce)
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
    if(ifirst) then begin
     ssdata_aeroce = mean(ssaeroce[*,iloc],/nan)
     ssmod_aeroce  = mean(sssmass[*,iloc],/nan)
     ifirst = 0
    endif else begin
     ssdata_aeroce = [ssdata_aeroce, mean(ssaeroce[*,iloc],/nan)]
     ssmod_aeroce  = [ssmod_aeroce,  mean(sssmass[*,iloc],/nan)]
    endelse
  endfor


  set_plot, 'ps'
  plotfile = './output/plots/sfcobs_annual.'+expid[0]+'.ps'
  device, file=plotfile, /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=20, ysize=18
  !p.font=0
  !p.multi=[0,2,2]

  loadct, 0

  plot, [.05,10], [.05,10], /xlog,/ylog, $
   thick=3, xthick=3, ythick=3, xstyle=1, ystyle=1, $
   xtitle='Data [!Mm!3g m!E-3!N]', ytitle='Model [!Mm!3g m!E-3!N]', $
   title = 'Dust'
  plots,[.05,10], [.1,20], lin=2, noclip=0
  plots,[.1,10], [.05,5], lin=2, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0, /fill
  plots, dudata, dumod, psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, dudata, dumod, psym=8, noclip=0


  plot, [.1,200], [.1,200], /xlog,/ylog, $
   thick=3, xthick=3, ythick=3, xstyle=1, ystyle=1, $
   xtitle='Data [!Mm!3g m!E-3!N]', ytitle='Model [!Mm!3g m!E-3!N]', $
   title = 'Sea Salt'
  plots,[.1,200], [.2,400], lin=2, noclip=0
  plots,[.1,200], [.05,100], lin=2, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0, /fill
  plots, ssdata_aeroce, ssmod_aeroce, psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, ssdata_aeroce, ssmod_aeroce, psym=8, noclip=0

  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=120, /fill
  plots, ssdata_imp, ssmod_imp, psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, ssdata_imp, ssmod_imp, psym=8, noclip=0





  plot, [.1,10], [.1,10], /xlog,/ylog, $
   thick=3, xthick=3, ythick=3, xstyle=1, ystyle=1, $
   xtitle='Data [!Mm!3g S m!E-3!N]', ytitle='Model [!Mm!3g S m!E-3!N]', $
   title = 'Sulfate'
  plots,[.1,200], [.2,400], lin=2, noclip=0
  plots,[.1,200], [.05,100], lin=2, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0, /fill
  plots, so4data_emep/3., so4mod_emep/3., psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, so4data_emep/3., so4mod_emep/3., psym=8, noclip=0

  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=120, /fill
  plots, so4data_imp/3., so4mod_imp/3., psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, so4data_imp/3., so4mod_imp/3., psym=8, noclip=0



  ccdata = 1.4*ocdata+bcdata
  ccmod  = ocmod+bcmod
  plot, [.1,10], [.1,10], /xlog,/ylog, $
   thick=3, xthick=3, ythick=3, $
   xtitle='Data [!Mm!3g m!E-3!N]', ytitle='Model [!Mm!3g m!E-3!N]', $
   title = 'Carbonaceous'
  plots,[.1,10], [.2,20], lin=2, noclip=0
  plots,[.1,10], [.05,5], lin=2, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0, /fill
  plots, ccdata, ccmod, psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, ccdata, ccmod, psym=8, noclip=0


  device, /close

end
