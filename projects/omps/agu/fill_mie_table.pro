; Create a structure to hold the lookup tables
; Optionally return on a specified wavelength, lambda, given in [nm]

  pro fill_mie_table, filename, str, lambdanm=lambdanm

    pmom = 1.d
    readoptics, filename, reff, lambda, qext, qsca, bext, bsca, g, bbck, $
                rh, rmass, refr, refi, radius=r, dr=dr, rlow=rlow, $
                rup=rup, pmoments=pmom, pback=pback

;   for now restrict pmoments to first element
    pmom = pmom[*,*,*,*,0]

;   If a particular wavelength is requested, then return only that
    if(keyword_set(lambdanm)) then begin
     lambdam = lambdanm*1e-9
     il = interpol(indgen(n_elements(lambda)),lambda,lambdam)
     lambda = lambdam
     nbin   = n_elements(reff[0,*])
     nrh    = n_elements(reff[*,0])
     nmom   = n_elements(pmom[0,0,0,*])
     qext_  = fltarr(nrh,nbin)
     qsca_  = fltarr(nrh,nbin)
     bext_  = fltarr(nrh,nbin)
     bsca_  = fltarr(nrh,nbin)
     bbck_  = fltarr(nrh,nbin)
     g_     = fltarr(nrh,nbin)
     refr_  = fltarr(nrh,nbin)
     refi_  = fltarr(nrh,nbin)
     pmom_  = fltarr(nrh,nbin,nmom)
     for irh = 0, nrh-1 do begin
      for ibin = 0, nbin-1 do begin
       qext_[irh,ibin] = interpolate(qext[*,irh,ibin],il)
       qsca_[irh,ibin] = interpolate(qsca[*,irh,ibin],il)
       bext_[irh,ibin] = interpolate(bext[*,irh,ibin],il)
       bsca_[irh,ibin] = interpolate(bsca[*,irh,ibin],il)
       bbck_[irh,ibin] = interpolate(bbck[*,irh,ibin],il)
       g_[irh,ibin]    = interpolate(g[*,irh,ibin],il)
       refr_[irh,ibin] = interpolate(refr[*,irh,ibin],il)
       refi_[irh,ibin] = interpolate(refi[*,irh,ibin],il)
       for imom = 0, nmom-1 do begin
        pmom_[irh,ibin,imom] = interpolate(pmom[*,irh,ibin,imom],il)
       endfor
      endfor
     endfor
     qext = qext_
     qsca = qsca_
     bext = bext_
     bsca = bsca_
     bbck = bbck_
     g    = g_
     refr = refr_
     refi = refi_
     pmom = pmom_
    endif

    str = {reff:reff, lambda: lambda, qext:qext, qsca:qsca, bext:bext, bsca:bsca, $
           g:g, bbck:bbck, rh:rh, rmass:rmass, refr:refr, refi:refi, pmom:pmom}

  end
