; Colarco, June 2010
; Presumes already ran mon-budget script across years desired
; in order to get budget tables
; Specify experiment ID and all years to run across
; Specify "draft = 1" in order to write info about experiment on
; plot


nsites = 30 ;#of AEROCE sites
site_names = strarr(nsites)
lats = fltarr(nsites)
lons = fltarr(nsites)
dust_conc = fltarr(12,nsites)
var_dust_conc = fltarr(12,nsites)
ann_dust = fltarr(nsites)


site_titles = ['Chatham Island', 'Cape Point', 'Cape Grim', $
 	       'Invercargill', 'Marsh King George Island', $
	       'Marion Island', 'Nawson Antarctica', 'Palmer Station Antarctica', $
	       'Reunion Island', 'Wellington Baring Head', 'Yate New Caldedonia', $
	       'Funafuti Tuvalu', 'Nauru', 'Norfolk Island', 'Rarotonga Cook Islands', $
	       'American Samoa', 'Midway Island', 'Oahu Hawaii', 'Cheju', 'Hedo', $
	       'Fanning Island', 'Enewetak Atoll', 'Ragged Point Barbados', $
	       'Izana Tenerife', 'Bermuda', 'Heimaey', 'Mace Head', 'Miami', $
	       'Jabirun', 'Rukomechi']

ymax = [1., 3., 4., 2., 2., .5, .5, 2., .5, 1.5,$
        1., 1., .5, 6., .5, .75, 5.5, 4., $
        45., 45., .5, 1., 120., 240., $
	30., 2., 3., 60., 35., 12.] 
	       
;get the AEROCE sites, locations, and data first
line = ''
aeroce_file = './conc_aeroce.prn.txt'
openr, lun, aeroce_file, /get_lun
  for s=0, nsites-1 do begin
    readf, lun, line
    temp = strsplit(line, ' ', /extract)
    site_names[s] = temp[0]
    readf, lun, line
    readf, lun, line
    temp = strsplit(line, ' ', /extract)
    lat_ = temp[0]
    temp_ = strsplit(lat_, '°', /extract)
    lats[s] = temp[0]
    if (temp_[1] eq 'S') then begin
      lats[s] = -lats[s]
    endif
    lon_ = temp[1]
    temp_ = strsplit(lon_, '°', /extract)
    lons[s] = temp[1]
    if (temp_[1] eq 'W') then begin
      lons[s] = -lons[s]
    endif    
    readf, lun, line
    readf, lun, line
    readf, lun, line
    temp = strsplit(line, ' ', /extract)
    a = where(temp eq 'Dust')
    readf, lun, line
    for i=0, 11 do begin
      readf, lun, line
      readf, lun, line
      temp = strsplit(line, ' ', /extract)
      dust_conc[i,s] = temp[9]
      readf, lun, line
      temp = strsplit(line, ' ', /extract)
      var_dust_conc[i,s] = temp[9]      
    endfor
    readf, lun, line
    temp = strsplit(line, ' ', /extract)
    ann_dust[s] = temp[9]
    readf, lun, line
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
  colorarray=[0, 254,254,254,84,84,208,208]
  linarray  =[0, 0,  1,  2,  0, 2, 0,  1]
  
  years = strcompress(string(2011 + indgen(40)),/rem)
  draft = 0 ; suppress experiment information on plot
;  draft = 1 ; show experiment information on plot

  nexp = n_elements(expid)
  ny = n_elements(years)

  mod_dust_ann = fltarr(nsites, nexp)*!values.f_nan

  for iex = 0, n_elements(site_names)-1 do begin

  print, site_names[iex]

  set_plot, 'ps'
  device, file = './plot_dusmass.'+expid[0]+'.'+site_names[iex]+'.eps', /color, /helvetica, $
   font_size=12, xsize=16, xoff=.5, ysize=10, yoff=.5, /encap
  !P.font=0
  loadct, 0

  xtickname = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

