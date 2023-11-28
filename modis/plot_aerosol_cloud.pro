; Colarco, Jan 2010
; Redo for figure 13 in GEOS-4 paper
; Plot model aerosol, masked model aerosol, model cloud, and MODIS cloud for a single day
; MODIS cloud is from the Giovanni MODIS day+night cloud file

  yyyy = '2000'
  mm   = '06'
  dd   = '05'
  date = yyyy+mm+dd

; Get the model aot
  modelfile = '/misc/prc10/colarco/t003_c32/tau/Y'+yyyy+'/M'+mm+'/t003_c32.tau2d.v2.SSo2.total.'+date+'.hdf'
  ga_getvar, modelfile, 'aodtau', aodtau, lon=lon, lat=lat, wantlev=['5.5e-7'], time=time

; Get the model cloud fraction
  modelfile = '/misc/prc10/colarco/t003_c32/diag/Y'+yyyy+'/M'+mm+'/t003_c32.chem_diag.sfc.'+date+'.hdf'
  ga_getvar, modelfile, 'cldtot', modelcldtot, lon=lon, lat=lat, wantlev=['5.5e-7'], time=time

; Get the corresponding MODIS aerosol files
  modisocn = '/misc/prc10/MODIS/Level3/MOD04/c4/GRITAS/Y2000/M06/MOD04_L2_ocn.aero_005.qawt.20000605.hdf'
  ga_getvar, modisocn, 'aodtau', modocn, lon=lon, lat=lat, wantlev=['550'], time=time
  modislnd = '/misc/prc10/MODIS/Level3/MOD04/c4/GRITAS/Y2000/M06/MOD04_L2_lnd.aero_005.qawt.20000605.hdf'
  ga_getvar, modislnd, 'aodtau', modlnd, lon=lon, lat=lat, wantlev=['550'], time=time

; Create the data arrays for aerosol products
  nx = n_elements(lon)
  ny = n_elements(lat)
  aodtau = reform(aodtau)
  modocn = reform(modocn)
  modlnd = reform(modlnd)
  modeltau = fltarr(nx,ny)
  modeltau = total(aodtau,3)/4.
  a = where(modocn gt 1e14)
  modocn[a] = !values.f_nan
  a = where(modlnd gt 1e14)
  modlnd[a] = !values.f_nan
  modistau = fltarr(nx,ny,4)
  for it = 0, 3 do begin
   for iy = 0, ny-1 do begin
    for ix = 0, nx-1 do begin
     modistau[ix,iy,it]= mean([modocn[ix,iy,it],modlnd[ix,iy,it]],/nan)
    endfor
   endfor
  endfor

  a = where(finite(modistau) ne 1)
  aodtau_sampled = aodtau
  aodtau_sampled[a] = !values.f_nan
  modeltau_sampled = fltarr(nx,ny)
  for iy = 0, ny-1 do begin
   for ix = 0, nx-1 do begin
    modeltau_sampled[ix,iy] = mean(aodtau_sampled[ix,iy,*],/nan)
   endfor
  endfor

; Now make the plots
  set_plot, 'ps'
  device, file='plot_aerosol_cloud.ps', /color, /helvetica, font_size=14, $
          xoff=.5, yoff=.5, xsize=25, ysize=20
  !p.font=0


; position the plots
  position = fltarr(4,4)
  position[*,0] = [.05,.555,.45,.905]
  position[*,1] = [.55,.555,.95,.905]
  position[*,2] = [.05,.03,.45,.38]
  position[*,3] = [.55,.03,.95,.38]


  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  loadct, 39
  levelArray = [.02,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.]
  labelArray = ['0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0']
  colorArray = [30,64,80,96,144,176,192,199,208,254,10]

  map_set, position=position[*,0], /noborder
  plotgrid, modeltau, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, position = position[*,0]
  xyouts, position[0,0], position[3,0]+.03, 'Model AOT [June 5, 2000]', /normal, charsize=.8
  map_grid, /box, charsize=.8


  map_set, position=position[*,2], /noborder, /noerase
  plotgrid, modeltau_sampled, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan , /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, position = position[*,2]
  xyouts, position[0,2], position[3,2]+.03, 'Model AOT (MODIS Terra sampled) [June 5, 2000]', /normal, charsize=.8
  map_grid, /box, charsize=.8

  makekey, .05, .465, .4, .025, 0, -.02, color=colorarray, label=labelarray, $
   align=0, charsize=.65

  map_set, position=position[*,1], /noborder, /noerase
  plotgrid, modelcldtot, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, position = position[*,1]
  xyouts, position[0,1], position[3,1]+.03, 'Model Cloud Fraction [June 5, 2000]', /normal, charsize=.8
  map_grid, /box, charsize=.8

; Read the MODIS Cloud mask data
  cdfid = ncdf_open('/misc/prc10/MODIS/Level3/MOD08_D3.A2000157.005.2006253132724.ss000500113870.Cloud_Fraction_Mean.G3.nc')
   id = ncdf_varid(cdfid,'lon')
   ncdf_varget, cdfid, id, lon
   id = ncdf_varid(cdfid,'lat')
   ncdf_varget, cdfid, id, lat
   id = ncdf_varid(cdfid,'Cloud_Fraction_Mean')
   ncdf_varget, cdfid, id, modiscldtot
  ncdf_close, cdfid
  dx = 1.
  dy = 1.

  map_set, position=position[*,3], /noborder, /noerase
  plotgrid, modiscldtot, levelarray, colorarray, lon, lat, dx, dy, undef=!values.f_nan, /map
  map_continents, color=0, thick=5
  map_continents, color=0, thick=1, /countries
  map_set, /noerase, position = position[*,1]
  xyouts, position[0,3], position[3,3]+.03, 'MODIS Cloud Fraction [June 5, 2000]', /normal, charsize=.8
  map_grid, /box, charsize=.8


  makekey, .55, .465, .4, .025, 0, -.02, color=colorarray, label=labelarray, $
   align=0, charsize=.65

  device, /close


end
