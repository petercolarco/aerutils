; Colarco, August 2006
; Read in the monthly means for some number of years, concatenate, and
; make site plots!

  expid= 't003_c32'
  yearwant = ['2000']
  read_mon_mean, expid, yearwant, locations, lat, lon, date, $
                     dusmass, sssmass, so4smass, bcsmass, ocsmass, $
                     dusmassStd, sssmassStd, so4smassStd, bcsmassStd, ocsmassStd, $
                     dusm25, dusm25Std, sssm25, sssm25Std, $
                     duaeroce, duaerocestd, ssaeroce, ssaerocestd, $
                     so4emep, so4emepstd, $
                     so4improve, so4improvestd, ssimprove, ssimprovestd, $
                     bcimprove, bcimprovestd, ocimprove, ocimprovestd

  date = strcompress(string(date),/rem)
stop
; Create a plot file
  set_plot, 'ps'
  device, file='./output/plots/sfcobs_site.aeroce.ps', /color, /helvetica, font_size=14, $
          xoff=.5, yoff=26, xsize=25, ysize=20, /landscape
  !p.font=0


; position the plots
  position = fltarr(4,4)
  position[*,0] = [.1,.6,.55,.95]
  position[*,1] = [.65,.6,.95,.95]
  position[*,2] = [.1,.1,.55,.45]
  position[*,3] = [.65,.1,.95,.45]

  nloc = n_elements(locations)
  locuse = make_array(nloc,val=0)
  for iloc = 0, nloc-1 do begin


   plot_panel, date, dusmass[*,iloc], dusmassstd[*,iloc], duaeroce[*,iloc], duaerocestd[*,iloc], $
               locations[iloc], 'Model', 'AEROCE', 'Dust Concentration [!Mm!3g m!E-3!N]', position[*,0:1], $
               locuse=locuse_
   locuse[iloc] = locuse_

   plot_panel, date, sssmass[*,iloc], sssmassstd[*,iloc], ssaeroce[*,iloc], ssaerocestd[*,iloc], $
               locations[iloc], 'Model', 'AEROCE', 'Seasalt Concentration [!Mm!3g m!E-3!N]', position[*,2:3], $
               /noerase

  endfor

; Make a map
  loadct, 0
  map_set, /cont
  usersym, 2.*[-1,0,1,0,-1],2.*[0,-1,0,1,0], /fill, color=160
  for iloc = 0, nloc-1 do begin
   if(locuse[iloc]) then begin
    plots, lon[iloc], lat[iloc], psym=8, noclip=0
    label = locations[iloc]
    xyouts, lon[iloc], lat[iloc]-1, label, $
            align=0, charsize=.75, clip=[0,0,1,1]
   endif
  endfor


  device, /close

end
