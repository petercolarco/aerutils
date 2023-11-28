  pro ss450_sza, swath, post=post

  sinc = 'ss450'
  outstr = sinc+'.'+swath+'km'  
  if(swath eq 'nadir') then outstr = sinc+'.'+swath
  if(keyword_set(post)) then goto, jump

  fstr = strupcase(sinc)

; Get and read Patricia's files to pluck out the zonal mean
; scattering angles per day, daylight only

; Outputs
  nyo  = 181
  lato = -90.+findgen(nyo)
  szamxo = make_array(365,nyo,val=!values.f_nan)
  szamno = make_array(365,nyo,val=!values.f_nan)
  


; Get the filenames to probe...
  iday = 0
  for imm = 1, 12 do begin
   for idd = 1, 31 do begin

    mm = strpad(imm,10)
    dd = strpad(idd,10)
    filen = file_search('/misc/prc19/colarco/OBS/A-CCP/SS450/LevelB/Y2006/M'+mm+'/',$
               	       	'*2006'+mm+dd+'_0[0,1,2]*nc4')
    if(filen[0] ne '') then begin
     jj = 0
     for ii = 0, n_elements(filen)-1 do begin
print, filen[ii]
      cdfid = ncdf_open(filen[ii])
       id = ncdf_varid(cdfid,'time')
       ncdf_varget, cdfid, id, time_
       nt = n_elements(time_)
       case swath of
       '50': begin
          offset=[473,0,0]
          count =[50,10,nt]
          end
       '100': begin
          offset=[448,0,0]
          count =[100,10,nt]
          end
       '300': begin
          offset=[348,0,0]
          count =[300,10,nt]
          end
       '500': begin
          offset=[248,0,0]
          count =[500,10,nt]
          end
     'nadir': begin
          offset=[498,0,0]
          count =[1,10,nt]
          end
       endcase
       id = ncdf_varid(cdfid,'latitude')
       ncdf_varget, cdfid, id, lat_, offset=offset, count=count
       id = ncdf_varid(cdfid,'sza')
       ncdf_varget, cdfid, id, sza_, offset=offset, count=count
;       id = ncdf_varid(cdfid,'scatAngle')
;       ncdf_varget, cdfid, id, scat_, offset=offset, count=count
      ncdf_close, cdfid
;      These lines might be useful if I want a histogram of statistics
;      scat_ = reform(transpose(scat_,[0,2,1]),count[0]*nt*1L,10)
;      sza_  = reform(transpose(sza_,[0,2,1]),count[0]*nt*1L,10)
;      lat_  = reform(transpose(lat_,[0,2,1]),count[0]*nt*1L,10)
;     Make simple: only select on any view of SZA < 80
      a = where(sza_ lt 80.)
      if(a[0] ne -1) then begin
       if(jj eq 0) then begin
        sza = sza_[a]
        lat  = lat_[a]
        jj = 1
       endif else begin
        sza = [sza,sza_[a]]
        lat  = [lat,lat_[a]]
       endelse
      endif
     endfor

;    Now collect the scattering angles for the day on the regular grid
     iy = fix(interpol(findgen(nyo),lato,lat)+0.5d)
     for j = 0, nyo-1 do begin
      a = where(iy eq j)
      if(a[0] ne -1) then begin
       szamxo[iday,j] = max(sza[a])
       szamno[iday,j] = min(sza[a])
      endif
     endfor
     iday = iday + 1
    endif    ; day exists

   endfor    ; day
  endfor     ; month

  save, /variables, filename=outstr+'.sza.sav'
jump:
  if(keyword_set(post)) then restore, outstr+'.sza.sav'

; Make a plot
  titinc = 'Sun-synchronous'
  set_plot, 'ps'
  device, file=outstr+'.sza.max.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  xtickv = [0,50,100,150,200,250,300,350,365]
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-80,80], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   xticks=8, xtickv=xtickv, $
   xtickn = [string(xtickv[0:7],format='(i3)'),' '], $
   yticks=8, ytickn=[' ','-60','-40','-20','0','20','40','60',' '], $
   title=titinc+', Maximum Solar Zenith Angle', $
   xtitle='Day of Year', ytitle='Latitude'
  levels = findgen(6)*15
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = [10,35,60,85,200,225]
  dx = 1.
  dy = 1.
  loadct, 66
  plotgrid, szamxo, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
