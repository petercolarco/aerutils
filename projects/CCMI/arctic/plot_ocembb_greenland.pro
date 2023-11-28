; Plot the monthly mean AOT over Greenland

  red   = [49,69,116,171,224,255,254,253,244,215,165, 152, 0]
  green = [54,117,173,217,243,255,224,174,109,48,0  , 152, 0]
  blue  = [149,180,209,233,248,191,144,97,67,39,38  , 152, 0]
  tvlct, red, green, blue
  levels = [-2000.,-25,-15,-10,-5,-1,1,5,10,15,25]
  labels = string(levels,format='(i3)')
  labels[0] = ' '
  dcolors=indgen(n_elements(levels))
  igrey  = n_elements(red)-2
  iblack = n_elements(red)-1

; Data file
  dir = '/misc/prc14/colarco/CCMI/ref_c2_h53/ccmi_mon2d/'
  filename = dir +  'ref_c2_h53.ccmi_mon2d.monthly.201207.nc4'
  nc4readvar, filename, ['ocem001','ocem002'], oc12, lon=lon, lat=lat, /sum
  nc4readvar, filename, ['oceman'], oc12_, lon=lon, lat=lat, /sum
  oc12 = oc12-oc12_
  filename = dir +  'ref_c2_h53.ccmi_mon2d.monthly.201307.nc4'
  nc4readvar, filename, ['ocem001','ocem002'], oc13, lon=lon, lat=lat, /sum
  nc4readvar, filename, ['oceman'], oc13_, lon=lon, lat=lat, /sum
  oc13 = oc13-oc13_
  area, lon, lat, nx, ny, dx, dy, area, grid='b'

; convert the units
  oc = (oc12-oc13)*31.*86400*1000.  ; g m-2
  
  
  set_plot, 'ps'
  device, file='ref_c2_h53.ocembb.201207_201307.ps', font_size=14, /helvetica, /color, $
   xsize=12, ysize=16, xoff=.5, yoff=.5
  !p.font=0
  map_set, /stereo, 75, -45, /iso, limit=[55,-180,85,180], /hires, $
   position=[.05,.2,.95,.9]
  plotgrid, oc, levels, dcolors, lon, lat, dx, dy, /map
  map_continents, /hires, color=iblack
  map_grid, color=igrey, glinestyle=2, glinethick=.5

  loadct, 0
  makekey, .05, .15, .9, .03, 0, -.025, $
     color=make_array(11,val=0), $
     label=labels, $
     charsize=.7, align=.5

  tvlct, red, green, blue
  makekey, .05, .15, .9, .03, 0, -.025, $
     color=dcolors[0:10], bcolor=iblack, $
     label=make_array(11,val=' ')
   

  

  device, /close

end

