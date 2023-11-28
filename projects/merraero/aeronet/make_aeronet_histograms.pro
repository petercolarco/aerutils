; Make a histogram diagram of the difference (model - aeronet) in AOT
; field.  Supports multiple instances of model field.

; Expid to compare
  expid = ['dR_MERRA-AA-r2','dR_F25b18']
  expfn = ['/misc/prc15/colarco/dR_MERRA-AA-r2/inst2d_hwl_x/aeronet/', $
           '/misc/prc14/colarco/dR_F25b18/inst2d_hwl_x/aeronet/'] $
          + expid+'.inst2d_hwl.aeronet.%ch.%y4.nc4'
  nexp = n_elements(expid)

; How sample?
  yyyy = strpad(findgen(1)+2007.,1000L)
  date0 = '20070101'
  date1 = '20071231'
  nymd = [date0,date1]
  nhms = ['000000','230000']
  three = 0
  six   = 0
  hourly = 1
  varwant = ['totexttau']

; Set up the histogram binning
  nbin = 101
  minv = -0.5
  maxv =  0.5
  hist = lonarr(nbin,nexp)


; Read the database of aeronet locations
  read_aeronet_locs, location, lat, lon, ele, database='aeronet_locs.dat'
  nlocs = n_elements(location)
  aeronetPath = '/misc/prc10/AERONET/LEV30/'
  lambdabase = '550'
  first = 1
  useloc = intarr(nlocs)
  numloc = lonarr(nlocs)
  for iloc = 0, nlocs-1 do begin

;if(location[iloc] ne 'Capo_Verde') then continue

;  read in the aeronet aot and angstrom exponents and reduce to
;  specified date range
   locwant = location[iloc]
   aeronetAngstrom = 1.
   read_aeronet2nc, aeronetPath, locwant, lambdabase, yyyy, aeronetAOT, aeronetDate, $
                    naot=aeronetNum, hourly=hourly, three=three, six=six
   a = where(aeronetAOT lt -9990.)
   if(a[0] ne -1) then aeronetAOT[a] = !values.f_nan
   if(a[0] ne -1) then aeronetNum[a] = !values.f_nan
   aeronetNYMD = string(aeronetDate/100,format='(i8)')
   a = where(aeronetNYMD ge date0 and aeronetNYMD le date1)
   if(a[0] eq -1) then begin
    print, 'No dates in requested range; exit'
    stop
   endif

   b = where(finite(aeronetAOT[a]) eq 1)
   if(b[0] eq -1) then continue
   useloc[iloc] = 1
   print, 'Getting: ',location[iloc], ' ('+strpad(iloc+1,100)+'/'+strpad(nlocs,100)+')'
   aeronetDate = aeronetDate[a]
   aeronetAOT  = aeronetAOT[a]
   aeronetNum  = aeronetNum[a]

   a = where(finite(aeronetaot) eq 1)
   numloc[iloc] = n_elements(a)

;  Keep this
   if(first eq 1) then begin
    aeraot = aeronetaot[a]
   endif else begin
    aeraot = [aeraot,aeronetaot[a]]
   endelse

;  At this point read the corresponding model
   if(six)    then tinc = 360.
   if(three)  then tinc = 180.
   if(hourly) then tinc = 60.

   for iexp = 0, nexp-1 do begin
    readmodel_aeronet, expfn[iexp], locwant, nymd, nhms, lambdabase, $
                       varwant, modeldate, modelAOT, tinc=tinc
    if(iexp eq 0) then begin
     modaot_ = modelaot[a]
    endif else begin
     modaot_ = [modaot_,modelaot[a]]
    endelse
   endfor

   modaot_ = reform(modaot_,n_elements(a),nexp)
   if(first eq 1) then begin
    modaot = modaot_
    first = 0
   endif else begin
    modaot = [modaot,modaot_]
   endelse
  endfor

  save, /all, filename='aeronet_histogram.2007.sav'

end


