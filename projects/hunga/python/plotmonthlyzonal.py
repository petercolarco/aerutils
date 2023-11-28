import monthly
for yy in range (2012,2023):
	for mm in range (1,13):
		print(yy,mm)
		monthly.plotzonal(yy,mm)
