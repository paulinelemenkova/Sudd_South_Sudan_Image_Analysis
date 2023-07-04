#!/bin/sh
# 1. Import data
# listing the files
g.list rast
# importing the image subset with 7 Landsat bands and display the raster map
r.import input=/Users/polinalemenkova/grassdata/Sudan_2017/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B1.TIF output=L8_2017_01 resample=bilinear extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2017/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B2.TIF output=L8_2017_02 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2017/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B3.TIF output=L8_2017_03 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2017/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B4.TIF output=L8_2017_04 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2017/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B5.TIF output=L8_2017_05 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2017/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B6.TIF output=L8_2017_06 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2017/LC08_L2SP_173055_20171231_20200902_02_T1_SR_B7.TIF output=L8_2017_07 extent=region resolution=region --overwrite
#
g.list rast
# raster metadata:
r.info -r L8_2017_07
# Set computational region to match the scene
g.region raster=L8_2017_01 -p
# grouping data by i.group.
i.group group=L8_2017 subgroup=res_30m \
  input=L8_2017_01,L8_2017_02,L8_2017_03,L8_2017_04,L8_2017_05,L8_2017_06,L8_2017_07
#
i.segment group=L8_2017 output=segs_L8_2017 threshold=0.90 minsize=100 --overwrite
#
# Mapping
d.mon wx0
g.region raster=segs_L8_2017 -p
r.colors segs_L8_2017 color=roygbiv -e
d.rast segs_L8_2017
d.legend raster=segs_L8_2017 title="2017" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=segs_L8_2017 format=jpg --overwrite
