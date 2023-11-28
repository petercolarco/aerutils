; Colarco, December 30, 2010
; Reader to pull variables from a file and return array and metadata.
; Possible unit conversion takes place; see below.
; Optional variable is "type" which may specify the aerosol type
; or else some other code.

; Given a species type and a variable name, return a filled variable array

  pro read_geos_diag, filename, varWant, varValue, $
                      varTitle, varunits, levelarray, labelarray, formcode, $
                      lon=lon, lat=lat, diverge=diverge, $
                      wantlon=wantlon, wantlat=wantlat, type=type, oldscav=oldscav, rc=rc

   if(not(keyword_set(type))) then type = 'DU' ; give a default value
   varwant_ = strlowcase(varWant)

;  Special handling
   if(varwant_[0] eq 'ssa' or varwant_[0] eq 'tauabs') then varwant_ = ['tau','tausca']
   if(varwant_[0] eq 'taufrac')                        then varwant_ = ['tau','tautot']

;  Default values can be overridden
   rc       = 0
   sum      = 0
   template = 0
   diverge  = 0
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
           formcode = '(f5.3)'
           end
    'SU' : begin
           levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]
           formcode = '(f5.2)'
           end
    'NI' : begin
           levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]
           formcode = '(f5.3)'
           end
   'SUV' : begin
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
    'BRC': begin
           levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]
           formcode = '(f5.2)'
           end
    ELSE : begin
           end
   endcase

