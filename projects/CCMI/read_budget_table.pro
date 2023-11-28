  pro read_budget_table, expid, aertype, yyyy, $
                         emis, sed, dep, wet, scav, burden, tau, burden25=burden25, $
                         emisso2=emisso2, emisdms=emisdms, depso2=depso2, $
                         pso4g=pso4g, pso4liq=pso4liq, pso2=pso2, loadso2=loadso2, loaddms=loaddms, $
                         pno3aq=pno3aq, pno3ht=pno3ht, depnh3=depnh3, depnh4=depnh4, $
                         sednh4=sednh4, scavnh4=scavnh4, wetnh3=wetnh3, wetnh4=wetnh4, $
                         embf=embf, embb=embb, eman=eman, embg=embg, rc=rc

  rc = 0
  ny = n_elements(yyyy)

  case aertype of
   'BC':   vars = ['emis','dep','wet','scav','load','tau','ssa','tauabs','taufrac','embb','embf','eman']
   'POM':  vars = ['emis','dep','wet','scav','load','tau','ssa','tauabs','taufrac','embb','embf','eman','embg']
   'BRC':  vars = ['emis','dep','wet','scav','load','tau','ssa','tauabs','taufrac','embb','embf','eman','embg']
   'SM':   vars = ['emis','sed','dep','wet','scav','load','load25', 'tau','ssa','tauabs','taufrac']
   'DU':   vars = ['emis','sed','dep','wet','scav','load','load25', 'tau','ssa','tauabs','taufrac']
   'DZ':   vars = ['emis','sed','dep','wet','scav','load','load25', 'tau','ssa','tauabs','taufrac']
   'SS':   vars = ['emis','sed','dep','wet','scav','load','load25','tau','ssa','tauabs','taufrac']
   'SU':   vars = ['emis','emisso2','emisdms','dep','depso2','wet','scav',$
                   'pso4g','pso4liq','pso2','load','loadso2','loaddms', $
                   'emisvolcn', 'emisvolce','tau','ssa','tauabs','taufrac']
   'SUV':   vars = ['emis','emisso2','emisdms','dep','depso2','wet','scav',$
                   'pso4g','pso4liq','pso2','load','loadso2','loaddms', $
                   'emisvolcn', 'emisvolce','tau','ssa','tauabs','taufrac']
   'NI':   vars = ['emisnh3','pno3aq','pno3ht','depnh3','depnh4','depno3','sednh4',$
                   'sed','scavnh4','scavno3','wetnh3','wetnh4','wetno3', $
                   'load','tau','ssa','tauabs','taufrac']
   'CO':   vars = ['emis','prod','loss','load']
   'CO2':  vars = ['emis','load']
  endcase


  nvars = n_elements(vars)

; setup the arrays to read
; 12 months + 1 annual average/total = 13
  input = fltarr(13,ny,nvars)
  for iy = 0, ny-1 do begin
   openr, lun, 'output/tables/budget.'+expid+'.'+aertype+'.'+yyyy[iy]+'.txt', /get, error=rc
   if(rc ne 0) then return
   strline = 'a'
   data = fltarr(2,13)
   for ivar = 0, nvars-1 do begin
    readf, lun, data
    readf, lun, strline
    input[*,iy,ivar] = data[1,*]
   endfor
   free_lun, lun
  endfor

  emis = input[*,*,0]

  case aertype of
  'NI':   begin
          pno3aq  = input[*,*,1]
          pno3ht  = input[*,*,2]
          depnh3  = input[*,*,3]
          depnh4  = input[*,*,4]
          dep     = input[*,*,5]
          sednh4  = input[*,*,6]
          sed     = input[*,*,7]
          scavnh4 = input[*,*,8]
          scav    = input[*,*,9]
          wetnh3  = input[*,*,10]
          wetnh4  = input[*,*,11]
          wet     = input[*,*,12]
          burden  = input[*,*,13]
          tau     = input[*,*,14]
          end
  'SU':   begin
           emisso2 = input[*,*,1]
           emisdms = input[*,*,2]
           dep = input[*,*,3]
           wet = input[*,*,5]
           scav = input[*,*,6]
           burden = input[*,*,10]
           burdenso2 = input[*,*,11]
           burdendms = input[*,*,12]
           depso2 = input[*,*,4]
           pso4g = input[*,*,7]
           pso4liq = input[*,*,8]
           pso2 = input[*,*,9]
           tau = input[*,*,15]
           sed = dep
           sed[*,*] = 0.
           end
  'SUV':   begin
           emisso2 = input[*,*,1]
           emisdms = input[*,*,2]
           dep = input[*,*,3]
           wet = input[*,*,5]
           scav = input[*,*,6]
           burden = input[*,*,10]
           burdenso2 = input[*,*,11]
           burdendms = input[*,*,12]
           depso2 = input[*,*,4]
           pso4g = input[*,*,7]
           pso4liq = input[*,*,8]
           pso2 = input[*,*,9]
           tau = input[*,*,15]
           sed = dep
           sed[*,*] = 0.
           end
   'BC':   begin
           dep = input[*,*,1]
           wet = input[*,*,2]
           scav = input[*,*,3]
           burden = input[*,*,4]
           tau = input[*,*,5]
           embb = input[*,*,9]
           embf = input[*,*,10]
           eman = input[*,*,11]
           sed = dep
           sed[*,*] = 0.
           end
   'POM':  begin
           dep = input[*,*,1]
           wet = input[*,*,2]
           scav = input[*,*,3]
           burden = input[*,*,4]
           tau = input[*,*,5]
           embb = input[*,*,9]
           embf = input[*,*,10]
           eman = input[*,*,11]
           embg = input[*,*,12]
           sed = dep
           sed[*,*] = 0.
           end
   'BRC':  begin
           dep = input[*,*,1]
           wet = input[*,*,2]
           scav = input[*,*,3]
           burden = input[*,*,4]
           tau = input[*,*,5]
           embb = input[*,*,9]
           embf = input[*,*,10]
           eman = input[*,*,11]
           embg = input[*,*,12]
           sed = dep
           sed[*,*] = 0.
           end
   'DU':   begin
           sed = input[*,*,1]
           dep = input[*,*,2]
           wet = input[*,*,3]
           scav = input[*,*,4]
           burden = input[*,*,5]
           burden25 = input[*,*,6]
           tau = input[*,*,7]
           end
   'SM':   begin
           sed = input[*,*,1]
           dep = input[*,*,2]
           wet = input[*,*,3]
           scav = input[*,*,4]
           burden = input[*,*,5]
           burden25 = input[*,*,6]
           tau = input[*,*,7]
           end
   'DZ':   begin
           sed = input[*,*,1]
           dep = input[*,*,2]
           wet = input[*,*,3]
           scav = input[*,*,4]
           burden = input[*,*,5]
           burden25 = input[*,*,6]
           tau = input[*,*,7]
           end
   'SS':   begin
           sed = input[*,*,1]
           dep = input[*,*,2]
           wet = input[*,*,3]
           scav = input[*,*,4]
           burden = input[*,*,5]
           burden25 = input[*,*,6]
           tau = input[*,*,7]
           end
   'CO':   vars = ['emis','prod','loss','load']
   'CO2':  vars = ['emis','load']
  endcase



end
