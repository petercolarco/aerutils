  date = '20100423'
  fcast = '2010042300'
  flight = 'b6.6_03_10'

  inpfile = 'glopac.fcast.chm.'+flight+'.v'+date+'.f'+fcast+'.nc'

  plot_curtain, inpfile, 'du'
  plot_curtain, inpfile, 'bc'
  plot_curtain, inpfile, 'so4'
  plot_curtain, inpfile, 'ss'
  plot_curtain, inpfile, 'co'
  plot_curtain, inpfile, 'cfc12'
;  plot_curtain, inpfile, 'cobbgl'
;  plot_curtain, inpfile, 'conbgl'

  inpfile = 'glopac.fcast.met.'+flight+'.v'+date+'.f'+fcast+'.nc'
  plot_curtain, inpfile, 'o3'
  plot_curtain, inpfile, 'epv'

end
