  pro plot_ratio, ratio, lon, lat, color=color, length=length

  thick = 8

  if(not(keyword_set(color))) then color = 0
  if(not(keyword_set(length))) then length=0

; Ratio larger
  a = where(ratio ge 2)
  if(a[0] ne -1) then begin
   if(length) then begin
    for i = 0, n_elements(a)-1 do begin
     if(ratio[a[i]] gt 100.) then scale=4.
     if(ratio[a[i]] le 100.) then scale=3.
     if(ratio[a[i]] le 10.) then scale=2.
     if(ratio[a[i]] le 5.) then scale=1.
     if(color eq 255) then begin
      usersym, [-1,0,1,0,0]*scale, [2,3,2,3,0]*scale, thick=thick*2, color=0
      plots, lon[a[i]], lat[a[i]], psym=8, noclip=0
     endif
     usersym, [-1,0,1,0,0]*scale, [2,3,2,3,0]*scale, thick=thick, color=color
     plots, lon[a[i]], lat[a[i]], psym=8, noclip=0
    endfor
   endif else begin
    if(color eq 255) then begin
     usersym, [-1,0,1,0,0]*1.5, [2,3,2,3,0]*1.5, thick=thick*2, color=0
     plots, lon[a], lat[a], psym=8, noclip=0
    endif
    usersym, [-1,0,1,0,0], [2,3,2,3,0], thick=thick, color=color
    plots, lon[a], lat[a], psym=8, noclip=0
   endelse
  endif

  a = where(ratio lt 2 and ratio gt .5)
  if(a[0] ne -1) then begin
   if(color eq 255) then begin
    usersym, [-1,1,0,0,0]*1.5, [0,0,0,1,-1]*1.5, thick=thick*2, color=0
    plots, lon[a], lat[a], psym=8, noclip=0
   endif
   usersym, [-1,1,0,0,0], [0,0,0,1,-1], thick=thick, color=color
   plots, lon[a], lat[a], psym=8, noclip=0
  endif

  a = where(ratio le 0.5)
  if(a[0] ne -1) then begin
   if(length) then begin
    for i = 0, n_elements(a)-1 do begin
     if(1./ratio[a[i]] gt 100.) then scale=4.
     if(1./ratio[a[i]] le 100.) then scale=3.
     if(1./ratio[a[i]] le 10.) then scale=2.
     if(1./ratio[a[i]] le 5.) then scale=1.
     if(color eq 255) then begin
      usersym, [-1,0,1,0,0]*scale, [-2,-3,-2,-3,0]*scale, thick=thick*2, color=0
      plots, lon[a[i]], lat[a[i]], psym=8, noclip=0
     endif
     usersym, [-1,0,1,0,0]*scale, [-2,-3,-2,-3,0]*scale, thick=thick, color=color
     plots, lon[a[i]], lat[a[i]], psym=8, noclip=0
    endfor
   endif else begin
    if(color eq 255) then begin
     usersym, [-1,0,1,0,0]*1.5, [-2,-3,-2,-3,0]*1.5, thick=thick*2, color=0
     plots, lon[a], lat[a], psym=8, noclip=0
    endif
    usersym, [-1,0,1,0,0], [-2,-3,-2,-3,0], thick=thick, color=color
    plots, lon[a], lat[a], psym=8, noclip=0
   endelse
  endif

end

