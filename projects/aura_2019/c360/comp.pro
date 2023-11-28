  pro comp, var1, var2, lon, lat, $
            ct=ct, levels=levels, colors=colors, labels=labels, $
            dct=dct, dlevels=dlevels, dcolors=dcolors, plon=plon, plat=plat

  dx = lon[1]-lon[0]
  dy = lat[1]-lat[0]
  xycomp, var1, var2, lon, lat, dx, dy, $
    colortable=ct, $
    levels=levels, $
    colors=colors, $
    labels=labels, $
    dcolortable=dct, $
    dlevels=dlevels, $
    dcolors=dcolors, $
    geolimits=[-40,-20,5,50], $
    plon=plon, plat=plat
  device, /close

end
