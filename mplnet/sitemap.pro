; Bryon Baumstarck
; 6-8-2009

; Named coordinates for each site in MPLNET
;ACE_Asia_Cruise=[-999.00000, -999.00000, 0.0001]
;Abracos_Hill=[-10.76670, -62.36670, 0.2830]
;Anmyon=[36.53330, 126.31670, 0.0450]
;Appledore_Island=[42.96670, -70.61670, 0.0400]
;Bermuda=[32.36973, -64.69583, 0.0100]
;COVE=[36.90972, -75.70972, 0.0100]
;CRYSTAL_FACE=[25.64780, -80.43280, 0.0050]
;Capo_Verde=[16.74206, -22.94822, 0.0600]
;Dunhuang=[40.03800, 94.79370, 1.3000]
;EPA-NCU=[24.96670, 121.18060, 0.1350]
;GSFC=[39.01667, -76.86670, 0.0500]
;Gosan_SNU=[33.28300, 128.16901, 0.0500]
;ICEALOT=[-999.00000, -999.00000, 0.0050]
;Kanpur=[26.51900, 80.23268, 0.1500]
;MAARCO=[24.88300, 54.83300, 0.0000]
;Mongu=[-15.25433, 23.15050, 1.0250]
;Monterey=[36.58300, -121.85000, 0.0500]
;NCU_Taiwan=[24.96670, 121.18060, 0.1350]
;Ny_Alesund=[78.91667, 11.93300, 0.0400]
;Pimai=[15.18937, 102.56388, 0.2200]
;Ragged_Point=[13.17000, -59.43000, 0.0300]
;Roosevelt_Roads=[18.21667, -65.60000, 0.0060]
;SACOL=[35.94583, 104.13695, 1.9650]
;SEDE_BOKER=[30.85500, 34.78220, 0.4800]
;SMART=[24.21700, 55.51700, 0.2500]
;Santa_Cruz_Tenerife=[28.47250, -16.24740, 0.0520]
;Skukuza=[-24.97200, 31.58500, 0.1500]
;South_Pole=[-89.98000, -24.80000, 2.8350]
;Syowa=[-69.00000, 39.58000, 0.0300]
;Thompson_Farm=[43.11000, -70.95000, 0.0230]
;Trinidad_Head=[41.05400, -124.15100, 0.1070]
;Umbc=[39.24940, -76.71510, 0.0610]
;XiangHe=[39.75388, 116.96190, 0.0350]

; Procedure for printing ploted points on a continental map
pro printplot, vLongitude, vLatitude, vName
	plots, vLongitude, vLatitude, psym=1, color=240
	
	; Case Logic for changing the color of the text for sites being viewed
	CASE vName OF
		"Anmyon": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"Bermuda": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"COVE": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"EPA-NCU": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"GSFC": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"Gosan_SNU": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"ICEALOT": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"Monterey": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"Ny_Alesund": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"SACOL": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"SEDE_BOKER": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"Santa_Cruz_Tenerife": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"South_Pole": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"Syowa": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"Thompson_Farm": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		"Trinidad_Head": xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.85, charthick=2.2
		ELSE: xyouts, vLongitude, vLatitude, vName, CHARSIZE=0.65, charthick=1.2
	ENDCASE
end

; Create an effective array for all sites to be ploted from
siteName=["ACE_Asia_Cruise", "Abracos_Hill", "Anmyon", "Appledore_Island", $
	"Bermuda", "COVE", "CRYSTAL_FACE", "Capo_Verde", "Dunhuang", $
	"EPA-NCU", "GSFC", "Gosan_SNU", "ICEALOT", "Kanpur", "MAARCO", $
	"Mongu", "Monterey", "NCU_Taiwan", "Ny_Alesund", "Pimai", $ 
	"Ragged_Point", "Roosevelt_Roads", "SACOL", "SEDE_BOKER", "SMART", $
	"Santa_Cruz_Tenerife", "Skukuza", "South_Pole", "Syowa", $
	"Thompson_Farm", "Trinidad_Head", "Umbc", "XiangHe"]
siteLatitude=[-999.00000, -10.76670, 36.53330, 42.96670, 32.36973, 36.90972, $
	25.64780, 16.74206, 40.03800, 24.96670, 39.01667, 33.28300, -999.00000, $
	26.51900, 24.88300, -15.25433, 36.58300, 24.96670, 78.91667, 15.18937, $
	13.17000, 18.21667, 35.94583, 30.85500, 24.21700, 28.47250, -24.97200, $
	-89.98000, -69.00000, 43.11000, 41.05400, 39.24940, 39.75388]
siteLongitude=[-999.00000, -62.36670, 126.31670, -70.61670, -64.69583, $
	-75.70972, -80.43280, -22.94822, 94.79370, 121.18060, -76.86670, $
	128.16901, -999.00000, 80.23268, 54.83300, 23.15050, -121.85000, $
	121.18060, 11.93300, 102.56388, -59.43000, -65.60000, 104.13695, $
	34.78220, 55.51700, -16.24740, 31.58500, -24.80000, 39.58000, $
	-70.95000, -124.15100, -76.71510, 116.96190]

; To "print" the device to a PostScript file, with color
set_plot, 'ps'
device, color=1, file='~/aerutils/mplnet/output/plots/postscript/mplnet_sitemap.ps'

; Create a surface to plot onto
Map_Set, /Grid, /Continents, /Label
loadct, 39

; Plot sites based on site name
size=n_elements(siteName)
for index=0, size-1 do begin
	if((siteLongitude[index] EQ -999.0000) && (siteLatitude[index] EQ -999.0000)) then begin
		print, 'This site, '+siteName[index]+', is NOT STATIONARY.'
	endif else printplot, siteLongitude[index], siteLatitude[index], siteName[index]
endfor

device, /close

end
