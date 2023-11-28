; Colarco, December 30, 2010
; Reader to pull variables from a file and return array and metadata.
; Possible unit conversion takes place; see below.
; Optional variable is "type" which may specify the aerosol type
; or else some other code.

; Given a species type and a variable name, return a filled variable array

  pro read_carma_diag, filename, varWant, varValue, $
                       varTitle, varunits, levelarray, labelarray, formcode, $
                       lon=lon, lat=lat, $
                       wantlon=wantlon, wantlat=wantlat, type=type, rc=rc

   if(not(keyword_set(type))) then type = 'DU' ; give a default value
   varwant_ = strlowcase(varWant)

;  Special handling
   if(varwant_[0] eq 'ssa' or varwant_[0] eq 'tauabs') then varwant_ = ['tau','tausca']
   if(varwant_[0] eq 'taufrac')                        then varwant_ = ['tau','tautot']

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

;  Default level values
   case type of
    'BC' : begin
           levelArray = [0.001,0.002,0.005,0.01,0.02,0.05,0.1]
           levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]
           formcode = '(f5.3)'
           end
    'SU' : begin
           levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]
           formcode = '(f5.2)'
           end
    'OC' : begin
           levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]
           formcode = '(f5.2)'
           end
    'POM': begin
           levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]
           formcode = '(f5.2)'
           end
    'SM':  begin
           levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]
           formcode = '(f5.2)'
           end
    ELSE : begin
           end
   endcase