; Dust
  tdef = 'tdef time 12 linear 12z15jan2011 1mo'
  filename = '/misc/prc14/colarco/'+expid[0]+'/tavg2d_carma_x/'+expid[0]+'.tavg2d_carma_x.monthly.clim.M%m2.nc4'
  nc4readvar, filename, 'dusmass', dusmass, nymd=nymd, rc=rc, tdef=tdef, $
              wantlon=lons[iex], wantlat=lats[iex]
  nc4readvar, filename, 'var_dusmass', var_dusmass, nymd=nymd, rc=rc, tdef=tdef, $
              wantlon=lons[iex], wantlat=lats[iex]

;  Get 3-d info if site is elevated
  if (site_names[iex] eq 'IzanaTenerife') then begin
    file = '/misc/prc14/colarco/'+expid[0]+'/tavg3d_carma_p/'+expid[0]+'.tavg3d_carma_p.monthly.clim.M%m2.nc4'
    nc4readvar, file, 'airdens', rhoa, lev=lev, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    nc4readvar, file, 'duconc', duconc, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    nc4readvar, file, 'var_duconc', var_duconc, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    nc4readvar, file, 'ps', ps, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    
    print, file
    check, ps
    
    dusmass = fltarr(12)
    var_dusmass = fltarr(12)
    indices = intarr(12)
    duconc = reform(duconc)
    var_duconc = reform(var_duconc)
    rhoa = reform(rhoa)
    ps = reform(ps)
    lev = lev*100.
    nlev = n_elements(lev)

    duconc_ = fltarr(nlev,12)
    var_duconc_ = fltarr(nlev,12)
    rhoa_ = fltarr(nlev,12)
    lev = reverse(lev)
    for m=0, 11 do begin
      duconc_[*,m] = reverse(duconc[*,m])
      var_duconc_[*,m] = reverse(var_duconc[*,m])
      rhoa_[*,m] = reverse(rhoa[*,m])
    endfor

    z = fltarr(nlev,12)
    for m=0, 11 do begin
      delp = ps[m] - lev[0]
      dz = delp/rhoa_[0,m]/9.81
      z[0,m] = dz
      for k=1, nlev-2 do begin
        delp = lev[k]-lev[k+1]
        dz = delp/rhoa_[k,m]/9.81
        z[k,m] = z[k-1,m]+dz 
      endfor
      a = where(z[*,m] gt 2360.)
      indices[m] = a[0] 
      dusmass[m] = duconc_[indices[m],m]
      var_dusmass[m] = var_duconc_[indices[m],m]
    endfor
  endif

; Convert to ug m-3
  dusmass = dusmass*1.e9
  var_dusmass = var_dusmass*1.e9

  dusmass = [ [dusmass],[dusmass]]
  obs = [[dust_conc[*,iex]],[dust_conc[*,iex]]]
  a = where(obs lt -900)
  obs[a] = !values.f_nan
  obs_stdev = [[var_dust_conc[*,iex]],[var_dust_conc[*,iex]]]
  a = where(obs_stdev lt -900)
  obs_stdev[a] = !values.f_nan
  obs_stdev = obs_stdev/2.

  print, ymax[iex]
  
; Compute the standard deviation
  if(rc eq 0) then begin
   plot, [0,13], [0,ymax[iex]], /nodata, $
    xthick=3, ythick=3, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='Surface Dust Mass Concentration [ug m!u-3!n]', title=site_titles[iex]
   sdev = obs_stdev
   polymaxmin, indgen(12)+1, obs, color=200, fillcolor=240, lin=0, thick=12, sdev=sdev
   sdev = var_dusmass   
   polymaxmin, indgen(12)+1, dusmass[0:11,*], color=0, fillcolor=-1, lin=linarray[0], thick=9, sdev=sdev	   
  endif

