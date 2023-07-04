#!/bin/sh
# 1. Import data
# listing the files
g.list rast
# importing the image subset with 7 Landsat bands and display the raster map
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC09_L2SP_173055_20230514_20230516_02_T1_SR_B1.TIF output=L9_2023_01 resample=bilinear extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC09_L2SP_173055_20230514_20230516_02_T1_SR_B2.TIF output=L9_2023_02 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC09_L2SP_173055_20230514_20230516_02_T1_SR_B3.TIF output=L9_2023_03 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC09_L2SP_173055_20230514_20230516_02_T1_SR_B4.TIF output=L9_2023_04 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC09_L2SP_173055_20230514_20230516_02_T1_SR_B5.TIF output=L9_2023_05 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC09_L2SP_173055_20230514_20230516_02_T1_SR_B6.TIF output=L9_2023_06 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/SSudan/LC09_L2SP_173055_20230514_20230516_02_T1_SR_B7.TIF output=L9_2023_07 extent=region resolution=region
#
g.list rast
# raster metadata:
r.info -r L9_2023_07
#
# Set computational region to match the scene
g.region raster=L9_2023_01 -p
#north:      n=915615
#south:      s=683085
#west:       w=185985
#east:       e=414315
# grouping data by i.group to store VIZ, NIR, MIR into group/subgroup (leaving out TIR)
i.group group=L9_2023 subgroup=res_30m \
  input=L9_2023_01,L9_2023_02,L9_2023_03,L9_2023_04,L9_2023_05,L9_2023_06,L9_2023_07
#
# Segmentation. Threshold should be > 0 and < 1
# i.segment group=L9_2023 output=segs_L9 threshold=0.30 minsize=100
# i.segment group=L9_2023 output=segs_L9 threshold=0.90 minsize=100 --overwrite
i.segment group=L9_2023 output=segs_L9_2 threshold=0.05 seeds=segs_L9 minsize=100 iterations=10
#
# Mapping
d.mon wx0
g.region raster=segs_L9 -p
r.colors segs_L9 color=roygbiv -e
d.rast segs_L9
d.legend raster=segs_L9 title="2023" title_fontsize=12 font="Helvetica" fontsize=10 bgcolor=white border_color=white
d.out.file output=segs_L9 format=jpg --overwrite
