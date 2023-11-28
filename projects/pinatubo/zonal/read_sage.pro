; Colarco
; This is the SAGE dataset transmogrified by Larry Thomason, see his
; notes here: 
;  /misc/prc10/SAGE/CMIP\ Files/Release\ Notes\ on\ Version\ 6a.pdf
; The dataset is presented as an IDL save file with the following
; description:
;  grid4 = float(7,6,432,32,70) ; see below
;  lats  = float(32)            ; latitudes
;  tropa = float(12,32)         ; climatological (12-month, 32 lat)
;                               ; tropopause height [km]
;  dates = float(432)           ; fractional year 1979 - 2014
;  cpc   = float(4,12,32,70)    ; ???
; and the grid4 dimensions are
;  dim1(7):   0 - SAGE 1020 nm, 1 - SAGE XXX nm; 2 - SAGE YYY nm
;             3 - SAGE 386 nm, 4 - SAD, 5 - reff, 6 - OSIRIS 755 nm
;  dim2(6):   0 - mean extinction coefficient
;             1 - number of observations going into 0
;             2 - zonal standard deviation
;             3 - number of cloud observations excluded
;             4 - median report measurement uncertainty
;             5 - data source
;  dim3(432): month from 1/79 - 12/14
;  dim4(32):  latitudes
;  dim5(70):  altitude from 5 - 39.5 km (i.e., z = findgen(70)*.5 + 5)

; E.g., 
;  contour, grid4[0,0,149,*,*], lats, alt, $
;  levels=[6.3,16,40,100,250,630,1600,4000]*1e-7, /cell
; plots the SAGE 1020 nm extinction profile for June 1991
; and
;  contour, grid4[5,0,149,*,*], lats, alt, levels=[.1,.2,.3,.4], /cell
; plots the effective radius [um]
  restore, '/misc/prc10/SAGE/CMIP6\ Files/CCMI\ Version\ 6d\ 1979-2014.sav'
  alt = findgen(70)*.5 + 5.

end
