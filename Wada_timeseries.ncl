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

;  fils=systemfunc ("ls /raid2/r02229011/bnd_condition/surfdata/surfdata_96x144_dynirri_1901_2000_20120604.nc")
;  filsExp=systemfunc ("ls /raid2/r02229011/bnd_condition/surfdata/IRR_B_2000.clm2.h0.0001-01.nc")

;  fils=systemfunc ("ls surfdata/surfdata_0.9x1.25_global_irri_10yrmean_20131205.nc")
;  filsExp=systemfunc ("ls surfdata/F2000_CAM5.clm2.h0.0001-01.nc")

  fils=systemfunc("ls /scratch/mlo/data/IRRI/Wada/pcrglobwb_historical_PIrrWW_monthly_1960_2010.nc")
  filsExp=systemfunc ("ls /work3/mlo/cesm1/archive/F2000_CAM5_irri_test/atm/hist/F2000_CAM5_irri_test.cam2.h0.0001-01.nc")

  in = addfiles(fils,"r")
  inExp = addfiles(filsExp,"r")

  ListSetType (in,"cat")
  ListSetType (inExp,"cat")
  ;Var=in[:]->IRRI4d
  Var=in[:]->PIrrWW
  Var@long_name="irrigation"
  Var@units="mm/month"
  printVarSummary(Var)
;  Var&lsmlat= inExp[0]->lat
;  Var&lsmlon= inExp[0]->lon
  Var&latitude@units="degrees_north"
  Var&longitude@units="degrees_east"

;-----------mask
;    maskname="mask"
;    inmask=addfile("mask_0.9x1.25_IndusGanges.nc","r")
;    Var=mask(Var,conform(Var,inmask->$maskname$,(/1,2/)),1);+in[:]->SWCF(:,:,:)
;------------
  t=reshape(Var,(/51,12,360,720/))
  t!2="lat"
  t!3="lon"
  t&lat=Var&latitude
  t&lon=Var&longitude
;    clat = cos(inExp[0]->lat*4.0*atan(1.0)/180.0)  ; lat weight
;    clat!0="lat"
;    clat&lat=inExp[0]->lat

    clat = cos(in[0]->latitude*4.0*atan(1.0)/180.0)  ; lat weight
    clat!0="lat"
    clat&lat=in[0]->latitude

    latstart=34
    latend=40
    lonstart=-125+360
    lonend=-115+360

latstart=24
latend=29
lonstart=41
lonend=47
    location=latstart+"-"+latend+"N "+lonstart+"-"+lonend+"E "


    res=True
    multi_month=dim_avg_n_Wrap(t(:,(/0,1,2,3/),:,:),1)
    regional_avg=wgt_areaave_Wrap(multi_month(:,{latstart:latend},{lonstart:lonend}),clat({latstart:latend}),1.0,0)
    res@tiMainString="irri amount "+location+"JFMA"
    wks = gsn_open_wks("png","/home/L.r02229011/fig/irr_JFMA"+latstart+latend+lonstart+lonend)  ; open a wks
    plot  = gsn_csm_xy (wks,ispan(1960,2010,1),regional_avg  ,res) ; create plot
    
    multi_month=dim_avg_n_Wrap(t(:,(/1,2,3,4/),:,:),1)
    regional_avg=wgt_areaave_Wrap(multi_month(:,{latstart:latend},{lonstart:lonend}),clat({latstart:latend}),1.0,0)
    res@tiMainString="irri amount "+location+"FMAM"
    wks = gsn_open_wks("png","/home/L.r02229011/fig/irr_FMAM"+latstart+latend+lonstart+lonend)  ; open a wks
    plot  = gsn_csm_xy (wks,ispan(1960,2010,1),regional_avg  ,res) ; create plot

    multi_month=dim_avg_n_Wrap(t(:,(/4,5/),:,:),1)
    regional_avg=wgt_areaave_Wrap(multi_month(:,{latstart:latend},{lonstart:lonend}),clat({latstart:latend}),1.0,0)
    res@tiMainString="irri amount "+location+"MJ"
    wks = gsn_open_wks("png","/home/L.r02229011/fig/irr_MJ"+latstart+latend+lonstart+lonend)  ; open a wks
    plot  = gsn_csm_xy (wks,ispan(1960,2010,1),regional_avg  ,res) ; create plot

    multi_month=dim_avg_n_Wrap(t(:,(/6,7,8/),:,:),1)
    regional_avg=wgt_areaave_Wrap(multi_month(:,{latstart:latend},{lonstart:lonend}),clat({latstart:latend}),1.0,0)
    res@tiMainString="irri amount "+location+"JAS"
    wks = gsn_open_wks("png","/home/L.r02229011/fig/irr_JAS"+latstart+latend+lonstart+lonend)  ; open a wks
    plot  = gsn_csm_xy (wks,ispan(1960,2010,1),regional_avg  ,res) ; create plot

    multi_month=dim_avg_n_Wrap(t(:,(/9,10,11/),:,:),1)
    regional_avg=wgt_areaave_Wrap(multi_month(:,{latstart:latend},{lonstart:lonend}),clat({latstart:latend}),1.0,0)
    res@tiMainString="irri amount "+location+"OND"
    wks = gsn_open_wks("png","/home/L.r02229011/fig/irr_OND"+latstart+latend+lonstart+lonend)  ; open a wks
    plot  = gsn_csm_xy (wks,ispan(1960,2010,1),regional_avg  ,res) ; create plot

	month_abbr = (/"1_Jan","2_Feb","3_Mar","4_Apr","5_May","6_Jun","7_Jul","8_Aug","9_Sep","10_Oct","11_Nov","12_Dec"/)
	delete(regional_avg)
	Var=where(Var.gt.1.,Var,Var@_FillValue)
	regional_avg=wgt_areaave_Wrap(Var(:,{latstart:latend},{lonstart:lonend}),clat({latstart:latend}),1.0,0)
	print(regional_avg)
	; print timeseries out

	delete(regional_avg)
    res                = True               ; plot mods desired
    res@gsnDraw   = False                             ; don't draw yet
    res@gsnFrame  = False                             ; don't advance yet
    res@cnFillOn	= True               ; turn on color fill
    res@cnLinesOn	= False              ; turn off contour lines
    res@gsnMaximize	= True
    res@mpOutlineBoundarySets       = "National"
    res@mpDataSetName = "Earth..4"
    res@mpCountyLineThicknessF=2.0
    res@mpGeophysicalLineThicknessF =5.0
    res@lbLabelFontHeightF=.02
    res@cnLevelSelectionMode ="ManualLevels"
    res@cnMaxLevelValF  = 140
    res@cnMinLevelValF  = 1 
    res@cnLevelSpacingF = 7
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
	res@cnFillMode="RasterFill"
