; See also aerutils/projects/omps/scat/scat.pro

; Using here also the Gamma Distribution from Zhong Chen's 2018 AMT paper
; Compute the 525/120 angstrom parameter

; Optics tables
  fileSU = '/share/colarco/fvInput/AeroCom/x/carma_optics_SU.v1.nbin=22.nc'

; Wavelength
  lambdanm = 525.

; Get tables
  fill_mie_table, fileSU, strSU525, lambdanm=525.
  fill_mie_table, fileSU, strSU1020, lambdanm=1020.

; Zhong's PSD
  alpha = 2.8
  beta  = 20.5
  nbin = 22
  rmrat = (3.25d/0.0002d)^(3.d/nbin)
  rmin = 02.d-10*((1.+rmrat)/2.d)^(1.d/3.)
; Put rmin in microns
  rmin = rmin * 1e6
  carmabins, nbin, rmrat, rmin, 1700., $
             rmass, rmassup, r, rup, dr, rlow
  dndr = 1.*beta^alpha*r^(alpha-1)*exp(-r*beta) / gamma(alpha) / dr
  dvdr = 4./3.*!dpi*r^3*dndr

; 525
  tables = {strSU:strSU525}
  tauomps = 0.
  ssaomps = 0.
  gomps   = 0.
  for ib = 0, 21 do begin
   get_mie_table, tables.strSU, table, ib, .0
   tau_ = dvdr[ib]*dr[ib]*table.bext
   ssa_ = table.bsca / table.bext
   tauomps = tauomps + tau_
   ssaomps = ssaomps + ssa_*tau_
   gomps   = gomps   + table.g*ssa_*tau_
  endfor

; Normalize
  ssaomps  = ssaomps / tauomps
  gomps    = gomps / (ssaomps*tauomps)
  tauomps525 = tauomps

; 1020
  tables = {strSU:strSU1020}
  tauomps = 0.
  ssaomps = 0.
  gomps   = 0.
  for ib = 0, 21 do begin
   get_mie_table, tables.strSU, table, ib, .0
   tau_ = dvdr[ib]*dr[ib]*table.bext
   ssa_ = table.bsca / table.bext
   tauomps = tauomps + tau_
   ssaomps = ssaomps + ssa_*tau_
   gomps   = gomps   + table.g*ssa_*tau_
  endfor

; Normalize
  ssaomps  = ssaomps / tauomps
  gomps    = gomps / (ssaomps*tauomps)
  tauomps1020 = tauomps

; Angstrom parameter
  angstrom = -alog(tauomps525/tauomps1020)/alog(525./1020.)
  print, angstrom


end

