 pro getregions, nreg, ymaxwant, maskwant, $
                 lon0want, lon1want, $
                 lat0want, lat1want, $
                 regtitle

nreg = 46
ymaxwant = make_array(nreg,val=0.5)
maskwant = make_array(nreg,val=1)
regtitle = strarr(nreg)
lon0want = fltarr(nreg)
lon1want = fltarr(nreg)
lat0want = fltarr(nreg)
lat1want = fltarr(nreg)


i =        0
regtitle[i] = "NAmer_Alsk"
lon0want[i] = -170
lon1want[i] = -140
lat0want[i] = 50
lat1want[i] = 70

i =        1
regtitle[i] = "NAmer_Cana"
lon0want[i] = -140
lon1want[i] = -80
lat0want[i] = 50
lat1want[i] = 70

i =        2
regtitle[i] = "NAmer_Queb"
lon0want[i] = -80
lon1want[i] = -55
lat0want[i] = 45
lat1want[i] = 65

i =        3
regtitle[i] = "NAmer_USW"
lon0want[i] = -130
lon1want[i] = -105
lat0want[i] = 30
lat1want[i] = 50

i =        4
regtitle[i] = "NAmer_USC"
lon0want[i] = -105
lon1want[i] = -90
lat0want[i] = 30
lat1want[i] = 50

i =        5
regtitle[i] = "NAmer_USE"
lon0want[i] = -90
lon1want[i] = -70
lat0want[i] = 25
lat1want[i] = 45

i =        6
regtitle[i] = "SAmm_Mex"
lon0want[i] = -120
lon1want[i] = -85
lat0want[i] = 10
lat1want[i] = 30

i =        7
regtitle[i] = "SAmm_Brazf"
lon0want[i] = -75
lon1want[i] = -50
lat0want[i] = -15
lat1want[i] = 5
ymaxwant[i] = 1.

i =        8
regtitle[i] = "SAmm_Brazc"
lon0want[i] = -50
lon1want[i] = -30
lat0want[i] = -20
lat1want[i] = 0

i =        9
regtitle[i] = "SAmm_Argen"
lon0want[i] = -75
lon1want[i] = -50
lat0want[i] = -60
lat1want[i] = -15
ymaxwant[i] = 1.

i =       10
regtitle[i] = "Afri_West"
lon0want[i] = -20
lon1want[i] = 15
lat0want[i] = 0
lat1want[i] = 15
ymaxwant[i] = 1.

i =       11
regtitle[i] = "Afri_Central"
lon0want[i] = 15
lon1want[i] = 30
lat0want[i] = 5
lat1want[i] = 15
ymaxwant[i] = 1.5

i =       12
regtitle[i] = "Afri_East"
lon0want[i] = 30
lon1want[i] = 50
lat0want[i] = -10
lat1want[i] = 15

i =       13
regtitle[i] = "Afri_Congo"
lon0want[i] = 10
lon1want[i] = 30
lat0want[i] = -10
lat1want[i] = 5
ymaxwant[i] = 1.

i =       14
regtitle[i] = "Afri_Zamb"
lon0want[i] = 22
lon1want[i] = 35
lat0want[i] = -18
lat1want[i] = -8

i =       15
regtitle[i] = "Afri_South"
lon0want[i] = 10
lon1want[i] = 35
lat0want[i] = -35
lat1want[i] = -20

i =       16
regtitle[i] = "Afri_Madag"
lon0want[i] = 42
lon1want[i] = 50
lat0want[i] = -25
lat1want[i] = -12

i =       17
regtitle[i] = "Eusi_Scan"
lon0want[i] = 0
lon1want[i] = 35
lat0want[i] = 55
lat1want[i] = 75

i =       18
regtitle[i] = "Eusi_Mosc"
lon0want[i] = 30
lon1want[i] = 60
lat0want[i] = 45
lat1want[i] = 60

i =       19
regtitle[i] = "Eusi_Sibw"
lon0want[i] = 35
lon1want[i] = 90
lat0want[i] = 60
lat1want[i] = 75

i =       20
regtitle[i] = "Eusi_Sibe"
lon0want[i] = 90
lon1want[i] = 140
lat0want[i] = 60
lat1want[i] = 75

i =       21
regtitle[i] = "Eusi_Eurw"
lon0want[i] = -10
lon1want[i] = 30
lat0want[i] = 35
lat1want[i] = 55

i =       22
regtitle[i] = "Eusi_Mide"
lon0want[i] = 30
lon1want[i] = 60
lat0want[i] = 30
lat1want[i] = 45

