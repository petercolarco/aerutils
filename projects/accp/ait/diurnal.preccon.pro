  gather_diurnal_preccon, 'preccon.full', out_full
  gather_diurnal_preccon, 'preccon.nadir045', out_n45
  gather_diurnal_preccon, 'preccon.nadir050', out_n50
  gather_diurnal_preccon, 'preccon.nadir055', out_n55
  gather_diurnal_preccon, 'preccon.nadir060', out_n60
  gather_diurnal_preccon, 'preccon.nadir065', out_n65
  gather_diurnal_preccon, 'preccon.wide045', out_w45
  gather_diurnal_preccon, 'preccon.wide050', out_w50
  gather_diurnal_preccon, 'preccon.wide055', out_w55
  gather_diurnal_preccon, 'preccon.wide060', out_w60
  gather_diurnal_preccon, 'preccon.wide065', out_w65

  save, /variables, filename='diurnal.preccon.sav'

 end
