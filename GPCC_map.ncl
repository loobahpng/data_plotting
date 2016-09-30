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
    maskwhat="no"
  end if


    autolevs=0
    maxLevel=0.2
    minLevel=-0.2
    maxLevelTrend=2.
    minLevelTrend=-2.
    maxLevelBase=40.
    minLevelBase=0.
	month_abbr = (/"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"/)

	fils=systemfunc ("ls /work4/L.r02229011/GPCC/Full_Data_Reanalysis_V7/full_data_v7_05.nc")
	varname="p"

	fils=systemfunc ("ls /dadm1/obs/GPCP/mon/GPCP_V2.2_197901-201307.nc")
	varname="precip"

	print ("varname= "+varname)
	in=addfiles(fils,"r")
	ListSetType (in,"cat")
;===============
	lat = in[0]->lat
	lon = in[0]->lon
	print("*******************")
	print(ind(lat.eq.lat({26.33})))
	print(ind(lon.eq.lon({43.97})))
	print("grid cell at: "+lat({26.33})+", "+lon({43.97}))
	print("*******************")
;==================
	res	= True               ; plot mods desired
	res@cnFillOn	= True               ; turn on color fill
	res@cnLinesOn	= False              ; turn off contour lines
	res@gsnMaximize	= True
	res@gsnSpreadColors = False               ; use full range of color map
	res@cnFillPalette = "precip3_16lev"
	res@cnSpanFillPalette=True
	res@mpOutlineBoundarySets       = "National"
	res@mpDataSetName = "Earth..4"
	res@mpCountyLineThicknessF=2.0
	res@mpGeophysicalLineThicknessF =2.5
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
    res@gsnFrame=False
    res@gsnDraw=False
	res@cnLevelSelectionMode ="ManualLevels"
	res@cnMaxLevelValF  = 120.
	res@cnMinLevelValF  = 0.
	res@cnLevelSpacingF = (120.-0.)/20.

;	res@cnLevelSelectionMode="ExplicitLevels"
;	res@cnLevels=(/0,1,2,3,4,5,6,7/)+0.5
;	delete(res@cnFillPalette)
;	res@cnFillPalette = (/"white","red","orange","yellow","green","blue","purple","black"/)

	res@cnFillMode           = "RasterFill"
	do year=1970,2010
		res@gsnLeftString="GPCC precipitation "+year+"FMAM"
		Month=in[:]->$varname$((1991-1901)*12+(5-1),:,:)
		Month(:,:)=(in[:]->$varname$((year-1901)*12+(2-1),:,:)+in[:]->$varname$((year-1901)*12+(3-1),:,:)+in[:]->$varname$((year-1901)*12+(4-1),:,:)+in[:]->$varname$((year-1901)*12+(5-1),:,:))/4
		Month&lat@units="degrees_north"
		wks=gsn_open_wks("png","/home/L.r02229011/fig/GPCC_"+year+"FMAM")
		plot=gsn_csm_contour_map(wks,Month,res)
	;****************************
	; for plotting the block
	latstart=24
	latend=29
	lonstart=41
	lonend=47
	;----------
	;latstart=30
	;latend=45
	;lonstart=30
	;lonend=50
	;----------
	location=latstart+"-"+latend+"N "+lonstart+"-"+lonend+"E "
	ypts=(/latstart,latstart,latend,latend,latstart/)
	xpts=(/lonstart,lonend,lonend,lonstart,lonstart/)
	resp                  = True                      ; polyline mods desired
	resp@gsLineColor      = "red"                     ; color of lines
	resp@gsLineThicknessF = 4.0                       ; thickness of lines
	;****************
	  dum = new(4,graphic)  
	  do i = 0 , 3
		dum(i)=gsn_add_polyline(wks,plot,xpts(i:i+1),ypts(i:i+1),resp)      
	  end do 
	  draw(plot)
	  frame(wks)
	;********************************
	end do
;===============
	startyear=1970
	endyear=2010
	Var= in[:]->$varname$((startyear-1901)*12:(endyear-1901)*12+11,:,:)
	startyear2=1994
	endyear2=2010
	VarExp= in[:]->$varname$((startyear2-1901)*12:(endyear2-1901)*12+11,:,:)

	lat = in[0]->lat
	lon = in[0]->lon
	print("*******************")
	print(ind(lat.eq.lat({26.33})))
	print(ind(lon.eq.lon({43.97})))
	print("*******************")

	clat = cos(lat*4.0*atan(1.0)/180.0)  ; lat weight