;goto, jump
  if(nexpid gt 1) then begin
   !quiet = 1L
   loadct, 39
   for iexpid = 1, nexpid-1 do begin
    nyuse = ny
    nt = strpad(nyuse*12,100)
    tdef = 'tdef time 12 linear 12z15jan2011 1mo'
    filename = '/misc/prc14/colarco/'+expid[iexpid]+'/tavg2d_carma_x/'+expid[iexpid]+'.tavg2d_carma_x.monthly.clim.M%m2.nc4'
    nc4readvar, filename, 'dusmass', dusmass, nymd=nymd, rc=rc, tdef=tdef, $
                wantlon=lons[iex], wantlat=lats[iex]
    nc4readvar, filename, 'var_dusmass', var_dusmass, nymd=nymd, rc=rc, tdef=tdef, $
                wantlon=lons[iex], wantlat=lats[iex]


;  Get 3-d info if site is elevated
  if (site_names[iex] eq 'IzanaTenerife') then begin
    file = '/misc/prc14/colarco/'+expid[iexpid]+'/tavg3d_carma_p/'+expid[iexpid]+'.tavg3d_carma_p.monthly.clim.M%m2.nc4'
    nc4readvar, file, 'airdens', rhoa, lev=lev, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    nc4readvar, file, 'duconc', duconc, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    nc4readvar, file, 'var_duconc', var_duconc, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    nc4readvar, file, 'ps', ps, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    
    ;print, file
    ;check, ps
    
    dusmass = fltarr(12)
    var_dusmass = fltarr(12)
    indices = intarr(12)
    duconc = reform(duconc)
    var_duconc = reform(var_duconc)
    rhoa = reform(rhoa)
    ps = reform(ps)
    lev = lev*100.
    nlev = n_elements(lev)

    duconc_ = fltarr(nlev,12)
    var_duconc_ = fltarr(nlev,12)
    rhoa_ = fltarr(nlev,12)
    lev = reverse(lev)
    for m=0, 11 do begin
      duconc_[*,m] = reverse(duconc[*,m])
      var_duconc_[*,m] = reverse(var_duconc[*,m])
      rhoa_[*,m] = reverse(rhoa[*,m])
    endfor

    z = fltarr(nlev,12)
    for m=0, 11 do begin
      delp = ps[m] - lev[0]
      dz = delp/rhoa_[0,m]/9.81
      z[0,m] = dz
      for k=1, nlev-2 do begin
        delp = lev[k]-lev[k+1]
        dz = delp/rhoa_[k,m]/9.81
        z[k,m] = z[k-1,m]+dz 
      endfor
      a = where(z[*,m] gt 2360.)
      indices[m] = a[0] 
      dusmass[m] = duconc_[indices[m],m]
      var_dusmass[m] = var_duconc_[indices[m],m]
    endfor
  endif

;   Convert to ug m-3		
    dusmass = dusmass*1.e9
    var_dusmass = var_dusmass*1.e9       		
    dusmass = [ [dusmass],[dusmass]]
    sdev = var_dusmass
    
;    a = where(dusmass[0:11,0] gt ymax[iex])
;    if (a[0] ne -1) then begin
;      print, site_names[iex], max(dusmass[a,0])
;    endif       
    if(rc eq 0) then $
     polymaxmin, indgen(12)+1, dusmass[0:11,*], fillcolor=-1, color=colorarray[iexpid], $
                 lin=linarray[iexpid], thick=6, sdev=sdev
		 	
	 
;if(iexpid eq nexpid-1) then dusmass7 = dusmass[5,0]
   endfor
  endif
jump:

   loadct, 0
   polymaxmin, indgen(12)+1, obs, color=200, fillcolor=-1, lin=0, thick=12

  device, /close  





