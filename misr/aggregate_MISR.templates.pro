; Aggregate MODIS AOT to various grids

; MISR/a
;  ods2grid_misr, 'MISR', '20000301', '200901130', $
;                 odsdir = '/misc/prc10/MISR/Level3/ODS_03/', $
;                 odsver = 'aero_tc8', $
;                 ntday = 8, synopticoffset=90, $
;                 resolution = 'a', qatype = 'noqawt', $
;                 /shave

; MISR/b
;  ods2grid_misr, 'MISR', '20000301', '200901130', $
;                 odsdir = '/misc/prc10/MISR/Level3/ODS_03/', $
;                 odsver = 'aero_tc8', $
;                 ntday = 8, synopticoffset=90, $
;                 resolution = 'b', qatype = 'noqawt', $
;                 /shave

; MISR/c
;  ods2grid_misr, 'MISR', '20000301', '200901130', $
;                 odsdir = '/misc/prc10/MISR/Level3/ODS_03/', $
;                 odsver = 'aero_tc8', $
;                 ntday = 8, synopticoffset=90, $
;                 resolution = 'c', qatype = 'noqawt', $
;                 /shave

; MISR/d
;  ods2grid_misr, 'MISR', '20000301', '200901130', $
;                 odsdir = '/misc/prc10/MISR/Level3/ODS_03/', $
;                 odsver = 'aero_tc8', $
;                 ntday = 8, synopticoffset=90, $
;                 resolution = 'd', qatype = 'noqawt', $
;                 /shave

; MISR/a
  ods2grid_misr, 'MISR', '20000301', '200901130', $
                 odsdir = '/misc/prc10/MISR/Level3/ODS_03/', $
                 odsver = 'aero_tc8', $
                 outdir = '/misc/prc10/MISR/Level3/boxav/a/GRITAS/', $
                 ntday = 8, synopticoffset=90, $
                 resolution = 'a', qatype = 'noqawt', $
                 /shave

; MISR/b
  ods2grid_misr, 'MISR', '20000301', '200901130', $
                 odsdir = '/misc/prc10/MISR/Level3/ODS_03/', $
                 odsver = 'aero_tc8', $
                 outdir = '/misc/prc10/MISR/Level3/boxav/b/GRITAS/', $
                 ntday = 8, synopticoffset=90, $
                 resolution = 'b', qatype = 'noqawt', $
                 /shave

; MISR/c
  ods2grid_misr, 'MISR', '20000301', '200901130', $
                 odsdir = '/misc/prc10/MISR/Level3/ODS_03/', $
                 odsver = 'aero_tc8', $
                 outdir = '/misc/prc10/MISR/Level3/boxav/c/GRITAS/', $
                 ntday = 8, synopticoffset=90, $
                 resolution = 'c', qatype = 'noqawt', $
                 /shave

; MISR/d
  ods2grid_misr, 'MISR', '20000301', '200901130', $
                 odsdir = '/misc/prc10/MISR/Level3/ODS_03/', $
                 odsver = 'aero_tc8', $
                 outdir = '/misc/prc10/MISR/Level3/boxav/d/GRITAS/', $
                 ntday = 8, synopticoffset=90, $
                 resolution = 'd', qatype = 'noqawt', $
                 /shave

end
