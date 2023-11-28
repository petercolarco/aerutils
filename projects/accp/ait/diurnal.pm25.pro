  gather_diurnal_pm25, 'pm25.nadir045', out_n45
  gather_diurnal_pm25, 'pm25.nadir050', out_n50
  gather_diurnal_pm25, 'pm25.nadir055', out_n55
  gather_diurnal_pm25, 'pm25.nadir060', out_n60
  gather_diurnal_pm25, 'pm25.nadir065', out_n65
  gather_diurnal_pm25, 'pm25.wide045', out_w45
  gather_diurnal_pm25, 'pm25.wide050', out_w50
  gather_diurnal_pm25, 'pm25.wide055', out_w55
  gather_diurnal_pm25, 'pm25.wide060', out_w60
  gather_diurnal_pm25, 'pm25.wide065', out_w65
  gather_diurnal_pm25, 'pm25.full', out_full

  save, /variables, filename='diurnal.pm25.sav'

 end
