#!/bin/sh
# 1. Import data
# listing the files
g.list rast
# LC08_L2SP_193036_20140101_20200912_02_T1_SR_B1
# importing the image subset with 7 Landsat bands and display the raster map (polinalemenkova)
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B1.TIF output=L8_2016_01 resample=bilinear extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B2.TIF output=L8_2016_02 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B3.TIF output=L8_2016_03 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B4.TIF output=L8_2016_04 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B5.TIF output=L8_2016_05 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B6.TIF output=L8_2016_06 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B7.TIF output=L8_2016_07 extent=region resolution=region
# another way by r.in.gdal:
# r.in.gdal input=/Users/polinalemenkova/grassdata/Algeria/LC08_L2SP_193036_20140101_20200912_02_T1_SR_B7.TIF output=L8_2014_07 --overwrite
#
g.list rast
#
# grouping data by i.group
# Set computational region to match the scene
g.region raster=L8_2016_01 -p
# store VIZ, NIR, MIR into group/subgroup (leaving out TIR)
i.group group=L8_2016 subgroup=res_30m \
  input=L8_2016_01,L8_2016_02,L8_2016_03,L8_2016_04,L8_2016_05,L8_2016_06,L8_2016_07
#
# 4. Clustering: generating signature file and report using k-means clustering algorithm
i.cluster group=L8_2016 subgroup=res_30m \
  signaturefile=cluster_L8_2016 \
  classes=10 reportfile=rep_clust_L8_2016.txt --overwrite
# 5. Classification by i.maxlik module
#
i.maxlik group=L8_2016 subgroup=res_30m \
  signaturefile=cluster_L8_2016 \
  output=L8_2016_cluster_classes reject=L8_2016_cluster_reject
#
# 6. Mapping
d.mon wx0
g.region raster=L8_2016_cluster_classes -p
r.colors L8_2016_cluster_classes color=rainbow -e
# d.rast.leg L8_2014_cluster_classes
d.rast L8_2016_cluster_classes
d.legend raster=L8_2016_cluster_classes title="2016" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=SSudan_2016 format=jpg --overwrite
#
d.mon wx1
g.region raster=L8_2016_cluster_classes -p
d.rast L8_2016_cluster_reject
d.legend raster=L8_2016_cluster_reject title="2016" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=SSudan_2016_reject format=jpg --overwrite
#d.rast.leg L8_2014_cluster_reject
#
# r.kappa - Calculates error matrix and kappa parameter for accuracy assessment of classification result.
g.region raster=L8_2016_cluster_classes -p
r.kappa -w classification=L8_2016_cluster_classes reference=training_classes_Sudd

# g.rename raster=L8_2014_cluster_classes,training_classes_Sudd

# export Kappa matrix as CSV file "kappa.csv"
r.kappa classification=L8_2016_cluster_classes reference=training_classes_Sudd output=kappa.csv -m -h --overwrite
