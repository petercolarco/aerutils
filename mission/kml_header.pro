; colarco, May 2007
; Write the KML header

  pro kml_header, lun, title, dirmake

  printf, lun, '<?xml version="1.0" encoding="UTF-8"?>'
  printf, lun, '<kml xmlns="http://earth.google.com/kml/2.1">'
  printf, lun, '<Folder>'
  printf, lun, ' <name>&lt;b&gt;'+title+'&lt;/b&gt;</name>'
  printf, lun, ' <description>&lt;b&gt;'+title+'&lt;/b&gt;</description>'
  printf, lun, ' <visibility>1</visibility>'
  printf, lun, ' <open>1</open>'
  printf, lun, '<LookAt>'
  printf, lun, ' <longitude>-84</longitude>'
  printf, lun, ' <latitude>10</latitude>'
  printf, lun, ' <altitude>0</altitude>'
  printf, lun, ' <range>9747604.567246858</range>'
  printf, lun, ' <tilt>2.646630325482836e-016</tilt>'
  printf, lun, ' <heading>1.847421291267507</heading>'
  printf, lun, '</LookAt>'
  printf, lun, '<ScreenOverlay>'
  printf, lun, '    <name>Color Bar</name>'
  printf, lun, '    <Icon>'
  printf, lun, '      <href>'+dirmake+'/legend.png</href>'
  printf, lun, '    </Icon>'
  printf, lun, '    <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>'
  printf, lun, '    <screenXY x="0" y="1" xunits="fraction" yunits="fraction"/>'
  printf, lun, '    <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>'
  printf, lun, '    <size x="0" y="0" xunits="fraction" yunits="fraction"/>'
  printf, lun, '</ScreenOverlay>'
  printf, lun, '<Folder>'
  printf, lun, ' <name>Individual time slices</name>'
  printf, lun, ' <description>Individual time slices</description>'
  printf, lun, ' <visibility>1</visibility>'
  printf, lun, ' <open>0</open>'

end
