; Colarco, October 2006

; Get the lifetimes
  expid = 't002_b55'
  years = ['2000','2001','2002','2003','2004','2005','2006']
  read_lifetime, expid, years, date, var, tau, ksca, kwet, ksed, kdry

  for ivar = 0, n_elements(var)-1 do begin
   print, var[ivar]
   print, mean(tau[*,ivar]), mean(tau[*,ivar,*])
   print, mean(ksca[*,ivar]+kwet[*,ivar]), mean(ksca[*,ivar,*]+kwet[*,ivar,*])
   print, mean(kdry[*,ivar]+ksed[*,ivar]), mean(kdry[*,ivar,*]+ksed[*,ivar,*])
  
  endfor

end

