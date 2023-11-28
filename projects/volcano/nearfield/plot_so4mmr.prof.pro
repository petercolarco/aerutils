; Colarco
; Plot distributions of volcanic SO4 in range of weeks following eruption

; Experiments
  expids = ['VMNHL', 'VMNML', 'VMTRO', 'VMSTR', 'VMSML', 'VMSHL']
  months = ['jan','apr','jul','oct']

  for iexpid = 0, 5 do begin

  expid = expids[iexpid]
  case expid of
   'VMNHL': locstr = 'Northern Hemisphere High Latitude, Zonal Mean Sulfate mixing ratio [10!Ex!N ppbm] @ 60!Eo!NN'
   'VMNML': locstr = 'Northern Hemisphere Mid Latitude, Zonal Mean Sulfate mixing ratio [10!Ex!N ppbm] @ 45!Eo!NN'
   'VMTRO': locstr = 'Northern Hemisphere Tropics, Zonal Mean Sulfate mixing ratio [10!Ex!N ppbm] @ 15!Eo!NN'
   'VMSTR': locstr = 'Southern Hemisphere Tropics, Zonal Mean Sulfate mixing ratio [10!Ex!N ppbm] @ 15!Eo!NS'
   'VMSML': locstr = 'Southern Hemisphere Mid Latitude, Zonal Mean Sulfate mixing ratio [10!Ex!N ppbm] @ 60!Eo!NS'
   'VMSHL': locstr = 'Southern Hemisphere High Latitude, Zonal Mean Sulfate mixing ratio [10!Ex!N ppbm] @ 75!Eo!NS'
  endcase

; Set up plot
  set_plot, 'ps'
  device, file='plot_so4mmr.prof.'+expid+'01.ps', $
   /color, /helvetica, font_size=10, $
   xsize=36, ysize=18, xoff=.5, yoff=.5
  !p.font=0
; Set up a four-element array of the positions for individual panels
  position = [ [.05,.575,.45,.925], [.55,.575,.95,.925], $
               [.05,.125,.45,.475], [.55,.125,.95,.475]]

  loadct, 0
  xyouts, .05, .975, locstr, charsize=1.5, /normal  


  for imon = 0, 3 do begin

  mon = months[imon]

  case mon of
   'jan': monstr = 'January'
   'apr': monstr = 'April'
   'jul': monstr = 'July'
   'oct': monstr = 'October'
  endcase

  case expid of
   'VMNHL' : latwant = [60,60]
   'VMNML' : latwant = [45,45]
   'VMTRO' : latwant = [15,15]
   'VMSTR' : latwant = [-15,-15]
   'VMSML' : latwant = [-60,-60]
   'VMSHL' : latwant = [-75,-75]
  endcase

; Get ensemble of simulations
  cc = ['01','02','03','04','05']
  su = make_array(45,48,5,val=!values.f_nan)
  for icc = 0, 4 do begin
    filetemplate = expid+mon+cc[icc]+'.tavg3d_carma_p.ddf'
    ga_times, filetemplate, nymd, nhms, template=template
;   Pick off times in the window 
    nymd = nymd[0:44]
    nhms = nhms[0:44]
    filename=strtemplate(template,nymd,nhms)
    nc4readvar, filename, 'su', su_, lon=lon, lat=lat, lev=lev, wantlat=latwant+[-5,5], rc=rc
print, filetemplate
if(rc ne 0) then goto, jump
;   Throw out undef
    a = where(su_ gt 1e14)
    su_[a] = !values.f_nan
;   Convert sulfate mmr to ppbm
    su_ = su_*1e9
;   Zonally average
    su[*,*,icc] = transpose(mean(mean(su_,dim=1,/nan),dim=1,/nan))
jump:
   endfor
   su = mean(su,dim=3,/nan)
   loadct, 0
   levels=findgen(8)*.5-1

   red   = [255,247,217,173,120,65,35,0,    152, 0]
   green = [255,252,240,221,198,171,132,90, 152, 0]
   blue  = [229,185,163,142,121,93,67,50,   152, 0]
   tvlct, red, green, blue
   iblack = n_elements(red)-1
   igrey  = n_elements(red)-2
   dcolors = indgen(n_elements(levels))

   contour, alog10(su[*,*]), findgen(45), lev, /noerase, $
            yrange=[1000,1], /ylog, ytitle='altitude [hPa]', $
            xrange=[0,45], xstyle=1, xtitle='Days since eruption', $
            lev=levels, c_col=dcolors, /fill, color=iblack, $
            position=position[*,imon]

   contour, /over, alog10(su[*,*]), findgen(45), lev, $
           lev=[0], c_col=iblack, c_thick=2

   xyouts, position[0,imon]+(position[2,imon]-position[0,imon])/2.,$
           position[3,imon]+.01, monstr, /normal, color=iblack, align=0.5, chars=1.25

  endfor

  loadct, 0
  makekey, .25, .025, .5, .03, 0, -.02, align=0, charsize=1, $
           color=make_array(8,val=0), $
           label=['-1','-0.5','0','0.5','1','1.5','2','2.5']
  tvlct, red, green, blue
  makekey, .25, .025, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','']

  device, /close

endfor


end
