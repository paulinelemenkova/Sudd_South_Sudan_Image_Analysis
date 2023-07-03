#!/bin/sh
# 1. Import data
# listing the files
g.list rast
# importing the image subset with 7 Landsat bands and display the raster map (polinalemenkova)
r.import input=/Users/polinalemenkova/grassdata/Sudan_2015/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B1.TIF output=L8_2015_01 resample=bilinear extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2015/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B2.TIF output=L8_2015_02 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Sudan_2015/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B3.TIF output=L8_2015_03 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Sudan_2015/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B4.TIF output=L8_2015_04 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Sudan_2015/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B5.TIF output=L8_2015_05 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Sudan_2015/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B6.TIF output=L8_2015_06 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Sudan_2015/LC08_L2SP_173055_20150108_20200910_02_T1_SR_B7.TIF output=L8_2015_07 extent=region resolution=region
#
g.list rast
#
# grouping data by i.group. Set computational region to match the scene
g.region raster=L8_2015_01 -p
#
i.group group=L8_2015 subgroup=res_30m \
  input=L8_2015_01,L8_2015_02,L8_2015_03,L8_2015_04,L8_2015_05,L8_2015_06,L8_2015_07
#
i.segment group=L8_2015 output=segs_L8_2015 threshold=0.90 minsize=100 --overwrite
#
# 6. Mapping
d.mon wx0
g.region raster=segs_L8_2015 -p
r.colors segs_L8_2015 color=roygbiv -e
d.rast segs_L8_2015
d.legend raster=segs_L8_2015 title="2015" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=segs_L8_2015 format=jpg --overwrite
