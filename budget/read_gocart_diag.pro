; Given a species type and a variable name, return a filled variable array
; GOCART version -- need to divide the emissions, etc., by surface area and sec/month

  pro read_gocart_diag, ctlfileIn, type, wanttime, varWant, area, varValue, varTitle, levelarray, formcode

;  Flag to protect runs with no convective scavenging
   scav = 0

   nsecmon = 30.*86400.
 
   case type of

      'DU': begin
            ctlsplit = strsplit(ctlfileIn,'.',/extract)
            ctlfile = ctlsplit[0]+'_du.'+ctlsplit[1]
            levelarray = [.1,.2,.5,1,2,5,10]
            formcode = '(f5.1)'
            case varWant of
             'emis':  begin
                      varTitle = 'Emissions'
                      ga_getvar, ctlfile, 'bemis_kgdu1', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'bemis_kgdu2', out2, wanttime=wanttime
                      ga_getvar, ctlfile, 'bemis_kgdu3', out3, wanttime=wanttime
                      ga_getvar, ctlfile, 'bemis_kgdu4', out4, wanttime=wanttime
                      ga_getvar, ctlfile, 'bemis_kgdu5', out5, wanttime=wanttime
                      varvalue = out1+out2+out3+out4+out5
                      end
             'sed':   begin
                      varTitle = 'Sedimentation'
                      ga_getvar, ctlfile, 'bsettl_du1', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'bsettl_du2', out2, wanttime=wanttime
                      ga_getvar, ctlfile, 'bsettl_du3', out3, wanttime=wanttime
                      ga_getvar, ctlfile, 'bsettl_du4', out4, wanttime=wanttime
                      ga_getvar, ctlfile, 'bsettl_du5', out5, wanttime=wanttime
                      varvalue = out1+out2+out3+out4+out5
                      end
             'dep':   begin
                      varTitle = 'Deposition'
                      ga_getvar, ctlfile, 'bdrykg_du1', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'bdrykg_du2', out2, wanttime=wanttime
                      ga_getvar, ctlfile, 'bdrykg_du3', out3, wanttime=wanttime
                      ga_getvar, ctlfile, 'bdrykg_du4', out4, wanttime=wanttime
                      ga_getvar, ctlfile, 'bdrykg_du5', out5, wanttime=wanttime
                      varvalue = out1+out2+out3+out4+out5
                      end
             'wet':   begin
                      varTitle = 'Wet Deposition'
                      ga_getvar, ctlfile, 'bwetkg_du1', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'bwetkg_du2', out2, wanttime=wanttime
                      ga_getvar, ctlfile, 'bwetkg_du3', out3, wanttime=wanttime
                      ga_getvar, ctlfile, 'bwetkg_du4', out4, wanttime=wanttime
                      ga_getvar, ctlfile, 'bwetkg_du5', out5, wanttime=wanttime
                      varvalue = out1+out2+out3+out4+out5
                      end
             'scav':  begin
                      varTitle = 'Scavenging'
                      ga_getvar, ctlfile, 'bscakg_du1', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'bscakg_du2', out2, wanttime=wanttime
                      ga_getvar, ctlfile, 'bscakg_du3', out3, wanttime=wanttime
                      ga_getvar, ctlfile, 'bscakg_du4', out4, wanttime=wanttime
                      ga_getvar, ctlfile, 'bscakg_du5', out5, wanttime=wanttime
                      varvalue = out1+out2+out3+out4+out5
                      end
             'load':  begin
                      ctlsplit = strsplit(ctlfileIn,'.',/extract)
                      ctlfile = ctlsplit[0]+'_du.2d.'+ctlsplit[1]
                      varTitle = 'Load'
                      ga_getvar, ctlfile, 'tcmasa_du1', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'tcmasa_du2', out2, wanttime=wanttime
                      ga_getvar, ctlfile, 'tcmasa_du3', out3, wanttime=wanttime
                      ga_getvar, ctlfile, 'tcmasa_du4', out4, wanttime=wanttime
                      ga_getvar, ctlfile, 'tcmasa_du5', out5, wanttime=wanttime
                      varvalue = out1+out2+out3+out4+out5
                      end
             endcase
            end
      'SS': begin
            levelarray = [.1,.2,.5,1,2,5,10]
            formcode = '(f5.1)'
            case varWant of
             'emis':  begin
                      varTitle = 'Emissions'
                      ga_getvar, ctlfile, 'ssem001', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'ssem002', out2, wanttime=wanttime
                      ga_getvar, ctlfile, 'ssem003', out3, wanttime=wanttime
                      ga_getvar, ctlfile, 'ssem004', out4, wanttime=wanttime
                      ga_getvar, ctlfile, 'ssem005', out5, wanttime=wanttime
                      varvalue = out1+out2+out3+out4+out5
                      end
             'sed':   begin
                      varTitle = 'Sedimentation'
                      ga_getvar, ctlfile, 'sssd001', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'sssd002', out2, wanttime=wanttime
                      ga_getvar, ctlfile, 'sssd003', out3, wanttime=wanttime
                      ga_getvar, ctlfile, 'sssd004', out4, wanttime=wanttime
                      ga_getvar, ctlfile, 'sssd005', out5, wanttime=wanttime
                      varvalue = out1+out2+out3+out4+out5
                      end
             'dep':   begin
                      varTitle = 'Deposition'
                      ga_getvar, ctlfile, 'ssdp001', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'ssdp002', out2, wanttime=wanttime
                      ga_getvar, ctlfile, 'ssdp003', out3, wanttime=wanttime
                      ga_getvar, ctlfile, 'ssdp004', out4, wanttime=wanttime
                      ga_getvar, ctlfile, 'ssdp005', out5, wanttime=wanttime
                      varvalue = out1+out2+out3+out4+out5
                      end
             'wet':   begin
                      varTitle = 'Wet Deposition'
                      ga_getvar, ctlfile, 'sswt001', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'sswt002', out2, wanttime=wanttime
                      ga_getvar, ctlfile, 'sswt003', out3, wanttime=wanttime
                      ga_getvar, ctlfile, 'sswt004', out4, wanttime=wanttime
                      ga_getvar, ctlfile, 'sswt005', out5, wanttime=wanttime
                      varvalue = out1+out2+out3+out4+out5
                      end
             'scav':  begin
                      varTitle = 'Scavenging'
                      ga_getvar, ctlfile, 'sssv001', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'sssv002', out2, wanttime=wanttime
                      ga_getvar, ctlfile, 'sssv003', out3, wanttime=wanttime
                      ga_getvar, ctlfile, 'sssv004', out4, wanttime=wanttime
                      ga_getvar, ctlfile, 'sssv005', out5, wanttime=wanttime
                      varvalue = out1+out2+out3+out4+out5
                      end
             'load':  begin
                      levelarray = [.01,.02,.05,.1,.2,.5,1]
                      formcode = '(f5.2)'
                      varTitle = 'Load'
                      ga_getvar, ctlfile, 'sscmass', varvalue, wanttime=wanttime
                      end
             endcase
            end
      'BC': begin
            ctlsplit = strsplit(ctlfileIn,'.',/extract)
            ctlfile = ctlsplit[0]+'_cc.'+ctlsplit[1]
            levelarray = [.001,.002,.005,.01,.02,.05,.1]
            formcode = '(f5.3)'
            case varWant of
             'emis':  begin
                      varTitle = 'Emissions'
                      ga_getvar, ctlfile, 'bemis_mobc1', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'bemis_mobc2', out2, wanttime=wanttime
                      varvalue = out1+out2
                      varvalue = 0.012*varvalue
                      end
             'dep':   begin
                      varTitle = 'Deposition'
                      ga_getvar, ctlfile, 'bdrymo_bc1', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'bdrymo_bc2', out2, wanttime=wanttime
                      varvalue = out1+out2
                      varvalue = -0.012*varvalue
                      end
             'wet':   begin
                      varTitle = 'Wet Deposition'
                      ga_getvar, ctlfile, 'bwetmo2d_bc2', varvalue, wanttime=wanttime
                      varvalue = -0.012*varvalue
                      end
             'scav':  begin
                      varTitle = 'Scavenging'
                      ga_getvar, ctlfile, 'bscamo2d_bc2', varvalue, wanttime=wanttime
                      varvalue = -0.012*varvalue
                      end
             'load':  begin
                      ctlsplit = strsplit(ctlfileIn,'.',/extract)
                      ctlfile = ctlsplit[0]+'_cc.2d.'+ctlsplit[1]
                      varTitle = 'Load'
                      ga_getvar, ctlfile, 'tcmasa_bc1', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'tcmasa_bc2', out2, wanttime=wanttime
                      varvalue = out1+out2
                      varvalue = varvalue*.012
                      end
             endcase
            end
      'OC': begin
            ctlsplit = strsplit(ctlfileIn,'.',/extract)
            ctlfile = ctlsplit[0]+'_cc.'+ctlsplit[1]
            levelarray = [.01,.02,.05,.1,.2,.5,1]
            formcode = '(f5.2)'
            case varWant of
             'emis':  begin
                      varTitle = 'Emissions'
                      ga_getvar, ctlfile, 'bemis_mooc1', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'bemis_mooc2', out2, wanttime=wanttime
                      varvalue = out1+out2
                      varvalue = varvalue*.012*1.4
                      end
             'dep':   begin
                      varTitle = 'Deposition'
                      ga_getvar, ctlfile, 'bdrymo_oc1', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'bdrymo_oc2', out2, wanttime=wanttime
                      varvalue = out1+out2
                      varvalue = -0.012*1.4*varvalue
                      end
             'wet':   begin
                      varTitle = 'Wet Deposition'
                      ga_getvar, ctlfile, 'bwetmo2d_oc2', varvalue, wanttime=wanttime
                      varvalue = -0.012*1.4*varvalue
                      end
             'scav':  begin
                      varTitle = 'Scavenging'
                      ga_getvar, ctlfile, 'bscamo2d_oc2', varvalue, wanttime=wanttime
                      varvalue = -0.012*1.4*varvalue
                      end
             'load':  begin
                      ctlsplit = strsplit(ctlfileIn,'.',/extract)
                      ctlfile = ctlsplit[0]+'_cc.2d.'+ctlsplit[1]
                      varTitle = 'Load'
                      ga_getvar, ctlfile, 'tcmasa_oc1', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'tcmasa_oc2', out2, wanttime=wanttime
                      varvalue = out1+out2
                      varvalue = varvalue*.012*1.4
                      end
             endcase
            end
      'SU': begin
            levelarray = [.01,.02,.05,.1,.2,.5,1]
            formcode = '(f5.2)'
            case varWant of
             'emis':  begin
                      varTitle = 'Emissions'
                      ga_getvar, ctlfile, 'suem003', varvalue, wanttime=wanttime
                      end
             'emisso2':  begin
                      varTitle = 'Emissions (SO2)'
                      ga_getvar, ctlfile, 'suem002', varvalue, wanttime=wanttime
                      end
             'emisdms':  begin
                      varTitle = 'Emissions (DMS)'
                      ga_getvar, ctlfile, 'suem001', varvalue, wanttime=wanttime
                      end
             'dep':   begin
                      varTitle = 'Deposition'
                      ga_getvar, ctlfile, 'sudp003', varvalue, wanttime=wanttime
                      end
             'depso2':begin
                      varTitle = 'Deposition (SO2)'
                      ga_getvar, ctlfile, 'sudp002', varvalue, wanttime=wanttime
                      end
             'wet':   begin
                      varTitle = 'Wet Deposition'
                      ga_getvar, ctlfile, 'suwt003', varvalue, wanttime=wanttime
                      end
             'scav':  begin
                      varTitle = 'Scavenging'
                      ga_getvar, ctlfile, 'susv003', varvalue, wanttime=wanttime
                      end
             'pso4g': begin
                      varTitle = 'Production (gas)'
                      ga_getvar, ctlfile, 'supso4g', varvalue, wanttime=wanttime
                      end
             'pso4liq': begin
                      varTitle = 'Production (aqueous)'
                      ga_getvar, ctlfile, 'supso4aq', out1, wanttime=wanttime
                      ga_getvar, ctlfile, 'supso4wt', out2, wanttime=wanttime
                      varvalue = out1+out2
                      end
             'pso2':  begin
                      varTitle = 'Production (SO2)'
                      ga_getvar, ctlfile, 'supso2', varvalue, wanttime=wanttime
                      end
             'load':  begin
                      varTitle = 'Load'
                      levelarray = [.01,.02,.05,.1,.2,.5,1]/10
                      formcode = '(f5.3)'
                      ga_getvar, ctlfile, 'so4cmass', varvalue, wanttime=wanttime
                      end
             'loadso2':  begin
                      levelarray = [.01,.02,.05,.1,.2,.5,1]/10
                      formcode = '(f5.3)'
                      varTitle = 'Load (SO2)'
                      ga_getvar, ctlfile, 'so2cmass', varvalue, wanttime=wanttime
                      end
             'loaddms':  begin
                      levelarray = [.01,.02,.05,.1,.2,.5,1]/10
                      formcode = '(f5.3)'
                      varTitle = 'Load (DMS)'
                      ga_getvar, ctlfile, 'dmscmass', varvalue, wanttime=wanttime
                      end
             'emisvolcn':  begin
                      varTitle = 'Emissions, Volcanic Non-Explosive (SO2)'
                      ga_getvar, ctlfile, 'so2emvn', varvalue, wanttime=wanttime
                      end
             'emisvolce':  begin
                      varTitle = 'Emissions, Volcanic Explosive (SO2)'
                      ga_getvar, ctlfile, 'so2emve', varvalue, wanttime=wanttime
                      end
             endcase
            end
      'CO': begin
            levelarray = [.1,.2,.5,1,2,5,10]
            formcode = '(f5.1)'
            case varWant of
             'emis':  begin
                      varget = 'coem001'
                      varTitle = 'Emissions'
                      end
             'prod':  begin
                      varget = 'copd001'
                      varTitle = 'Production'
                      end
             'loss':  begin
                      varget = 'cols001'
                      varTitle = 'Loss'
                      end
             'load':  begin
                      varget = 'cocl001'
                      varTitle = 'Load'
                      end
            endcase
            ga_getvar, ctlfile, varget, varvalue, wanttime=wanttime
            end
      'CO2': begin
            case varWant of
             'emis':  begin
                      levelarray = [-100,-20,-10,0,10,20,100]
                      formcode = '(f7.1)'
                      varget = 'co2em001'
                      varTitle = 'Emissions'
                      end
             'load':  begin
                      levelarray = [1000,2000,3000,4000,5000,6000,7000]
                      formcode = '(f7.1)'
                      varget = 'co2cl001'
                      varTitle = 'Load'
                      end
            endcase
            ga_getvar, ctlfile, varget, varvalue, wanttime=wanttime
            end

   endcase
   area = reform(area)
   varvalue = reform(varvalue)
   nt = n_elements(varvalue[0,0,*])
   for it = 0, nt-1 do begin
    varvalue[*,*,it] = varvalue[*,*,it]/area
   endfor
   if(strpos(varwant, 'load') eq -1) then varvalue = varvalue/nsecmon

end
