; Colarco, August 2006
; Read in the monthly means for some number of years, concatenate, and
; make site plots!

  expid= 't003_c32'
  yearwant = ['2000']
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
  device, file='./output/plots/sfcobs_site.improve.ps', /color, /helvetica, font_size=14, $
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
   a = where(finite(bcimprove[*,iloc]) eq 1)
   if(n_elements(a) gt 3) then begin
    noerase = 1
    plot_panel, date, bcsmass[*,iloc], bcsmassstd[*,iloc], bcimprove[*,iloc], bcimprovestd[*,iloc], $
                location[iloc], 'Model', 'IMPROVE', 'Black Carbon Concentration [!Mm!3g m!E-3!N]', position[*,0:1], $
                locuse=locuse_
    locuse[iloc] = locuse_
   endif

   a = where(finite(ocimprove[*,iloc]) eq 1)
   if(n_elements(a) gt 3) then begin
    plot_panel, date, ocsmass[*,iloc], ocsmassstd[*,iloc], 1.4*ocimprove[*,iloc], 1.4*ocimprovestd[*,iloc], $
                location[iloc], 'Model', 'IMPROVE', 'Organic Carbon Concentration [!Mm!3g m!E-3!N]', position[*,2:3], $
                /noerase
    locuse[iloc] = locuse_
   endif


   noerase = 0
   a = where(finite(so4improve[*,iloc]) eq 1)
   if(n_elements(a) gt 3) then begin
    noerase = 1
    plot_panel, date, so4smass[*,iloc], so4smassstd[*,iloc], so4improve[*,iloc], so4improvestd[*,iloc], $
                location[iloc], 'Model', 'IMPROVE', 'SO4 Concentration [!Mm!3g m!E-3!N]', position[*,0:1], $
                locuse=locuse_
    locuse[iloc] = locuse_
   endif

   a = where(finite(ocimprove[*,iloc]) eq 1)
   if(n_elements(a) gt 3) then begin
    plot_panel, date, sssm25[*,iloc], sssm25std[*,iloc], ssimprove[*,iloc], ssimprovestd[*,iloc], $
                location[iloc], 'Model', 'IMPROVE', 'Seasalt Concentration [!Mm!3g m!E-3!N]', position[*,2:3], $
                /noerase
    locuse[iloc] = locuse_
   endif

  endfor

; Make a map
  loadct, 0
  map_set, /cont, limit=[10,-160,70,-30]
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