;-------------mask
if (maskwhat.ne."no")then
    if (maskwhat.eq."IGP")then
      filsmask=systemfunc("ls /home/L.r02229011/irr/mask_2x2_IndusGanges.nc")
      inmask=addfiles(filsmask,"r")
     ListSetType(inmask,"cat")
      maskname="mask"
      Var=mask(Var,conform(Var,inmask[0]->$maskname$,(/1,2/)),1)
    end if
    if (maskwhat.eq."land") then
      filsmask=systemfunc("ls /work3/mlo/cesm1/archive/IRR_B_2000_CAM5/lnd/hist/IRR_B_2000_CAM5.clm2.h0.0101-02.nc")
      inmask=addfiles(filsmask,"r")
     ListSetType(inmask,"cat")
      maskname="landmask"
      Var=mask(Var,conform(Var,inmask[0]->$maskname$,(/1,2/)),0)
    end if
    if (maskwhat .eq."ocean")then
      filsmask=systemfunc("ls /work3/mlo/cesm1/archive/IRR_B_2000_CAM5/lnd/hist/IRR_B_2000_CAM5.clm2.h0.0101-02.nc")
      inmask=addfiles(filsmask,"r")
     ListSetType(inmask,"cat")
      maskname="landmask"
      Var=mask(Var,conform(Var,inmask[0]->$maskname$,(/1,2/)),1)
    end if
end if
;  0 for ocean  1 for land
;-------------------
;****************************
; for plotting the block
latstart=24
latend=29
lonstart=41
lonend=47
;----------
;latstart=30
;latend=45
;lonstart=30
;lonend=50
;----------
location=latstart+"-"+latend+"N "+lonstart+"-"+lonend+"E "
ypts=(/latstart,latstart,latend,latend,latstart/)
xpts=(/lonstart,lonend,lonend,lonstart,lonstart/)
  resp                  = True                      ; polyline mods desired
  resp@gsLineColor      = "red"                     ; color of lines
  resp@gsLineThicknessF = 4.0                       ; thickness of lines
;  resp@gsLineLabelString= "test"                    ; adds a line label string
;******************************
;************************************************
; create default plot
;************************************************

  if (plottype .eq. "map") then
    tavg=dim_avg_n_Wrap(Var(:,:,:),0) ;time avg
;    tavgAno=dim_avg_n_Wrap(VarAno(:,:,:),0)

;  gsn_define_colormap(wks,"BlWhRe")        ; choose colormap
;  gsn_define_colormap(wksExp,"BlWhRe")        ; choose colormap
;    gsn_define_colormap(wks,"BlAqGrYeOrRe")
;    gsn_define_colormap(wksExp,"BlAqGrYeOrRe")

    res	= True               ; plot mods desired
    res@cnFillOn	= True               ; turn on color fill
    res@cnLinesOn	= False              ; turn off contour lines
    res@gsnMaximize	= True
;    res@gsnSpreadColors       = True               ; use full range of color map
    res@cnFillPalette="BlAqGrYeOrRe"
;    res@mpOutlineBoundarySets       = "National"
;    res@mpDataSetName = "Earth..4"
;    res@mpCountyLineThicknessF=2.0
;    res@mpGeophysicalLineThicknessF =5.0
;    res@mpProjection="CylindricalEquidistant"
;********************
;res@mpPerimOn            = False
;res@mpGridAndLimbOn   = True
;res@mpGridLatSpacingF = 30.         
;res@mpGridLonSpacingF = 30.
;res@mpProjection = "Robinson"
;res@mpCenterLonF=150
;********************
if (res@mpProjection.ne."Robinson" )then
  res@cnFillMode           = "RasterFill"
end if

  res@cnLinesOn            = False   ; turn of contour lines

;    res@mpMinLatF       = 0
;    res@mpMaxLatF       = 60
;    res@mpMinLonF       = 60 
;    res@mpMaxLonF       = 120
;
;    res@mpMinLatF       = 0
;    res@mpMaxLatF       = 50
;    res@mpMinLonF       = 20
;    res@mpMaxLonF       = 70

