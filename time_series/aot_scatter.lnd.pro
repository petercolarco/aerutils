; Scatter the monthly means of satellite and model versus each other by region

; Header information
;  plottitlehead = tag that names output files
;  datewant = two-element array of begin and end YYYYMM
;  ctlfile = n-element array of control file names to read
;  typefile = n-element array of type of each control file (tau, diag, MOD04, etc.)
;  colorarray = n_element array of rainbow pallette colors
;  linarray = n-element linestyle array
;  resolution = n-element array of resolution of each data set (b, c)
;  scolorarray = n_element array of grey pallette background colors for std-dev

; Mod vs. MYD 
;  plottitlehead = 't003_c32_v_MOD04.qawt.'
;  ctlfile  = ['MOD04_L2_005.lnd.qawt.ctl', 't003_c32.tau.v2.SSo2.MOD04_L2_005.lnd.qawt.ctl']
;  plottitlehead = 't003_c32_v_MYD04.qawt.'
;  ctlfile  = ['MYD04_L2_005.lnd.qawt.ctl', 't003_c32.tau.v2.SSo2.MYD04_L2_005.lnd.qawt.ctl']
  plottitlehead = 't003_c32_v_MOD04.2003_2006.qawt.'
  ctlfile  = ['MOD04_L2_005.lnd.qawt.ctl', 't003_c32.tau.v2.SSo2.MOD04_L2_005.lnd.qawt.ctl']
  typefile = ['MODIS','tau_tot','tau_tot','tau_tot']
;  datewant=['200001','200612']
  datewant=['200301','200612']
;  colorarray = [0, 84, 84, 84]
  resolution = ['c','c','c','c']
  scolorarray = [0,0,0,0]

  plotfile = plottitlehead+'scatter.lnd.ps'

  ga_getvar, ctlfile[0], '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint
  nt = n_elements(time)

; Pick regions based on the mask file
  maskwant = [-2,   1,   1,   1,  1,  -2,  3,  3,   4,  4,  4,  4,  5,  5,  5,  5,  5,  2]
  lon0want = [0,    0,-100,-130,  0,-179,  0,-15,   0,  0,100,  0,  0,  0,  0,-20,  0,  0]
  lon1want = [359,359, -10,-100,360, -10,360, 30, 359,360,360,100,360,360,360, 10,360,359]
  lat0want = [-89,  0,  23,  28,  0,  50,  0,  0, -89, 45,  0,-89,-45,  0,-45, 10,-10,-89]
  lat1want = [89,  89,  50,  50, 32,  89, 89, 60,  89, 89, 45, 89, 45, 45,  0, 30,  0, 89]

  title = ['Whole World', 'North America', 'Eastern North America', $
           'Western North America', 'Central America', 'Canada', $
           'Europe', 'Western Europe', 'Asia', $
           'Northern Asia', 'Southern Asia', 'Western Asia', $
           'Africa', 'Northern Africa', 'Southern Africa', 'Western Sahara', 'Central Africa', 'South America']

  nreg = n_elements(maskwant)



; Loop over the number of control files
  nctl = n_elements(ctlfile)
  regional_val = fltarr(nt, nreg, nctl)
  regional_std = fltarr(nt, nreg, nctl)
  for ictl = 0, nctl-1 do begin
    template = 0
    case typefile[ictl] of
     'tau'   : begin
               var = ['du', 'ss', 'ocphilic', 'ocphobic', 'bcphilic', 'bcphobic', 'so4']
               wantlev=5.5e-7
               template = 1
               end
     'tau_tot': begin
               var = ['aodtau']
               wantlev=5.5e-7
               end
     'diag'  : begin
               var = ['duexttau', 'ssexttau', 'ocexttau', 'bcexttau', 'suexttau']
               wantlev=-9999
               end
     'MODIS' : begin
               var = ['aodtau']
               wantlev=550.
               end
     'MISR'  : begin
               var = ['aodtau']
               wantlev=550.
               end
    endcase

    spawn, 'echo ${BASEDIRAER}', basedir
    case resolution[ictl] of
     'c' : begin
           nx = 288
           ny = 181
           maskfile = basedir+'/data/c/colarco.regions_co.sfc.clm.hdf'
           end
     'b' : begin
           nx = 144
           ny = 91
           maskfile = basedir+'/data/b/colarco.regions_co.sfc.clm.hdf'
           end
    endcase

;   Read the regional mask
    ga_getvar, maskfile, 'COMASK', mask, lon=lon, lat=lat
    a = where(mask gt 100)
    if(a[0] ne -1) then mask[a] = 0
    nvars = n_elements(var)
    inp = fltarr(nx,ny,nt)
    date = strarr(nt)
    q = fltarr(nx,ny,nreg)
    print, ctlfile[ictl]
    for ivar = 0, nvars-1 do begin
      print, 'Reading var: '+var[ivar]+', '+string(ivar+1)+'/'+string(nvars)
      ga_getvar, ctlfile[ictl], var[ivar], varout, lon=lon, lat=lat, $
       wanttime=datewant, wantlev=wantlev, template=template
      inp = inp + varout
    endfor

;   possibly shift the result
    if(min(lon) lt 0) then begin
     lon = lon + 180.
     inp = shift(inp,nx/2,0,0)
    endif

    for it = 0, nt-1 do begin
     for ireg = 0, nreg-1 do begin
      stdreg = 1.
      integrate_region, inp[*,*,it], lon, lat, mask, $
                        maskwant[ireg], lon0want[ireg], lon1want[ireg], $
                        lat0want[ireg], lat1want[ireg], intreg, /avg, q=qback, std=stdreg
      q[*,*,ireg] = qback
      regional_val[it,ireg,ictl] = intreg
      regional_std[it,ireg,ictl] = stdreg
     endfor
    endfor
    lonsave = lon
    latsave = lat
    date = strmid(time,0,4)+strmid(time,5,2)

  endfor

; Set up the plot
  set_plot, 'ps'
  device, file=plotfile, font_size=18, /helvetica, $
   xsize=25, ysize=15, xoff=.5, yoff=26, /landscape, /color
  !P.font=0
  !p.multi=[0,3,2]
  

; all
  for ireg = 0, nreg-1 do begin
   iplot = 6 - (ireg - (ireg/6) * 6)
   if(iplot eq 6) then iplot = 0
   !p.multi=[iplot,3,2]
   val=reform(regional_val[*,ireg,*])
   std=reform(regional_std[*,ireg,*])
   ymax = max(val[where(finite(val) eq 1)])
   plot_scatter, date, val, ymax, '', title[ireg], 'MOD04', ctlfile, $
                 q=q[*,*,ireg], lon=lonsave, lat=latsave, colors=colorarray, $
                 std=std, scolorarray=scolorarray

  endfor

; CLose the plot
  device, /close

end