;==========
	do mm=0,11
		month=dim_avg_n_Wrap(t(40:50,mm,:,:),0)
		month=where(month.gt.1.,month,month@_FillValue)
		regional_avg=wgt_areaave_Wrap(month({latstart:latend},{lonstart:lonend}),clat({latstart:latend}),1.0,0)
;		print(month_abbr(mm)+": "+regional_avg)
;		print("max: "+max(month({latstart:latend},{lonstart:lonend})))
		res@tiMainString="irri amount "+location+month_abbr(mm)
		wks = gsn_open_wks("png","/home/L.r02229011/fig/irr_fillvalue"+month_abbr(mm)+latstart+latend+lonstart+lonend)  ; open a wks
		plot=gsn_csm_contour_map(wks,month,res)
		draw(plot)
		frame(wks)
	end do

    ;gavg=wgt_areaave_Wrap(Var(:,{35:40},{70:80}),clat({35:40}),1.0,0)   ; global avg
    ;gavg=wgt_areaave_Wrap(Var(:,{10:40},{280:300}),clat({10:40}),1.0,0)   ; global avg

;    gavg=runave_n_Wrap(gavg,3,1,0)
;    gavg_thar=runave_n_Wrap(gavg_thar,3,1,0)

;    diff=gavg_thar-gavg
;    diff=runave_n_Wrap(diff,5,1,0)
;    gavg=runave_n_Wrap(gavg,5,1,0)
;    gavg_thar=runave_n_Wrap(gavg_thar,5,1,0)
    ;res@tiMainString=Var@long_name
    ;res@tiXAxisString="time (month)"
    ;res@tiYAxisString=Var@units
;    res@trYMaxF = latstart.5;21.5;19.;15.5
;    res@trYMinF = 24.5;17.5;15.;11.5
;    res@trYMaxF = 20.;21.5;19.;15.5
;    res@trYMinF = 16.;17.5;15.;11.5
    ;res@tiMainString="35N-40N 70E-80E avg precip"
    ;res@tiMainString="10N-40N 280E-300E avg precip"
;    restick = True
;    restick@ttmFormat = "%Y"
;    time_axis_labels(in[:]->time,res,restick) ; call the formatting procedure
    ;plot  = gsn_csm_xy (wks,in[:]->time,runave_Wrap( gavg,5,0) ,res) ; create plot
;    wks = gsn_open_wks("png","/home/L.r02229011/fig/DJF_irr"+latstart+"_"+latend+"_"+lonstart+"_"+lonend)  ; open a wks
;    plot  = gsn_csm_xy (wks,ispan(1902,2000,1), regional_avg_DJF ,res) ; create plot
;    wks = gsn_open_wks("png","/home/L.r02229011/fig/JJA_irr"+latstart+"_"+latend+"_"+lonstart+"_"+lonend)  ; open a wks
;    res@tiMainString="JJA irr"
;    plot  = gsn_csm_xy (wks,ispan(1902,2000,1), regional_avg_JJA ,res) ; create plot
    ;plot  = gsn_csm_xy (wks,tt, gavg ,res) ; create plot
    ;plotDJF  = gsn_csm_xy (wksDJF,tt,DJF,res) ; create plot
    ;plotJJA=gsn_csm_xy (wksJJA,tt,JJA,res)
;    wks = gsn_open_wks("png","/home/L.r02229011/fig/DJF_"+varname+"latstart3latstart575_run5")  ; open a wks
;    plot  = gsn_csm_xy (wks,ispan(1960,2000,1), gavg_thar(59:99) ,res) ; create plot

  print("file= irr")
end
