import numpy as np
import matplotlib.pyplot as plt
import netCDF4 as nc
import string
import subprocess as sys
#Fil=nc.MFDataset("/work4/L.r02229011/GPCC/Full_Data_Reanalysis_V7/full_data_v7_05.nc")
#Var=Fil.variables['p'][:,127,447] # GPCC 1901-2013

#Fil=nc.MFDataset("/work4/L.r02229011/CRU/cru_ts3.21.1901.2012.pre.dat.nc")
#Var=Fil.variables['pre'][:,232,447] # CRU 1901-2012

Fil=nc.MFDataset("/dadm1/obs/GPCP/mon/GPCP_V2.2_197901-201307.nc")
Var=Fil.variables['precip'][:,25,17] # GPCP   1979-2013Jul

Var=np.array(Var)
Var4d=np.zeros((12,35))
for i in range(7):
	Var4d[i,:]=Var[i:len(Var):12]
print(Var4d.shape)
FMAM=sum(Var4d[0:5,:])
fig=plt.figure()
ax1=fig.add_subplot(111)
#for i in range(1,5):
#	ax1.plot(Var4d[i,:],  '-')
ax1.plot(FMAM/4,  '-')

#fig.suptitle("("+str(ygrid)+", "+str(xgrid)+") Precipitation")
ax1.grid()
fig.suptitle("GPCP the grid nearest to 26.33N 43.97E")
#ax1.set_ylim([0,100])
#ax1.set_xticks(range(0,112,5))
#ax1.set_xticklabels(range(1901,2013,5))
#ax1.set_xlim([70,112])
ax1.set_xticks(range(0,35,5))
ax1.set_xticklabels(range(1979,2013,5))


figname= (raw_input('figname? '))
#figname="rainy_day_precipAno"
if figname!="no":
	plt.savefig('/home/L.r02229011/fig/'+figname+'.png',bbox_inches=0)
	plt.savefig('/home/L.r02229011/fig/'+figname+'.pdf',bbox_inches=0)
plt.show()