;  Loop over number of needed variables
   for ivar = 0, n_elements(varwant_)-1 do begin

    case varwant_[ivar] of

              'precipls': begin
                     vartitle='Large-scale Precip'
                     varunits=' [mm day!E-1!N]'
                     varn='pls'
                     convfac = 86400. ; kg m-2 s-1 -> mm day-1
                     levelarray = findgen(100)*.2
                     labelarray = ['0','20']
                     end
              'precipcu': begin
                     vartitle='Convective Precip'
                     varunits=' [mm day!E-1!N]'
                     varn='pcu'
                     convfac = 86400. ; kg m-2 s-1 -> mm day-1
                     levelarray = findgen(100)*.2
                     labelarray = ['0','20']
                     end
              'precipsno': begin
                     vartitle='Snowfall'
                     varunits=' [mm day!E-1!N]'
                     varn='sno'
                     convfac = 86400. ; kg m-2 s-1 -> mm day-1
                     levelarray = findgen(100)*.2
                     labelarray = ['0','20']
                     end
              'preciptot': begin
                     vartitle='Total Precip'
                     varunits=' [mm day!E-1!N]'
                     varn=['pls','pcu','sno']
                     convfac = 86400. ; kg m-2 s-1 -> mm day-1
                     levelarray = findgen(100)*.2
                     labelarray = ['0','20']
                     sum = 1
                     end
              't2m': begin
                     vartitle='2-m Temperature'
                     varunits=' [!Eo!NC]'
                     varn='t2m'
                     convfac = -273. ; K -> C
                     levelarray = -25. + findgen(100)*.7
                     labelarray = ['-25','45']
                     end
              'cldtt': begin
                     vartitle='Cloud Fraction (total)'
                     varn='cldtt'
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     end
              'cldlo': begin
                     vartitle='Cloud Fraction (Low)'
                     varn='cldlo'
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     end
              'cldmd': begin
                     vartitle='Cloud Fraction (Medium)'
                     varn='cldmd'
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     end
              'cldhi': begin
                     vartitle='Cloud Fraction (High)'
                     varn='cldhi'
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     end
              'ttau': begin
                     vartitle='Total AOT [400 - 690 nm band]'
                     varn=['ttaudu','ttauss','ttauso','ttauoc','ttaubc']
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     sum = 1
                     end
              'ttaudu': begin
                     vartitle='Dust AOT [400 - 690 nm band]'
                     varn='ttaudu'
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     end
              'ttauss': begin
                     vartitle='Sea Salt AOT [400 - 690 nm band]'
                     varn='ttauss'
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     end
              'ttauso': begin
                     vartitle='Sulfate AOT [400 - 690 nm band]'
                     varn='ttauso'
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     end
              'ttaubc': begin
                     vartitle='Black Carbon AOT [400 - 690 nm band]'
                     varn='ttaubc'
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     end
              'ttauoc': begin
                     vartitle='Organic Carbon AOT [400 - 690 nm band]'
                     varn='ttauoc'
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     end
              'tautot': begin
                     levelarray = [.1,.2,.3,.4,.5,.7,1.0]
                     varn = ['totexttau']
                     sum = 1
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     varTitle = 'TAUEXT [550 nm]'
                     end
              'tau': begin
                     levelarray = [.1,.2,.3,.4,.5,.7,1.0]
                     if(type eq 'TOT') then varn = ['totexttau']
                     if(type eq 'TOT') then sum = 1
                     if(type eq 'TOT') then levelarray = findgen(100)*.01
                     if(type eq 'TOT') then labelarray = ['0','1']
                     if(type eq 'DU' or type eq 'DZ') then varn = 'duexttau'
                     if(type eq 'BC') then varn = 'bcexttau'
                     if(type eq 'BC') then levelarray = 0.1*[.1,.2,.3,.4,.5,.7,1.0]
                     if(type eq 'BC') then levelarray = [.1,.2,.3,.4,.5,.7,1.0]
                     if(type eq 'SU') then varn = 'suexttau'
                     if(type eq 'SS') then varn = 'ssexttau'
                     if(type eq 'SM') then varn = 'smexttau'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocexttau'
                     varTitle = 'TAUEXT [550 nm]'
                     end
              'tausca': begin
                     if(type eq 'TOT') then varn = ['totscatau']
                     if(type eq 'TOT') then sum = 1
                     if(type eq 'DU' or type eq 'DZ') then varn = 'duscatau'
                     if(type eq 'BC') then varn = 'bcscatau'
                     if(type eq 'SU') then varn = 'suscatau'
                     if(type eq 'SS') then varn = 'ssscatau'
                     if(type eq 'SM') then varn = 'smscatau'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocscatau'
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     varTitle = 'TAUSCA [550 nm]'
                     end
              'emis': begin
                     varTitle = 'Emissions'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     template = 1
                     sum = 1
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'duem'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocem'
                     if(type eq 'BC')                  then varn = 'bcem'
                     if(type eq 'SS')                  then varn = 'ssem'
                     if(type eq 'SM')                  then varn = 'smem'
                     if(type eq 'SU')                  then varn = 'suem'
                     if(type eq 'CO')                  then varn = 'coem001'
                     if(type eq 'CO2') then begin
                        varn = 'co2em001'
                        levelarray = [-100,-20,-10,0,10,20,100]
                        formcode = '(f7.1)'
                     endif
                     end
             'emisso2':  begin
                     varTitle = 'Emissions (SO2)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')                  then varn = 'suem002'
                     end
             'emisdms':  begin
                     varTitle = 'Emissions (DMS)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')                  then varn = 'suem001'
                     end
              'sed': begin
                     varTitle = 'Sedimentation'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     template = 1
                     sum = 1
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'dusd'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocsd'
                     if(type eq 'BC')                  then varn = 'bcsd'
                     if(type eq 'SS')                  then varn = 'sssd'
                     if(type eq 'SM')                  then varn = 'smsd'
                     end
               'dep': begin
                     varTitle = 'Dry Deposition'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     template = 1
                     sum = 1
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'dudp'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocdp'
                     if(type eq 'BC')                  then varn = 'bcdp'
                     if(type eq 'SS')                  then varn = 'ssdp'
                     if(type eq 'SM')                  then varn = 'smdp'
                     if(type eq 'SU')                  then varn = 'sudp'
                     end
             'depso2':  begin
                     varTitle = 'Dry Deposition (SO2)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')                  then varn = 'sudp002'
                     end
               'wet': begin
                     varTitle = 'Wet Deposition'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     template = 1
                     sum = 1
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'duwt'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocwt'
                     if(type eq 'BC')                  then varn = 'bcwt'
                     if(type eq 'SS')                  then varn = 'sswt'
                     if(type eq 'SM')                  then varn = 'smwt'
                     if(type eq 'SU')                  then varn = 'suwt'
                     end
               'scav': begin
                     varTitle = 'Scavenging'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'dusv'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocsv'
                     if(type eq 'BC')                  then varn = 'bcsv'
                     if(type eq 'SS')                  then varn = 'sssv'
                     if(type eq 'SM')                  then varn = 'smsv'
                     if(type eq 'SU')                  then varn = 'susv'
                     end
               'load': begin
                     varTitle = 'Burden'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'ducmass'
                     if(type eq 'POM' or type eq 'OC') then varn = 'occmass'
                     if(type eq 'BC')                  then varn = 'bccmass'
                     if(type eq 'SS')                  then varn = 'sscmass'
                     if(type eq 'SM')                  then varn = 'smcmass'
                     if(type eq 'SU')                  then varn = 'sucmass'
                     if(type eq 'CO')                  then varn = 'cocl001'
                     if(type eq 'CO2') then begin
                        varn = 'co2cl001'
                        levelarray = findgen(7)*1000. + 1000.
                        formcode = '(f7.1)'
                     endif
                     end
               'load25': begin
                     varTitle = 'Burden (PM2.5)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'ducmass25'
                     if(type eq 'POM' or type eq 'OC') then varn = 'occmass25'
                     if(type eq 'BC')                  then varn = 'bccmass25'
                     if(type eq 'SS')                  then varn = 'sscmass25'
                     end
             'loadso2':  begin
                     varTitle = 'Burden (SO2)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'so2cmass'
                     end
             'loaddms':  begin
                     varTitle = 'Load (DMS)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'dmscmass'
                     end
               'embb':  begin
                     varTitle = 'Biomass Burning Emissions'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocembb'
                     if(type eq 'BC')                  then varn = 'bcembb'
                     end
               'embf':  begin
                     varTitle = 'Biofuel Emissions'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocembf'
                     if(type eq 'BC')                  then varn = 'bcembf'
                     end
               'eman':  begin
                     varTitle = 'Anthropogenic Emissions'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'POM' or type eq 'OC') then varn = 'oceman'
                     if(type eq 'BC')                  then varn = 'bceman'
                     end
               'embg':  begin
                     varTitle = 'Biogenic Emissions'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocembg'
                     if(type eq 'BC')                  then varn = 'bcembg'
                     end
             'emisvolcn':  begin
                     varTitle = 'Emissions, Volcanic Non-Explosive (SO2)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'so2emvn'
                     end
             'emisvolce':  begin
                     varTitle = 'Emissions, Volcanic Explosive (SO2)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'so2emve'
                     end
             'pso4g': begin
                     varTitle = 'Production (gas)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'SUPSO4g'
                     end
             'pso4liq': begin
                     varTitle = 'Production (aqueous)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = ['SUPSO4aq','SUPSO4wt']
                     sum = 1
                     end
             'pso2':  begin
                     varTitle = 'Production (SO2)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'supso2'
                     end
            'prod':  begin
                     varn = 'copd001'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varTitle = 'Production'
                     end
            'loss':  begin
                     varn = 'cols001'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varTitle = 'Loss'
                     end
            else:    varn = varwant_
    endcase

