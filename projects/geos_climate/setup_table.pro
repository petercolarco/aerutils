  pro setup_table, expid, aerytpe, yyyy, $
                   emis, sed, dep, wet, scav, burden, tau

  case aertype of
   'SU':   begin
           str = 'Sulfate'
           read_budget_table, expid, aertype, yyyy, $
                  emis, sed, dep, wet, scav, burden, tau, $
                  emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                  pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, $
                  loadso2=loadso2, loaddms=loaddms
           emisRange = [2,8]
           emisClimRange = [0,1]
           emisRangeSO2 = [0,100]
           emisClimRangeSO2 = [0,20]
           emisRangeDMS = [0,40]
           emisClimRangeDMS = [0,5]
           pSO4Range = [0,80]
           pSO4ClimRange = [0,10]
           pSO2Range = [0,40]
           pSO2ClimRange = [0,5]
           lossRange = [0,100]
           lossClimRange = [0,10]
           burdenRange = [0,1]
           burdenClimRange = [0,1]
           lifetimeRange = [0,5]
           dryLifetimeRange = [10,100]
           dryLifetimeClimRange = [10,100]
           wetLifetimeRange = [4,6]
           wetLifetimeClimRange = [4,16]
           aotRange = [0,.05]
           aotClimRange = [0,.05]
          end
   'NI':   begin
           str = 'Nitrate'
           read_budget_table, expid, aertype, yyyy, $
                  emis, sed, dep, wet, scav, burden, tau, $
                  pno3aq=pno3aq, pno3ht=pno3ht, depnh3=depnh3, depnh4=depnh4, $
                  sednh4=sednh4, scavnh4=scavnh4, wetnh3=wetnh3, wetnh4=wetnh4
           loss = fltarr(13,ny,4)
           loss[*,*,0] = sed
           loss[*,*,1] = dep
           loss[*,*,2] = wet
           loss[*,*,3] = scav
           lossnh4 = fltarr(13,ny,4)
           lossnh4[*,*,0] = sednh4
           lossnh4[*,*,1] = depnh4
           lossnh4[*,*,2] = wetnh4
           lossnh4[*,*,3] = scavnh4
           lossnh3 = fltarr(13,ny,4)
           lossnh3[*,*,1] = depnh3
           lossnh3[*,*,2] = wetnh3
          end
  endcase
