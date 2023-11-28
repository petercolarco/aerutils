  pro plot_panel, date, val0_, std0_, val1, std1, title, title0, title1, ytitle,$
                  position, noerase=noeraseUse, locuse=locuse

  if(not keyword_set(noeraseUse)) then noeraseUse = 0



   a = where(finite(val1) eq 1)
   nt = n_elements(date)
   xval = indgen(nt)+1

   val0 = make_array(nt,val=!values.f_nan)
   std0 = make_array(nt,val=!values.f_nan)
   val0[a] = val0_[a]
   std0[a] = std0_[a]


   locuse = 1

;  Find a suitable maximum value
   ymax = max([max(val1[a]+std1[a]),max(val0[a]+std0[a])])
   loadct, 0
   plot, xval, /nodata, noerase=noeraseUse, $
    xthick=3, xstyle=8, ythick=3, yrange=[0,ymax], ystyle=8, $
    xtitle='date', ytitle=ytitle, title=title, $
    position=position[*,0]
   for i = 0, nt-1 do begin
    x = i+1
    y = val1[i]
    yf = std1[i]
    if(finite(y)) then $
     polyfill, x+[-.5,.5,.5,-.5,-.5], y+[-yf,-yf,yf,yf,-yf], color=150, noclip=0
   endfor
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=70
   plots, indgen(nt)+1, val1[*], psym=-8, thick=4, lin=2, color=70

   usersym, [-1,1,1,-1,-1],[-1,-1,1,1,-1], /fill, color=0
   plots, xval, val0, psym=-8, thick=4
   for i = 0, nt-1 do begin
    x = i+1
    y = val0[i]
    yf = std0[i]
    if(finite(y)) then begin
     plots, x, y+[-yf,yf], color=0, noclip=0, thick=2
     plots, x+[-.5,.5], y-yf, color=0, thick=2, noclip=0
     plots, x+[-.5,.5], y+yf, color=0, thick=2, noclip=0
    endif
   endfor

   loadct, 0
   plot, indgen(1000), $
         xrange=[0,ymax], yrange=[0,ymax], $
         xstyle=8, ystyle=8, $
         xthick=4, ythick=4, $
         position=position[*,1], /noerase, $
         xtitle=title1, ytitle=title0
   ymax=!x.crange[1]   
   polyfill, [0,ymax,ymax,0], [0,.5*ymax,2*ymax,0], /fill, color=150, noclip=0
   oplot, indgen(1000)
   usersym, [-1,0,1,0,-1], [0,-1,0,1,0], /fill, color=0
   plots, val1, val0, psym=8

   do_stat = 1
   if(do_stat) then begin
    a = where(finite(val1) eq 1)
    n = n_elements(a)
    statistics, val1[a], val0[a], $
                mean0, mean1, std0_, std1_, r, bias, rms, skill, linslope, linoffset
    plots, findgen(1000), linslope*findgen(1000)+linoffset, linestyle=2, noclip=0
    n = strcompress(string(n, format='(i2)'),/rem)
    r = strcompress(string(r, format='(f6.3)'),/rem)
    bias = strcompress(string(bias, format='(f8.3)'),/rem)
    rms = strcompress(string(rms, format='(f6.3)'),/rem)
    skill = strcompress(string(skill, format='(f5.3)'),/rem)
    scale = !x.crange[1]
    polyfill, [.04,.72,.72,.04,.04]*scale, [.775,.775,.95,.95,.775]*scale, color=255, /fill
    xyouts, .05*scale, .9*scale, 'n = '+n, charsize=.65
    xyouts, .05*scale, .85*scale, 'r = '+r, charsize=.65
    xyouts, .05*scale, .8*scale, 'bias = '+bias, charsize=.65
    xyouts, .34*scale, .9*scale, 'rms = '+rms, charsize=.65
    xyouts, .34*scale, .85*scale, 'skill = '+skill, charsize=.65
    m = string(linslope,format='(f5.2)')
    b = string(linoffset,format='(f7.2)')
    xyouts, .34*scale, .8*scale, 'y = '+m+'x + '+b, charsize=.65
   endif


end
