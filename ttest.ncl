
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
;************
x=(/ 0. ,  0.1 , 0.2 , 0.3,  0.4,  0.5,  0.6,  0.7,  0.8,  0.9/)
y=(/  0. , 10.,  20.,  30.,  40.,  50.,  60.,  70.,  80.,  90./)
xavg=dim_avg_n_Wrap(x,0)
yavg=dim_avg_n_Wrap(y,0)
xvar=   dim_variance_n_Wrap(x,0)
yvar=   dim_variance_n_Wrap(y,0)
sX=dimsizes(x)
sY=dimsizes(y)
iflag=True
p = ttest(xavg,xvar,sX,yavg,yvar,sY, iflag, False)
print(p)
end