;get annual info and make scatter plot
    ; Dust
    tdef = 'tdef time 1 linear 9z1jan2011 1mo' 
    filename = '/misc/prc14/colarco/'+expid[0]+'/tavg2d_carma_x/'+expid[0]+'.tavg2d_carma_x.monthly.clim.ANN.nc4'
    nc4readvar, filename, 'dusmass', dusmass, nymd=nymd, rc=rc, tdef=tdef, $
                wantlon=lons[iex], wantlat=lats[iex]
    nc4readvar, filename, 'var_dusmass', var_dusmass, nymd=nymd, rc=rc, tdef=tdef, $
                wantlon=lons[iex], wantlat=lats[iex]


  ;  Get 3-d info if site is elevated
    if (site_names[iex] eq 'Izana') then begin
      tdef = 'tdef time 1 linear 9z1jan2011 1mo'    
      file = '/misc/prc14/colarco/'+expid[0]+'/tavg3d_carma_p/'+expid[0]+'.tavg3d_carma_p.monthly.clim.ANN.nc4'
      nc4readvar, file, 'airdens', rhoa, lev=lev, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
      nc4readvar, file, 'duconc', duconc, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
      nc4readvar, file, 'var_duconc', var_duconc, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
      nc4readvar, file, 'ps', ps, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    
      duconc = reform(duconc)
      var_duconc = reform(var_duconc)
      rhoa = reform(rhoa)
      ps = reform(ps)
      lev = lev*100.
      nlev = n_elements(lev)

      duconc_ = reverse(duconc)
      var_duconc_ = reverse(var_duconc)
      rhoa_ = reverse(rhoa)
      lev = reverse(lev)

      z = fltarr(nlev)
      delp = ps - lev[0]
      dz = delp/rhoa_[0]/9.81
      z[0] = dz
      for k=1, nlev-2 do begin
        delp = lev[k]-lev[k+1]
        dz = delp/rhoa_[k]/9.81
        z[k] = z[k-1]+dz 
      endfor
      a = where(z[*] gt 2360.)
      index = a[0] 
      dusmass = duconc_[index]
      var_dusmass = var_duconc_[index]
    endif

  ; Convert to ug m-3
    dusmass = dusmass*1.e9
    var_dusmass = var_dusmass*1.e9
    
    mod_dust_ann[iex,0] = dusmass
    
    
  ;goto, jump
    if(nexpid gt 1) then begin
     !quiet = 1L
     loadct, 39
   
   for iexpid = 1, nexpid-1 do begin
      nyuse = ny
      nt = strpad(nyuse*12,100)
      tdef = 'tdef time 1 linear 9z1jan2011 1mo' 
    filename = '/misc/prc14/colarco/'+expid[iexpid]+'/tavg2d_carma_x/'+expid[iexpid]+'.tavg2d_carma_x.monthly.clim.ANN.nc4'
    nc4readvar, filename, 'dusmass', dusmass, nymd=nymd, rc=rc, tdef=tdef, $
                wantlon=lons[iex], wantlat=lats[iex]
    nc4readvar, filename, 'var_dusmass', var_dusmass, nymd=nymd, rc=rc, tdef=tdef, $
                wantlon=lons[iex], wantlat=lats[iex]

;  Get 3-d info if site is elevated
  if (site_names[iex] eq 'Izana') then begin
    tdef = 'tdef time 1 linear 9z1jan2011 1mo'  
    file = '/misc/prc14/colarco/'+expid[iexpid]+'/tavg3d_carma_p/'+expid[iexpid]+'.tavg3d_carma_p.monthly.clim.ANN.nc4'
    nc4readvar, file, 'airdens', rhoa, lev=lev, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    nc4readvar, file, 'duconc', duconc, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    nc4readvar, file, 'var_duconc', var_duconc, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    nc4readvar, file, 'ps', ps, wantlon=lons[iex], wantlat=lats[iex], tdef=tdef
    
    duconc = reform(duconc)
    var_duconc = reform(var_duconc)
    rhoa = reform(rhoa)
    ps = reform(ps)
    lev = lev*100.
    nlev = n_elements(lev)

    duconc_ = reverse(duconc)
    var_duconc_ = reverse(var_duconc)
    rhoa_ = reverse(rhoa)
    lev = reverse(lev)

    z = fltarr(nlev)
    delp = ps - lev[0]
    dz = delp/rhoa_[0]/9.81
    z[0] = dz
    for k=1, nlev-2 do begin
      delp = lev[k]-lev[k+1]
      dz = delp/rhoa_[k]/9.81
      z[k] = z[k-1]+dz 
    endfor
    a = where(z[*] gt 2360.)
    index = a[0] 
    dusmass = duconc_[index]
    var_dusmass = var_duconc_[index]
  endif

