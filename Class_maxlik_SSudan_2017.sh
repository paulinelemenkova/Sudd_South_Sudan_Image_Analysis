#!/bin/sh
#
# importing the image subset with 7 Landsat bands and display the raster map
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B1.TIF output=L8_2017_01 resample=bilinear extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B2.TIF output=L8_2017_02 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B3.TIF output=L8_2017_03 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B4.TIF output=L8_2017_04 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B5.TIF output=L8_2017_05 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B6.TIF output=L8_2017_06 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B7.TIF output=L8_2017_07 extent=region resolution=region
#
# listing the files
g.list rast
#
# Set computational region to match the scene
g.region raster=L8_2017_01 -p
# grouping data by i.group store VIZ, NIR, MIR into group/subgroup (leaving out TIR)
i.group group=L8_2017 subgroup=res_30m \
  input=L8_2017_01,L8_2017_02,L8_2017_03,L8_2017_04,L8_2017_05,L8_2017_06,L8_2017_07
#
# Clustering: generating signature file and report using k-means clustering algorithm
i.cluster group=L8_2017 subgroup=res_30m \
  signaturefile=cluster_L8_2017 \
  classes=10 reportfile=rep_clust_L8_2017.txt --overwrite
#
# Classification by i.maxlik module
i.maxlik group=L8_2017 subgroup=res_30m \
  signaturefile=cluster_L8_2017 \
  output=L8_2017_cluster_classes reject=L8_2017_cluster_reject
#
# Mapping
d.mon wx0
g.region raster=L8_2017_cluster_classes -p
r.colors L8_2017_cluster_classes color=rainbow -e
d.rast L8_2017_cluster_classes
d.legend raster=L8_2017_cluster_classes title="2017" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=SSudan_2017 format=jpg --overwrite
#
# Rejected classes
d.mon wx1
g.region raster=L8_2017_cluster_classes -p
d.rast L8_2017_cluster_reject
d.legend raster=L8_2017_cluster_reject title="2017" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=SSudan_2017_reject format=jpg --overwrite
#
# Accuracy assessment by r.kappa: error matrix and kappa parameters of classification result.
g.region raster=L8_2017_cluster_classes -p
r.kappa -w classification=L8_2017_cluster_classes reference=training_classes_Sudd

# Export Kappa matrix as CSV file "kappa.csv"
r.kappa classification=L8_2017_cluster_classes reference=training_classes_Sudd output=kappa.csv -m -h --overwrite