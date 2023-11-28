; Colarco, December 30, 2010
; Reader to pull variables from a file and return array and metadata.
; Possible unit conversion takes place; see below.
; Optional variable is "type" which may specify the aerosol type
; or else some other code.

; Given a species type and a variable name, return a filled variable array

  pro read_geos_diag, filename, varWant, varValue, $
                      varTitle, varunits, levelarray, labelarray, formcode, $
                      lon=lon, lat=lat, $
                      wantlon=wantlon, wantlat=wantlat, rc=rc

   varwant_ = strlowcase(varWant)

;  Default values can be overridden
   rc       = 0
   sum      = 0
   template = 0
   convfac  = 1.
   varn     = ''
   vartitle = ''
   varunits = ''
   formcode = '(f5.1)'
   levelarray = [.1,.2,.5,1,2,5,10]
   labelarray = ''

;  Loop over number of needed variables
   for ivar = 0, n_elements(varwant_)-1 do begin

    case varwant_[ivar] of

              'swtoaclr': begin
                     vartitle='SW TOA Aerosol (clear-sky)'
                     varunits=' [W m!E-2!N]'
                     varn='swtnetc'
                     nc4readvar, filename, varn, varval1, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     varn='swtnetcna'
                     nc4readvar, filename, varn, varval2, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     varvalue = varval2-varval1
                     levelarray = findgen(100)*.4 - 20
                     levelarray[0] = -1000.
                     labelarray = ['-20','20']
                     end
              'swsfcclr': begin
                     vartitle='SW Surface Aerosol (clear-sky)'
                     varunits=' [W m!E-2!N]'
                     varn='swgnetc'
                     nc4readvar, filename, varn, varval1, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     varn='swgnetcna'
                     nc4readvar, filename, varn, varval2, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     varvalue = varval2-varval1
                     levelarray = findgen(100)
                     labelarray = ['0','100']
                     end
              'swatmclr': begin
                     vartitle='SW Atmosphere Aerosol (clear-sky)'
                     varunits=' [W m!E-2!N]'
                     varn='swgnetc'
                     nc4readvar, filename, varn, varval1, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     varn='swgnetcna'
                     nc4readvar, filename, varn, varval2, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     sfc = varval2-varval1
                     varn='swtnetc'
                     nc4readvar, filename, varn, varval1, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     varn='swtnetcna'
                     nc4readvar, filename, varn, varval2, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     toa = varval2-varval1
                     varvalue = sfc - toa
                     levelarray = findgen(100)
                     labelarray = ['0','100']
                     end
              'swtoaall': begin
                     vartitle='SW TOA Aerosol (all-sky)'
                     varunits=' [W m!E-2!N]'
                     varn='swtnet'
                     nc4readvar, filename, varn, varval1, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     varn='swtnetna'
                     nc4readvar, filename, varn, varval2, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     varvalue = varval2-varval1
                     levelarray = findgen(100)*.4 - 20
                     levelarray[0] = -1000.
                     labelarray = ['-20','20']
                     end
              'swsfcall': begin
                     vartitle='SW Surface Aerosol (all-sky)'
                     varunits=' [W m!E-2!N]'
                     varn='swgnet'
                     nc4readvar, filename, varn, varval1, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     varn='swgnetna'
                     nc4readvar, filename, varn, varval2, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     varvalue = varval2-varval1
                     levelarray = findgen(100)
                     labelarray = ['0','100']
                     end
              'swatmall': begin
                     vartitle='SW Atmosphere Aerosol (all-sky)'
                     varunits=' [W m!E-2!N]'
                     varn='swgnet'
                     nc4readvar, filename, varn, varval1, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     varn='swgnetna'
                     nc4readvar, filename, varn, varval2, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     sfc = varval2-varval1
                     varn='swtnet'
                     nc4readvar, filename, varn, varval1, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     varn='swtnetna'
                     nc4readvar, filename, varn, varval2, sum=sum, template=template, $
                       lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc
                     toa = varval2-varval1
                     varvalue = sfc - toa
                     levelarray = findgen(100)
                     labelarray = ['0','100']
                     end
            else:    varn = varwant_
    endcase

   endfor ; loop over variables actually needed

   if(labelarray[0] eq '') then $
      labelarray = string(levelarray,format=formcode)

  
   if(convfac gt 0) then varvalue = reform(varvalue) * convfac $
   else varvalue = reform(varvalue) + convfac

end
