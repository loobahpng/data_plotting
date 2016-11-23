load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;************************************************
begin

regional=0
robinson=0
lambert=1

maxLevel=40.
minLevel=0.
nrec =0 
dims = (/360,720/)
temp=new((/120,360,720/),"float")
temp2=new((/33,360,720/),"float")
daily=new(120,"float")

lat=fspan(-89.75,89.75,360)
lat!0="lat"
lat&lat=lat
lon=fspan(0.25,359.75,720)
lon!0="lon"
lon&lon=lon
;temp = fbindirread("/home/L.JeffBlue/work5/Data/PRECL/precl_mon_v1.0.lnx.2012.gri0.5m", nrec, dims, "float")
do yyyy=1979,2011
	fil=systemfunc("ls /work4/L.r02229011/CPC_Uni/"+yyyy+"/PRCP_CU_GAUGE_V1.0GLB_0.50deg.lnx.* | tail -n +32|head -n 120")
;	print(dimsizes(fil))
	do i=0,dimsizes(fil)-1
		temp(i,:,:)=fbindirread(fil(i),nrec,dims,"float")
		temp@_FillValue=-999.
	end do
	do dd=0,119
		;Var2=Var
		Var2=temp(dd,:,:)
		Var2@_FillValue=-999.
		Var2(:,:)=Var2@_FillValue
		do i=229,236
			Var2(i,316-i:316-i+5)=temp(dd,i,316-i:316-i+5)
		end do
		Var2!1="longitude"
		Var2!0="latitude"
		Var2&longitude=lon
		Var2&latitude=lat
		Var2&latitude@units="degrees_north"
		Var2&longitude@units="degrees_east"
		clat = cos(lat*4.0*atan(1.0)/180.0)  ; lat weight
		regional_avg=wgt_areaave_Wrap(Var2,clat,1.0,0)
		daily(dd)=regional_avg
		delete(Var2)
	end do
	print("     "+daily)
	temp2(yyyy-1979,:,:)=dim_sum_n_Wrap(temp,0)*0.1/4.
	temp2@_FillValue=-999.
end do
exit
Var=dim_avg_n_Wrap(temp2,0)



Var@_FillValue=-999.
Var!1="longitude"
Var!0="latitude"
Var&longitude=lon
Var&latitude=lat
Var&latitude@units="degrees_north"
Var&longitude@units="degrees_east"
printVarSummary(Var)



    res	= True               ; plot mods desired
    res@cnFillOn	= True               ; turn on color fill
    res@cnLinesOn	= False              ; turn off contour lines
    res@gsnMaximize	= True
;    res@gsnSpreadColors       = True               ; use full range of color map
    res@cnFillPalette="BlAqGrYeOrRe"
	res@cnFillPalette="MPL_RdBu"
    res@cnFillPalette="precip3_16lev"
    res@mpOutlineBoundarySets       = "National"
    res@mpDataSetName = "Earth..4"
    res@mpCountyLineThicknessF=2.0
    res@mpGeophysicalLineThicknessF =2.5
    res@cnFillMode           = "RasterFill"
    res@gsnAddCyclic = False
;	res@trGridType="TriangularMesh"
	latstart=20
	latend=40
	lonstart=60
	lonend=120
if regional.eq.1 then
    res@mpMinLatF       = latstart
    res@mpMaxLatF       = latend
    res@mpMinLonF       = lonstart
    res@mpMaxLonF       = lonend
end if
res@cnLevelSelectionMode ="ManualLevels"
res@cnMaxLevelValF  = maxLevel
res@cnMinLevelValF  = minLevel
res@cnLevelSpacingF = (maxLevel-minLevel)/20.

;***************
if robinson.eq.1 then
	res@mpPerimOn            = False
	res@mpGridAndLimbOn   = True
	res@mpGridLatSpacingF = 30.
	res@mpGridLonSpacingF = 30.
	res@mpProjection = "Robinson"
	res@mpCenterLonF=150
end if
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
    res@mpOutlineBoundarySets       = "National"
    res@mpNationalLineThicknessF=1.
    res@mpGeophysicalLineThicknessF =5.
    res@mpNationalLineColor = "Black"

end if
;*******************
	print("*******************")
	lllat=28.096
	lllon=40.2474
	print(ind(lat.eq.lat({lllat}))+", "+ind(lon.eq.lon({lllon})))
	print("grid cell at: "+lat({lllat})+", "+lon({lllon}))
	lllat=28.0561
	lllon=42.7025
	print(ind(lat.eq.lat({lllat}))+", "+ind(lon.eq.lon({lllon})))
	print("grid cell at: "+lat({lllat})+", "+lon({lllon}))
	lllat=24.6694
	lllon=43.8797
	print(ind(lat.eq.lat({lllat}))+", "+ind(lon.eq.lon({lllon})))
	print("grid cell at: "+lat({lllat})+", "+lon({lllon}))
	lllat=24.5354
	lllon=46.2145
	print(ind(lat.eq.lat({lllat}))+", "+ind(lon.eq.lon({lllon})))
	print("grid cell at: "+lat({lllat})+", "+lon({lllon}))
	print("*******************")
xxx=new(33,"float")
do j=0,32
	;Var2=Var
	Var2=temp2(j,:,:)
	Var2@_FillValue=-999.
	Var2!1="longitude"
	Var2!0="latitude"
	Var2&longitude=lon
	Var2&latitude=lat
	Var2&latitude@units="degrees_north"
	Var2&longitude@units="degrees_east"
	Var2(:,:)=Var2@_FillValue
	do i=229,236
		Var2(i,316-i:316-i+5)=temp2(j,i,316-i:316-i+5)
	end do
	clat = cos(lat*4.0*atan(1.0)/180.0)  ; lat weight
    regional_avg=wgt_areaave_Wrap(Var2,clat,1.0,0)
	xxx(j)=regional_avg
	delete(Var2)
;	wks=gsn_open_wks("png","/home/L.r02229011/fig/that_point")
;	res@cnLevelSelectionMode="ExplicitLevels"
;	res@cnLevels=(/0/)+0.5
;	delete(res@cnFillPalette)
;	res@cnFillPalette = (/"white","red"/)
;	plot=gsn_csm_contour_map(wks,Var,res)
end do
print(xxx)
	exit
;*******************
	wksMonth=gsn_open_wks("png","/home/L.r02229011/fig/CPCu")
	plotMonth=gsn_csm_contour_map(wksMonth,Var,res)
end
