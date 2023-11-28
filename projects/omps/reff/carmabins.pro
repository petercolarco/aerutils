; Colarco, February 2004
; Procedure returns a carma-like distributions of radius bins
; The bins are centered in volume betwen rlow and rup
; That is...r^3-rlow^3 = rup^3-r^3
; rup^3 = rlow^3*rmrat, which can be solved to find r given rmrat
; and a desired rlow, e.g. rmin = 1.d-6*((1.+rmrat)/2.)^(1.d/3)
; where the desired rlow = 1.d-6 in this example.
; The meaning of r is that it is the radius of the particle with 
; the average volume of the bin.

  pro carmabins, nbin, rmrat, rmin, rhop, $
                 rmass, rmassup, r, rup, dr, rlow, masspart

    cpi = 4.d/3.*!dpi

    rmassmin = cpi*rhop*rmin^3.d
    vrfact = ( (3./2./!dpi / (rmrat+1))^(1.d/3.))*(rmrat^(1.d/3.) - 1.)

    rmass = dblarr(nbin)
    rmassup = dblarr(nbin)
    r = dblarr(nbin)
    rup = dblarr(nbin)
    dr = dblarr(nbin)
    rlow = dblarr(nbin)

    for ibin = 0, nbin-1 do begin
     rmass[ibin]   = rmassmin*rmrat^double(ibin)
     rmassup[ibin] = 2.*rmrat/(rmrat+1.)*rmass[ibin]
     r[ibin]       = (rmass[ibin]/rhop/cpi)^(1.d/3.)
     rup[ibin]     = (rmassup[ibin]/rhop/cpi)^(1.d/3.)
     dr[ibin]      = vrfact*(rmass[ibin]/rhop)^(1.d/3.)
     rlow[ibin]    = rup[ibin] - dr[ibin]
    endfor
    masspart = 4./3. * !pi * r^3. * rhop

  end
