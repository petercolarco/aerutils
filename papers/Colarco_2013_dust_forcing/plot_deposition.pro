; Colarco, June 2010
; Presumes already ran mon-budget script across years desired
; in order to get budget tables
; Specify experiment ID and all years to run across
; Specify "draft = 1" in order to write info about experiment on
; plot


nsites = 84 ;#of depo sites
site_names = strarr(nsites)
lats = fltarr(nsites)
lons = fltarr(nsites)
obs_dep = fltarr(nsites)
obs_years = strarr(nsites)
grid_area = fltarr(nsites)
	       
;get the depo sites, locations, and data first
line = ''
depo_file = '/misc/prc17/epnowott/surface_mass/deposition/data/DustDepo_AllDataSet_ed.txt'
openr, lun, depo_file, /get_lun
  readf, lun, line
  temp = strsplit(line, '  ', /extract)
  for n=0, nsites-1 do begin
    readf, lun, line
    temp = strsplit(line, ' ', /extract)
    site_names[n] = temp[1]
    obs_dep[n] = temp[4]
    obs_years[n] = temp[5]
    lats[n] = temp[2]
    lons[n] = temp[3]
  endfor
free_lun, lun  

; Model Data
; Get the lifetimes
  expid = ['b_F25b9-base-v1',$      ; no forcing
           'bF_F25b9-base-v1', $    ; OPAC-Spheres
           'bF_F25b9-base-v11', $   ; OPAC-Spheroids
           'bF_F25b9-base-v7', $    ; OPAC-Ellipsoids
           'bF_F25b9-base-v6', $    ; Shettle/Fenn-Spheres
           'bF_F25b9-base-v5', $    ; Shettle/Fenn-Spheroids
           'bF_F25b9-base-v8', $    ; OBS (Colarco/Kim) - Spheres
           'bF_F25b9-base-v10' ]    ; OBS (Colarco/Kim) - Ellipsoids

  nexpid = n_elements(expid)
  years = strcompress(string(2011 + indgen(40)),/rem)
  draft = 0 ; suppress experiment information on plot
  nexp = n_elements(expid)

  mod_dust_dep = fltarr(nsites, nexp)*!values.f_nan



;get area
filename = '/misc/prc14/colarco/'+expid[0]+'/tavg2d_carma_x/'+expid[0]+'.tavg2d_carma_x.monthly.clim.M01.nc4'
ga_getvar, filename, 'duexttau', temp, lat=lat, lon=lon
nlat = n_elements(lat)
nlon = n_elements(lon)
dx = lon[1]-lon[0]
dy = lat[1]-lat[0]
area, lon, lat, nlon, nlat, dx, dy, area
for n=0, nsites-1 do begin
  a = where(lon ge lons[n])
  b = where(lat ge lats[n])
  grid_area[n] = area[a[0],b[0]]
endfor 
;goto, jump
;for iex = 0, 0 do begin
for iex = 0, n_elements(site_names)-1 do begin


  print, site_names[iex]


; Dust
  tdef = 'tdef time 1 linear 9z1jan2011 1mo'
  filename = '/misc/prc14/colarco/'+expid[0]+'/tavg2d_carma_x/'+expid[0]+'.tavg2d_carma_x.monthly.clim.M%m2.nc4'
  nc4readvar, filename, 'dusd', dusd, nymd=nymd, rc=rc, tdef=tdef, $
              wantlon=lons[iex], wantlat=lats[iex]
  nc4readvar, filename, 'duwt', duwt, nymd=nymd, rc=rc, tdef=tdef, $
              wantlon=lons[iex], wantlat=lats[iex]
  nc4readvar, filename, 'dusv', dusv, nymd=nymd, rc=rc, tdef=tdef, $
              wantlon=lons[iex], wantlat=lats[iex]	      
  nc4readvar, filename, 'dudp', dudp, nymd=nymd, rc=rc, tdef=tdef, $
              wantlon=lons[iex], wantlat=lats[iex]
  
  mod_dust_dep[iex,0] = total(dusd+duwt+dusv+dudp)
 
  if(nexpid gt 1) then begin
   !quiet = 1L
   for iexpid = 1, nexpid-1 do begin
    tdef = 'tdef time 1 linear 9z1jan2011 1mo'
    filename = '/misc/prc14/colarco/'+expid[iexpid]+'/tavg2d_carma_x/'+expid[iexpid]+'.tavg2d_carma_x.monthly.clim.M%m2.nc4'
    nc4readvar, filename, 'dusd', dusd, nymd=nymd, rc=rc, tdef=tdef, $
                wantlon=lons[iex], wantlat=lats[iex]
    nc4readvar, filename, 'duwt', duwt, nymd=nymd, rc=rc, tdef=tdef, $
                wantlon=lons[iex], wantlat=lats[iex]
    nc4readvar, filename, 'dusv', dusv, nymd=nymd, rc=rc, tdef=tdef, $
                wantlon=lons[iex], wantlat=lats[iex]	      
    nc4readvar, filename, 'dudp', dudp, nymd=nymd, rc=rc, tdef=tdef, $
                wantlon=lons[iex], wantlat=lats[iex]

    mod_dust_dep[iex,iexpid] = total(dusd+duwt+dusv+dudp)

   endfor
 endif		
  
