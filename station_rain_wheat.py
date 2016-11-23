import numpy as np
import matplotlib.pyplot as plt
import netCDF4 as nc
import string
import subprocess as sys
import csv


fig=plt.figure()
ax1=fig.add_subplot(111)
f = open('/home/L.r02229011/wrf_plotting/qaseem_1980_2012.csv', 'r')
def replace(l, X, Y):
  for i,v in enumerate(l):
     if v == X:
        l.pop(i)
        l.insert(i, Y)

for row in csv.reader(f):
	continue
f.close()
print("len of row: "+str(len(row)))
feb=(row[2:len(row):12])
mar=(row[3:len(row):12])
apr=(row[4:len(row):12])
may=(row[5:len(row):12])
replace(feb, '999', np.nan)
replace(feb, '-1', 0)
replace(mar, '999', np.nan)
replace(mar, '-1', 0)
replace(apr, '999', np.nan)
replace(apr, '-1', 0)
replace(may, '999', np.nan)
replace(may, '-1', 0)
feb=np.array([float(i) for i in feb])
mar=np.array([float(i) for i in mar])
apr=np.array([float(i) for i in apr])
may=np.array([float(i) for i in may])

FMAM=(feb+mar+apr+may)/4
#ax1.plot(range(1980,2013),FMAM,  'k.-',linewidth=1)
#print(np.average(FMAM[0:13]))
#x=FMAM[13:len(FMAM)]
#x = x[np.logical_not(np.isnan(x))]
#print(np.average(x))
#print(np.var(FMAM[0:13]))
#print(np.var(x))
############################

Qaseem_wheat=[9224.8,7768.2,29750.9,14091,10342,11953.8,10976.4,np.nan,15755.2,17563.7,45050.2,91205.9,141205.8,204639.6,201533.8,203202.2,251753.5,255284,242427,262586,276121,224158,168922,95121,63895,109064,102120,140370,133086,92624,144287,147007,130533,117957,99712,84621,45654,22792,26426,22951,17160]
ax2=plt.twinx()
ax2.plot(range(1972,2013),Qaseem_wheat,  '.-')

Hail_wheat=[422.4,760.7,955.2,1057.9,4163.1,4025.3,1128.8,np.nan,2724.8,2724.4,6129.4,11868.1,32074.5,40403.7,47553,54940,62389.4,76573,85806,77399,78959,66557,48513,34241,36223,38062,56151,69940,68395,45303,47537,51009,55810,57252,56349,58222,44559,23558,28048,27196,20334]
ax2.plot(range(1972,2013),Hail_wheat,  '.-')

Qaseem_fodder=[7821.1,8007,12685.6,12216.4,14232.7,13227.5,13502.4,18835.9,17932.2,15875,15364,31429,28886,33021,42358,45614,46777,40726,41784,35194,41240,75715,40413,34551,22844,19154,18157,20127,14457,18463,23800,25006]
ax2.plot(range(1980,2012),Qaseem_fodder,  '.-')

###########################

#fig.suptitle("("+str(ygrid)+", "+str(xgrid)+") Precipitation")
#ax1.grid()
#fig.suptitle("The grid nearest to 26.33N 43.97E")
#ax1.set_ylim([0,100])
#ax1.set_xticks(range(0,112,5))
#ax1.set_xticklabels(range(1901,2013,5))
#ax1.set_xlim([70,112])
#ax1.set_xticks(range(0,63,3))
#ax1.set_xticklabels(range(1948,2011,3))
#ax1.set_xlim([25,65])
#ax1.set_xticks(range(1970,2013,5))
ax1.set_xlim([1970,2014])
ax2.set_xlim([1970,2014])
#ax1.plot((1979.5, 1979.5), (0, 120), 'k--',linewidth=3)
#ax1.plot((1993.5, 1993.5), (0, 120), 'k--',linewidth=3)

#ax1.legend(["Qaseem rain"],loc='upper left')
ax2.legend(["Qaseem wheat","Hail wheat","Qaseem fodder"],loc='upper right')
ax1.plot((1983.5, 1983.5), (0, 120), 'k--',linewidth=3)
ax1.plot((1993.5, 1993.5), (0, 120), 'k--',linewidth=3)
ax1.plot((1999.5, 1999.5), (0, 120), 'k--',linewidth=3)
ax2.grid()

figname= (raw_input('figname? '))
#figname="rainy_day_precipAno"
if figname!="no":
	plt.savefig('/home/L.r02229011/fig/'+figname+'.png',bbox_inches=0)
	plt.savefig('/home/L.r02229011/fig/'+figname+'.pdf',bbox_inches=0)
plt.show()
