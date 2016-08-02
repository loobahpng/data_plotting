;
;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
;************************************************
; create pointer to file and read in data
;************************************************

  if(.not.isvar("plottype")) then
    plottype="map"
  end if
  month_abbr = (/"1_Jan","2_Feb","3_Mar","4_Apr","5_May","6_Jun","7_Jul","8_Aug","9_Sep","10_Oct","11_Nov","12_Dec"/)
    varname="elevation"
    autolevsCli=0
    minLevelCli=0
    maxLevelCli=1000
	fils=systemfunc ("ls /work4/L.r02229011/GMTED2010_15n030_0125deg.nc")
	in=addfiles(fils,"r")
	ListSetType (in,"join")
	;  Var= short2flt(in[:]->$varname$)
	Var=short2flt(in[:]->$varname$)
;-------------mask
;  filsmask=systemfunc("ls /work3/mlo/cesm1/archive/IRR_B_2000_CAM5/lnd/hist/IRR_B_2000_CAM5.clm2.h0.0101-02.nc")
;;  filsmask=systemfunc("ls /home/L.r02229011/irr/mask_2x2_IndusGanges.nc")
;  inmask=addfiles(filsmask,"r")
;  ListSetType(inmask,"cat")
;  maskname="landmask"
;  Var=mask(Var,conform(Var,inmask[0]->$maskname$,(/1,2/)),1);+in[:]->SWCF(:,:,:)
;-------------------
	lat = in[0]->latitude
	lon = in[0]->longitude
;	lat@units="degrees_north"
;	lon@units="degrees_east"
	Var!0="lat"
	Var!1="lon"
	delete(Var&lat)
	delete(Var&lon)
	Var&lat=lat
	Var&lon=lon
	printVarSummary(Var)
;	Var@_FillValue=999
	clat = cos(in[0]->latitude*4.0*atan(1.0)/180.0)  ; lat weight
;************************************************
; create default plot
;************************************************
  if (plottype .eq. "map") then
    wks = gsn_open_wks("png","fig/"+varname+"_ctrl_"+plottype)  ; open a wks
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

	latstart=24
	latend=29
	lonstart=41
	lonend=46
    res@mpMinLatF       = latstart
    res@mpMaxLatF       = latend
    res@mpMinLonF       = lonstart
    res@mpMaxLonF       = lonend
    res@cnFillMode           = "RasterFill"

;***************
;	res@mpProjection="LambertConformal"
;	res@mpLambertParallel1F = 30.0         ; two parallels
;	res@mpLambertParallel2F = 60.0
;	res@mpLambertMeridianF  = 40.0        ; central meridian
;	res@mpLimitMode         = "Corners"
;	res@mpLeftCornerLatF           =   14.6026     ; map area
;	res@mpLeftCornerLonF           = 32.0755       ; and
;	res@mpRightCornerLatF           = 36.5432       ; latitudes
;	res@mpRightCornerLonF           = 60.1822        ; longitudes
;	res@mpDataBaseVersion="MediumRes"
;	res@mpGridAndLimbOn=True
;	res@mpGridLineThicknessF        = 0.5
;	res@mpGridSpacingF              = 5
;	res@mpLimbLineColor             = "Gray"
;	res@mpLimbLineThicknessF        = 0.5
;	res@mpNationalLineColor         = "Gray"
;	res@mpNationalLineThicknessF    = 0.5
;	res@mpPerimLineColor            = "Gray"
;	res@mpPerimOn                   = True
;	res@mpUSStateLineColor          = "Gray"
;	res@mpUSStateLineThicknessF     = 0.5
;	res@pmTickMarkDisplayMode       = "Always"
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
	wksMonth=gsn_open_wks("png","fig/elevation_zoom")
	plotMonth=gsn_csm_contour_map(wksMonth,Var(:,:),res)
    pmres = True
    pmres@gsMarkerColor = "Black"
    pmres@gsMarkerIndex = 16
    pmres@gsMarkerSizeF = 0.01
    plotstn=gsn_add_polymarker(wksMonth,plotMonth,43.97,26.33,pmres)
	;****************************
	; for plotting the block
;	location=latstart+"-"+latend+"N "+lonstart+"-"+lonend+"E "
;	ypts=(/latstart,latstart,latend,latend,latstart/)
;	xpts=(/lonstart,lonend,lonend,lonstart,lonstart/)
;	resp                  = True                      ; polyline mods desired
;	resp@gsLineColor      = "red"                     ; color of lines
;	resp@gsLineThicknessF = 4.0                       ; thickness of lines
;	;****************
;	  dum = new(4,graphic)  
;	  do i = 0 , 3
;		dum(i)=gsn_add_polyline(wksMonth,plotMonth,xpts(i:i+1),ypts(i:i+1),resp)      
;	  end do 
	;********************************
    draw(plotMonth)
    frame(wksMonth)
;    print(month_abbr(month_plot)+" ok")
;    month_plot=month_plot+1
;    end do
  end if
  print("file= "+varname+"_"+plottype)
end