i =       23
regtitle[i] = "Asia_Cent"
lon0want[i] = 60
lon1want[i] = 110
lat0want[i] = 35
lat1want[i] = 50

i =       24
regtitle[i] = "Asia_Chine"
lon0want[i] = 110
lon1want[i] = 150
lat0want[i] = 35
lat1want[i] = 60
ymaxwant[i] = 1.

i =       25
regtitle[i] = "Asia_Nepal"
lon0want[i] = 65
lon1want[i] = 95
lat0want[i] = 25
lat1want[i] = 35
ymaxwant[i] = 1.

i =       26
regtitle[i] = "Asia_India"
lon0want[i] = 70
lon1want[i] = 90
lat0want[i] = 5
lat1want[i] = 25
ymaxwant[i] = 1.

i =       27
regtitle[i] = "Asia_Chins"
lon0want[i] = 100
lon1want[i] = 125
lat0want[i] = 20
lat1want[i] = 40
ymaxwant[i] = 1.

i =       28
regtitle[i] = "Asia_Indchn"
lon0want[i] = 90
lon1want[i] = 110
lat0want[i] = 10
lat1want[i] = 25
ymaxwant[i] = 1.

i =       29
regtitle[i] = "Ausa_Philip"
lon0want[i] = 115
lon1want[i] = 130
lat0want[i] = 5
lat1want[i] = 20

i =       30
regtitle[i] = "Ausa_Sumatra"
lon0want[i] = 95
lon1want[i] = 110
lat0want[i] = -10
lat1want[i] = 10

i =       31
regtitle[i] = "Ausa_Borneo"
lon0want[i] = 110
lon1want[i] = 120
lat0want[i] = -5
lat1want[i] = 8

i =       32
regtitle[i] = "Ausa_Indpng"
lon0want[i] = 120
lon1want[i] = 160
lat0want[i] = -10
lat1want[i] = 5

i =       33
regtitle[i] = "Ausa_Ausn"
lon0want[i] = 120
lon1want[i] = 150
lat0want[i] = -20
lat1want[i] = -10

i =       34
regtitle[i] = "Ausa_Ausw"
lon0want[i] = 110
lon1want[i] = 130
lat0want[i] = -35
lat1want[i] = -20

i =       35
regtitle[i] = "Ausa_Ause"
lon0want[i] = 135
lon1want[i] = 155
lat0want[i] = -45
lat1want[i] = -20

i =       36
regtitle[i] = "Eusi_Sibfe"
lon0want[i] = 140
lon1want[i] = 170
lat0want[i] = 60
lat1want[i] = 75

i =       37
regtitle[i] = "Afri_Sahara"
lon0want[i] = -15
lon1want[i] = 30
lat0want[i] = 13
lat1want[i] = 35
ymaxwant[i] = 1.

i =       38
regtitle[i] = "Afri_Sahel"
lon0want[i] = -15
lon1want[i] = 35
lat0want[i] = 11
lat1want[i] = 13

i =       39
regtitle[i] = "Afri_CapVerd"
lon0want[i] = -26
lon1want[i] = -20
lat0want[i] = 10
lat1want[i] = 20
ymaxwant[i] = 1.
maskwant[i] = 0

i =       40
regtitle[i] = "Afri_RedSea"
lon0want[i] = 30
lon1want[i] = 45
lat0want[i] = 10
lat1want[i] = 30
ymaxwant[i] = 1.
maskwant[i] = 0

i =       41
regtitle[i] = "Asia_PerGulf"
lon0want[i] = 45
lon1want[i] = 60
lat0want[i] = 20
lat1want[i] = 30
ymaxwant[i] = 1.
maskwant[i] = 0

i =       42
regtitle[i] = "IO_ArabSea"
lon0want[i] = 60
lon1want[i] = 70
lat0want[i] = 10
lat1want[i] = 20
ymaxwant[i] = 1.
maskwant[i] = 0

i =       43
regtitle[i] = "NAO_Carib"
lon0want[i] = -80
lon1want[i] = -60
lat0want[i] = 13
lat1want[i] = 23
maskwant[i] = 0

i =       44
regtitle[i] = "NAO_AfrDust"
lon0want[i] = -60
lon1want[i] = -26
lat0want[i] = 13
lat1want[i] = 30
maskwant[i] = 0

i =       45
regtitle[i] = "SAO_SAmmBB"
lon0want[i] = -45
lon1want[i] = -20
lat0want[i] = -45
lat1want[i] = -25
maskwant[i] = 0

end