;   Check and return a fail if variable not found
    if(varn[0] eq '') then begin
     rc = 1
     return
    endif

;   Now finally read a variable
    nc4readvar, filename, varn, varvalue, sum=sum, template=template, $
                lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc

    if(rc ne 0) then begin
     rc = 2
     return
    endif

    if(varwant_[ivar] eq 'tau')    then tau = varvalue
    if(varwant_[ivar] eq 'tautot') then tautot = varvalue
    if(varwant_[ivar] eq 'tausca') then tausca = varvalue

   endfor ; loop over variables actually needed

   if(strlowcase(varwant) eq 'ssa')    then begin
      varvalue = tausca/tau
      vartitle = 'SSA [550 nm]'
      levelarray = findgen(7)*.05+.65
      labelarray = ['0.65','0.7','.75','.8','.85','0.9','0.95']
      if(type eq 'BC') then begin
       formcode = '(f5.2)'
       levelarray = [.2,.25,.3,.35,.4,.45,.5]
       labelarray = string(levelarray,format=formcode)
      endif
      if(type eq 'DU') then begin
       levelarray = findgen(7)*.02+.86
       labelarray = ['0.86','0.088','0.09','0.92','0.94','0.96','0.98','1']
      endif
   endif
   if(strlowcase(varwant) eq 'tauabs') then begin
      varvalue = tau-tausca
      vartitle = 'TAUABS [550 nm]'
      levelarray = findgen(100)*.001+.001
      labelarray = ['0','0.1']
      formcode = '(f5.2)'
      levelarray = 0.1*[.1,.2,.3,.4,.5,.7,1.]
      labelarray = string(levelarray,format=formcode)
   endif
   if(strlowcase(varwant) eq 'taufrac') then begin
      varvalue = tau/tautot
      vartitle = 'TAU fraction [550 nm]'
      levelarray = findgen(7)*.14
      labelarray = ['0','1']
   endif


   if(labelarray[0] eq '') then $
      labelarray = string(levelarray,format=formcode)

  
   if(convfac gt 0) then varvalue = reform(varvalue) * convfac $
   else varvalue = reform(varvalue) + convfac

end
