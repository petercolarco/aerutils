  directory = '/science/dao_ops/GEOS-4_INTEXB/a_flk_04C/forecast/'

  date0 = ['2005061800', '2005061812', '2005061900', '2005061912', $
           '2005062000', '2005062012', '2005062100', '2005062112', $
           '2005062200', '2005062212',  $
           '2006062600', '2006062612', '2006062700', '2006062712', $
           '2006071300', '2006071312', '2006071400', '2006071412', $
           '2006081800', '2006081812', '2006081900', '2006081912', $
           '2006080800', '2006080812', '2006080900', '2006080912' ]
  for i = 0, n_elements(date0)-1 do begin
   ctlfile = 'prs.'+date0[i]+'.ddf'
   filehead = 'a_flk_04C.chem_diag.prs.'
   write_ddf, ctlfile, directory, filehead, date0[i], /forecast, incstr='3'
   ctlfile = 'sfc.'+date0[i]+'.ddf'
   filehead = 'a_flk_04C.chem_diag.sfc.'
   write_ddf, ctlfile, directory, filehead, date0[i], /forecast, incstr='3'
  endfor

end
