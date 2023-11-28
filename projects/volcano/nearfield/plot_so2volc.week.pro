; Colarco
; Plot distributions of sulfate a week out from peak of eruption

; Experiments
  expid = ['VMNHL', 'VMNML', 'VMTRO', 'VMSTR', 'VMSML', 'VMSHL']
  mon = 'jul'
  nexpid = n_elements(expid)
  area, lon, lat, nx, ny, dx, dy, area, grid='b'
  so2half = fltarr(nx,ny,nexpid)
  for iexpid = 0, nexpid-1 do begin
    print, expid[iexpid]
    filetemplate = expid[iexpid]+mon+'01.tavg2d_aer_x.ddf'
    ga_times, filetemplate, nymd, nhms, template=template
    nymd = nymd[0:100]
    nhms = nhms[0:100]
    filename=strtemplate(template,nymd,nhms)
    nc4readvar, filename, 'so2cmassvolc', su, lon=lon, lat=lat
    if(iexpid eq 0) then begin
       nt = n_elements(filename)
       so2v = make_array(nt,nexpid,val=0.)
       imax = intarr(nexpid)
       ihmax = intarr(nexpid)
    endif
    for it = 0, nt-1 do begin
       so2v[it,iexpid] = total(su[*,*,it]*area)/1.e9 ; Tg
    endfor
    imax[iexpid] = where(so2v[*,iexpid] eq max(so2v[*,iexpid]))
    ihmax[iexpid] = imax[iexpid]+56  ; 7*8 time steps forward
    so2half[*,*,iexpid] = su[*,*,ihmax[iexpid]]
  endfor
jump:

; Make a plot of the distribution of SO2 at the half point
  set_plot, 'ps'
  device, file='plot_so2volc.'+mon+'01.week.ps', $
   /color, /helvetica, font_size=10, $
   xsize=40, ysize=18, xoff=.5, yoff=.5
  !p.font=0
; Set up a six-element array of the positions for individual panels
  position = [ [.05,.6,.325,.95], [.375,.6,.65,.95], [.7,.6,.975,.95], $
               [.05,.15,.325,.5], [.375,.15,.65,.5], [.7,.15,.975,.5] ]

  loadct, 0
  levels=[1,2,5,10,20,50,100,200]/1e6

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
print, iexpid
   title = string((ihmax[iexpid]-imax[iexpid])/8,format='(i4)')
   plot_map, so2half[*,*,iexpid], lon, lat, dx, dy, levels, dcolors, $
             position[*,iexpid], iblack, p0=p0, p1=p1, limits=geolimits, $
             textcolor=iblack
   xyouts, position[0,iexpid], position[1,iexpid], title, /normal, color=iblack
  endfor

  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.02, align=0, charsize=1, $
           color=make_array(8,val=0), $
           label=['1','2','5','10','20','50','100','200']
  tvlct, red, green, blue
  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','']

  device, /close



; Do SO4
  so4half = fltarr(nx,ny,nexpid)
  for iexpid = 0, nexpid-1 do begin
    print, expid[iexpid]
    filetemplate = expid[iexpid]+mon+'01.tavg2d_carma_x.ddf'
    ga_times, filetemplate, nymd, nhms, template=template
    nymd = nymd[ihmax[iexpid]]
    nhms = nhms[ihmax[iexpid]]
    filename=strtemplate(template,nymd,nhms)
    nc4readvar, filename, 'sucmass', su, lon=lon, lat=lat
    if(iexpid eq 0) then begin
       nt = n_elements(filename)
       so4v = make_array(nt,nexpid,val=0.)
    endif
    for it = 0, nt-1 do begin
       so4v[it,iexpid] = total(su[*,*,it]*area)/1.e9 ; Tg
    endfor
    so4half[*,*,iexpid] = su[*,*,0]
  endfor


; Make a plot of the distribution of SO4 at the half point
  set_plot, 'ps'
  device, file='plot_so4volc.'+mon+'01.week.ps', $
   /color, /helvetica, font_size=10, $
   xsize=40, ysize=18, xoff=.5, yoff=.5
  !p.font=0
; Set up a six-element array of the positions for individual panels
  position = [ [.05,.6,.325,.95], [.375,.6,.65,.95], [.7,.6,.975,.95], $
               [.05,.15,.325,.5], [.375,.15,.65,.5], [.7,.15,.975,.5] ]

  loadct, 0
  levels=[1,2,5,10,20,50,100,200]/1e6

  red   = [255,237,199,127,65,29,34,12,    152, 0]
  green = [255,248,233,205,182,145,94,44,  152, 0]
  blue  = [217,177,180,187,196,192,168,132,152, 0]
  tvlct, red, green, blue
  iblack = n_elements(red)-1
  igrey  = n_elements(red)-2
  dcolors = indgen(n_elements(levels))
  p0 = 0
  p1 = 0
  geolimits = [-90,-180,90,180]

  for iexpid = 0, nexpid-1 do begin
print, iexpid
   plot_map, so4half[*,*,iexpid], lon, lat, dx, dy, levels, dcolors, $
             position[*,iexpid], iblack, p0=p0, p1=p1, limits=geolimits, $
             textcolor=iblack, title=title, format='(f6.3)', varunits=' W m!E-2!N'
  endfor

  loadct, 0
  makekey, .25, .07, .5, .03, 0, -.02, align=0, charsize=1, $
           color=make_array(8,val=0), $
           label=['1','2','5','10','20','50','100','200']
  tvlct, red, green, blue
  makekey, .25, .07, .5, .03, 0, -.02, color=dcolors, /noborder, $
     label=['','','','','','','','','','','']

  device, /close


end
