  res = 'd'
  regtitle = ['South America', 'Southern Africa', 'African Dust', 'Nile Valley', $
              'Indogangetic Plain', 'China', 'Southeast Asia', 'Asian Outflow']
  ymax   = [1,.6,.8,.8,.8,1,.8,.5]
  regstr = ['sam','saf','naf','nrv','igp','chn','sea','npac']
  lon0 = [-75,-15,-30,30,75,100,95,135]
  lon1 = [-45,35,-15,36,95,125,110,165]
  lat0 = [-20,-20,10,22,20,25,10,30]
  lat1 = [0,0,30,32,30,42,25,55]
  nreg = n_elements(lon0)

  yyyy = strpad(indgen(9)+2003,1000L)
  yyyy = ['2010']
  ny   = n_elements(yyyy)
  mm   = ['01','02','03','04','05','06','07','08','09','10','11','12']
  nm   = 12

  reg = fltarr(ny,nm,nreg,2,5)

  samples = [' ','caliop1', 'caliop2', 'caliop3', 'caliop4']

  for isam = 0, 4 do begin
print, isam
   for iy = 0, ny-1 do begin
   for im = 0, nm-1 do begin

    if(isam eq 0) then begin
     read_monthly, 'MYD04', samples[isam], yyyy[iy], mm[im], aotsat, lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, res=res
     reg[iy,im,*,0,isam] = reg_aot
     reg[iy,im,*,1,isam] = reg_aot
    endif else begin
     read_monthly, 'MYD04', samples[isam], yyyy[iy], mm[im], aotsat, lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, /exclude, res=res
     reg[iy,im,*,0,isam] = reg_aot
     read_monthly, 'MYD04', samples[isam], yyyy[iy], mm[im], aotsat, lon0=lon0, lon1=lon1, lat0=lat0, lat1=lat1, reg_aot=reg_aot, /exclude, /inverse, res=res
     reg[iy,im,*,1,isam] = reg_aot
    endelse

   endfor
   endfor

  endfor

; Multi-year
  if(ny eq 1) then begin
   reg = reform(reg[0,*,*,*,*])
   ystr = yyyy[0]
  endif else begin
   regsave = reg
   reg_ = fltarr(nm,nreg,2,5)
   for i = 0, 4 do begin
    for j = 0, 1 do begin
     for k = 0, nreg-1 do begin
      for l = 0, nm-1 do begin
       val = total(reg[*,l,k,j,i],/nan)
       n = n_elements(where(finite(reg[*,l,k,j,i]) eq 1))
       reg_[l,k,j,i] = val/n
      endfor
     endfor
    endfor
   endfor
   reg = reg_
   ystr = yyyy[0]+'_'+yyyy[ny-1]
  endelse

; Plot
  set_plot, 'ps'
  !p.font = 0

   x = findgen(nm)+1
   nx = n_elements(x)
   xl = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

  for ireg = 0, nreg-1 do begin
   device, file='./output/plots/regional.caliop.'+res+'.'+ystr+'.'+regstr[ireg]+'.ps', $
           /color, /helvetica, font_size=12, $
           xsize=16, ysize=20, xoff=.5, yoff=.5

;  Plot the values
   plot, x, reg[*,ireg,0,0], /nodata, yrange=[0,ymax[ireg]], $
    xtitle = 'Month', ytitle='AOT', title=regtitle[ireg], $
    xticks = nx+1, xtickn = xl[0:nx+1], xminor=1, yminor=2, $
    xstyle=9, ystyle=9, thick=3, xrange=[0,nx+1], $
    position=[.15,.6,.85,.95]

   oplot, x, reg[*,ireg,0,0], thick=8
;  Exclude
;   oplot, x, reg[*,ireg,0,1], thick=8, color=84
;   oplot, x, reg[*,ireg,0,2], thick=8, color=84, lin=2
;   oplot, x, reg[*,ireg,0,3], thick=8, color=84, lin=1
;   oplot, x, reg[*,ireg,0,4], thick=8, color=84, lin=3
;  Inverse
   loadct, 1
   oplot, x, reg[*,ireg,1,1], thick=8, color=200
   loadct, 3
   oplot, x, reg[*,ireg,1,2], thick=8, color=200
   loadct, 7
   oplot, x, reg[*,ireg,1,3], thick=8, color=200
   loadct, 8
   oplot, x, reg[*,ireg,1,4], thick=8, color=200
   loadct, 0
   oplot, x, reg[*,ireg,0,0], thick=8

;  Plot the difference
   plot, x, reg[*,ireg,0,0], /nodata, yrange=[-ymax[ireg],ymax[ireg]], /noerase, $
    xtitle = 'Month', ytitle='fraction', $
    xticks = nx+1, xtickn = xl[0:nx+1], xminor=1, yminor=2, $
    xstyle=9, ystyle=9, thick=3, xrange=[0,nx+1], $
    position=[.15,.32,.85,.52]
   xyouts, 1, .85*ymax[ireg], 'Fractional Difference from Full Swath'
   polyfill, [1,12,12,1,1], [-.2,-.2,.2,.2,-.2], color=200

;  Exclude
   diff = fltarr(nx,n_elements(samples))
   for isam = 0, n_elements(samples)-1 do begin
    diff[*,isam] = (reg[*,ireg,0,isam] - reg[*,ireg,0,0]) / reg[*,ireg,0,0]
   endfor
;   oplot, x, diff[*,1], thick=8, color=84
;   oplot, x, diff[*,2], thick=8, color=84, lin=2
;   oplot, x, diff[*,3], thick=8, color=84, lin=1
;   oplot, x, diff[*,4], thick=8, color=84, lin=3
;  Inverse
   diff = fltarr(nx,n_elements(samples))
   for isam = 0, n_elements(samples)-1 do begin
    diff[*,isam] = (reg[*,ireg,1,isam] - reg[*,ireg,0,0]) / reg[*,ireg,0,0]
   endfor
   loadct, 1
   oplot, x, diff[*,1], thick=8, color=200
   loadct, 3
   oplot, x, diff[*,2], thick=8, color=200
   loadct, 7
   oplot, x, diff[*,3], thick=8, color=200
   loadct, 8
   oplot, x, diff[*,4], thick=8, color=200
   loadct, 0
   plots, [1,12], 0, thick=8


;  Absolute axis
   plot, x, reg[*,ireg,0,0], /nodata, yrange=[-.4*ymax[ireg],.4*ymax[ireg]], /noerase, $
    xtitle = 'Month', ytitle='difference', $
    xticks = nx+1, xtickn = xl[0:nx+1], xminor=1, yminor=2, $
    xstyle=9, ystyle=9, thick=3, xrange=[0,nx+1], $
    position=[.15,.08,.85,.28]
   xyouts, 1, -.4*.8*ymax[ireg], 'Absolute Difference from Full Swath'
   polyfill, [1,12,12,1,1], [-.05,-.05,.05,.05,-.05], color=200

   diff = fltarr(nx,n_elements(samples))
   for isam = 0, n_elements(samples)-1 do begin
    diff[*,isam] = (reg[*,ireg,1,isam] - reg[*,ireg,0,0])
   endfor
   loadct, 1
   oplot, x, diff[*,1], thick=8, color=200
   loadct, 3
   oplot, x, diff[*,2], thick=8, color=200
   loadct, 7
   oplot, x, diff[*,3], thick=8, color=200
   loadct, 8
   oplot, x, diff[*,4], thick=8, color=200
   loadct, 0
   plots, [1,12], 0, thick=8


   device, /close
  endfor
end
