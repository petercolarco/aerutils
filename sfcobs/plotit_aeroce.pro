; Colarco, August 2006
; Read in the monthly means for some number of years, concatenate, and
; make site plots!

  expid= 'dR_Fortuna-M-1-1'
  yearwant = ['2004','2005','2006','2007','2008','2009']
  read_mon_mean, expid, yearwant, location, latitude, longitude, date, $
                     dusmass, sssmass, so4smass, bcsmass, ocsmass, $
                     dusmassStd, sssmassStd, so4smassStd, bcsmassStd, ocsmassStd, $
                     dusm25, dusm25Std, sssm25, sssm25Std, $
                     duaeroce, duaerocestd, ssaeroce, ssaerocestd, $
                     so4emep, so4emepstd, $
                     so4improve, so4improvestd, ssimprove, ssimprovestd, $
                     bcimprove, bcimprovestd, ocimprove, ocimprovestd

  date = strcompress(string(date),/rem)

; Create a plot file
  set_plot, 'ps'
  device, file='./output/plots/sfcobs_site.aeroce.'+expid+'.ps', /color, /helvetica, font_size=14, $
;  device, file='./output/plots/sfcobs_site.aeroce.pm25.ps', /color, /helvetica, font_size=14, $
          xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
  !p.font=0


; position the plots
  position = fltarr(4,4)
  position[*,0] = [.1,.6,.55,.95]
  position[*,1] = [.65,.6,.95,.95]
  position[*,2] = [.1,.1,.55,.45]
  position[*,3] = [.65,.1,.95,.45]


  nloc = n_elements(location)
  locuse = make_array(nloc,val=0)
  for iloc = 0, nloc-1 do begin

   noerase = 0
   a = where(finite(duaeroce[*,iloc]) eq 1)
   if(n_elements(a) gt 3) then begin
    noerase = 1
    plot_panel, date, dusmass[*,iloc], dusmassstd[*,iloc], duaeroce[*,iloc], duaerocestd[*,iloc], $
;    plot_panel, date, dusm25[*,iloc], dusm25std[*,iloc], duaeroce[*,iloc], duaerocestd[*,iloc], $
                location[iloc], 'Model', 'AEROCE', 'Dust Concentration [!Mm!3g m!E-3!N]', position[*,0:1], $
                locuse=locuse_
    locuse[iloc] = locuse_
   endif


   a = where(finite(ssaeroce[*,iloc]) eq 1)
   if(n_elements(a) gt 3) then begin
   plot_panel, date, sssmass[*,iloc], sssmassstd[*,iloc], ssaeroce[*,iloc], ssaerocestd[*,iloc], $
;    plot_panel, date, sssm25[*,iloc], sssm25std[*,iloc], ssaeroce[*,iloc], ssaerocestd[*,iloc], $
                location[iloc], 'Model', 'AEROCE', 'Seasalt Concentration [!Mm!3g m!E-3!N]', position[*,2:3], $
                noerase = noerase, locuse=locuse_
    locuse[iloc] = locuse_
   endif


  endfor

; Make a map
  loadct, 0
  map_set, /cont
  usersym, 2.*[-1,0,1,0,-1],2.*[0,-1,0,1,0], /fill, color=160
  for iloc = 0, nloc-1 do begin
   if(locuse[iloc]) then begin
    plots, longitude[iloc], latitude[iloc], psym=8, noclip=0
    label = location[iloc]
    xyouts, longitude[iloc], latitude[iloc]-1, label, $
            align=0, charsize=.75, clip=[0,0,1,1]
   endif
  endfor


  device, /close

end