;********************
    res@gsnSpreadColors       = False               ; use full range of color map
    res@cnFillPalette = "temp_19lev"
    res@cnFillPalette = "GMT_gebco"
    res@cnFillPalette = "MPL_RdBu"
    res@cnSpanFillPalette=True
    res@cnLevelSelectionMode ="ManualLevels"
;    wksExp=gsn_open_wks("png","fig/"+varname+"_ano_"+plottype)
;    tavgExp(:,:)=tavgExp(:,:)-tavg(:,:)
;    tavgExp=mask(tavgExp,tavgExp.lt.0.5 .and. tavgExp.gt.-0.5,False)
;    if (autolevs.eq.1 )then
;	symMinMaxPlt(tavgExp,20,False,res)
;    end if
;    plotExp= gsn_csm_contour_map(wksExp,tavgExp,res)
;***************************
vdim=dimsizes(Var)
t=reshape(Var,(/endyear-startyear+1,12,vdim(1),vdim(2)/))
tExp=reshape(VarExp,(/endyear2-startyear2+1,12,vdim(1),vdim(2)/))
printVarSummary(t)
sleep(5)
map=new((/12,vdim(1),vdim(2)/),"double")
map=dim_avg_n_Wrap(t,0)
mapExp=new((/12,vdim(1),vdim(2)/),"double")
mapExp=dim_avg_n_Wrap(tExp,0)

month_plot=1
diff=new((/vdim(1),vdim(2)/),"double")
diff!0="latitude"
diff!1="longitude"
diff&latitude=lat
diff&longitude=lon
diff@long_name=startyear2+"to"+endyear2+"-"+startyear+"to"+endyear
diff&latitude@units="degrees_north"
diff&longitude@units="degrees_east"


res@cnLevelSelectionMode ="ManualLevels"
res@cnMaxLevelValF  = maxLevelBase
res@cnMinLevelValF  = 0.
res@cnLevelSpacingF = (maxLevelBase-0.)/20.
res@cnFillPalette = "precip3_16lev"
res@gsnLeftString="GPCC FMAM precipitation 1970 to 2010"
diff(:,:)=(/dim_avg_n_Wrap(map((/1,2,3,4/),:,:),0)/)
wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_FMAM_period_1")
plot=gsn_csm_contour_map(wksMonth,diff,res)
;****************
dum = new(4,graphic)  
do i = 0 , 3
dum(i)=gsn_add_polyline(wksMonth,plot,xpts(i:i+1),ypts(i:i+1),resp)      
end do 
draw(plot)
frame(wksMonth)
;********************************

res@cnLevelSelectionMode ="ManualLevels"
res@cnMaxLevelValF  =maxLevelBase 
res@cnMinLevelValF  = 0.
res@cnLevelSpacingF = (maxLevelBase-0.)/20.
res@cnFillPalette = "precip3_16lev"
res@gsnLeftString="GPCC FMAM precipitation 1994 to 2010"
diff(:,:)=(/dim_avg_n_Wrap(mapExp((/1,2,3,4/),:,:),0)/)
wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_FMAM_period_2")
plot=gsn_csm_contour_map(wksMonth,diff,res)
;****************
dum = new(4,graphic)  
do i = 0 , 3
dum(i)=gsn_add_polyline(wksMonth,plot,xpts(i:i+1),ypts(i:i+1),resp)      
end do 
draw(plot)
frame(wksMonth)
;********************************

