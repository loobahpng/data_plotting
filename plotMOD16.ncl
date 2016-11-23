;
;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
plottype="map"
;************************************************
; create pointer to file and read in data
;************************************************
lambert=0
regional=1
month_abbr = (/"_1_Jan_","_2_Feb_","_3_Mar_","_4_Apr_","_5_May_","_6_Jun_","_7_Jul_","_8_Aug_","_9_Sep_","_10_Oct_","_11_Nov_","_12_Dec_"/)

varname="Band1"

do mm=5,5
;do yy=2003,2015
	fils=new(1,"string")
	do	yy=2001,2001
		fils((yy-2001))=systemfunc ("ls /work4/L.r02229011/MODIS/MOD16A2_LE_0.05deg_GEO/*"+yy+"*.nc |head -n "+mm+"|tail -n 1")
	end do
	print(fils)
	;	fils=systemfunc("ls /work4/L.r02229011/MODIS/MYD13C2.005/*A"+yy+"*.hdf |head -n 5|tail -n 1")
	;	print(fils)
	in=addfiles(fils,"r")
	ListSetType (in,"join")
;	Var= dim_avg_n_Wrap((in[:]->$varname$),0)
	Var=where(in[:]->Band1.lt.32000,in[:]->Band1,9.96921e+36)
	Var@_FillValue=-9999
	Var(:,:)=Var(:,:)*1.0e4

	printVarSummary(Var)
	autolevsCli=0
	minLevelCli=0
	maxLevelCli=50
;-------------mask
;  filsmask=systemfunc("ls /work3/mlo/cesm1/archive/IRR_B_2000_CAM5/lnd/hist/IRR_B_2000_CAM5.clm2.h0.0101-02.nc")
;;  filsmask=systemfunc("ls /home/L.r02229011/irr/mask_2x2_IndusGanges.nc")
;  inmask=addfiles(filsmask,"r")
;  ListSetType(inmask,"cat")
;  maskname="landmask"
;  Var=mask(Var,conform(Var,inmask[0]->$maskname$,(/1,2/)),1);+in[:]->SWCF(:,:,:)
;-------------------
	lat = fspan(80.,-60.,2800)
	lon = fspan(-180.,180.,7200)
	lat@units="degrees_north"
	lon@units="degrees_east"
	Var!0="lat"
	Var!1="lon"
	Var&lat=lat
	Var&lon=lon
	printVarSummary(Var)
	clat = cos(lat*4.0*atan(1.0)/180.0)  ; lat weight
;************************************************
; create default plot
;************************************************
  if (plottype .eq. "map") then
    wks = gsn_open_wks("png","/home/L.r02229011/fig/"+varname+"_ctrl_"+plottype)  ; open a wks
    res	= True               ; plot mods desired
    res@cnFillOn	= True               ; turn on color fill
    res@cnLinesOn	= False              ; turn off contour lines
    res@gsnMaximize	= True
;    res@gsnSpreadColors       = True               ; use full range of color map
    res@cnFillPalette="BlAqGrYeOrRe"
    res@mpOutlineBoundarySets       = "National"
    res@mpDataSetName = "Earth..4"
    res@mpCountyLineThicknessF=2.0
    res@mpGeophysicalLineThicknessF =2.5
    res@cnFillMode           = "RasterFill"
;***********Qaseem
	latstart=24
	latend=29
	lonstart=41
	lonend=46
;****************
	latstart=25
	latend=27
	lonstart=43
	lonend=45

;*****Kansas
;	latstart=35
;	latend=40
;	lonstart=-100
;	lonend=-95
;************

;*****California
;	latstart=30
;	latend=35
;	lonstart=-115
;	lonend=-110
;************
if regional.eq.1 then
    res@mpMinLatF       = latstart
    res@mpMaxLatF       = latend
    res@mpMinLonF       = lonstart
    res@mpMaxLonF       = lonend
end if
;***************
if lambert.eq.1 then
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

end if
;**********************
res@trGridType="TriangularMesh"

    if (autolevsCli.eq.0)then
	res@cnLevelSelectionMode ="ManualLevels"
	res@cnMaxLevelValF  = maxLevelCli
	res@cnMinLevelValF  = minLevelCli
	res@cnLevelSpacingF = (maxLevelCli-minLevelCli)/20.
    end if
