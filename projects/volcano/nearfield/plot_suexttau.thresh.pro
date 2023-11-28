; Colarco
; Plot distributions of volcanic SO2 in range of weeks following eruption

; Set a threshold AOT value
  aotthresh = 0.1

; Experiments
  expid = ['VMNHL', 'VMNML', 'VMTRO', 'VMSTR', 'VMSML', 'VMSHL']

  months = ['jan','apr','oct','jul']
  for imon = 0, 3 do begin

  mon = months[imon]

  case mon of
   'jan': monstr = 'January'
   'apr': monstr = 'April'
   'jul': monstr = 'July'
   'oct': monstr = 'October'
  endcase

  for iper = 0, 2 do begin

  case iper of
   0: begin
      range=indgen(112)
      filetag = '0_2'
      titlestr = 'Weeks 0 - 2 Frequency of volcanic AOD > 0.1, '
      end
   1: begin
      range=indgen(112)+112
      filetag = '2_4'
      titlestr = 'Weeks 2 - 4 Frequency of volcanic AOD > 0.1, '
      end
   2: begin
      range=indgen(112)+224
      filetag = '4_6'
      titlestr = 'Weeks 4 - 6 Frequency of volcanic AOD > 0.1, '
      end
  endcase
      

  nexpid = n_elements(expid)
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  suthresh = make_array(nx,ny,nexpid,val=0.)
  for iexpid = 0, nexpid-1 do begin
    print, expid[iexpid]
    filetemplate = expid[iexpid]+mon+'01.tavg2d_carma_x.ddf'
    ga_times, filetemplate, nymd, nhms, template=template
;   Pick off times in the window 
    nymd = nymd[range]
    nhms = nhms[range]
    filename=strtemplate(template,nymd,nhms)
    nc4readvar, filename, 'suexttau', su, lon=lon, lat=lat
    nt = n_elements(nymd)
    a = where(su gt aotthresh)
    b = where(su le aotthresh)
    su[a] = 1.
    su[b] = 0.
    suthresh[*,*,iexpid] = total(su,3)
  endfor
; Make it a fraction
  suthresh = suthresh/(nt*1.)

; Make a plot of the distribution of SO2 at the half point
  set_plot, 'ps'
  device, file='plot_suexttau.'+mon+'01.thresh.weeks'+filetag+'.ps', $
   /color, /helvetica, font_size=10, $
   xsize=40, ysize=18, xoff=.5, yoff=.5
  !p.font=0
; Set up a six-element array of the positions for individual panels
  position = [ [.05,.55,.325,.9], [.375,.55,.65,.9], [.7,.55,.975,.9], $
               [.05,.15,.325,.5], [.375,.15,.65,.5], [.7,.15,.975,.5] ]

  loadct, 0
  levels=[0.01,0.02,0.05,0.1,0.2,0.3,0.5,0.8]

  red   = [255,247,217,173,120,65,35,0,    152, 0]
  green = [255,252,240,221,198,171,132,90, 152, 0]
  blue  = [229,185,163,142,121,93,67,50,   152, 0]
  tvlct, red, green, blue
  iblack = n_elements(red)-1
  igrey  = n_elements(red)-2
  dcolors = indgen(n_elements(levels))
  p0 = 0
  p1 = 0
  geolimits = [-90,-180,90,180]

  for iexpid = 0, nexpid-1 do begin
   case expid[iexpid] of
   'VMNHL': locstr = 'Northern Hemisphere High Latitude'
   'VMNML': locstr = 'Northern Hemisphere Mid Latitude'
   'VMTRO': locstr = 'Northern Hemisphere Tropics'
   'VMSTR': locstr = 'Southern Hemisphere Tropics'
   'VMSML': locstr = 'Southern Hemisphere Mid Latitude'
   'VMSHL': locstr = 'Southern Hemisphere High Latitude'
   endcase
print, iexpid
   plot_map, suthresh[*,*,iexpid], lon, lat, dx, dy, levels, dcolors, $
             position[*,iexpid], iblack, p0=p0, p1=p1, limits=geolimits, $
             textcolor=iblack
   xyouts, position[0,iexpid]+(position[2,iexpid]-position[0,iexpid])/2.,$
           position[3,iexpid], locstr, /normal, color=iblack, align=0.5, chars=1.25
  endfor

  xyouts, .5, .95, titlestr+monstr+' eruption', $
          /normal, align=.5, chars=1.75, color=iblack

  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.02, align=0, charsize=1, $
           color=make_array(8,val=0), $
           label=['0.01','0.02','0.05','0.1','0.2','0.3','0.5','0.8']
  tvlct, red, green, blue
  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','']

  device, /close

endfor
endfor


end
