; Colarco
; August 28, 2008
; Given the MBL hypothetical track, I have sampled the "d" resolution
; MYD04 AOT at 550 nm along those tracks for Jul. 13 - 31, 2007.
; The objective is to correlate the MYD04 AOT (that is, the observed AOT)
; between one track and another.

  lon0want = [-180,-90, 0, 90,-180,-90, 0, 90,-180,-90, 0, 90,-180]
  lon1want = [ -90,  0,90,180, -90,  0,90,180, -90,  0,90,180, 180]
  lat0want = [30,30,30,30, 0, 0, 0, 0,-30,-30,-30,-30,-70]
  lat1want = [70,70,70,70,30,30,30,30,  0,  0,  0,  0,-30]

  for ir = 0, 12 do begin
  
  regstr = strcompress(string(ir+1),/rem)
  if(ir+1 lt 10) then regstr = '0'+regstr
  regstr = 'region'+regstr

  lonwant = [lon0want[ir],lon1want[ir]]
  latwant = [lat0want[ir],lat1want[ir]]

; Set up the plot
  set_plot, 'ps'
  device, file='corr_tatl_model.'+regstr+'.ps', /helvetica, font_size=14, /color, $
   xoff=.5, yoff=.5, xsize=18, ysize=26
  loadct, 39
  !p.font=0

; Read in the tracks
  read_mbltrack_model, time, date, lon, lat, tau

; Nadir track lat, lon
  latn = lat[*,3]
  lonn = lon[*,3]


; break the dataset into unique days
  dateday = date/100L
  uniqday = uniq(dateday)
  nday = n_elements(uniqday)


  for iday = 0, nday-2 do begin
   a = where(date/100L eq dateday[uniqday[iday]] and $
             lonn ge lonwant[0] and lonn le lonwant[1] and $
             latn ge latwant[0] and latn le latwant[1])

   if(a[0] ne -1) then begin
  !p.multi=[0,2,4]

;  find contiguous chunks of it all
   iestart = a[0]
   for i = 1L, n_elements(a)-1 do begin
    if(a[i] - a[i-1] gt 1) then begin
     iestart = [iestart,a[i]]
     it = n_elements(iestart)-1
     if(it eq 1) then ieend = a[i-1]
     if(it gt 1) then ieend = [ieend,a[i-1]]
    endif
   endfor
   ieend = [ieend,a[n_elements(a)-1]]
   ntracks = n_elements(iestart)

   map_set, limit=[latwant[0],lonwant[0],latwant[1],lonwant[1]], $
    position=[.075,.775,.5,.95]
   xyouts, .075, .975, $
      'GEOS-5: '+strcompress(string(dateday[uniqday[iday]]), /rem), $
      /normal
   map_continents, thick=3
   map_continents, /countries

   color = [48,84,120,0,172,208,254]

   usetrack = make_array(ntracks,val=0)
   for i = 0, ntracks-1 do begin
;   Select only ascending (daytime) tracks
    if(latn[iestart[i]] lt latn[ieend[i]]) then begin
     usetrack[i] = 1
     for it = 0, 6 do begin
      lon_ = lon[iestart[i]:ieend[i],it]
      lat_ = lat[iestart[i]:ieend[i],it]
      plots, lon_, lat_, thick=6, color=color[it]
     endfor
     xyouts, lonn[iestart[i]], latn[iestart[i]], strcompress(string(i+1),/rem)
    endif
   endfor

   iplot = 0
   for i = 0, ntracks-1 do begin

    if(usetrack[i] eq 1) then begin

     !p.multi=[6-iplot,2,4]
     time_ = time[iestart[i]:ieend[i]]
     hour_ = (time_ - fix(time_))*24.
     lon_ = lon[iestart[i]:ieend[i]]
     lat_ = lat[iestart[i]:ieend[i]]
     tau_ = reform(tau[iestart[i]:ieend[i],*])

;    Set up the x-axis range
     time0   = min(hour_)
     time1   = max(hour_)
;    If the time is less than some minimum value, expand it
     delnn   = (time1-time0)*60.
     if(delnn lt 8.) then begin
      tinc = (8.-delnn)/2./60.
      time0 = time0-tinc
      time1 = time1+tinc
     endif
     hh0     = fix(time0)
     nn0     = (time0-hh0)*60.
     time0   = hh0+fix(nn0)/60.
     hh1     = fix(time1)
     nn1     = (time1-hh1)*60.
     time1   = hh1+fix(nn1+.5)/60.



     plot, hour_, tau_, /nodata, $
      yrange=[0,2], ythick=3, ystyle=9, $
      xrange=[time0,time1], xthick=3, xstyle=9, $
      title='Track #'+strcompress(string(i+1),/rem), $
      xtitle = 'hour', ytitle='AOT [550 nm]'

     for it = 0, 6 do begin    
      oplot, hour_, tau_[*,it], color=color[it], thick=3
     endfor

 ;   Make a correlation matrix
     x0 = !x.region[0] + (!x.region[1]-!x.region[0])/3.
     dx = (!x.region[1] - x0)/9.
     y0 = !y.region[0] + (!y.region[1]-!y.region[0])/2.
     dy = (!y.region[1] - y0)/9.
     label = ['-15','-10','-5','0','5','10','15']
     for ix = 1, 7 do begin
      xyouts, x0+ix*dx, y0+7.*dy, label[ix-1], $
       color=color[ix-1], /normal, charsize=.5, align=.5
     endfor
     for iy = 1, 7 do begin
      xyouts, x0, y0+(7.-iy)*dy, label[iy-1], $
       color=color[iy-1], /normal, charsize=.5
     endfor
     for ix = 1, 7 do begin
      for iy = 1, 7 do begin
       xp = x0+ix*dx
       yp = y0+(7.-iy)*dy
       if(ix eq iy) then begin
        xyouts, xp, yp, '-', /normal, align=.5
       endif else begin
        b = where(finite(tau_[*,ix-1]) eq 1 and $
                  finite(tau_[*,iy-1]) eq 1)
        if(n_elements(b) lt 3) then begin
         xyouts, xp, yp, '-', /normal, align=.5
        endif else begin
         r = correlate(tau_[b,ix-1],tau_[b,iy-1])
         xyouts, xp, yp, strcompress(string(r,format='(f5.2)'),/rem), /normal, align=.5, charsize=.5
        endelse
       endelse
      endfor
     endfor     

     iplot = iplot+1
    endif

   endfor

  endif

  endfor

  device, /close

  endfor ; region

end
