; Colarco, September 2007

; Pass in the parameters of a lognormal distribution (rmed, sigma, frac)
; along with the desired size bins and return the quantities dNdr, dSdr,
; and dMdr.

; Input
;  rmed, sigma, frac = nmodes element arrays of the parameters of the
;                      desired lognormal modes.
;  r, dr             = nbin element arrays specifying the bin sizes
;                      results are desired on.
;  volume            = (optional)  If volume = 1 (i.e., /volume) then the
;                      then parameters passed are assumed to be those
;                      of a volume distribution, else assumed number
;                      parameters were passed.
;  rlow, rup         = (optional) nbin elements arrays specifying the size
;                      bin upper and lower edges, from which you can
;                      exactly calculate the quantities in each size bin
;                      using error functions.

  pro lognormal, rmed, sigma, frac, $
                 r, dr, $
                 dNdr, dSdr, dVdr, $
                 volume=volume, $
                 rlow=rlow, rup=rup

; First, how many modes are requested.
  nmodes = n_elements(rmed)
  if(nmodes ne n_elements(sigma)) then stop
  if(nmodes ne n_elements(frac))  then stop

; Check the number of size bins in the output
  nbin = n_elements(r)
  if(nbin ne n_elements(dr)) then stop

; Now we normalize the distribution
  tfrac = total(frac)
  frac_ = frac/tfrac


; Output fundamental
  dQdr = fltarr(nbin)
  for im = 0, nmodes-1 do begin
   for ibin = 0L, nbin-1 do begin
    dQdr[ibin] = dQdr[ibin] + $
                 frac_[im] / (sqrt(2.*!dpi)*alog(sigma[im])) * $
                 (1./r[ibin]) * exp(-(alog(r[ibin]/rmed[im]))^2. / $
                                     (2.*(alog(sigma[im]))^2.) )
   endfor
  endfor

; Alternatively, if the ranges of each bin are passed, can
; accurately compute quantities using error functions (Zender et al., 2003)
  if(keyword_set(rlow)) then begin
   nbin = n_elements(rlow)
   if(not(keyword_set(rup))) then stop
   if(n_elements(rup) ne nbin) then stop
   mFrac = fltarr(nbin)
   for im = 0, nmodes-1 do begin
    for ibin = 0L, nbin-1 do begin
     mFrac[ibin] = mFrac[ibin] + $
                   frac_[im] * $
                   0.5 * ( erf( alog(rup[ibin]/rmed[im]) / $
                               (sqrt(2.)*alog(sigma[im])) ) - $
                           erf( alog(rlow[ibin]/rmed[im]) / $
                               (sqrt(2.)*alog(sigma[im])) ) $
                         )
    endfor
   endfor
   dQdr = mFrac / (rup-rlow)
  endif


; Check if parameters passed were for a volume distribution
  if(keyword_set(volume)) then begin
   if(volume) then begin
    dVdr = dQdr
    dNdr = dQdr / (4./3.*!dpi*r^3.)
    dSdr = dNdr * (4.*!dpi*r^2.)
   endif
  endif else begin
   dNdr = dQdr
   dSdr = dNdr * (4.*!dpi*r^2.)
   dVdr = dNdr * (4./3.*!dpi*r^3.)
  endelse

end


