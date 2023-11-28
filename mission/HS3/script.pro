  set_plot, 'ps'
  !p.font = 0
  loadct, 39

  for itr = 0, nthresh-1 do begin

   device, file='tropatl.thresh='+strpad(itr+1,10)+'.ps', /color
   tmp  = aotarea[*,*,itr]
   tmpm = aotaream[*,*,itr]
   tmpa = areat

;  Smooth (7-day filter)
   for iyr = 0, nyr-1 do begin
    tmp[*,iyr]  = smooth(tmp[*,iyr],7)
    tmpa[*,iyr] = smooth(tmpa[*,iyr],7)
   endfor
   for iyr = 0, nyrm-1 do begin
    tmpm[*,iyr]  = smooth(tmpm[*,iyr],7)
   endfor
   xticks=9
   plot, [0,124], [0,1], /nodata, $
    xstyle=9, ystyle=9, ytitle='fractional area', $
    xticks=8, xminor=1, $
    xtickv=[1,17,31,48,62,79,93,109,123], $
    xtickn=['Jun 15','Jul 1','Jul 15','Aug 1',$
            'Aug 15','Sep 1','Sep 15','Oct 1','Oct 15']
   polymaxmin, indgen(123)+1, tmp, color=255, fillcolor=75
   oplot, indgen(123)+1, total(tmpm,2)/nyrm, thick=6
;   polymaxmin, indgen(123)+1, tmpm, color=255, fillcolor=208
  
   device, /close
  endfor

end
