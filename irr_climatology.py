import numpy as np
import matplotlib.pyplot as plt
import netCDF4 as nc
import string
import subprocess as sys
import csv


fig=plt.figure()
ax1=fig.add_subplot(111)


#####################
month_name=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
irr_clmatology=[2.72616,3.45203,6.69849,8.66795,15.609,10.0776,14.4144,16.7104,13.4751,11.0276,4.3721,2.29811]

ax1.plot(range(12),irr_clmatology,'.-')

#fig.suptitle("("+str(ygrid)+", "+str(xgrid)+") Precipitation")
fig.suptitle("Irri climatology")
ax1.grid()
#ax1.set_ylim([0,100])
#ax1.set_xticks(range(0,112,5))
#ax1.set_xticklabels(range(1901,2013,5))
#ax1.set_xlim([70,112])
#ax1.set_xticks(range(0,63,3))
#ax1.set_xticklabels(range(1948,2011,3))
#ax1.set_xlim([25,65])
#ax1.set_xticks(range(1966,2013,5))
#ax1.set_xlim([1966,2014])
#ax1.plot((1983.5, 1983.5), (0, 120), 'k--',linewidth=3)
#ax1.plot((1993.5, 1993.5), (0, 120), 'k--',linewidth=3)
#ax1.plot((1999.5, 1999.5), (0, 120), 'k--',linewidth=3)
#ax1.legend([month_name[i] for i in mmonth],bbox_to_anchor=(0.9, 1.),loc='upper left',borderaxespad=0.)
ax1.legend(["irrigation from Wada"],loc='upper left')
figname= (raw_input('figname? '))
#figname="rainy_day_precipAno"
if figname!="no":
	plt.savefig('/home/L.r02229011/fig/'+figname+'.png',bbox_inches=0)
	plt.savefig('/home/L.r02229011/fig/'+figname+'.pdf',bbox_inches=0)
plt.show()
