import numpy as np
import matplotlib.pyplot as plt
import netCDF4 as nc
import string
import subprocess as sys
import csv
from scipy import stats

fig=plt.figure()
ax1=fig.add_subplot(111)
#############
wada=open("Wada_timeseries_fill.txt","r")
wadacontent=wada.read()
wada.close()
wadatext=wadacontent.split("\n")
wadatext.pop()
wada=[]
for i in range(len(wadatext)):
	wada.append(float(wadatext[0]))
	wadatext.pop(0)
wadamonthly=[]
mmonth=[1,2,3,4]
for mm in mmonth:
	wadamonth=(wada[mm:len(wada):12])
	wadamonth=np.array([float(i) for i in wadamonth])
	wadamonthly.append(wadamonth)
season=(np.nanmean(wadamonthly,axis=0))
#ax2=plt.twinx()
#ax2.plot(range(1960,2011),season,'k-')
###################

Fil=nc.MFDataset("/work4/L.r02229011/GPCC/Full_Data_Reanalysis_V7/full_data_v7_05.nc")
clat=np.array(Fil.variables['lat'])
clat=np.cos(clat*4.0*np.arctan(1.0)/180.0)
Var=np.array(range(1356))*0.
for t in range(1356):
	upper=0.
	lower=0.
	for y in [123,124,125,126,127,128,129,130]:
		for x in [-3,-2,-1,0,1,2]:
			upper=upper+Fil.variables['p'][t,y,y+320+x]*clat[y] # GPCC 1901-2013 mm/month
			lower=lower+clat[y]
	Var[t]=upper/lower
Var4d=np.zeros((12,113))
for i in range(12):
	Var4d[i,:]=Var[i:len(Var):12]
print(Var4d.shape)
FMAM=sum(Var4d[0:5,:])/4
for i in range(1,5):
#	ax1.plot(Var4d[i,:],  '-')
	pass
ax1.plot(range(1901,2014),FMAM,  '-')
print("GPCC")
print(np.average(FMAM[65:77]))
print(np.average(FMAM[79:97]))
print(np.var(FMAM[65:77]))
print(np.var(FMAM[79:97]))
t, p = stats.ttest_ind(FMAM[65:77], FMAM[79:97], equal_var=False)
print("t test p= "+str(p))
#####################
Fil=nc.MFDataset("/work4/L.r02229011/CRU/cru_ts3.21.1901.2012.pre.dat.nc")
clat=np.array(Fil.variables['lat'])
clat=np.cos(clat*4.0*np.arctan(1.0)/180.0)
Var=np.array(range(1344))*0.
for t in range(1344):
	upper=0.
	lower=0.
	for y in [229,230,231,232,233,234,235,236]:
		for x in [0,1,2,3,4,5]:
			upper=upper+Fil.variables['pre'][t,y,447+229-y+x]*clat[y] # CRU 1901-2012mm
			lower=lower+clat[y]
	Var[t]=upper/lower
Var4d=np.zeros((12,112))
for i in range(12):
	Var4d[i,:]=Var[i:len(Var):12]
print(Var4d.shape)
FMAM=sum(Var4d[0:5,:])/4
for i in range(1,5):
#	ax1.plot(Var4d[i,:],  '-')
	pass
ax1.plot(range(1901,2013),FMAM,  '-')
print("CRU")
print(np.average(FMAM[65:77]))
print(np.average(FMAM[79:97]))
print(np.var(FMAM[65:77]))
print(np.var(FMAM[79:97]))
t, p = stats.ttest_ind(FMAM[65:77], FMAM[79:97], equal_var=False)
print("t test p= "+str(p))
############################3
#Fil=nc.MFDataset("/dadm1/obs/GPCP/mon/GPCP_V2.2_197901-201307.nc")
#clat=np.array(Fil.variables['lat'])
#clat=np.cos(clat*4.0*np.arctan(1.0)/180.0)
#Var=np.array(range(415))*0.
#for t in range(415):
#	upper=0.
#	lower=0.
#	for y in [24,25]:
#		for x in [0,1]:
#			if y==25 and x==1:
#				break
#			upper=upper+Fil.variables['precip'][t,y,y-8+x]*clat[y] # GPCP 1979-2013Jul mm/day
#			lower=lower+clat[y]
#	Var[t]=upper/lower
#Var4d=np.zeros((12,35))
#for i in range(7):
#	Var4d[i,:]=Var[i:len(Var):12]
#print(Var4d.shape)
#FMAM=sum(Var4d[0:5,:])/4*30
#for i in range(1,5):
#	ax1.plot(Var4d[i,:],  '-')
#ax1.plot(range(1979,2014),FMAM,  '-')
#print("GPCP")
#print(np.average(FMAM[5:14]))
#print(np.average(FMAM[21:len(FMAM)]))
#print(np.var(FMAM[5:14]))
#print(np.var(FMAM[21:len(FMAM)]))
####################
Fil=nc.MFDataset("/work4/L.r02229011/PRECL.mon.mean.0.5x0.5.nc")
clat=np.array(Fil.variables['lat'])
clat=np.cos(clat*4.0*np.arctan(1.0)/180.0)
Var=np.array(range(769))*0.
for t in range(769):
	upper=0.
	lower=0.
	for y in [123,124,125,126,127,128,129,130]:
		for x in [0,1,2,3,4,5]:
			upper=upper+Fil.variables['precip'][t,y,y-43+x]*clat[y] # PRECL   1948-2012Jan mm/day
			lower=lower+clat[y]
	Var[t]=upper/lower
