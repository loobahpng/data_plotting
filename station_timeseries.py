import numpy as np
import matplotlib.pyplot as plt
import netCDF4 as nc
import string
import subprocess as sys
import csv
from scipy import stats

fig=plt.figure()
ax1=fig.add_subplot(111)


#####################
for fff in range(3):
	month_name=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
	if fff==0:
		file = open("Qaseem_1966_2012.txt", 'r')
		print("Qaseem")
	if fff==1:
		file = open("Riyadh_1966_2012.txt", 'r')
		print("Riyadh")
	if fff==2:
		file = open("Hail_1966_2012.txt", 'r')
		print("Hail")
	content = file.read()
	file.close()
	Vartext=content.split('\n')
	Vartext.pop()
	numFils=len(Vartext)
	Var=[]
	for i in range(numFils):
	#		if float(Vartext[0])>-1:
			if float(Vartext[0])==999:
				Var.append(np.nan)
				Vartext.pop(0)
				continue
			if float(Vartext[0])==-1:
				Var.append(0)
				Vartext.pop(0)
				continue
			Var.append(float(Vartext[0]))
			Vartext.pop(0)
	mmonth=range(12)
	monthly=[]
	for mm in mmonth:
		month=(Var[mm:len(Var):12])
		month=np.array([float(i) for i in month])
		monthly.append(month)
	#	ax1.plot(range(1966,2013),month,'.-')
		period1=month[0:12]
		period2=month[14:45]
		period1 = period1[np.logical_not(np.isnan(period1))]
		period2 = period2[np.logical_not(np.isnan(period2))]
		print(month_name[mm])
		print(np.nanmean(period1))
		print(np.nanmean(period2))
		print(np.var(period1))
		print(np.var(period2))
		t, p = stats.ttest_ind(period1, period2, equal_var=False)
		print("p= "+str(p))
		print("-------")

	FMAM=(np.nanmean(monthly,axis=0))
	ax1.plot(range(1966,2013),FMAM,'.-')
######################
#Qaseem=[9224.8,7768.2,29750.9,14091,10342,11953.8,10976.4,np.nan,15755.2,17563.7,45050.2,91205.9,141205.8,204639.6,201533.8,203202.2,251753.5,255284,242427,262586,276121,224158,168922,95121,63895,109064,102120,140370,133086,92624,144287,147007,130533,117957,99712,84621,45654,22792,26426,22951,17160]
#ax2=plt.twinx()
#ax2.plot(range(1972,2013),Qaseem,  'k.-')
#ax2.set_xlim([1970,2014])

#fig.suptitle("("+str(ygrid)+", "+str(xgrid)+") Precipitation")
fig.suptitle("JJAS for 3 stations")
ax1.grid()
#ax1.set_ylim([0,100])
#ax1.set_xticks(range(0,112,5))
#ax1.set_xticklabels(range(1901,2013,5))
#ax1.set_xlim([70,112])
#ax1.set_xticks(range(0,63,3))
#ax1.set_xticklabels(range(1948,2011,3))
#ax1.set_xlim([25,65])
ax1.set_xticks(range(1966,2013,5))
ax1.set_xlim([1966,2014])
#ax1.plot((1983.5, 1983.5), (0, 120), 'k--',linewidth=3)
#ax1.plot((1993.5, 1993.5), (0, 120), 'k--',linewidth=3)
#ax1.plot((1999.5, 1999.5), (0, 120), 'k--',linewidth=3)
#ax1.legend([month_name[i] for i in mmonth],bbox_to_anchor=(0.9, 1.),loc='upper left',borderaxespad=0.)
ax1.legend(["Qaseem","Riyadh","Hail"],loc='upper left')
#figname= (raw_input('figname? '))
figname="no"
if figname!="no":
	plt.savefig('/home/L.r02229011/fig/'+figname+'.png',bbox_inches=0)
	plt.savefig('/home/L.r02229011/fig/'+figname+'.pdf',bbox_inches=0)
plt.show()