res@cnLevelSelectionMode ="ManualLevels"
res@cnMaxLevelValF  = 20.
res@cnMinLevelValF  = -20.
res@cnLevelSpacingF = (20.+20.)/20.
res@cnFillPalette = "precip4_diff_19lev"
res@gsnLeftString="GPCC FMAM precipitation Differences"
diff(:,:)=(/dim_avg_n_Wrap(mapExp((/1,2,3,4/),:,:),0)-dim_avg_n_Wrap(map((/1,2,3,4/),:,:),0)/)
wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_FMAM_diff")
plot=gsn_csm_contour_map(wksMonth,diff,res)
;****************
dum = new(4,graphic)  
do i = 0 , 3
dum(i)=gsn_add_polyline(wksMonth,plot,xpts(i:i+1),ypts(i:i+1),resp)      
end do 
draw(plot)
frame(wksMonth)
;********************************
res@cnLevelSelectionMode ="ManualLevels"
res@cnMaxLevelValF  = 1.
res@cnMinLevelValF  = -1.
res@cnLevelSpacingF = (1.+1.)/20.
res@cnFillPalette = "precip4_diff_19lev"
temp=where(dim_avg_n_Wrap(map((/1,2,3,4/),:,:),0).gt.0,dim_avg_n_Wrap(map((/1,2,3,4/),:,:),0),map@_FillValue)
diff(:,:)=(dim_avg_n_Wrap(mapExp((/1,2,3,4/),:,:),0)-dim_avg_n_Wrap(map((/1,2,3,4/),:,:),0))/temp
wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_FMAM_diff_ratio")
plot=gsn_csm_contour_map(wksMonth,diff,res)
;****************
dum = new(4,graphic)  
do i = 0 , 3
dum(i)=gsn_add_polyline(wksMonth,plot,xpts(i:i+1),ypts(i:i+1),resp)      
end do 
draw(plot)
frame(wksMonth)
;********************************
;**************
res@cnLevelSelectionMode ="ManualLevels"
res@cnMaxLevelValF  = maxLevelBase
res@cnMinLevelValF  = 0.
res@cnLevelSpacingF = (maxLevelBase-0.)/20.
res@cnFillPalette = "precip3_16lev"
diff(:,:)=(/dim_avg_n_Wrap(map((/0,1,2,3,10,11/),:,:),0)/)
wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_wet_period_1")
plot=gsn_csm_contour_map(wksMonth,diff,res)

res@cnLevelSelectionMode ="ManualLevels"
res@cnMaxLevelValF  =maxLevelBase 
res@cnMinLevelValF  = 0.
res@cnLevelSpacingF = (maxLevelBase-0.)/20.
res@cnFillPalette = "precip3_16lev"
diff(:,:)=(/dim_avg_n_Wrap(mapExp((/0,1,2,3,10,11/),:,:),0)/)
wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_wet_period_2")
plot=gsn_csm_contour_map(wksMonth,diff,res)

res@cnLevelSelectionMode ="ManualLevels"
res@cnMaxLevelValF  = 20.
res@cnMinLevelValF  = -20.
res@cnLevelSpacingF = (20.+20.)/20.
res@cnFillPalette = "precip4_diff_19lev"
diff(:,:)=(/dim_avg_n_Wrap(mapExp((/0,1,2,3,10,11/),:,:),0)-dim_avg_n_Wrap(map((/0,1,2,3,10,11/),:,:),0)/)
wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_wet_diff")
plot=gsn_csm_contour_map(wksMonth,diff,res)

res@cnLevelSelectionMode ="ManualLevels"
res@cnMaxLevelValF  = 1.
res@cnMinLevelValF  = -1.
res@cnLevelSpacingF = (1.+1.)/20.
res@cnFillPalette = "precip4_diff_19lev"
temp=where(dim_avg_n_Wrap(map((/0,1,2,3,10,11/),:,:),0).gt.0,dim_avg_n_Wrap(map((/0,1,2,3,10,11/),:,:),0),map@_FillValue)
diff(:,:)=(dim_avg_n_Wrap(mapExp((/0,1,2,3,10,11/),:,:),0)-dim_avg_n_Wrap(map((/0,1,2,3,10,11/),:,:),0))/temp
wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_wet_diff_ratio")
plot=gsn_csm_contour_map(wksMonth,diff,res)

res@cnLevelSelectionMode ="ManualLevels"
res@cnMaxLevelValF  = maxLevelBase
res@cnMinLevelValF  = 0.
res@cnLevelSpacingF = (maxLevelBase-0.)/20.
res@cnFillPalette = "precip3_16lev"
diff(:,:)=(/dim_avg_n_Wrap(map((/5,6,7,8/),:,:),0)/)
wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_dry_period_1")
plot=gsn_csm_contour_map(wksMonth,diff,res)

res@cnLevelSelectionMode ="ManualLevels"
res@cnMaxLevelValF  = maxLevelBase
res@cnMinLevelValF  = 0.
res@cnLevelSpacingF = (maxLevelBase-0.)/20.
res@cnFillPalette = "precip3_16lev"
diff(:,:)=(/dim_avg_n_Wrap(mapExp((/5,6,7,8/),:,:),0)/)
wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_dry_period_2")
plot=gsn_csm_contour_map(wksMonth,diff,res)

