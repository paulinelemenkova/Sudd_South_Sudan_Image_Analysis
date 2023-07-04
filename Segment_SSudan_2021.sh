#!/bin/sh
# 1. Import data
# listing the files
g.list rast
# importing the image subset with 7 Landsat bands and display the raster map
r.import input=/Users/polinalemenkova/grassdata/Sudan_2021/LC08_L2SP_173055_20210329_20210408_02_T1_SR_B1.TIF output=L8_2022_01 resample=bilinear extent=region resolution=region --overwrite

r.import input=/Users/polinalemenkova/grassdata/Sudan_2021/LC08_L2SP_173055_20210329_20210408_02_T1_SR_B2.TIF output=L8_2021_02 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2021/LC08_L2SP_173055_20210329_20210408_02_T1_SR_B3.TIF output=L8_2021_03 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2021/LC08_L2SP_173055_20210329_20210408_02_T1_SR_B4.TIF output=L8_2021_04 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2021/LC08_L2SP_173055_20210329_20210408_02_T1_SR_B5.TIF output=L8_2021_05 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2021/LC08_L2SP_173055_20210329_20210408_02_T1_SR_B6.TIF output=L8_2021_06 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2021/LC08_L2SP_173055_20210329_20210408_02_T1_SR_B7.TIF output=L8_2021_07 extent=region resolution=region --overwrite
#
#g.list rast
# raster metadata:
r.info -r L8_2021_07
#
# Set computational region to match the scene
g.region raster=L8_2021_01 -p
#north:      n=915615
#south:      s=683085
#west:       w=185985
#east:       e=414315
# grouping data by i.group to store VIZ, NIR, MIR into group/subgroup (leaving out TIR)
i.group group=L8_2021 subgroup=res_30m \
  input=L8_2021_01,L8_2021_02,L8_2021_03,L8_2021_04,L8_2021_05,L8_2021_06,L8_2021_07
# segmentation
i.segment group=L8_2021 output=segs_L8_2021 threshold=0.90 minsize=100 --overwrite
# Mapping
d.mon wx0
g.region raster=segs_L8_2021 -p
r.colors segs_L8_2021 color=roygbiv -e
d.rast segs_L8_2021
d.legend raster=segs_L8_2021 title="2021" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=segs_L9 format=jpg --overwrite