;    res@cnLevelSelectionMode ="ManualLevels"
;    maxLevel=2.;104000.
;    minLevel=-2.;98400.
;    res@cnMaxLevelValF  = maxLevel
;    res@cnMinLevelValF  = minLevel
;    res@cnLevelSpacingF = (maxLevel-minLevel)/20.

    ;symMinMaxPlt(tavg,20,False,res)
    res@gsnDraw=False
    res@gsnFrame=False
    if (varname.eq."CMG_0_05_Deg_Monthly_EVI")then
      res@gsnLeftString="EVI"
    end if
    if (varname.eq."CMG_0_05_Deg_Monthly_NDVI")then
      res@gsnLeftString="NDVI"
    end if
    if (varname.eq."LST_Day_CMG")then
      res@gsnLeftString="Land Surf Temp"
    end if
;    plot = gsn_csm_contour_map(wks,Var,res)     
;  pmres = True
;  pmres@gsMarkerColor = "Black"
;  pmres@gsMarkerIndex = 16
;  pmres@gsMarkerSizeF = 0.01
;  plotstn=gsn_add_polymarker(wks,plot,43.97,26.33,pmres)
;draw(plot)
;frame(wks)

;******seasonal climatology
;    VarClima=clmMonTLL(Var(:,:,:))
;    DJF=dim_avg_n_Wrap(VarClima((/11,0,1/),:,:),0)
;    JFM=dim_avg_n_Wrap(VarClima((/0,1,2/),:,:),0)
;    JJA=dim_avg_n_Wrap(VarClima((/5,6,7/),:,:),0)
;    MAM=dim_avg_n_Wrap(VarClima((/2,3,4/),:,:),0)
;    SON=dim_avg_n_Wrap(VarClima((/8,9,10/),:,:),0)
;    DJF@long_name=DJF@long_name+" DJF"
;    JFM@long_name=JFM@long_name+" JFM"
;    JJA@long_name=JJA@long_name+" JJA"
;    MAM@long_name=MAM@long_name+" MAM"
;    SON@long_name=SON@long_name+" SON"
;    wksDJF= gsn_open_wks("png","fig/"+varname+"_DJF_"+plottype)
;    wksJFM= gsn_open_wks("png","fig/"+varname+"_JFM_"+plottype)
;    wksJJA= gsn_open_wks("png","fig/"+varname+"_JJA_"+plottype)
;    wksMAM= gsn_open_wks("png","fig/"+varname+"_MAM_"+plottype)
;    wksSON= gsn_open_wks("png","fig/"+varname+"_SON_"+plottype)
;    plotDJF=gsn_csm_contour_map(wksDJF,DJF,res)
;    plotJFM=gsn_csm_contour_map(wksJFM,JFM,res)
;    plotJJA=gsn_csm_contour_map(wksJJA,JJA,res)
;    plotMAM=gsn_csm_contour_map(wksMAM,MAM,res)
;    plotSON=gsn_csm_contour_map(wksSON,SON,res)
;    month_plot=0
;    do while (month_plot .le. 11)
;	wksMonth= gsn_open_wks("png","fig/"+varname+"_"+month_abbr(month_plot))
	;symMinMaxPlt(VarClima(month_plot,:,:)*plotscale,20,False,res)
;	plotMonth=gsn_csm_contour_map(wksMonth,VarClima(month_plot,:,:),res)
	print("wksMonth")
	wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/MODIS"+month_abbr(mm-1)+varname+"_r_2003-2015")
	print("plotMonth")
	res@gsnAddCyclic = False
	plotMonth=gsn_csm_contour_map(wksMonth,Var,res)

	print("*****")
	Var1d=ndtooned(Var)
	print(ind(Var1d.gt.100))
	print("*****")

	print("plot ok")
    pmres = True
    pmres@gsMarkerColor = "Black"
    pmres@gsMarkerIndex = 16
    pmres@gsMarkerSizeF = 0.01
	print("plotstn")
    plotstn=gsn_add_polymarker(wksMonth,plotMonth,43.97,26.33,pmres)
	;****************************
	; for plotting the block
	location=latstart+"-"+latend+"N "+lonstart+"-"+lonend+"E "
	ypts=(/latstart,latstart,latend,latend,latstart/)
	xpts=(/lonstart,lonend,lonend,lonstart,lonstart/)
	resp                  = True                      ; polyline mods desired
	resp@gsLineColor      = "red"                     ; color of lines
	resp@gsLineThicknessF = 4.0                       ; thickness of lines
	;****************
	  dum = new(4,graphic)  
	  do i = 0 , 3
		dum(i)=gsn_add_polyline(wksMonth,plotMonth,xpts(i:i+1),ypts(i:i+1),resp)      
	  end do 
	;********************************
	print("draw")
    draw(plotMonth)
	print("frame")
    frame(wksMonth)
;    print(month_abbr(month_plot)+" ok")
;    month_plot=month_plot+1
;    end do
  end if
  print("file= "+varname+"_"+plottype)
;end do ; yy
end do ; mm
end
