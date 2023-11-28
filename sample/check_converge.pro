; Given a threshold, check the number of days it takes for the
; AOT of the samples to converge to within some threshold of
; the full MODIS swath

  threshold = .02

  nymd0 = '20090701'
  nymd1 = '20090920'
  dateexpand, nymd0, nymd1, '000000', '000000', nymd, nhms, /daily

  ntemplate = 5
  nt = n_elements(nymd)
  nbin = 11

  aot = fltarr(ntemplate,nt)
  std = fltarr(ntemplate,nt)
  num = fltarr(ntemplate,nt)
  minval = fltarr(ntemplate,nt)
  maxval = fltarr(ntemplate,nt)
  aotpdf = fltarr(ntemplate,nt,nbin)

  filedir =    '/Users/colarco/data/MODIS/Level3/MOD04/ten/GRITAS/new/Y%y4/M%m2/'
  sample  =   ['', '.caliop1', '.caliop2', '.misr1', '.misr2']

  for it = 0, n_elements(nymd)-1 do begin

; On first time, set up the arrays and counters
  if(it eq 0) then begin
     filename = strtemplate(filedir + 'MOD04_L2_ocn'+sample[0]+'.aero_tc8_051.qast.%y4%m2%d2.nc4', nymd[it], nhms[it])
     read_sample, filename, nbin, lon, lat, $
                  aot_, aotpdf_, num_, std_, minval_, maxval_
     nx = n_elements(lon)
     ny = n_elements(lat)
     nxy = long(nx)*ny
     aot = fltarr(nxy,ntemplate)
     ndays = make_array(nxy,ntemplate,val=-1)
     ncount = make_array(nxy,ntemplate,val=0L)
  endif

  for itemplate = 0, ntemplate-1 do begin

;  Get the ocean
   filename = strtemplate(filedir + 'MOD04_L2_ocn'+sample[itemplate]+'.aero_tc8_051.qast.%y4%m2%d2.nc4', nymd[it], nhms[it])
   read_sample, filename, nbin, lon, lat, $
                aoto, aotpdf_, numo, std_, minval_, maxval_
   a = where(numo lt 1.)
   numo[a] = 1.e15

;  Get the land
   filename = strtemplate(filedir + 'MOD04_L2_lnd'+sample[itemplate]+'.aero_tc8_051.qast3.%y4%m2%d2.nc4', nymd[it], nhms[it])
   read_sample, filename, nbin, lon, lat, $
                aotl, aotpdf_, numl, std_, minval_, maxval_
   a = where(numl lt 1.)
   numl[a] = 1.e15

   aot_ = merge_land_ocean(aoto, aotl, lon, lat)
   num_ = merge_land_ocean(numo, numl, lon, lat)

   for ix = 0L, nxy-1 do begin
;     Accumulate the running mean AOT and Level 2 counts
      if(finite(aot_[ix]) eq 1) then begin
;      If the grid box has a valid mean already, create new mean by
;      weighting by number of retrievals
;!!!   Weight rather by number of days
       if(ncount[ix,itemplate] gt 0) then begin
;if(itemplate eq 1) then stop
;print, filename, aot_[15,10], num_[15,10]
        aot[ix,itemplate] = $
         mean( $
              [make_array(ncount[ix,itemplate],val=aot[ix,itemplate]), $
               make_array(num_[ix],val=aot_[ix]) $
;               aot_[ix] $
              ])
         ncount[ix,itemplate] = ncount[ix,itemplate]+num_[ix]
;         ncount[ix,itemplate] = ncount[ix,itemplate]+1
       endif else begin
         aot[ix,itemplate] = aot_[ix]
;        Weight by number
         ncount[ix,itemplate] = num_[ix]
;         ncount[ix,itemplate] = 1
       endelse
      endif

   endfor
 

;  If absolute AOT difference is less than some threshold and 
;  not already converged then accumulate
   for ix = 0L, nxy-1 do begin
     if(itemplate gt 0 and ndays[ix,itemplate] lt 0 and ncount[ix,itemplate] gt 0) then begin
       if(abs(aot[ix,itemplate]-aot[ix,0]) lt threshold) then $
          ndays[ix,itemplate] = it+1
     endif
   endfor

  endfor

  print, filename

  endfor

  ndays = reform(ndays,nx,ny,ntemplate)
  aot   = reform(aot,nx,ny,ntemplate)

  set_plot, 'ps'
  device, file='converge.ten.ps', /helvetica, font_size=14, $
   xsize=25, ysize=20, /color, xoff=.5, yoff=.5
  !P.font=0
  loadct, 39

  position = fltarr(4,4)
  position[*,0] = [.05,.585,.45,.935]
  position[*,1] = [.55,.585,.95,.935]
  position[*,2] = [.05,.12,.45,.47]
  position[*,3] = [.55,.12,.95,.47]

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]

  levelArray = [-2,1,2,4,8,16,32,64]-.1
  labelArray = ['N','1','2','4','8','16','32','64']
  colorArray = [255,30,64,96,176,199,208,254]

  for itemplate = 1, ntemplate-1 do begin
   map_set, position=position[*,itemplate-1], /noborder, limit=geolimits, /noerase
   plotgrid, ndays[*,*,itemplate], levelarray, colorarray, $
    lon, lat, dx, dy, undef=!values.f_nan, /map
   map_continents, color=0, thick=5
   map_continents, color=0, thick=1, /countries
   map_set, /noerase, position=position[*,itemplate-1], limit=geolimits
   case itemplate of
    1: titlestr = 'CALIOP1'
    2: titlestr = 'CALIOP2'
    3: titlestr = 'MISR1'
    4: titlestr = 'MISR2'
   endcase

   xyouts, position[0,itemplate-1], position[3,itemplate-1]+.03, titlestr,  /normal
   map_grid, /box, charsize=.8
   makekey, .05, .04, .9, .025, 0, -.03, color=colorarray, label=labelarray, $
    align=0

  endfor

device, /close

end