;  Loop over number of needed variables
   for ivar = 0, n_elements(varwant_)-1 do begin

    flipsign = 0
    case varwant_[ivar] of

              'precipls': begin
                     vartitle='Large-scale Precip'
                     varunits=' [mm day!E-1!N]'
                     varn='pls'
                     convfac = 86400. ; kg m-2 s-1 -> mm day-1
                     levelarray = findgen(100)*.1
                     labelarray = ['0','10']
                     end
              'precipcu': begin
                     vartitle='Convective Precip'
                     varunits=' [mm day!E-1!N]'
                     varn='pcu'
                     convfac = 86400. ; kg m-2 s-1 -> mm day-1
                     levelarray = findgen(100)*.15
                     labelarray = ['0','15']
                     end
              'precipsno': begin
                     vartitle='Snowfall'
                     varunits=' [mm day!E-1!N]'
                     varn='sno'
                     convfac = 86400. ; kg m-2 s-1 -> mm day-1
                     levelarray = findgen(100)*.05
                     labelarray = ['0','5']
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
                     varunits=' !Eo!NC'
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
                     varn = ['duexttau','suexttau','ssexttau','bcexttau','ocexttau']
                     if(type eq 'SUV') then varn = [varn,'suexttauvolc']
                     sum = 1
                     levelarray = findgen(100)*.01
                     labelarray = ['0','1']
                     varTitle = 'TAUEXT [550 nm]'
                     end
              'tau': begin
                     levelarray = [.1,.2,.3,.4,.5,.7,1.0]
                     if(type eq 'TOT') then varn = ['duexttau','suexttau','ssexttau','bcexttau', $
                                                    'ocexttau','niexttau','suexttauvolc','brcexttau']
                     if(type eq 'TOT') then sum = 1
                     if(type eq 'TOT') then levelarray = findgen(100)*.01
                     if(type eq 'TOT') then labelarray = ['0','1']
                     if(type eq 'DU' or type eq 'DZ') then varn = 'duexttau'
                     if(type eq 'BC') then varn = 'bcexttau'
                     if(type eq 'BC') then levelarray = 0.1*[.1,.2,.3,.4,.5,.7,1.0]
                     if(type eq 'SU') then varn = 'suexttau'
                     if(type eq 'SUV') then varn = 'suexttauvolc'
                     if(type eq 'SS') then varn = 'ssexttau'
                     if(type eq 'NI') then varn = 'niexttau'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocexttau'
                     if(type eq 'BRC' or type eq 'BRC') then varn = 'brcexttau'
                     varTitle = 'TAUEXT [550 nm]'
                     end
              'tausca': begin
                     if(type eq 'TOT') then varn = ['duscatau','suscatau','ssscatau','bcscatau', $
                                                    'ocscatau','niscatau','suscatauvolc','brcscatau']
                     if(type eq 'TOT') then sum = 1
                     if(type eq 'DU' or type eq 'DZ') then varn = 'duscatau'
                     if(type eq 'BC') then varn = 'bcscatau'
                     if(type eq 'SU') then varn = 'suscatau'
                     if(type eq 'SUV') then varn = 'suscatauvolc'
                     if(type eq 'SS') then varn = 'ssscatau'
                     if(type eq 'NI') then varn = 'niscatau'
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
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'duem0'
                     if(type eq 'POM' or type eq 'OC') then varn = ['ocem001','ocem002']
                     if(type eq 'BRC'                ) then varn = ['brcem001','brcem002']
                     if(type eq 'BC')                  then varn = ['bcem001','bcem002']
                     if(type eq 'SS')                  then varn = 'ssem0'
                     if(type eq 'SU')                  then varn = 'suem003'
                     if(type eq 'SUV')                 then varn = 'suem003volc'
                     if(type eq 'CO')                  then varn = 'coem001'
                     if(type eq 'CO2') then begin
                        varn = 'co2em001'
                        levelarray = [-100,-20,-10,0,10,20,100]
                        formcode = '(f7.1)'
                     endif
                     if(type eq 'POM' or type eq 'OC' or type eq 'BRC' or $
                        type eq 'BC' or type eq 'SU') then template = 0
                     end
             'emisso2':  begin
                     varTitle = 'Emissions (SO2)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')                  then varn = 'suem002'
                     if(type eq 'SUV')                 then varn = 'suem002volc'
                     end
             'emisnh3':  begin
                     varTitle = 'Emissions (NH3)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'nh3em'
                     end
             'emisdms':  begin
                     varTitle = 'Emissions (DMS)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')                  then varn = 'suem001'
                     if(type eq 'SUV')                 then varn = 'suem001volc'
                     end
              'sed': begin
                     varTitle = 'Sedimentation'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     template = 1
                     sum = 1
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'dusd0'
                     if(type eq 'POM' or type eq 'OC') then varn = ['ocsd001','ocsd002']
                     if(type eq 'BRC'                ) then varn = ['brcsd001','brcsd002']
                     if(type eq 'BC')                  then varn = ['bcsd001','bcsd002']
                     if(type eq 'SU')                  then varn = ['susd003']
                     if(type eq 'SS')                  then varn = 'sssd0'
                     if(type eq 'NI')                  then varn = 'nisd0'
                     if(type eq 'NI')                  then levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]/10.

                     end
               'dep': begin
                     varTitle = 'Dry Deposition'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     template = 1
                     sum = 1
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'dudp0'
                     if(type eq 'POM' or type eq 'OC') then varn = ['ocdp001','ocdp002']
                     if(type eq 'BRC'                ) then varn = ['brcdp001','brcdp002']
                     if(type eq 'BC')                  then varn = ['bcdp001','bcdp002']
                     if(type eq 'SS')                  then varn = 'ssdp0'
                     if(type eq 'SU')                  then varn = ['sudp003']
                     if(type eq 'SUV')                 then varn = ['sudp003volc']
                     if(type eq 'POM' or type eq 'OC' or type eq 'BRC' or $
                        type eq 'BC' or type eq 'SU') then template = 0
                     end
             'depno3': begin
                     levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]/10.
                     template=1
                     sum = 1
                     varTitle = 'Dry Deposition (nitrate)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'nidp'
                     end
             'depnh3': begin
                     levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]/10.
                     varTitle = 'Dry Deposition (NH3)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'nh3dp'
                     end
             'depnh4': begin
                     levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]/10.
                     varTitle = 'Dry Deposition (NH4a)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'nh4dp'
                     end
             'sednh4': begin
                     levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]/10.
                     varTitle = 'Sedimentation (NH4a)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'nh4sd'
                     end
             'depso2':  begin
                     varTitle = 'Dry Deposition (SO2)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')                  then varn = 'sudp002'
                     if(type eq 'SUV')                 then varn = 'sudp002volc'
                     end
               'wet': begin
                     varTitle = 'Wet Deposition'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     template = 1
                     sum = 1
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'duwt0'
                     if(type eq 'POM' or type eq 'OC') then varn = ['ocwt001','ocwt002']
                     if(type eq 'BRC'                ) then varn = ['brcwt001','brcwt002']
                     if(type eq 'BC')                  then varn = ['bcwt001','bcwt002']
                     if(type eq 'SS')                  then varn = 'sswt0'
                     if(type eq 'SU')                  then varn = 'suwt003'
                     if(type eq 'SUV')                 then varn = 'suwt003volc'
                     if(type eq 'POM' or type eq 'OC' or type eq 'BRC' or $
                        type eq 'BC' or type eq 'SU') then template = 0
                     end
             'wetno3': begin
                     template=1
                     sum = 1
                     levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]/10.
                     varTitle = 'Wet Deposition (nitrate)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'niwt'
                     end
             'wetnh3': begin
                     varTitle = 'Wet Deposition (nh3)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'nh3wt'
                     end
             'wetnh4': begin
                     varTitle = 'Wet Deposition (NH4a)'
                     levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]/10.
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'nh4wt'
                     end
               'scav': begin
                     flipsign = 1
                     varTitle = 'Scavenging'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
