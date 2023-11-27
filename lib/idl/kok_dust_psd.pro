; Simple procedure to consider the particle size distribution of dust
; suggest by Kok 2010. (His equations 5 & 6)

; Create a series of size bins
  nbin = 22
  rmrat = (15.d^3/.05d^3)^(1.d/nbin)
  rmin = 0.1*((1.+rmrat)/2.)^(1.d/3)
  rhop = 2650.
  carmabins, nbin, rmrat, rmin, rhop, $
             rmass, rmassup, r, rup, dr, rlow

  kok_psd, r, dr, dvdr, dndr

; normalize
  dv = dvdr*dr
  dv = dv/total(dv)
  dvdr = dv/dr

  dndlnd = dndr*r
  dvdlnd = dvdr*r
  d  = 2.*r
  dd = 2.*dr

; Plot
  !p.multi=[0,1,2]
  plot, 2.*r, dndlnd, /xlog, /ylog, xrange = [.2,20], xstyle=1, yrange=[1e-4,1], ystyle=1
  plot, 2.*r, dvdlnd, /xlog, /ylog, xrange = [.2,20], xstyle=1, yrange=[5e-4,2.5], ystyle=1

; Print the volume fraction to go into each size bin of gocart
  dlow  = [.1,1,1.8,3,6] * 2.
  dup   = [1,1.8,3,6,10] * 2.
  mfrac = fltarr(5)
  for ibin = 0, 4 do begin
   a = where(d ge dlow[ibin] and d lt dup[ibin])
   mfrac[ibin] = total(dvdlnd[a]*d[a]/dd[a])
  endfor
  mfrac = mfrac / total(mfrac)

end
