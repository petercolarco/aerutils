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
  filename = '/misc/prc13/MERRA2/d5124_m2_jan10/Y2012/M06/d5124_m2_jan10.tavg1_2d_aer_Nx.monthly.201206.nc4'
  nc4readvar, filename, 'ocembb', oc12, lon=lon, lat=lat
  filename = '/misc/prc13/MERRA2/d5124_m2_jan10/Y2013/M06/d5124_m2_jan10.tavg1_2d_aer_Nx.monthly.201306.nc4'
  nc4readvar, filename, 'ocembb', oc13, lon=lon, lat=lat
  area, lon, lat, nx, ny, dx, dy, area, grid='d'

; convert the units
  oc = (oc12-oc13)*31.*86400*1000.  ; g m-2
  
  
  set_plot, 'ps'
  device, file='MERRA2.ocembb.201206_201306.ps', font_size=14, /helvetica, /color, $
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

