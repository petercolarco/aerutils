; First cut at autocorrelation code...

  res = 'f'
  read_mbltrack_modis, time, date, lon, lat, lev, tau, res=res
  itrack = 3  ; central track
  latn = lat[*,itrack]
  lonn = lon[*,itrack]


; Pick a region
  lonwant_ = fltarr(2,3)
  lonwant_[*,0] = [-40,-20]; tatl
  lonwant_[*,1] = [-70,-40]; carib
  lonwant_[*,2] = [130,150]; asia

  latwant = [-10,60]

; break the dataset into unique days
  dateday = date/100L
  uniqday = uniq(dateday)
  nday = n_elements(uniqday)

;map_set, /cont
  colorarray = [254, 208, 90]
  set_plot, 'ps'
  device, filename='spaceautocor.ps', /color
  !p.font=0
  loadct, 39
  plot, indgen(100)+1, /nodata, $
        /xlog, xrange=[.1,10000], xtitle='Lag/20 km', $
        yrange=[-.4,1], ytitle='Autocorrelation, r', ystyle=1
  plots, [.1,10000], .8, lin=1


for ilon = 0, 2 do begin
  lonwant = lonwant_[*,ilon]


  idone = 0
; Loop over the days and find the separate tracks in this region
  for iday = 0, nday-2 do begin
   a = where(date/100L eq dateday[uniqday[iday]] and $
             lonn ge lonwant[0] and lonn le lonwant[1] and $
             latn ge latwant[0] and latn le latwant[1])

;  Probably you have several tracks passing through the region
;  Find contiguous chunks to identify the individual tracks
;  At end, iestart and ieend are the indices of the beginning
;  and ending points of each track
   iestart = a[0]
   ieend   = a[n_elements(a)-1]
   it = 0
   for i = 1L, n_elements(a)-1 do begin
    if(a[i] - a[i-1] gt 1) then begin
     iestart = [iestart,a[i]]
     it = n_elements(iestart)-1
     if(it eq 1) then begin 
       ieend = a[i-1]
     endif else begin
       ieend   = [ieend,a[i-1]]
     endelse
    endif
   endfor
   if(it gt 0) then ieend = [ieend,a[n_elements(a)-1]] 
   ntracks = n_elements(iestart)

;  Nighttime tracks will not have satellite data associated,
;  so exclude these.  Only ascending tracks are daytime.
   usetrack = make_array(ntracks,val=0)
   for i = 0, ntracks-1 do begin
;   Select only ascending (daytime) tracks
    if(latn[iestart[i]] lt latn[ieend[i]]) then begin
     usetrack[i] = 1
    endif
   endfor

;  Select the date of the valid track
   qb = where(usetrack eq 1)
   ntracks = n_elements(qb)
   if(qb[0] ne -1) then begin
    for iqb = 0, n_elements(qb)-1 do begin
     if(idone eq 0) then begin
      trackdate = date[iestart[qb[iqb]]]
      trackstart = iestart[qb[iqb]]
      trackend = ieend[qb[iqb]]
      trackpts = ieend[qb[iqb]] - iestart[qb[iqb]]+1
      idone = 1
     endif else begin
      trackdate  = [trackdate, date[iestart[qb[iqb]]] ]
      trackstart = [trackstart, iestart[qb[iqb]]]
      trackend   = [trackend, ieend[qb[iqb]]]
      trackpts = [trackpts, ieend[qb[iqb]] - iestart[qb[iqb]]+1]
     endelse
;     plots, lonn[iestart[qb[iqb]]:ieend[qb[iqb]]], latn[iestart[qb[iqb]]:ieend[qb[iqb]]], psym=3
    endfor

   endif

  endfor


; Now at this point I have a collection of the individual tracks
; This is what I will lag against
  ntracks = n_elements(trackdate)
  lagcorr = make_array(ntracks,7,value=!values.f_nan)
  clagcorr = make_array(ntracks,7,value=0)
  for itrack = 0, ntracks-1 do begin
   tau_ = tau[trackstart[itrack]:trackend[itrack],*]

;  Loop over the lags
   for lag = 0, 6 do begin
     m1 = 0.
     m2 = 0.
     s1 = 0.
     s2 = 0.
     c1 = 0
     c2 = 0
     corr = 0.

;    Mean of points -k away from another data point
     for il = lag, 6 do begin
      a = where(finite(tau_[*,il-lag]) eq 1 and finite(tau_[*,il]) eq 1)
      if(a[0] ne -1) then begin
       m1 = m1 + total(tau_[a,il-lag])
       c1 = c1 + n_elements(tau_[a,il-lag])
      endif
     endfor
     m1 = m1/c1

;    Standard deviation of points -k away from another data point
     for il = lag, 6 do begin
      a = where(finite(tau_[*,il-lag]) eq 1 and finite(tau_[*,il]) eq 1)
      if(a[0] ne -1) then begin
       s1 = s1 + total( (tau_[a,il-lag]-m1)^2. )
      endif
     endfor
     s1 = sqrt(s1/(c1-1.))

;    Mean of points +k away from another data point
     for il = 0, 6-lag do begin
      a = where(finite(tau_[*,il]) eq 1 and finite(tau_[*,il+lag]) eq 1)
      if(a[0] ne -1) then begin
       m2 = m2 + total(tau_[a,il+lag])
       c2 = c2 + n_elements(tau_[a,il+lag])
      endif
     endfor
     m2 = m2/c2

;    Standard deviation of points +k away from another data point
     for il = 0, 6-lag do begin
      a = where(finite(tau_[*,il]) eq 1 and finite(tau_[*,il+lag]) eq 1)
      if(a[0] ne -1) then begin
       s2 = s2 + total( (tau_[a,il+lag]-m2)^2. )
      endif
     endfor
     s2 = sqrt(s2/(c2-1.))

;    Lag correlation
     for il = 0, 6-lag do begin
      a = where(finite(tau_[*,il]) eq 1 and finite(tau_[*,il+lag]) eq 1)
      if(a[0] ne -1) then begin
       corr = corr + total( (tau_[a,il]-m1)*(tau_[a,il+lag]-m2) )
      endif
     endfor
     lagcorr[itrack,lag] = corr/(s1*s2)/sqrt((c1-1.)*(c2-1.))
     clagcorr[itrack,lag] = sqrt((c1-1.)*(c2-1.))

   endfor
  endfor

; Now compose a weighted average of the lagcorrelations
  nlag = 7
  lagcorr_ = fltarr(nlag)
  for lag = 0, nlag-1 do begin
   lc = lagcorr[*,lag]
   cc = clagcorr[*,lag]
   a = where(finite(lc) eq 1 and cc gt 2)
   lagcorr_[lag] = total(lc[a]*cc[a])/total(cc[a])
  endfor

  hour = findgen(nlag)*62./20.
  hour[0] = .1
  oplot, hour, lagcorr_, thick=6, color=colorarray[ilon], lin=2


endfor


  device, /close








end
