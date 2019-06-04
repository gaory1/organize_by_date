# organize_by_date
按照日期整理照片。Organize photos by date.


用法:

./organize_by_date.sh source_dir photo_base_dir     # dry run

./organize_by_date.sh source_dir photo_base_dir -y  # run

举例:

./organize_by_date.sh ~/Pictures ./repo     # 查看执行效果

./organize_by_date.sh ~/Pictures ./repo -y  # 确认执行

照片会被放到这样的目录中：./repo/2017/01/.

*请注意: 如果确认执行, 那么重复的文件会被删除!*

软件包exiv2和libimage-exiftool-perl用来提取照片和视频上的真实日期. 在Ubuntu上安装:

sudo apt install -y exiv2

sudo apt install -y libimage-exiftool-perl

-----------------------------------

Usages:

./organize_by_date.sh source_dir photo_base_dir # dry run

./organize_by_date.sh source_dir photo_base_dir -y # run

Example:

./organize_by_date.sh ~/Pictures ./repo # dry run

./organize_by_date.sh ~/Pictures ./repo -y # confirm to run

It will move the photos into directories like ./repo/2017/01/.

*Caution: Duplicate files will be removed if confirmed to run!*

The package 'exiv2' and 'libimage-exiftool-perl' are used to help extract the real date of the photo. To install them on Ubuntu:

sudo apt install -y exiv2

sudo apt install -y libimage-exiftool-perl
