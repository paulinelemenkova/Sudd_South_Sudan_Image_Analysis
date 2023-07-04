#!/bin/sh
# 1. Import data
# listing the files
g.list rast
# importing the image subset with 7 Landsat bands and display the raster map
r.import input=/Users/polinalemenkova/grassdata/Sudan_2019/LC08_L2SP_173055_20190308_20200829_02_T1_SR_B1.TIF output=L8_2019_01 resample=bilinear extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2019/LC08_L2SP_173055_20190308_20200829_02_T1_SR_B2.TIF output=L8_2019_02 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2019/LC08_L2SP_173055_20190308_20200829_02_T1_SR_B3.TIF output=L8_2019_03 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2019/LC08_L2SP_173055_20190308_20200829_02_T1_SR_B4.TIF output=L8_2019_04 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2019/LC08_L2SP_173055_20190308_20200829_02_T1_SR_B5.TIF output=L8_2019_05 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2019/LC08_L2SP_173055_20190308_20200829_02_T1_SR_B6.TIF output=L8_2019_06 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2019/LC08_L2SP_173055_20190308_20200829_02_T1_SR_B7.TIF output=L8_2019_07 extent=region resolution=region --overwrite
#
g.list rast
# raster metadata:
r.info -r L8_2019_07
# Set computational region to match the scene
g.region raster=L8_2019_01 -p
#north:      n=915615
#south:      s=683085
#west:       w=185985
#east:       e=414315
# grouping data by i.groupto store VIZ, NIR, MIR into group/subgroup (leaving out TIR)
i.group group=L8_2019 subgroup=res_30m \
  input=L8_2019_01,L8_2019_02,L8_2019_03,L8_2019_04,L8_2019_05,L8_2019_06,L8_2019_07
#
i.segment group=L8_2019 output=segs_L8_2019 threshold=0.90 minsize=100 --overwrite
#
# Mapping
d.mon wx0
g.region raster=segs_L8_2019 -p
r.colors segs_L8_2019 color=roygbiv -e
d.rast segs_L8_2019
d.legend raster=segs_L8_2019 title="2019" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=segs_L8_2019 format=jpg --overwrite
