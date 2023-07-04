#!/bin/sh
# 1. Import data
# listing the files
g.list rast
# importing the image subset with 7 Landsat bands and display the raster map
r.import input=/Users/polinalemenkova/grassdata/Sudan_2016/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B1.TIF output=L8_2016_01 resample=bilinear extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2016/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B2.TIF output=L8_2016_02 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2016/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B3.TIF output=L8_2016_03 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2016/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B4.TIF output=L8_2016_04 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2016/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B5.TIF output=L8_2016_05 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2016/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B6.TIF output=L8_2016_06 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2016/LC08_L2SP_173055_20160212_20200907_02_T1_SR_B7.TIF output=L8_2016_07 extent=region resolution=region --overwrite
#
g.list rast
# Set computational region to match the scene
g.region raster=L8_2016_01 -p
# data grouping
i.group group=L8_2016 subgroup=res_30m \
  input=L8_2016_01,L8_2016_02,L8_2016_03,L8_2016_04,L8_2016_05,L8_2016_06,L8_2016_07
# Threshold should be > 0 and < 1
i.segment group=L8_2016 output=segs_L8_2016 threshold=0.90 minsize=100 --overwrite
# Mapping
d.mon wx0
g.region raster=segs_L8_2016 -p
r.colors segs_L8_2016 color=roygbiv -e
d.rast segs_L8_2016
d.legend raster=segs_L8_2016 title="2016" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=segs_L8_2016 format=jpg --overwrite