;                     if(type ne 'SU') then template = 1
;                     if(type ne 'SU') then sum = 1
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'dusv'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocsv'  ;['ocsv001','ocsv002']
                     if(type eq 'BRC'                ) then varn = 'brcsv' ;['brcsv001','brcsv002']
                     if(type eq 'BC')                  then varn = 'bcsv'  ;['bcsv001','bcsv002']
                     if(type eq 'SS')                  then varn = 'sssv'
                     if(type eq 'SU')                  then varn = 'susv'  ;'susv003'
                     if(type eq 'SUV')                 then varn = 'susv003volc'
;                     if(type eq 'POM' or type eq 'OC' or type eq 'BRC' or $
;                        type eq 'BC' or type eq 'SU') then template = 0
                     if(keyword_set(oldscav)) then begin
                      if(type ne 'SU') then template = 1
                      if(type ne 'SU') then sum = 1
                      if(type eq 'DU' or type eq 'DZ')  then varn = 'dusv'
                      if(type eq 'POM' or type eq 'OC') then varn = ['ocsv001','ocsv002']
                      if(type eq 'BRC'                ) then varn = ['brcsv001','brcsv002']
                      if(type eq 'BC')                  then varn = ['bcsv001','bcsv002']
                      if(type eq 'SS')                  then varn = 'sssv'
                      if(type eq 'SU')                  then varn = 'susv003'
                      if(type eq 'SUV')                 then varn = 'susv003volc'
                      if(type eq 'POM' or type eq 'OC' or type eq 'BRC' or $
                         type eq 'BC' or type eq 'SU') then template = 0
                     endif
                     end
            'scavno3': begin
                     flipsign = 1
                     template=1
                     sum = 1
                     varTitle = 'Scavenging (nitrate)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'nisv'
                     end
            'scavnh3': begin
                     flipsign = 1
                     varTitle = 'Scavenging (nh3)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'nh3sv'
                     end
            'scavnh4': begin
                     flipsign = 1
                     levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]/10.
                     varTitle = 'Scavenging (NH4a)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'nh4sv'
                     end

               'load': begin
                     varTitle = 'Burden'
                     varUnits = ' [kg m!E-2!N]'
                     if(type eq 'DU' or type eq 'DZ')  then varn = 'ducmass'
                     if(type eq 'POM' or type eq 'OC') then varn = 'occmass'
                     if(type eq 'BRC'                ) then varn = 'brccmass'
                     if(type eq 'BC')                  then varn = 'bccmass'
                     if(type eq 'SS')                  then varn = 'sscmass'
                     if(type eq 'SU')                  then varn = 'so4cmass'
                     if(type eq 'SUV')                 then varn = 'so4cmassvolc'
                     if(type eq 'CO')                  then varn = 'cocl001'
                     if(type eq 'NI')                  then varn = 'nicmass'
                     if(type eq 'NI')                  then levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]/10.

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
                     if(type eq 'BRC'                ) then varn = 'brccmass25'
                     if(type eq 'BC')                  then varn = 'bccmass25'
                     if(type eq 'SS')                  then varn = 'sscmass25'
                     end
             'loadso2':  begin
                     varTitle = 'Burden (SO2)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')  then varn = 'so2cmass'
                     if(type eq 'SUV') then varn = 'so2cmassvolc'
                     end
             'loaddms':  begin
                     varTitle = 'Load (DMS)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')  then varn = 'dmscmass'
                     if(type eq 'SUV') then varn = 'dmscmassvolc'
                     end
               'embb':  begin
                     varTitle = 'Biomass Burning Emissions'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocembb'
                     if(type eq 'BC')                  then varn = 'bcembb'
                     if(type eq 'BRC')                 then varn = 'brcembb'
                     end
               'embf':  begin
                     varTitle = 'Biofuel Emissions'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocembf'
                     if(type eq 'BC')                  then varn = 'bcembf'
                     if(type eq 'BRC')                 then varn = 'brcembf'
                     end
               'eman':  begin
                     varTitle = 'Anthropogenic Emissions'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'POM' or type eq 'OC') then varn = 'oceman'
                     if(type eq 'BC')                  then varn = 'bceman'
                     if(type eq 'BRC')                 then varn = 'brceman'
                     end
               'embg':  begin
                     varTitle = 'Biogenic Emissions'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'POM' or type eq 'OC') then varn = 'ocembg'
                     if(type eq 'BC')                  then varn = 'bcembg'
                     if(type eq 'BRC')                 then varn = 'brcembg'
                     end
             'emisvolcn':  begin
                     varTitle = 'Emissions, Volcanic Non-Explosive (SO2)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')  then varn = 'so2emvn'
                     if(type eq 'SUV') then varn = 'so2emvnvolc'
                     end
             'emisvolce':  begin
                     varTitle = 'Emissions, Volcanic Explosive (SO2)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')  then varn = 'so2emve'
                     if(type eq 'SUV') then varn = 'so2emvevolc'
                     end
             'pno3aq': begin
                     levelArray = [-1,-.5,-.2,-.1,.1,.2,.5]*1.e-3
                     labelArray = ['-1','-0.5','-0.2','-0.1','0.1','0.2','0.5']
                     varTitle = 'Nitrate Production (aqueous)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'nipno3aq'
                     diverge = 1
                     end
             'pno3ht': begin
                     template=1
                     sum = 1
                     levelArray = [0.01,0.02,0.05,0.1,0.2,0.5,1.]/10.
                     varTitle = 'Nitrate Production (heterogeneous)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     varn = 'niht'
                     end
             'pso4g': begin
                     varTitle = 'Production (gas)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')  then varn = 'SUPSO4g'
                     if(type eq 'SUV') then varn = 'SUPSO4gvolc'
                     end
             'pso4liq': begin
                     varTitle = 'Production (aqueous)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')  then varn = ['SUPSO4aq','SUPSO4wt']
                     if(type eq 'SUV') then varn = ['SUPSO4aqvolc','SUPSO4wtvolc']
                     sum = 1
                     end
             'pso2':  begin
                     varTitle = 'Production (SO2)'
                     varUnits = ' [kg m!E-2!N s!E-1!N]'
                     if(type eq 'SU')  then varn = 'supso2'
                     if(type eq 'SUV') then varn = 'supso2volc'
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
;if(varn[0] eq 'susv003') then varn = 'susv'
    nc4readvar, filename, varn, varvalue, sum=sum, template=template, $
                lon=lon, lat=lat, wantlon=wantlon, wantlat=wantlat, rc=rc

    if(rc ne 0) then begin
     rc = 2
     return
    endif

;   GF implements scavenging diagnostic as dSPECIES/dt, so negative
;   for loss and at odds with old way. Added flipsign variable to
;   check if negative value provided then flip the sign
    if(max(abs(varvalue)) gt max(varvalue) and flipsign eq 1) then varvalue = -1.*varvalue

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
