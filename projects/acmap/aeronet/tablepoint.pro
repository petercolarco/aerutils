pro tablepoint, incnum, location, latitude, longitude, elevation, piname, stattable, statelem=statelem

   if(not(keyword_set(statelem))) then statelem = 0

   print, '('+strcompress(string(incnum),/rem)+')' $
          + location+' (PI: '+piname+'), ' $
          + strcompress(string(latitude,format='(f7.2)'),/rem)+', ' $
          + strcompress(string(longitude,format='(f7.2)'),/rem)+', ' $
          +strcompress(string(elevation,format='(i4)'),/rem)+', ', $
          stattable[0,0], ',', stattable[1,0], ',', stattable[2,0], ',', $
          stattable[4,0], ',', stattable[1,1], ',', stattable[2,1], ',', $
          stattable[4,1], ',', $
          stattable[0,2], ',', stattable[1,2], ',', stattable[2,2], ',', $
          stattable[4,2], format='(a-90,4x,i2,6(a1,2x,f6.2),a2,4x,i6,3(a3,2x,f10.4))'

;  If AOT bias is > 0 plot up symbol, else plot down symbol
   colorarray = [0,80,120,200,255] ; B&W
   colorarray = [30, 80, 255, 208, 254]
   colorlabel = [255,0,0,0,255]

;  AOT
   case statelem of
    0: begin
       if(stattable[2,statelem] lt -.1) then ic = 0
       if(stattable[2,statelem] ge -.1) then ic = 1
       if(stattable[2,statelem] ge -.025) then ic = 2
       if(stattable[2,statelem] ge .025) then ic = 3
       if(stattable[2,statelem] ge .1) then ic = 4
       end
    1: begin
       if(stattable[2,statelem] lt -.3) then ic = 0
       if(stattable[2,statelem] ge -.3) then ic = 1
       if(stattable[2,statelem] ge -.1) then ic = 2
       if(stattable[2,statelem] ge .1) then ic = 3
       if(stattable[2,statelem] ge .3) then ic = 4
       end
    2: begin
       if(stattable[2,statelem] lt -.025) then ic = 0
       if(stattable[2,statelem] ge -.025) then ic = 1
       if(stattable[2,statelem] ge -.005) then ic = 2
       if(stattable[2,statelem] ge .005) then ic = 3
       if(stattable[2,statelem] ge .025) then ic = 4
       end
   endcase

   if(ic gt 2) then begin
    usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], /fill, color=colorarray[ic]
    plots, longitude, latitude, psym=8, noclip=0
    usersym, 2.*[-1,1,1,0,-1,-1],2.*[-1,-1,1,2,1,-1], color=0
    plots, longitude, latitude, psym=8, noclip=0
   endif
   if(ic lt 2) then begin
    usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], /fill, color=colorarray[ic]
    plots, longitude, latitude, psym=8, noclip=0
    usersym, 2.*[-1,1,1,0,-1,-1],2.*[1,1,-1,-2,-1,1], color=0
    plots, longitude, latitude, psym=8, noclip=0
   endif
   if(ic eq 2) then begin
    usersym, 2.*[-1,1,1,-1,-1],2.*[1,1,-1,-1,1], /fill, color=colorarray[ic]
    plots, longitude, latitude, psym=8, noclip=0
    usersym, 2.*[-1,1,1,-1,-1],2.*[1,1,-1,-1,1], color=0
    plots, longitude, latitude, psym=8, noclip=0
   endif
   xyouts, longitude, latitude-1.25, strcompress(string(incnum),/rem), $
           align=.5, clip=[0,0,1,1], charsize=.8, color=colorlabel[ic]

end


