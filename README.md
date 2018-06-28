# organize_by_date
按照日期整理照片。Organize photos by date.


用法:

./organize_by_date.sh source_directory dest_directory [trash]

举例:

./organize_by_date.sh ~/Pictures ./repo

照片会被放到这样的目录中：./repo/2017/2017-01/.

而重复的文件放在./trash目录, 请检查后手工删除.

软件包'exiv2'用来提取照片真实日期. 在Ubuntu上安装:

sudo apt install exiv2

-----------------------------------

Usages:

./organize_by_date.sh source_directory dest_directory [trash]

Example:

./organize_by_date.sh ~/Pictures ./repo

It will move the photos into directories like ./repo/2017/2017-01/.

Duplicate files are put into ./trash, which should be examined and manually removed later.

The package 'exiv2' is used to help extract the real date of the photo. To install it on Ubuntu:

sudo apt install exiv2
