pro get_budget_table, expid, aertype, yyyy, $
                      emis, sed, dep, wet, scav, burden, tau, $
                      emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                      pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, $
                      loadso2=loadso2, loaddms=loaddms, burden25=burden25, $
                 pno3aq=pno3aq, pno3ht=pno3ht, depnh3=depnh3, depnh4=depnh4, $
                 sednh4=sednh4, scavnh4=scavnh4, wetnh3=wetnh3, wetnh4=wetnh

  case aertype of
   'BC':   begin
           str = 'Black Carbon'
           read_budget_table, expid, aertype, yyyy, $
                              emis, sed, dep, wet, scav, burden, tau
           end
   'POM':  begin
           str = 'Particulate Organic Matter'
           read_budget_table, expid, aertype, yyyy, $
                              emis, sed, dep, wet, scav, burden, tau
           end
   'BRC':  begin
           str = 'Brown Carbon'
           read_budget_table, expid, aertype, yyyy, $
                              emis, sed, dep, wet, scav, burden, tau
           end
   'DU':   begin
           str = 'Dust'
           pm25 = 1
           read_budget_table, expid, aertype, yyyy, $
                              emis, sed, dep, wet, scav, burden, tau, $
                              burden25=burden25
           end
   'SS':   begin
           str = 'Sea Salt'
           pm25 = 1
           read_budget_table, expid, aertype, yyyy, $
                              emis, sed, dep, wet, scav, burden, tau, $
                              burden25=burden25
           end
   'SU':   begin
           str = 'Sulfate'
           read_budget_table, expid, aertype, yyyy, $
                  emis, sed, dep, wet, scav, burden, tau, $
                  emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                  pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, $
                  loadso2=loadso2, loaddms=loaddms
          end
   'NI':  begin
          str = 'Nitrate'
          read_budget_table, expid, aertype, yyyy, $
                 emis, sed, dep, wet, scav, burden, tau, $
                 pno3aq=pno3aq, pno3ht=pno3ht, depnh3=depnh3, depnh4=depnh4, $
                 sednh4=sednh4, scavnh4=scavnh4, wetnh3=wetnh3, wetnh4=wetnh4
          end
  endcase

end
