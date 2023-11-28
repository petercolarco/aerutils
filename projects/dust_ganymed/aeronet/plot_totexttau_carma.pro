; Colarco, June 2010
; Presumes already ran mon-budget script across years desired
; in order to get budget tables
; Specify experiment ID and all years to run across
; Specify "draft = 1" in order to write info about experiment on
; plot

  site = ['Capo_Verde', 'RaggedPoint', 'Bermuda', 'La_Parguera', $
          'La_Laguna',  'Dahkla',      'Tamanrasset_INM']
  aersite = site
  aersite[1] = 'Ragged_Point'
  aersite[4] = 'Santa_Cruz_Tenerife'
  site_title = ['Cape Verde, Sal Island','Ragged Point, Barbados','Bermuda',$
                'La Parguera, Puerto Rico','Santa Cruz, Tenerife','Dahkla','Tamanrasset']
  ymax = [1.,.5,.5,.5,1.,1.5,1.5]
  lon  = [-22., -59., -64., -67., -16., -15.,  5.]
  lat  = [ 16.,  13.,  32.,  17.,  28.,  23., 22.]


; Get the lifetimes
  expid = ['c48_aG40-base-v1',$      ; no forcing
           'c48F_aG40-base-v1', $    ; OPAC-Spheres
           'c48F_aG40-base-v11', $    ; OPAC-Spheroids
           'c48F_aG40-base-v15', $   ; OBS-Spheroids
           'c48F_aG40-kok-v15']      ; OBS-Spheroids/Kok

  nexpid = n_elements(expid)
  colorarray=[0, 254,254,208,84]
  linarray  =[0, 0,  2,  0,  0]

  draft = 0 ; suppress experiment information on plot
;  draft = 1 ; show experiment information on plot

  nexp = n_elements(expid)

  for iex = 0, n_elements(site)-1 do begin

  set_plot, 'ps'
  device, file = './plot_totexttau.'+expid[0]+'.'+aersite[iex]+'.ps', /color, /helvetica, $
   font_size=12, xsize=16, xoff=.5, ysize=10, yoff=.5
  !P.font=0
  loadct, 0

  xtickname = [' ','J','F','M','A','M','J','J','A','S','O','N','D',' ']

; Get the AERONET data
  loadct, 0
  aeronetpath = '/misc/prc10/AERONET/LEV30/'
  nyears = 18
  yyyy = strpad(findgen(nyears)+1994,1000L)
  read_aeronet2nc, aeronetpath, aersite[iex], '500', yyyy, aot, date, naot=naot, /monthly
  a = where(aot lt 0)
  if(a[0] ne -1) then aot[a] = !values.f_nan
  aot = reform(aot,12,18)
a = where(finite(aot) eq 1)
print, aersite[iex], n_elements(a)
  aota = mean(aot,dimension=2,/nan)
  usersym, [-1,1,1,-1,-1], [-1,-1,1,1,-1], color=80, /fill
;  plots, indgen(12)+1, aota, psym=8
  sdeva = stddev(aot,dimension=2,/nan)
;  for imon = 0,11 do begin
;   plots, imon+1+[-1,1,0,0,-1,1]*0.25, aota[imon]+[-1,-1,-1,1,1,1]*sdev[imon], color=80, noclip=0
;  endfor

; Dust
  tdef = 'tdef time 12 linear 12z15jan2011 1mo'
  filename = '/misc/prc14/colarco/'+expid[0]+'/tavg2d_carma_x/'+expid[0]+'.tavg2d_carma_x.monthly.clim.M%m2.nc4'
  nc4readvar, filename, 'totexttau', exttau, nymd=nymd, rc=rc, tdef=tdef, $
              wantlon=lon[iex], wantlat=lat[iex]
  nc4readvar, filename, 'var_totexttau', var_exttau, nymd=nymd, rc=rc, tdef=tdef, $
              wantlon=lon[iex], wantlat=lat[iex]
  exttau = [ [exttau],[exttau]]
; Compute the standard deviation
  sdev = var_exttau
  if(rc eq 0) then begin
   plot, [0,13], [0,ymax[iex]], /nodata, $
    xthick=3, ythick=3, xstyle=9, ystyle=9, color=0, $
    xticks=13, xtickname=xtickname, $
    xtitle = 'Month', ytitle='AOT', title=site_title[iex]
   polymaxmin, indgen(12)+1, aot, color=200, fillcolor=240, lin=0, thick=12
   polymaxmin, indgen(12)+1, exttau[0:11,*], color=0, fillcolor=-1, lin=linarray[0], thick=9, sdev=sdev
aot0 = exttau[5,0]
  endif

;goto, jump
  if(nexpid gt 1) then begin
   !quiet = 1L
   loadct, 39
   for iexpid = 1, nexpid-1 do begin
    tdef = 'tdef time 12 linear 12z15jan2011 1mo'
    filename = '/misc/prc14/colarco/'+expid[iexpid]+'/tavg2d_carma_x/'+expid[iexpid]+'.tavg2d_carma_x.monthly.clim.M%m2.nc4'
    nc4readvar, filename, 'totexttau', exttau, nymd=nymd, rc=rc, tdef=tdef, $
                wantlon=lon[iex], wantlat=lat[iex]
    nc4readvar, filename, 'var_totexttau', var_exttau, nymd=nymd, rc=rc, tdef=tdef, $
                wantlon=lon[iex], wantlat=lat[iex]
print, filename, rc
    exttau = [ [exttau],[exttau]]
    sdev = var_exttau
    if(rc eq 0) then $
     polymaxmin, indgen(12)+1, exttau[0:11,*], fillcolor=-1, color=colorarray[iexpid], $
                 lin=linarray[iexpid], thick=6, sdev=sdev
if(iexpid eq nexpid-1) then aot7 = exttau[5,0]
   endfor
  endif
jump:

   loadct, 0
   polymaxmin, indgen(12)+1, aot, color=200, fillcolor=-1, lin=0, thick=12

print, site[iex], aot7/aot0
; Legend hard wired
  loadct, 39
  plots, [1,2.5], 0.950*ymax[iex], thick=6
  plots, [1,2.5], 0.875*ymax[iex], thick=6, color=254
  plots, [1,2.5], 0.800*ymax[iex], thick=6, color=254, lin=2
  plots, [1,2.5], 0.725*ymax[iex], thick=6, color=208
  plots, [1,2.5], 0.650*ymax[iex], thick=6, color=84
  xyouts, 2.8, 0.940*ymax[iex], 'No Forcing', charsize=.75
  xyouts, 2.8, 0.865*ymax[iex], 'OPAC-Spheres', charsize=.75
  xyouts, 2.8, 0.790*ymax[iex], 'OPAC-Spheroids', charsize=.75
  xyouts, 2.8, 0.715*ymax[iex], 'OBS-Spheroids', charsize=.75
  xyouts, 2.8, 0.640*ymax[iex], 'OBS-Spheroids/Kok', charsize=.75

  loadct, 0
  polyfill, [7, 8.5, 8.5, 7, 7]-6, [.625,.625,.675,.675,.625]*ymax[iex], color=240
  plots, [7,8.5]-6, 0.575*ymax[iex], thick=12, color=200
  xyouts, 8.8-6, .565*ymax[iex], 'AERONET', charsize=.75

  device, /close  

  endfor

end