Var=np.delete(Var,len(Var)-1) # to delete 2012Jan
Var4d=np.zeros((12,64))
for i in range(12):
	Var4d[i,:]=Var[i:len(Var):12]
print(Var4d.shape)
FMAM=sum(Var4d[0:5,:])/4*30
for i in range(1,5):
#	ax1.plot(Var4d[i,:],  '-')
	pass
ax1.plot(range(1948,2012),FMAM,  '-')
print("PREC/L")
print(np.average(FMAM[18:30]))
print(np.average(FMAM[32:48]))
print(np.var(FMAM[18:30]))
print(np.var(FMAM[32:48]))
t, p = stats.ttest_ind(FMAM[18:30], FMAM[32:48], equal_var=False)
print("t test p= "+str(p))
########################
#FMAM=np.array([6.720682,12.27245,35.56153,12.6882,8.593577,10.48366,5.50986,10.74386,8.19616,1.843551,3.68938,1.268218,3.52646,0.9196435,10.98701,0.981329,8.953,3.281899,1.97287,6.032456,3.179771,3.316271,2.286721,9.082449,0.6592908,4.062573,3.040227,2.806108,1.083259,0.4464742,6.025282,4.205269,3.239168])

#ax1.plot(range(1979,2012),FMAM,  '-')
#print("CPC-U")
#print(np.average(FMAM[5:16]))
#print(np.average(FMAM[23:len(FMAM)]))
#print(np.var(FMAM[5:16]))
#print(np.var(FMAM[23:len(FMAM)]))

#####################
#def replace(l, X, Y):
#  for i,v in enumerate(l):
#     if v == X:
#        l.pop(i)
#        l.insert(i, Y)
#file = open("qaseem_1966_2012.txt", 'r')
#content = file.read()
#file.close()
#Vartext=content.split('\r')
#Vartext.pop()
#print(len(Vartext))
#numFils=len(Vartext)
#Var=[]
#for i in range(numFils):
##		if float(Vartext[0])>-1:
#		if float(Vartext[0])==999:
#			print("999")
#			Var.append(np.nan)
#			Vartext.pop(0)
#			continue
#		if float(Vartext[0])==-1:
#			Var.append(0)
#			Vartext.pop(0)
#			continue
#		Var.append(float(Vartext[0]))
#		Vartext.pop(0)
#print("$$$$$$$$")
#print(Var)
#print("$$$$$$$$")
#feb=(Var[1:len(Var):12])
#mar=(Var[2:len(Var):12])
#apr=(Var[3:len(Var):12])
#may=(Var[4:len(Var):12])
##replace(feb, '999.0', np.nan)
##replace(feb, '-1.0', 0)
##replace(mar, '999.0', np.nan)
##replace(mar, '-1.0', 0)
##replace(apr, '999.0', np.nan)
##replace(apr, '-1.0', 0)
##replace(may, '999.0', np.nan)
##replace(may, '-1.0', 0)
#feb=np.array([float(i) for i in feb])
#mar=np.array([float(i) for i in mar])
#apr=np.array([float(i) for i in apr])
#may=np.array([float(i) for i in may])
#print(len(Var))
#print(len(feb))
#print(len(mar))
#print(len(apr))
#print(len(may))
#print(feb)
#FMAM=(feb+mar+apr+may)/4
#ax1.plot(range(1966,2013),FMAM,  'k.-',linewidth=1)
#print(np.average(FMAM[0:14]))
#x=FMAM[15:len(FMAM)]
#x = x[np.logical_not(np.isnan(x))]
#print(np.average(x))
#print(np.var(FMAM[0:14]))
#print(np.var(x))
######################
#Qaseem=[9224.8,7768.2,29750.9,14091,10342,11953.8,10976.4,np.nan,15755.2,17563.7,45050.2,91205.9,141205.8,204639.6,201533.8,203202.2,251753.5,255284,242427,262586,276121,224158,168922,95121,63895,109064,102120,140370,133086,92624,144287,147007,130533,117957,99712,84621,45654,22792,26426,22951,17160]
#ax2=plt.twinx()
#ax2.plot(range(1972,2013),Qaseem,  'k.-')
#ax2.set_xlim([1970,2014])

#fig.suptitle("("+str(ygrid)+", "+str(xgrid)+") Precipitation")
ax1.grid()
#fig.suptitle("The grid nearest to 26.33N 43.97E")
#ax1.set_ylim([0,100])
#ax1.set_xticks(range(0,112,5))
#ax1.set_xticklabels(range(1901,2013,5))
#ax1.set_xlim([70,112])
#ax1.set_xticks(range(0,63,3))
#ax1.set_xticklabels(range(1948,2011,3))
#ax1.set_xlim([25,65])
ax1.set_xticks(range(1966,1996,4))
ax1.set_xlim([1966,1996])
ax1.plot((1965.5, 1965.5), (0, 120), 'k--',linewidth=3)
ax1.plot((1977.5, 1977.5), (0, 120), 'k--',linewidth=3)
ax1.plot((1979.5, 1979.5), (0, 120), 'k--',linewidth=3)

ax1.legend(["GPCC","CRU","PREC/L"],loc='upper left')
#ax2.legend(["Irrigation Water demand"],loc='upper right')

figname= (raw_input('figname? '))
#figname="rainy_day_precipAno"
if figname!="no":
	plt.savefig('/home/L.r02229011/fig/'+figname+'.png',bbox_inches=0)
	plt.savefig('/home/L.r02229011/fig/'+figname+'.pdf',bbox_inches=0)
plt.show()
