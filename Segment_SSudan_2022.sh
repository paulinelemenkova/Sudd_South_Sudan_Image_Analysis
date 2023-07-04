#!/bin/sh
# 1. Import data
# listing the files
g.list rast
# importing the image subset with 7 Landsat bands and display the raster map
r.import input=/Users/polinalemenkova/grassdata/Sudan_2022/LC09_L2SP_173055_20220119_20230501_02_T1_SR_B1.TIF output=L9_2022_01 resample=bilinear extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2022/LC09_L2SP_173055_20220119_20230501_02_T1_SR_B2.TIF output=L9_2022_02 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2022/LC09_L2SP_173055_20220119_20230501_02_T1_SR_B3.TIF output=L9_2022_03 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2022/LC09_L2SP_173055_20220119_20230501_02_T1_SR_B4.TIF output=L9_2022_04 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2022/LC09_L2SP_173055_20220119_20230501_02_T1_SR_B5.TIF output=L9_2022_05 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2022/LC09_L2SP_173055_20220119_20230501_02_T1_SR_B6.TIF output=L9_2022_06 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/Sudan_2022/LC09_L2SP_173055_20220119_20230501_02_T1_SR_B7.TIF output=L9_2022_07 extent=region resolution=region --overwrite
#
#g.list rast
# raster metadata:
r.info -r L9_2022_07
# Set computational region to match the scene
g.region raster=L9_2022_01 -p
#north:      n=915615
#south:      s=683085
#west:       w=185985
#east:       e=414315
#  grouping data by i.group to store VIZ, NIR, MIR into group/subgroup (leaving out TIR)
i.group group=L9_2022 subgroup=res_30m \
  input=L9_2022_01,L9_2022_02,L9_2022_03,L9_2022_04,L9_2022_05,L9_2022_06,L9_2022_07
#
# Set the region
g.region -p raster=L9_2022_01
# Segmentation
i.segment group=L9_2022 output=segs_L9 threshold=0.90 minsize=100 --overwrite
#
# Mapping
d.mon wx0
g.region raster=L9_2022 -p
r.colors segs_L9 color=roygbiv -e
d.rast segs_L9
d.legend raster=segs_L9 title="2022" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=segs_L9 format=jpg --overwrite