res@cnLevelSelectionMode ="ManualLevels"
res@cnMaxLevelValF  = 10.
res@cnMinLevelValF  = -10.
res@cnLevelSpacingF = (10.+10.)/20.
res@cnFillPalette = "precip4_diff_19lev"
diff(:,:)=(/dim_avg_n_Wrap(mapExp((/5,6,7,8/),:,:),0)-dim_avg_n_Wrap(map((/5,6,7,8/),:,:),0)/)
wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_dry_diff")
plot=gsn_csm_contour_map(wksMonth,diff,res)

res@cnMaxLevelValF  = 1.
res@cnMinLevelValF  = -1.
res@cnLevelSpacingF = (1.+1.)/20.
res@cnFillPalette = "precip4_diff_19lev"
temp=where(dim_avg_n_Wrap(map((/5,6,7,8/),:,:),0).gt.0,dim_avg_n_Wrap(map((/5,6,7,8/),:,:),0),map@_FillValue)
diff(:,:)=(dim_avg_n_Wrap(mapExp((/5,6,7,8/),:,:),0)-dim_avg_n_Wrap(map((/5,6,7,8/),:,:),0))/temp
wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_dry_diff_ratio")
plot=gsn_csm_contour_map(wksMonth,diff,res)

do while (month_plot .le. 12)
    res@cnLevelSelectionMode ="ManualLevels"
    res@cnMaxLevelValF  = maxLevelBase
    res@cnMinLevelValF  = 0.
    res@cnLevelSpacingF = (maxLevelBase-0.)/20.
    res@cnFillPalette = "precip3_16lev"
    res@gsnFrame=False
    res@gsnDraw=False
    diff(:,:)=(/map(month_plot-1,:,:)/)
    wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_"+month_plot+"period_1")
    plot=gsn_csm_contour_map(wksMonth,diff,res)
        ;****************
          dum = new(4,graphic)  
          do i = 0 , 3
            dum(i)=gsn_add_polyline(wksMonth,plot,xpts(i:i+1),ypts(i:i+1),resp)      
          end do 
          draw(plot)
          frame(wksMonth)
        ;********************************

    diff(:,:)=(/mapExp(month_plot-1,:,:)/)
    wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_"+month_plot+"period_2")
    plot=gsn_csm_contour_map(wksMonth,diff,res)
        ;****************
          dum = new(4,graphic)  
          do i = 0 , 3
            dum(i)=gsn_add_polyline(wksMonth,plot,xpts(i:i+1),ypts(i:i+1),resp)      
          end do 
          draw(plot)
          frame(wksMonth)
        ;********************************

    diff(:,:)=mapExp(month_plot-1,:,:)-map(month_plot-1,:,:)
    res@cnLevelSelectionMode ="ManualLevels"
    res@cnMaxLevelValF  = 25.
    res@cnMinLevelValF  = -25.
    res@cnLevelSpacingF = (25.+25.)/20.
    res@cnFillPalette = "precip4_diff_19lev"
    wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_"+month_plot+"period_diff")
    plot=gsn_csm_contour_map(wksMonth,diff,res)
        ;****************
          dum = new(4,graphic)  
          do i = 0 , 3
            dum(i)=gsn_add_polyline(wksMonth,plot,xpts(i:i+1),ypts(i:i+1),resp)      
          end do 
          draw(plot)
          frame(wksMonth)
        ;********************************

    temp=where(map(month_plot-1,:,:).gt.0,map(month_plot-1,:,:),map@_FillValue)
    diff(:,:)=(mapExp(month_plot-1,:,:)-map(month_plot-1,:,:))/temp
    res@cnLevelSelectionMode ="ManualLevels"
    res@cnMaxLevelValF  = 2.
    res@cnMinLevelValF  = -2.
    res@cnLevelSpacingF = (2.+2.)/20.
    res@cnFillPalette = "precip4_diff_19lev"
    wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/GPCC"+"_"+month_plot+"period_diff_ratio")
    plot=gsn_csm_contour_map(wksMonth,diff,res)
        ;****************
          dum = new(4,graphic)  
          do i = 0 , 3
            dum(i)=gsn_add_polyline(wksMonth,plot,xpts(i:i+1),ypts(i:i+1),resp)      
          end do 
          draw(plot)
          frame(wksMonth)
        ;********************************

    month_plot=month_plot+1
end do
clat!0="lat"
clat&lat=lat
print("file= "+varname+"_"+plottype)
end if
end
