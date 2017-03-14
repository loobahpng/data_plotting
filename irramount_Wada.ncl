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

;  fils=systemfunc ("ls surfdata/surfdata_1.9x2.5_simyr2000_c091005_IRRI_global.nc")
;  fils=systemfunc ("ls surfdata/surfdata_1.9x2.5_simyr2000_c091005_IRRI_NCP.nc")
;  fils=systemfunc ("ls surfdata/surfdata_1.9x2.5_simyr2000_c091005_IRRI_LowLats.nc")
;  filsExp=systemfunc ("ls surfdata/IRR_B_2000.clm2.h0.0001-01.nc")
;  fils=systemfunc ("ls /work/mlo/proc/slr_wada/new_WW/PIrrWW_monthly_1960_2010_mm_per_month.nc")
;  filsExp=systemfunc ("ls /work3/mlo/cesm1/archive/F2000_CAM5_irri_test/atm/hist/F2000_CAM5_irri_test.cam2.h0.0001-01.nc")

;  fils=systemfunc ("ls surfdata/surfdata_1.9x2.5_simyr1850_c091108_Global_IRR.nc")
;  fils=systemfunc ("ls surfdata/surfdata_0.9x1.25_global_irri_10yrmean_indiaonly_20140129.nc")
  fils=systemfunc("ls /scratch/mlo/data/IRRI/Wada/pcrglobwb_historical_PIrrWW_monthly_1960_2010.nc")
;  filsExp=systemfunc ("ls /raid2/r02229011/irr/F2000_CAM5.clm2.h0.0001-01.nc")
;  fils=systemfunc ("ls /raid2/r02229011/surfdata_0.9x1.25_global_irri_10yrmean_20131205.nc")
;  filsExp=systemfunc ("ls /raid2/share/mlo/IRR_B_2000/lnd/hist/IRR_B_2000.clm2.h0.0001-01.nc")
dataset="Wada"
  in = addfiles(fils,"r")
;  inExp = addfiles(filsExp,"r")

  ListSetType (in,"cat")
;  ListSetType (inExp,"cat")
  Var=in[:]->PIrrWW
  Var@long_name="irrigation"
  Var@units="mm/month"
  printVarSummary(Var)
  Var&latitude@units="degrees_north"
  Var&longitude@units="degrees_east"
;  Var&latitude= inExp[0]->lat
;  Var&longitude= inExp[0]->lon
;-----------mask
;    maskname="mask"
;    inmask=addfile("mask_0.9x1.25_IndusGanges.nc","r")
;    Var=mask(Var,conform(Var,inmask->$maskname$,(/1,2/)),1);+in[:]->SWCF(:,:,:)
;------------
  VarClima=clmMonTLL(Var(240:431,:,:)) ;12*(y-1960)
  ;VarClima(:,:,:)=clmMonTLL(Var(0:11,:,:))
;  annual=dim_avg_n_Wrap(VarClima,0)*12.
;  annual=annual*inExp[0]->area/1000./1000.
;  total=dim_sum_n_Wrap(dim_sum_n_Wrap(annual,0),0)
  printVarSummary(VarClima)
;  print(total+"km3")
  VarClima@_Fillvalue=9.96921e+36
;  VarClima(:,:,:)=where(VarClima.ne.0,VarClima,VarClima@_Fillvalue)
  DJF=dim_avg_n_Wrap(VarClima((/0,1,11/),:,:),0)
  JFM=dim_avg_n_Wrap(VarClima((/0,1,2/),:,:),0)
  MAM=dim_avg_n_Wrap(VarClima((/2,3,4/),:,:),0)
  JJA=dim_avg_n_Wrap(VarClima((/5,6,7/),:,:),0)
  SON=dim_avg_n_Wrap(VarClima((/8,9,10/),:,:),0)

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
    res@cnMaxLevelValF  = 140
    res@cnMinLevelValF  = 1 
    res@cnLevelSpacingF = 7
;res@cnLevelSelectionMode="ExplicitLevels"
;res@cnLevels=(/1,2,3,4,5,10,15,20,25,50,100,150/)
;res@cnLevels=(/1,2,3,4,5,10,15,20,25,50,100,150/)
;res@cnLevels=(/1,3,5,10,15,20,25,30,35,40,45,50,100,150,200,250,300,400,500,1000/)

    res@cnFillPalette = "precip3_16lev"


;    res@mpMinLatF       = 0
;    res@mpMaxLatF       = 60
;    res@mpMinLonF       = 60 
;    res@mpMaxLonF       = 120
    res@mpMinLatF       = 0
    res@mpMaxLatF       = 50
    res@mpMinLonF       = 20
    res@mpMaxLonF       = 70
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
	res@cnFillMode="RasterFill"
    res@gsnLeftString="irrigation amount DJF"
    plotDJF=gsn_csm_contour_map(wksDJF,DJF,res)
        ;****************
          dum = new(4,graphic)  
          do i = 0 , 3
            dum(i)=gsn_add_polyline(wksDJF,plotDJF,xpts(i:i+1),ypts(i:i+1),resp)      
          end do 
          draw(plotDJF)
          frame(wksDJF)
        ;********************************
    res@gsnLeftString="irrigation amount JFM"
    plotJFM=gsn_csm_contour_map(wksJFM,JFM,res)
        ;****************
          dum = new(4,graphic)  
          do i = 0 , 3
            dum(i)=gsn_add_polyline(wksJFM,plotJFM,xpts(i:i+1),ypts(i:i+1),resp)      
          end do 
          draw(plotJFM)
          frame(wksJFM)
        ;********************************
    res@gsnLeftString="irrigation amount MAM"
    plotMAM=gsn_csm_contour_map(wksMAM,MAM,res)
        ;****************
          dum = new(4,graphic)  
          do i = 0 , 3
            dum(i)=gsn_add_polyline(wksMAM,plotMAM,xpts(i:i+1),ypts(i:i+1),resp)      
          end do 
          draw(plotMAM)
          frame(wksMAM)
        ;********************************
    res@gsnLeftString="irrigation amount SON"
    plotSON=gsn_csm_contour_map(wksSON,SON,res)
        ;****************
          dum = new(4,graphic)  
          do i = 0 , 3
            dum(i)=gsn_add_polyline(wksSON,plotSON,xpts(i:i+1),ypts(i:i+1),resp)      
          end do 
          draw(plotSON)
          frame(wksSON)
        ;********************************
    res@gsnLeftString="irrigation amount JJA"
    plotJJA=gsn_csm_contour_map(wksJJA,JJA,res)
        ;****************
          dum = new(4,graphic)  
          do i = 0 , 3
            dum(i)=gsn_add_polyline(wksJJA,plotJJA,xpts(i:i+1),ypts(i:i+1),resp)      
          end do 
          draw(plotJJA)
          frame(wksJJA)
        ;********************************
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
    delete(Var)

end