; Areal statistics
;  a = where(szamxo ge 155)
;  b = where(finite(szamxo) eq 1)
;  f = string(n_elements(a)*100./n_elements(b),format='(f5.2)')+'%'
;  xyouts, 20, -65, /data, 'Areal Coverage Max Solar Zenith Angle > 155!Eo!N = '+f, color=200
;  a = where(szamxo ge 165)
;  b = where(finite(szamxo) eq 1)
;  f = string(n_elements(a)*100./n_elements(b),format='(f5.2)')+'%'
;  xyouts, 20, -72, /data, 'Areal Coverage Max Solar Zenith Angle > 165!Eo!N = '+f, color=225
  device, /close


; Make a plot
  set_plot, 'ps'
  device, file=outstr+'.sza.ge165.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  xtickv = [0,50,100,150,200,250,300,350,365]
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-80,80], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   xticks=8, xtickv=xtickv, $
   xtickn = [string(xtickv[0:7],format='(i3)'),' '], $
   yticks=8, ytickn=[' ','-60','-40','-20','0','20','40','60',' '], $
   title=titinc+', Occurrence of Maximum Solar Zenith Angle > 165!Eo!N', $
   xtitle='Day of Year', ytitle='Latitude'
  levels = 80+findgen(10)*10
  dx = 1.
  dy = 1.
  loadct, 66
  szamxo_ = szamxo
  a = where(szamxo_ ge 165.)
  b = where(szamxo_ lt 165.)
  szamxo_[a] = 10.
  szamxo_[b] = !values.f_nan
  plotgrid, szamxo_, 1, 250, findgen(365)+0.5, lato, dx, dy
  device, /close


; Make a plot
  set_plot, 'ps'
  device, file=outstr+'.sza.min.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  xtickv = [0,50,100,150,200,250,300,350,365]
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-80,80], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   xticks=8, xtickv=xtickv, $
   xtickn = [string(xtickv[0:7],format='(i3)'),' '], $
   yticks=8, ytickn=[' ','-60','-40','-20','0','20','40','60',' '], $
   title=titinc+', Minimum Solar Zenith Angle', $
   xtitle='Day of Year', ytitle='Latitude'
  levels = findgen(6)*15.
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = [10,35,60,85,200,225]
  dx = 1.
  dy = 1.
  loadct, 66
  plotgrid, szamno, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close



; Make a plot
  set_plot, 'ps'
  device, file=outstr+'.sza.diff.ps', /color, /helvetica, font_size=12, $
   xsize=30, ysize=18
  !p.font=0

  loadct, 0
  xtickv = [0,50,100,150,200,250,300,350,365]
  plot, indgen(10), /nodata, $
   xrange=[0,365], yrange=[-80,80], $
   xstyle=1, ystyle=1, position=[.05,.15,.95,.95], $
   xticks=8, xtickv=xtickv, $
   xtickn = [string(xtickv[0:7],format='(i3)'),' '], $
   yticks=8, ytickn=[' ','-60','-40','-20','0','20','40','60',' '], $
   title=titinc+', Range Solar Zenith Angle', $
   xtitle='Day of Year', ytitle='Latitude'
  levels = findgen(18)*2
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = reverse(findgen(18)*14)
  dx = 1.
  dy = 1.
  loadct, 70
  plotgrid, szamxo-szamno, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close

;; Print the fraction of time sza > 165
;  a = where(szamxo ge 165.)
;  b = where(finite(szamxo) eq 1)
;  print, 'Fraction >= 165: ', n_elements(a), n_elements(b)

; Print the histogram of count statistics
  openw, lun, outstr+'.sza.max_freq.txt', /get
  thresh = 130. + findgen(10)*5.
  nthresh = n_elements(thresh)
  aa = where(lato ge -30 and lato le 30)
  szamxo30 = szamxo[*,aa]
  for i = 0, nthresh-1 do begin
    a = where(szamxo ge thresh[i])
    b = where(finite(szamxo) eq 1)
    c = where(szamxo30 ge thresh[i])
    d = where(finite(szamxo30) eq 1)
    printf, lun, thresh[i], n_elements(a), n_elements(b), $
                 n_elements(c), n_elements(d), format='(i3,2x,4(i6,2x))'
  endfor
  free_lun, lun

end
