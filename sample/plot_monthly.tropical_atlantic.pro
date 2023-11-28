  res = 'ten'
  plot_monthly, 'MYD04', '', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', res=res
  plot_monthly_num, 'MYD04', '', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', res=res

  plot_monthly, 'MYD04', 'caliop1', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', res=res
  plot_monthly, 'MYD04', 'caliop1', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', /exclude, res=res
  plot_monthly, 'MYD04', 'caliop1', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', /exclude, /inverse, res=res

  plot_monthly, 'MYD04', 'caliop3', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', res=res
  plot_monthly, 'MYD04', 'caliop3', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', /exclude, res=res
  plot_monthly, 'MYD04', 'caliop3', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', /exclude, /inverse, res=res

  plot_monthly, 'MYD04', 'misr1', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', res=res
  plot_monthly, 'MYD04', 'misr1', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', /exclude, res=res
  plot_monthly, 'MYD04', 'misr1', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', /exclude, /inverse, res=res

  plot_monthly, 'MYD04', 'misr3', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', res=res
  plot_monthly, 'MYD04', 'misr3', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', /exclude, res=res
  plot_monthly, 'MYD04', 'misr3', '2010', '09', geolimits=[-30,-90,45,45], geoname='tropical_atlantic', /exclude, /inverse, res=res


end
