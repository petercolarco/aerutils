; Colarco, March 2017
; Use the compute_reff_zonal to get the zonal mean reff profiles from
; all of the control files, and save in an IDL save file

; Get the DDF to scan
  ddflist = file_search("*ddf")
  nf = n_elements(ddflist)

; Get offsets to get 1 month, 1 year, and 2 years after eruption
  offset = intarr(nf)
  a = where(strpos(ddflist,'jan') ne -1)
  offset[a] = 1
  a = where(strpos(ddflist,'apr') ne -1)
  offset[a] = 4
  a = where(strpos(ddflist,'jul') ne -1)
  offset[a] = 7
  a = where(strpos(ddflist,'oct') ne -1)
  offset[a] = 10

  wantlat = fltarr(nf)
  a = where(strpos(ddflist,'NHL') ne -1)
  wantlat[a] = 60.
  a = where(strpos(ddflist,'NML') ne -1)
  wantlat[a] = 45.
  a = where(strpos(ddflist,'TRO') ne -1)
  wantlat[a] = 15.
  a = where(strpos(ddflist,'STR') ne -1)
  wantlat[a] = -15.
  a = where(strpos(ddflist,'SML') ne -1)
  wantlat[a] = -60.
  a = where(strpos(ddflist,'SHL') ne -1)
  wantlat[a] = -75.


; Hard set some array sizes
  nbin = 22
  nt   = 3

; Make the accumulating arrays
  dndr  = fltarr(nbin,nt,nf)
  r     = fltarr(nbin,nt,nf)
  dr    = fltarr(nbin,nt,nf)


  for i = 0, nf -1 do begin
   for it = 0, 2 do begin
    case it of
     0: itime = offset[i]    ; 1 month
     1: itime = offset[i]+11 ; 1 year
     2: itime = offset[i]+23 ; 2 years
    endcase
    compute_dndr, ddflist[i], wantlat[i], itime, dndr_, r_, dr_
    dndr[*,it,i] = dndr_
    r[*,it,i]    = r_
    dr[*,it,i]   = dr_
   endfor
  endfor
  save, /variables, filename = 'compute_dndr.sav'




end
