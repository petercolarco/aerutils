  expid = 't006_b32'
  yearwant = ['2000']
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
   a = where(finite(duaeroce[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     dudata = mean(duaeroce[a,iloc])
     dumod  = mean(dusmass[a,iloc])
     ifirst = 0
    endif else begin
     dudata = [dudata, mean(duaeroce[a,iloc])]
     dumod  = [dumod,  mean(dusmass[a,iloc])]
    endelse
   endif
  endfor

; black carbon
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(bcimprove[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     bcdata = mean(bcimprove[a,iloc])
     bcmod  = mean(bcsmass[a,iloc])
     ifirst = 0
    endif else begin
     bcdata = [bcdata, mean(bcimprove[a,iloc])]
     bcmod  = [bcmod,  mean(bcsmass[a,iloc])]
    endelse
   endif
  endfor

; organic carbon
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(ocimprove[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     ocdata = mean(ocimprove[a,iloc])
     ocmod  = mean(ocsmass[a,iloc])
     ifirst = 0
    endif else begin
     ocdata = [ocdata, mean(ocimprove[a,iloc])]
     ocmod  = [ocmod,  mean(ocsmass[a,iloc])]
    endelse
   endif
  endfor

; sulfate (improve)
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(so4improve[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     so4data_imp = mean(so4improve[a,iloc])
     so4mod_imp  = mean(so4smass[a,iloc])
     ifirst = 0
    endif else begin
     so4data_imp = [so4data_imp, mean(so4improve[a,iloc])]
     so4mod_imp  = [so4mod_imp,  mean(so4smass[a,iloc])]
    endelse
   endif
  endfor

; sulfate (emep)
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(so4emep[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     so4data_emep = mean(so4emep[a,iloc])
     so4mod_emep  = mean(so4smass[a,iloc])
     ifirst = 0
    endif else begin
     so4data_emep = [so4data_emep, mean(so4emep[a,iloc])]
     so4mod_emep  = [so4mod_emep,  mean(so4smass[a,iloc])]
    endelse
   endif
  endfor

; seasalt (improve)
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(ssimprove[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     ssdata_imp = mean(ssimprove[a,iloc])
     ssmod_imp  = mean(sssm25[a,iloc])
     ifirst = 0
    endif else begin
     ssdata_imp = [ssdata_imp, mean(ssimprove[a,iloc])]
     ssmod_imp  = [ssmod_imp,  mean(sssm25[a,iloc])]
    endelse
   endif
  endfor

; seasalt (aeroce)
  nloc = n_elements(locations)
  ifirst = 1
  for iloc =  0, nloc -1 do begin
   a = where(finite(ssaeroce[*,iloc]) eq 1)
   if(a[0] ne -1) then begin
    if(ifirst) then begin
     ssdata_aeroce = mean(ssaeroce[a,iloc])
     ssmod_aeroce  = mean(sssmass[a,iloc])
     ifirst = 0
    endif else begin
     ssdata_aeroce = [ssdata_aeroce, mean(ssaeroce[a,iloc])]
     ssmod_aeroce  = [ssmod_aeroce,  mean(sssmass[a,iloc])]
    endelse
   endif
  endfor


  set_plot, 'ps'
  plotfile = './output/plots/sfcobs_annual.allspec.'+expid[0]+'.ps'
  device, file=plotfile, /color, /helvetica, font_size=14, $
   xoff=.5, yoff=.5, xsize=12, ysize=18
  !p.font=0
  !p.multi=[0,2,3]

  loadct, 39

  plot, [.1,10], [.1,10], /xlog,/ylog, $
   thick=3, xthick=3, ythick=3, $
   xtitle='Data [!Mm!3g m!E-3!N]', ytitle='Model [!Mm!3g m!E-3!N]', $
   title = 'Organic Carbon'
  plots,[.1,10], [.2,20], lin=2, noclip=0
  plots,[.1,10], [.05,5], lin=2, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=90, /fill
  plots, ocdata, ocmod, psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, ocdata, ocmod, psym=8, noclip=0

  plot, [.01,1], [.01,1], /xlog,/ylog, $
   thick=3, xthick=3, ythick=3, $
   xtitle='Data [!Mm!3g m!E-3!N]', ytitle='Model [!Mm!3g m!E-3!N]', $
   title = 'Black Carbon'
  plots,[.01,1], [.02,2], lin=2, noclip=0
  plots,[.01,1], [.005,.5], lin=2, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=90, /fill
  plots, bcdata, bcmod, psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, bcdata, bcmod, psym=8, noclip=0

  plot, [.05,10], [.05,10], /xlog,/ylog, $
   thick=3, xthick=3, ythick=3, xstyle=1, ystyle=1, $
   xtitle='Data [!Mm!3g m!E-3!N]', ytitle='Model [!Mm!3g m!E-3!N]', $
   title = 'Dust'
  plots,[.05,10], [.1,20], lin=2, noclip=0
  plots,[.1,10], [.05,5], lin=2, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=208, /fill
  plots, dudata, dumod, psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, dudata, dumod, psym=8, noclip=0

  plot, [.1,200], [.1,200], /xlog,/ylog, $
   thick=3, xthick=3, ythick=3, xstyle=1, ystyle=1, $
   xtitle='Data [!Mm!3g m!E-3!N]', ytitle='Model [!Mm!3g m!E-3!N]', $
   title = 'Sea Salt'
  plots,[.1,200], [.2,400], lin=2, noclip=0
  plots,[.1,200], [.05,100], lin=2, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=208, /fill
  plots, ssdata_aeroce, ssmod_aeroce, psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, ssdata_aeroce, ssmod_aeroce, psym=8, noclip=0

  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=90, /fill
  plots, ssdata_imp, ssmod_imp, psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, ssdata_imp, ssmod_imp, psym=8, noclip=0



  plot, [.1,50], [.1,50], /xlog,/ylog, $
   thick=3, xthick=3, ythick=3, xstyle=1, ystyle=1, $
   xtitle='Data [!Mm!3g m!E-3!N]', ytitle='Model [!Mm!3g m!E-3!N]', $
   title = 'Sulfate'
  plots,[.1,200], [.2,400], lin=2, noclip=0
  plots,[.1,200], [.05,100], lin=2, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=176, /fill
  plots, so4data_emep, so4mod_emep, psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, so4data_emep, so4mod_emep, psym=8, noclip=0

  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=90, /fill
  plots, so4data_imp, so4mod_imp, psym=8, noclip=0
  usersym, [-1,0,1,0,-1],[0,-1,0,1,0], color=0
  plots, so4data_imp, so4mod_imp, psym=8, noclip=0


  device, /close

end