;   Convert to ug m-3		
    dusmass = dusmass*1.e9
    var_dusmass = var_dusmass*1.e9  

    mod_dust_ann[iex,iexpid] = dusmass
    
  endfor
  endif
endfor

;  colorarray=[50,50,50,50,50,150,150,150,150,150,200,200,200,200,200,250,250,250,250,250,0]
;  colorarray = [50,50,50,50,50,50,50,150,150,150,150,150,150,150,250,250,250,250,250,250,250]

;  North Pacific=150, South Pacific=50, Atlantic=250, Indian=20, Ant=0
  colorarray = [200,50,0,0,50,50,50,50,50,50,150,150,150,150,150,250,250,250,250,250,200,50]
  symarray  = [0,3,4,5,8,0,3,4,5,8,0,3,4,5,8,0,3,4,5,8,0,3]
  site_num = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22']
    
  a = where(ann_dust gt 0)
  ann_dust_good = ann_dust[a]
  max_val = 1e2
  titles_good = site_names[a]
  lats_good = lats[a]
  lons_good = lons[a]
  for iexpid=0, nexpid-1 do begin
    mod_dust_ann_good = mod_dust_ann[a,iexpid]
    ngood = n_elements(a)
    print, titles_good[iexpid], lats_good[iexpid], lons_good[iexpid], ann_dust_good[iexpid], mod_dust_ann_good 
    set_plot, 'ps'
    device, file = './plot_dusmass.scatter.'+expid[iexpid]+'.num.eps', /color, /helvetica, $
      font_size=12, xsize=16, xoff=.5, ysize=14, yoff=.5, /encap
    !P.font=0
    loadct, 39
    plot, ann_dust_good[*], mod_dust_ann_good[*], /nodata, $
      xtitle = 'Observed Dust Surface Mass Concentration [ug m!u-3!n]', $
      ytitle = 'Model Dust Surface Mass Concentration [ug m!u-3!n]', $
      xrange = [1e-3,max_val], xstyle=1, $
      yrange = [1e-3,max_val], ystyle=1, /xlog, /ylog, $
      position = [.15, .15, .9, .9]
    ;get 1 to 1
    onetoone = [.001,fix(max_val)+1.]
    oplot, onetoone, onetoone, thick=5
    oplot, [.01,fix(max_val)+1.], [.001,(fix(max_val)+1.)/10.], thick=5, linestyle=2
    oplot, [.001,(fix(max_val)+1.)/10.], [.01,fix(max_val)+1.], thick=5, linestyle=2 
    for n=0, ngood-1 do begin
      xyouts, ann_dust_good[n], mod_dust_ann_good[n], site_num[n], color=colorarray[n]
      ;plotsym, symarray[n], 1, thick=4, fill=1, color=colorarray[n]
      ;plots, ann_dust_good[n], mod_dust_ann_good[n], psym=8
    endfor
    device, /close
  endfor

  print, lats_good
  print, lons_good
  
  ;make a map
  set_plot, 'ps'
  device, filename='aeroce.map.eps', /color, /helvetica, font_size=12, $
          xsize=12, xoff=.5, ysize=10, yoff=.5, /encap
  !p.font=0
  loadct, 39
  map_set,/continents,/grid,limit=[-80,-180,80,180], position=[0.1,0.15,0.9,0.85]
  map_grid, /box_axes
  map_continents, thick=3
  for n=0, ngood-1 do begin
    xyouts, lons_good[n], lats_good[n], site_num[n], color=colorarray[n], charthick=4, charsize=1.3
  endfor
  xyouts, .5, .94, 'AEROCE Site Locations', /normal, charsize=1.4, align=.5
  device, /close


end
