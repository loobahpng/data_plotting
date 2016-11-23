
;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
    ECvarname="u"
    level=850

    autolevs=0
    maxLevel=5.
    minLevel=-5.

    in_EC=addfiles(systemfunc("ls /dadm1/reanalysis/ECMWF/ITM/0.75/mon/SFC/ERA_Interim*.nc"),"r")
    in_EC_PRS=addfiles(systemfunc("ls /dadm1/reanalysis/ECMWF/ITM/0.75/mon/PRS/ERA_Interim*.nc"),"r")
    ListSetType(in_EC,"cat")
    ListSetType(in_EC_PRS,"cat")

    startlat=-5.
    endlat=5.
    startlon=190.
    endlon=240.
;**************** area average

;    print("lat "+in_EC[0]->latitude({startlat:endlat}))
;    print("lon "+in_EC[0]->longitude({startlon:endlon}))
if (level.eq.0)then
    Var=short2flt(in_EC[:]->$ECvarname$)
    do i=1979,2012
		fil    = "/dadm1/reanalysis/ECMWF/ITM/0.75/mon/SFC/ERA_Interim_SFC_"+i+"_mon.nc"
		F      = addfile(fil,"r")
		Var((i-1979)*12:(i-1979)*12+11,:,:)=short2flt(F->$ECvarname$)
    end do
end if

if (level .ne. 0) then
    Var=short2flt(in_EC_PRS[:]->$ECvarname$(:,{level},:,:))
    do i=1979,2012
		fil    = "/dadm1/reanalysis/ECMWF/ITM/0.75/mon/PRS/ERA_Interim_PRS_"+i+"_mon.nc"
		F      = addfile(fil,"r")
		Var((i-1979)*12:(i-1979)*12+11,:,:)=short2flt(F->$ECvarname$(:,{level},:,:))
    end do
end if

    Vartimeseries=new((/12,34,241,480/),"float")
    monthes=408-1
    Vartimeseries(0,:,:,:)=Var(0:monthes:12,:,:)
    Vartimeseries(1,:,:,:)=Var(1:monthes:12,:,:)
    Vartimeseries(2,:,:,:)=Var(2:monthes:12,:,:)
    Vartimeseries(3,:,:,:)=Var(3:monthes:12,:,:)
    Vartimeseries(4,:,:,:)=Var(4:monthes:12,:,:)
    Vartimeseries(5,:,:,:)=Var(5:monthes:12,:,:)
    Vartimeseries(6,:,:,:)=Var(6:monthes:12,:,:)
    Vartimeseries(7,:,:,:)=Var(7:monthes:12,:,:)
    Vartimeseries(8,:,:,:)=Var(8:monthes:12,:,:)
    Vartimeseries(9,:,:,:)=Var(9:monthes:12,:,:)
    Vartimeseries(10,:,:,:)=Var(10:monthes:12,:,:)
    Vartimeseries(11,:,:,:)=Var(11:monthes:12,:,:)

    clat = cos(in_EC[0]->latitude*4.0*atan(1.0)/180.0)
    clat!0="lat"
    clat&lat=in_EC[0]->latitude

    t2Exp=Vartimeseries(1,:,:,:); dimension trick
    t2Exp(:,:,:)=(Vartimeseries(2,:,:,:)+Vartimeseries(3,:,:,:)+Vartimeseries(4,:,:,:)+Vartimeseries(1,:,:,:))/4
    VarClima= dim_avg_n_Wrap(t2Exp,0)
;	if ECvarname.eq."z"then
;		VarClima(:,:)=VarClima(:,:)/9.8
;	end if
;------------    
    VarClima!0="lat"
    VarClima&lat=t2Exp&latitude
    VarClima!1="lon"
    VarClima&lon=t2Exp&longitude
;-----------
    t2Exptemp=t2Exp(latitude|:,longitude|:,time|:)
    delete(t2Exp)
    t2Exp=t2Exptemp
    delete(t2Exptemp)
    vdim=dimsizes(Var)
    res	= True               ; plot mods desired
    res@cnFillOn	= True               ; turn on color fill
    res@cnLinesOn	= False              ; turn off contour lines
    res@gsnMaximize	= True
    res@gsnSpreadColors       = True               ; use full range of color map
    res@mpOutlineBoundarySets       = "National"
    res@mpDataSetName = "Earth..4"
    res@mpCountyLineThicknessF=2.0
;res@mpPerimOn            = False
;res@mpGridAndLimbOn   = True
;res@mpGridLatSpacingF = 30.
;res@mpGridLonSpacingF = 30.
;res@mpProjection = "Robinson"
;res@mpCenterLonF=150

    res@mpOutlineBoundarySets       = "National"
    res@mpDataSetName = "Earth..4"
    res@mpCountyLineThicknessF=2.0
    res@mpGeophysicalLineThicknessF =5.
    res@mpProjection="LambertConformal"
    res@mpLambertParallel1F = 30.0         ; two parallels
    res@mpLambertParallel2F = 60.0
    res@mpLambertMeridianF  = 40.0        ; central meridian
    res@mpLimitMode         = "Corners"
    res@mpLeftCornerLatF           =   14.6026     ; map area
    res@mpLeftCornerLonF           = 32.0755       ; and
    res@mpRightCornerLatF           = 36.5432       ; latitudes
    res@mpRightCornerLonF           = 60.1822        ; longitudes
    res@mpDataBaseVersion="MediumRes"
    res@mpGridAndLimbOn=True
    res@mpGridLineThicknessF        = 0.5
    res@mpGridSpacingF              = 5
    res@mpLimbLineColor             = "Gray"
    res@mpLimbLineThicknessF        = 0.5
    res@mpNationalLineColor         = "Gray"
    res@mpNationalLineThicknessF    = 0.5
    res@mpPerimLineColor            = "Gray"
    res@mpPerimOn                   = True
    res@mpUSStateLineColor          = "Gray"
    res@mpUSStateLineThicknessF     = 0.5
    res@pmTickMarkDisplayMode       = "Always"


    res@mpOutlineBoundarySets       = "National"
    res@mpNationalLineThicknessF=1.
    res@mpNationalLineColor = "Black"

	res@gsnSpreadColors       = False               ; use full range of color map
	res@cnFillPalette = "precip4_diff_19lev"
	res@cnFillPalette = "BlueDarkOrange18"
	res@cnFillPalette = "temp_19lev"
	res@cnFillPalette = "BlWhRe"
	res@cnFillPalette = "MPL_RdBu"
	res@cnSpanFillPalette=True
        res@lbLabelFontHeightF=.02
;    month_plot=0
;    do while(month_plot.ne.12)

    wks=gsn_open_wks("png","/home/L.r02229011/fig/climatology_"+ECvarname)
    gsn_define_colormap(wks,"BlAqGrYeOrRe")
;    symMinMaxPlt(VarClima,20,False,res)

;	month_plot=month_plot+1
;    end do
    if (autolevs.eq.0)then
		res@cnLevelSelectionMode ="ManualLevels"
		res@cnMaxLevelValF  = maxLevel
		res@cnMinLevelValF  = minLevel
		res@cnLevelSpacingF = (maxLevel-minLevel)/20.
    end if
	if (ECvarname.eq."sstk".or.ECvarname.eq."t2m")then
		res@cnFillPalette = "temp_19lev"
	end if
	if (autolevs.eq.1) then
	;	symMinMaxPlt(VarClima,20,False,res)
	end if
    plot=gsn_csm_contour_map(wks,VarClima,res)
;***************
end
