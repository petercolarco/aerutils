  pro incline_scat, inclination, swath, post=post

  sinc = 'gpm0'+inclination
  outstr = sinc+'.'+swath+'km'
  if(swath eq 'nadir') then outstr = sinc+'.'+swath
  titinc = inclination+'!Eo!N Inclination'
  if(keyword_set(post)) then goto, jump

  fstr = strupcase(sinc)

; Get and read Patricia's files to pluck out the zonal mean
; scattering angles per day, daylight only

; Outputs
  nyo  = 181
  lato = -90.+findgen(nyo)
  scatmxo = make_array(365,nyo,val=!values.f_nan)
  scatmno = make_array(365,nyo,val=!values.f_nan)
  


; Get the filenames to probe...
  iday = 0
  for imm = 1, 12 do begin
   for idd = 1, 31 do begin

    mm = strpad(imm,10)
    dd = strpad(idd,10)
    if(inclination eq '65') then begin
     filen = file_search('/misc/prc19/colarco/OBS/A-CCP/GPM/LevelB/Y2006/M'+mm+'/',$
                         '*2006'+mm+dd+'_0[0,1,2]*nc4')
    endif else begin
     filen = file_search('/misc/prc19/colarco/OBS/A-CCP/'+fstr+'/LevelB/Y2019/M'+mm+'/',$
                         '*2019'+mm+dd+'_0000z.nc4')
    endelse
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
       id = ncdf_varid(cdfid,'scatAngle')
       ncdf_varget, cdfid, id, scat_, offset=offset, count=count
      ncdf_close, cdfid
;      These lines might be useful if I want a histogram of statistics
;      scat_ = reform(transpose(scat_,[0,2,1]),count[0]*nt*1L,10)
;      sza_  = reform(transpose(sza_,[0,2,1]),count[0]*nt*1L,10)
;      lat_  = reform(transpose(lat_,[0,2,1]),count[0]*nt*1L,10)
;     Make simple: only select on any view of SZA < 80
      a = where(sza_ lt 80.)
      if(a[0] ne -1) then begin
       if(jj eq 0) then begin
        scat = scat_[a]
        lat  = lat_[a]
        jj = 1
       endif else begin
        scat = [scat,scat_[a]]
        lat  = [lat,lat_[a]]
       endelse
      endif
     endfor

;    Now collect the scattering angles for the day on the regular grid
     iy = fix(interpol(findgen(nyo),lato,lat)+0.5d)
     for j = 0, nyo-1 do begin
      a = where(iy eq j)
      if(a[0] ne -1) then begin
       scatmxo[iday,j] = max(scat[a])
       scatmno[iday,j] = min(scat[a])
      endif
     endfor
     iday = iday + 1
    endif    ; day exists

   endfor    ; day
  endfor     ; month

  save, /variables, filename=outstr+'.sav'
jump:
  if(keyword_set(post)) then restore, outstr+'.sav'

; Make a plot
  set_plot, 'ps'
  device, file=outstr+'.scat.max.ps', /color, /helvetica, font_size=12, $
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
   title=titinc+', Maximum Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude'
  levels = 80+findgen(10)*10
  levels = [80,100,120,140,155,165]
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = [10,35,60,85,200,225]
  dx = 1.
  dy = 1.
  loadct, 66
  plotgrid, scatmxo, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
; Areal statistics
  a = where(scatmxo ge 155)
  b = where(finite(scatmxo) eq 1)
  f = string(n_elements(a)*100./n_elements(b),format='(f5.2)')+'%'
  xyouts, 20, -65, /data, 'Areal Coverage Max Scattering Angle > 155!Eo!N = '+f, color=200
  a = where(scatmxo ge 165)
  b = where(finite(scatmxo) eq 1)
  f = string(n_elements(a)*100./n_elements(b),format='(f5.2)')+'%'
  xyouts, 20, -72, /data, 'Areal Coverage Max Scattering Angle > 165!Eo!N = '+f, color=225
  device, /close


; Make a plot
  set_plot, 'ps'
  device, file=outstr+'.scat.ge165.ps', /color, /helvetica, font_size=12, $
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
   title=titinc+', Occurrence of Maximum Scattering Angle > 165!Eo!N', $
   xtitle='Day of Year', ytitle='Latitude'
  levels = 80+findgen(10)*10
  dx = 1.
  dy = 1.
  loadct, 66
  scatmxo_ = scatmxo
  a = where(scatmxo_ ge 165.)
  b = where(scatmxo_ lt 165.)
  scatmxo_[a] = 10.
  scatmxo_[b] = !values.f_nan
  plotgrid, scatmxo_, 1, 250, findgen(365)+0.5, lato, dx, dy
  device, /close


; Make a plot
  set_plot, 'ps'
  device, file=outstr+'.scat.min.ps', /color, /helvetica, font_size=12, $
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
   title=titinc+', Minimum Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude'
  levels = findgen(13)*10.+20.
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = 10+findgen(13)*20
  dx = 1.
  dy = 1.
  loadct, 70
  plotgrid, scatmno, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close



; Make a plot
  set_plot, 'ps'
  device, file=outstr+'.scat.diff.ps', /color, /helvetica, font_size=12, $
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
   title=titinc+', Range Scattering Angle', $
   xtitle='Day of Year', ytitle='Latitude'
  levels = findgen(18)*10
  makekey, .1, .05, .8, .035, 0., -0.035, label=string(levels,format='(i3)'), $
   colors=make_array(n_elements(levels),val=0), align=0
  colors = reverse(findgen(18)*14)
  dx = 1.
  dy = 1.
  loadct, 70
  plotgrid, scatmxo-scatmno, levels, colors, findgen(365)+0.5, lato, dx, dy
  makekey, .1, .05, .8, .035, 0., -0.035, colors=colors, $
   labels=make_array(n_elements(levels),val=' '), /noborder
  device, /close

;; Print the fraction of time scat > 165
;  a = where(scatmxo ge 165.)
;  b = where(finite(scatmxo) eq 1)
;  print, 'Fraction >= 165: ', n_elements(a), n_elements(b)

; Print the histogram of count statistics
  openw, lun, outstr+'.scat.max_freq.txt', /get
  thresh = 130. + findgen(10)*5.
  nthresh = n_elements(thresh)
  aa = where(lato ge -30 and lato le 30)
  scatmxo30 = scatmxo[*,aa]
  for i = 0, nthresh-1 do begin
    a = where(scatmxo ge thresh[i])
    b = where(finite(scatmxo) eq 1)
    c = where(scatmxo30 ge thresh[i])
    d = where(finite(scatmxo30) eq 1)
    printf, lun, thresh[i], n_elements(a), n_elements(b), $
                 n_elements(c), n_elements(d), format='(i3,2x,4(i6,2x))'
  endfor
  free_lun, lun

end
