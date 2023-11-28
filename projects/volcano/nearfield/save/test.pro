  set_plot, 'ps'
  device, file='plot_so2volc.half.ps', $
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
   plot_map, so2half[*,*,iexpid], lon, lat, dx, dy, levels, dcolors, $
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
