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
;  ctlfile  = ['MOD04_L2_005.ocn.qawt.ctl', 't003_c32.tau.v2.SSo2.MOD04_L2_005.ocn.qawt.ctl']
  plottitlehead = 't003_c32_v_MYD04.qawt.'
  ctlfile  = ['MYD04_L2_005.ocn.qawt.ctl', 't003_c32.tau.v2.SSo2.MYD04_L2_005.ocn.qawt.ctl']
;  plottitlehead = 't003_c32_v_MOD04.2003_2006.qawt.'
;  ctlfile  = ['MOD04_L2_005.ocn.qawt.ctl', 't003_c32.tau.v2.SSo2.MOD04_L2_005.ocn.qawt.ctl']
  typefile = ['MODIS','tau_tot','tau_tot','tau_tot']
  datewant=['200001','200612']
;  datewant=['200301','200612']
;  colorarray = [0, 84, 84, 84]
  resolution = ['c','c','c','c']
  scolorarray = [0,0,0,0]

  plotfile = plottitlehead+'scatter.regions.ps'

  ga_getvar, ctlfile[0], '', varout, lon=lon, lat=lat, lev=lev, time=time, wanttime=datewant,/noprint
  nt = n_elements(time)

; Pick regions based on the mask file
  nreg = 14
  ymaxwant = intarr(nreg)
  maskwant = intarr(nreg)
  lon0want = fltarr(nreg)
  lon1want = fltarr(nreg)
  lat0want = fltarr(nreg)
  lat1want = fltarr(nreg)
  title    = strarr(nreg)
  plottitle= strarr(nreg)

 
  i = 0
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] = 180. &  lon1want[i] = 270.
  lat0want[i] =  30. &  lat1want[i] = 70.
  title[i] = 'Region 1'
  plottitle[i] = 'aot.r01.x180_270.n30_70.ps'
 
  i = 1
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] = 270. &  lon1want[i] = 360.
  lat0want[i] =  30. &  lat1want[i] = 70.
  title[i] = 'Region 2'
  plottitle[i] = 'aot.r02.x270_360.n30_70.ps'
 
  i = 2
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 90.
  lat0want[i] =  30. &  lat1want[i] = 70.
  title[i] = 'Region 3'
  plottitle[i] = 'aot.r03.x0_90.n30_70.ps'
 
  i = 3
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] =  90. &  lon1want[i] = 180.
  lat0want[i] =  30. &  lat1want[i] = 70.
  title[i] = 'Region 4'
  plottitle[i] = 'aot.r04.x90_180.n30_70.ps'
 
  i = 4
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] = 180. &  lon1want[i] = 270.
  lat0want[i] =   0. &  lat1want[i] = 30.
  title[i] = 'Region 5'
  plottitle[i] = 'aot.r05.x180_270.n0_30.ps'
 
  i = 5
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] = 270. &  lon1want[i] = 360.
  lat0want[i] =   0. &  lat1want[i] = 30.
  title[i] = 'Region 6'
  plottitle[i] = 'aot.r06.x270_360.n0_30.ps'
 
  i = 6
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 90.
  lat0want[i] =   0. &  lat1want[i] = 30.
  title[i] = 'Region 7'
  plottitle[i] = 'aot.r07.x0_90.n0_30.ps'
 
  i = 7
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] =  90. &  lon1want[i] = 180.
  lat0want[i] =   0. &  lat1want[i] = 30.
  title[i] = 'Region 8'
  plottitle[i] = 'aot.r08.x90_180.n0_30.ps'
 
  i = 8
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] = 180. &  lon1want[i] = 270.
  lat0want[i] = -30. &  lat1want[i] = 0.
  title[i] = 'Region 9'
  plottitle[i] = 'aot.r09.x180_270.s30_0.ps'
 
  i = 9
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] = 270. &  lon1want[i] = 360.
  lat0want[i] = -30. &  lat1want[i] = 0.
  title[i] = 'Region 10'
  plottitle[i] = 'aot.r10.x270_360.s30_0.ps'
 
  i = 10
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 90.
  lat0want[i] = -30. &  lat1want[i] = 0.
  title[i] = 'Region 11'
  plottitle[i] = 'aot.r11.x0_90.s30_0.ps'
 
  i = 11
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] =  90. &  lon1want[i] = 180.
  lat0want[i] = -30. &  lat1want[i] = 0.
  title[i] = 'Region 12'
  plottitle[i] = 'aot.r12.x90_180.s30_0.ps'

  i = 12
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 360.
  lat0want[i] = -70. &  lat1want[i] = -30.
  title[i] = 'Region 13'
  plottitle[i] = 'aot.r13.x270_360.s70_30.ps'
 
  i = 13
  ymaxwant[i] =   1  &  maskwant[i] = 0
  lon0want[i] =   0. &  lon1want[i] = 360.
  lat0want[i] = -89. &  lat1want[i] = 89.
  title[i] = 'Region 14'
  plottitle[i] = 'aot.r14.x0_360.s90_n90.ps'


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


