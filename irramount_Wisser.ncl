load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin
Var=new((/1224,360,720/),"float")
dataset="Wisser"
fils=systemfunc("ls /work/mlo/proc/obsirriwater/Dominik_irriWater/*.asc")
do itime=0,1223
    x1=asciiread(fils(itime) , -1, "float")
	varname="Irrigation (Wisser)"
	Var(itime,:,:)=onedtond(x1(6:),(/360,720/))
end do
Var@long_name="irrigation"
Var@units=""
lon=fspan(-180,180,720)
lat=fspan(90,-90,360)
Var@_FillValue=-9999.
Var!2="longitude"
Var!1="latitude"
Var&longitude=lon
Var&latitude=lat
Var&latitude@units="degrees_north"
Var&longitude@units="degrees_east"
VarClima=clmMonTLL(Var(1104:1223,:,:))
;****************************
; for plotting the block
latstart=24
latend=29
lonstart=41
lonend=47
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
    wks = gsn_open_wks("png","/home/L.r02229011/fig/"+dataset)      ; open a wks
    wksDJF=gsn_open_wks("png","/home/L.r02229011/fig/"+dataset+"_DJF")
    wksJFM=gsn_open_wks("png","/home/L.r02229011/fig/"+dataset+"_JFM")
    wksMAM=gsn_open_wks("png","/home/L.r02229011/fig/"+dataset+"_MAM")
    wksJJA=gsn_open_wks("png","/home/L.r02229011/fig/"+dataset+"_JJA")
    wksSON=gsn_open_wks("png","/home/L.r02229011/fig/"+dataset+"_SON")

;    gsn_define_colormap(wks,"BlAqGrYeOrRe")        ; choose colormap
;    gsn_define_colormap(wksDJF,"BlAqGrYeOrRe")        ; choose colormap
;    gsn_define_colormap(wksMAM,"BlAqGrYeOrRe")        ; choose colormap
;    gsn_define_colormap(wksSON,"BlAqGrYeOrRe")        ; choose colormap
;    gsn_define_colormap(wksJJA,"BlAqGrYeOrRe")        ; choose colormap
;    gsn_define_colormap(wks,"WhiteBlue")        ; choose colormap
    ;gsn_define_colormap(wksDJF,"WhiteBlue")        ; choose colormap
    ;gsn_define_colormap(wksMAM,"WhiteBlue")        ; choose colormap
    ;gsn_define_colormap(wksSON,"WhiteBlue")        ; choose colormap
    ;gsn_define_colormap(wksJJA,"WhiteBlue")        ; choose colormap
    res                = True               ; plot mods desired
    res@gsnDraw   = False                             ; don't draw yet
    res@gsnFrame  = False                             ; don't advance yet
    res@cnFillOn	= True               ; turn on color fill
    res@cnLinesOn	= False              ; turn off contour lines
    res@gsnMaximize	= True
;    res@gsnSpreadColors       = True               ; use full range of color map
;    res@mpProjection = "Robinson"       
    res@mpOutlineBoundarySets       = "National"
    res@mpDataSetName = "Earth..4"
    res@mpCountyLineThicknessF=2.0
    res@mpGeophysicalLineThicknessF =5.0
    res@lbLabelFontHeightF=.02

;res@mpPerimOn            = False
;res@mpGridAndLimbOn   = True
;res@mpGridLatSpacingF = 30.
;res@mpGridLonSpacingF = 30.
;res@mpProjection = "Robinson"
;res@mpCenterLonF=150

;  res@cnFillMode           = "RasterFill"
    res@cnLevelSelectionMode ="ManualLevels"
    res@cnMaxLevelValF  = 60
    res@cnMinLevelValF  = 1
    res@cnLevelSpacingF = 3
;res@cnLevelSelectionMode="ExplicitLevels"
;res@cnLevels=(/1,2,3,4,5,10,15,20,25,50,100,150/)
;res@cnLevels=(/1,2,3,4,5,10,15,20,25,50,100,150/)
;res@cnLevels=(/1,3,5,10,15,20,25,30,35,40,45,50,100,150,200,250,300,400,500,1000/)

    res@cnFillPalette = "precip3_16lev"


;==========Lambert
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
;==========
    res@gsnAddCyclic = False 
	res@cnFillMode="RasterFill"
    res@gsnLeftString="irrigation amount DJF"
    month_plot=0
   month_abbr = (/"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"/)
    do while (month_plot.ne.12)
	wksMonth= gsn_open_wks("png","/home/L.r02229011/fig/"+dataset+"_"+(month_plot+1))
;	gsn_define_colormap(wksMonth,"WhiteBlue")
	;symMinMaxPlt(VarClima(month_plot,:,:)*plotscale,20,False,res)
        res@gsnLeftString="irrigation amount "+month_abbr(month_plot)
	plotMonth=gsn_csm_contour_map(wksMonth,VarClima(month_plot,:,:),res)
        ;****************
          dum = new(4,graphic)  
          do i = 0 , 3
            dum(i)=gsn_add_polyline(wksMonth,plotMonth,xpts(i:i+1),ypts(i:i+1),resp)      
          end do 
          draw(plotMonth)
          frame(wksMonth)
        ;********************************
	month_plot=month_plot+1
    end do
	
	latstart=24
	latend=29
	lonstart=41
	lonend=47
    location=latstart+"-"+latend+"N "+lonstart+"-"+lonend+"E "
	t=reshape(Var,(/102,12,360,720/))
	t!2="lat"
	t!3="lon"
	t&lat=lat
	t&lon=lon
    clat = cos(lat*4.0*atan(1.0)/180.0)  ; lat weight
    clat!0="lat"
    clat&lat=lat
	res2=True
    multi_month=dim_avg_n_Wrap(t(:,(/1,2,3,4/),:,:),1)
    regional_avg=wgt_areaave_Wrap(multi_month(:,{latstart:latend},{lonstart:lonend}),clat({latstart:latend}),1.0,0)
    res2@tiMainString="Wisser irri amount "+location+"FMAM"
    wks = gsn_open_wks("png","/home/L.r02229011/fig/irr_FMAM"+latstart+latend+lonstart+lonend)  ; open a wks
    plot  = gsn_csm_xy (wks,ispan(1899,2000,1),regional_avg  ,res2) ; create plot

    Var@units="mm/yr"
    annualtotal=dim_avg_n_Wrap(Var,0)
    annualtotal(:,:)=12.*annualtotal
    res@cnMaxLevelValF  = 200
    res@cnMinLevelValF  = 0 
    res@cnLevelSpacingF = 10
;    res@mpMinLatF       = 0
;    res@mpMaxLatF       = 40
;    res@mpMinLonF       = 60 
;    res@mpMaxLonF       = 90
    res@gsnLeftString="irrigation amount ANN"
    plot = gsn_csm_contour_map(wks,annualtotal,res)     
        ;****************
          dum = new(4,graphic)  
          do i = 0 , 3
            dum(i)=gsn_add_polyline(wks,plot,xpts(i:i+1),ypts(i:i+1),resp)      
          end do 
          draw(plot)
          frame(wks)
        ;********************************

	delete(regional_avg)
	Var=where(Var.gt.1.,Var,Var@_FillValue)
	regional_avg=wgt_areaave_Wrap(Var(:,{latstart:latend},{lonstart:lonend}),clat({latstart:latend}),1.0,0)
	print(regional_avg)
    delete(Var)

end
