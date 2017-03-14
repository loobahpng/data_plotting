import numpy as np
import matplotlib.pyplot as plt
import netCDF4 as nc
import string
import subprocess as sys
import csv
from scipy import stats

fig=plt.figure()
ax1=fig.add_subplot(111)
export=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,27,7,10,11,7,78,1584,2436,1956,1578,1661,2317,2490,2015,1651,181,3,0,0,26,5,3,1,0,0,2,4,8,24,9,11,12,14,9,8,10,10]
ax1.plot(range(1960,2017),export,'r-')
#ax2=plt.twinx()
#ax2.plot(range(1966,2013),seasonly[0],'.-')
#ax2.plot(range(1966,2013),seasonly[1],'.-')
######################
#ax2=plt.twinx()
#ax2.plot(range(1972,2013),Qaseem,  'k.-')
#ax2.set_xlim([1970,2014])

#fig.suptitle("("+str(ygrid)+", "+str(xgrid)+") Precipitation")
fontsize=18
fig.suptitle("Saudi Arabia Wheat Exports by Year",fontsize=fontsize)
#ax1.grid()
#ax1.set_ylim([0,100])
#ax1.set_xticks(range(0,112,5))
#ax1.set_xticklabels(range(1901,2013,5))
#ax1.set_xlim([70,112])
#ax1.set_xticks(range(0,63,3))
#ax1.set_xticklabels(range(1948,2011,3))
ax1.set_xlabel("Year",fontsize=fontsize)
ax1.set_ylabel("1000MT",fontsize=fontsize)
ax1.set_xticks(range(1960,2017,8))
ax1.tick_params(labelsize=fontsize)
ax1.set_xlim([1960,2017])
#ax1.plot((1965.5, 1965.5), (-60, 40), 'k--',linewidth=3)
ax1.set_ylim([0,3000])

#ax1.legend([month_name[i] for i in mmonth],bbox_to_anchor=(0.9, 1.),loc='upper left',borderaxespad=0.)
figname= (raw_input('figname? '))
#figname="no"
if figname!="no":
	plt.savefig('/home/L.r02229011/fig/'+figname+'.png',bbox_inches=0)
	plt.savefig('/home/L.r02229011/fig/'+figname+'.pdf',bbox_inches=0)
plt.show()

