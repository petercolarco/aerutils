PRO sg2_indexinfo, data

data = {num_prof:           0L,            $ ; Number of profiles in these files

        ; Revision Info
        Met_Rev_Date:       0L,            $ ; LaRC Met Model Revision Date (YYYYMMDD)
        Driver_Rev:         BYTARR(8),     $ ; LaRC Driver Version (e.g. 6.20)
        Trans_Rev:          BYTARR(8),     $ ; LaRC Transmission Version
        Inv_Rev:            BYTARR(8),     $ ; LaRC Inversion Version
        Spec_Rev:           BYTARR(8),     $ ; LaRC Inversion Version
        Eph_File_Name:      BYTARR(32),    $ ; Ephemeris data file name
        Met_File_Name:      BYTARR(32),    $ ; Meteorological data file name
        Ref_File_Name:      BYTARR(32),    $ ; Refraction data file name
        Tran_File_Name:     BYTARR(32),    $ ; Transmission data file name
        Spec_File_Name:     BYTARR(32),    $ ; Species profile file name
        FillVal:            0.0E0,         $ ; Fill value

        ; Altitude grid and range info
        Grid_Size:          0.0E0,         $ ; Altitude grid spacing (0.5 km)
        Alt_Grid:           FLTARR(200),   $ ; Geometric altitudes (0.5,1.0,...,100.0 km)
        Alt_Mid_Atm:        FLTARR(70),    $ ; Middle atmosphere geometric altitudes
        Range_Trans:        FLTARR(2),     $ ; Transmission min & max altitudes       [0.5,100.]
        Range_O3:           FLTARR(2),     $ ; Ozone min & max altitudes              [0.5,70.0]
        Range_NO2:          FLTARR(2),     $ ; NO2 min & max altitudes                [0.5,50.0]
        Range_H2O:          FLTARR(2),     $ ; Water vapor min & max altitudes        [0.5,50.0]
        Range_Ext:          FLTARR(2),     $ ; Aerosol extinction min & max altitudes [0.5,40.0]
        Range_Dens:         FLTARR(2),     $ ; Density min & max altitudes            [0.5,70.0]
        Spare:              FLTARR(2),     $ ; 

        ; Event specific info useful for data subsetting
        YYYYMMDD:           LONARR(930),   $ ; Event date at 20 km subtangent point
        Event_Num:          LONARR(930),   $ ; Event number
        HHMMSS:             LONARR(930),   $ ; Event time at 20 km
        Day_Frac:           FLTARR(930),   $ ; Time of year (DDD.frac) at 20 km
        Lat:                FLTARR(930),   $ ; Subtangent latitude  at 20 km (-90,+90)
        Lon:                FLTARR(930),   $ ; Subtangent longitude at 20 km (-180,+180)
        Beta:               FLTARR(930),   $ ; Spacecraft beta angle (deg)
        Duration:           FLTARR(930),   $ ; Duration of event (sec)
        Type_Sat:           INTARR(930),   $ ; Event Type: Instrument (0=SR, 1=SS)
        Type_Tan:           INTARR(930),   $ ; Event Type: Local      (0=SR, 1=SS)

        ; Process tracking and flag info
        Dropped:            LONARR(930),   $ ; Dropped event flag
        InfVec:             LONARR(930),   $ ; Bit flags relating to processing

        ; Record creation dates and times
        Eph_Cre_Date:       LONARR(930),   $ ; Record creation date (YYYYMMDD format)
        Eph_Cre_Time:       LONARR(930),   $ ; Record creation time (HHMMSS format)
        Met_Cre_Date:       LONARR(930),   $ ; Record creation date (YYYYMMDD format)
        Met_Cre_Time:       LONARR(930),   $ ; Record creation time (HHMMSS format)
        Ref_Cre_Date:       LONARR(930),   $ ; Record creation date (YYYYMMDD format)
        Ref_Cre_Time:       LONARR(930),   $ ; Record creation time (HHMMSS format)
        Tran_Cre_Date:      LONARR(930),   $ ; Record creation date (YYYYMMDD format)
        Tran_Cre_Time:      LONARR(930),   $ ; Record creation time (HHMMSS format)
        Spec_Cre_Date:      LONARR(930),   $ ; Record creation date (YYYYMMDD format)
        Spec_Cre_Time:      LONARR(930)    } ; Record creation time (HHMMSS format)

END
