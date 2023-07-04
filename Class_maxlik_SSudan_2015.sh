#!/bin/sh
# 1. Import data
# listing the files
g.list rast
# importing the image subset with 7 Landsat bands and display the raster map
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B1.TIF output=L8_2015_01 resample=bilinear extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B2.TIF output=L8_2015_02 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B3.TIF output=L8_2015_03 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B4.TIF output=L8_2015_04 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B5.TIF output=L8_2015_05 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B6.TIF output=L8_2015_06 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B7.TIF output=L8_2015_07 extent=region resolution=region
#
g.list rast
#
# Set computational region to match the scene
g.region raster=L8_2015_01 -p
# grouping data by i.group to store VIZ, NIR, MIR into group/subgroup (leaving out TIR)
i.group group=L8_2015 subgroup=res_30m \
  input=L8_2015_01,L8_2015_02,L8_2015_03,L8_2015_04,L8_2015_05,L8_2015_06,L8_2015_07
#
# Clustering: generating signature file and report using k-means clustering algorithm
i.cluster group=L8_2015 subgroup=res_30m \
  signaturefile=cluster_L8_2015 \
  classes=10 reportfile=rep_clust_L8_2015.txt --overwrite
#
# Classification by i.maxlik module
i.maxlik group=L8_2015 subgroup=res_30m \
  signaturefile=cluster_L8_2015 \
  output=L8_2015_cluster_classes reject=L8_2015_cluster_reject
#
# Mapping
d.mon wx0
g.region raster=L8_2015_cluster_classes -p
r.colors L8_2015_cluster_classes color=rainbow -e
d.rast L8_2015_cluster_classes
d.legend raster=L8_2015_cluster_classes title="2015" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=SSudan_2015 format=jpg --overwrite
#
# Rejected classes
d.mon wx1
g.region raster=L8_2015_cluster_classes -p
d.rast L8_2015_cluster_reject
d.legend raster=L8_2015_cluster_reject title="2015" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=SSudan_2015_reject format=jpg --overwrite
#
# Accuracy assessment by r.kappa: error matrix and kappa parameters of classification result.
g.region raster=L8_2015_cluster_classes -p
r.kappa -w classification=L8_2015_cluster_classes reference=training_classes_Sudd

# export Kappa matrix as CSV file "kappa.csv"
r.kappa classification=L8_2015_cluster_classes reference=L8_2014_cluster_classes output=kappa.csv -m -h --overwrite