endfor

mod_dust_dep = mod_dust_dep*1000.*3600*24*30*12

jump:
;  North Pacific=150, South Pacific=50, Atlantic=250, Indian=20, Ant=0
  colorarray = intarr(nsites)+250
  site_num = ['1','2','a','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','A','18','19','20', $
   	      'b','21','22','23','24','B','25','26','27','C','28','29','30','31','32','33','34','35','36','37','38', $
   	      '39','D','40','41','E','42','F','43','44','45','46','47','G','48','49','50','51','52','53','54','55', $
   	      'H','56','I','57','58','59','60','61','J','62','63','64','65','66','67','68','c','d','e','f']
  
  coloruse = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,50,50,200,50,50,250,250,50,150,250, $
  	      150,150,250,20,150,250,150,20,20,20,20,20,250,250,250,250,250,150,250, $
	      250,250,250,150,250,250,150,20,250,250,250,250,250,250,150,250,250,150, $
	      150,150,250,250,150,250,250,250,250,150,150,250,250,150,250,250,250,250,250,250] 	       
    
  ;make a map
  set_plot, 'ps'
  device, filename='depo.map.eps', /color, /helvetica, font_size=12, $
          xsize=12, xoff=.5, ysize=10, yoff=.5, /encap
  !p.font=0
  loadct, 39
  map_set,/continents,/grid,limit=[-80,-180,80,180], position=[0.1,0.15,0.9,0.85]
  map_grid, /box_axes
  map_continents, thick=3
  for n=0, nsites-1 do begin
    xyouts, lons[n], lats[n], site_num[n], color=coloruse[n], charthick=4, charsize=.8
  endfor
  xyouts, .5, .94, 'Deposition Site Locations', /normal, charsize=1.2, align=.5
  device, /close
stop
;
  for iexpid=0, nexpid-1 do begin
     
   fname = './'+expid[iexpid]+'.dep.txt' 
   openw, lun, fname, /get_lun
    
    set_plot, 'ps'
    device, file = './plot_depo.scatter.'+expid[iexpid]+'.num.eps', /color, /helvetica, $
      font_size=12, xsize=12, xoff=.5, ysize=10, yoff=.5, /encap
    !P.font=0
    loadct, 39
    plot, obs_dep[*], mod_dust_dep[*,0], /nodata, $
      xtitle = 'Observed Dust Deposition [g m!u-2!n yr!u-1!n]', $
      ytitle = 'Model Dust Deposition [g m!u-2!n yr!u-1!n]', $
      xrange = [1.e-4,1.e4], xstyle=1, $
      yrange = [1.e-4,1.e4], ystyle=1, /xlog, /ylog
    ;get 1 to 1
    onetoone = [1.e-4,1.e4]
    oplot, onetoone, onetoone, thick=5
    oplot, [10.e-4,1.e4], [1.e-4,.1e4], thick=5, linestyle=2
    oplot, [1.e-4,.1e4], [10.e-4,1.e4], thick=5, linestyle=2
    for n=0, nsites-1 do begin 
       print, mod_dust_dep[n,iexpid]
       printf, lun, mod_dust_dep[n,iexpid],format='(F8.4)'
      xyouts, obs_dep[n], mod_dust_dep[n,iexpid], site_num[n], color=coloruse[n], charsize=.6
;      degrees = lats[n]
;      d2dms, degrees=degrees, dms_out=dms_out
;      lat_ = dms_out
;      degrees = lons[n]
;      d2dms, degrees=degrees, dms_out=dms_out
;      lon_ = dms_out
;      print, site_names[n]
;      print, lat_
;      print, lon_
;      print, obs_dep[n]
;      print, mod_dust_dep[n,1]
    endfor
  free_lun, lun  
    device, /close
  endfor


end
