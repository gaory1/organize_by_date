#!/bin/bash -e

src_dir=$1
dst_dir=$2
trash=$3

test -z "$src_dir" -o -z "$dst_dir" && echo "usage: $0 <source directory> <dest directory> [trash]" && exit 1

if test -z "$trash"
then
	trash=./trash
fi

find $src_dir -type f | while read f
do
	ext=$(echo "$f" | awk -F . '{print toupper($NF)}')
	if test "$ext" = "JPG" -o "$ext" = "JPEG" -o "$ext" = "jpg" -o "$ext" = "jpeg"
	then
		read year month day <<<$(exiv2 pr "$f" 2>/dev/null | awk '/timestamp/{split($4,a,":"); print a[1],a[2],a[3]}')
	fi
	if test -z "$day"
	then
		read year month day <<<$(stat "$f" 2>/dev/null | awk '/Modify/{split($2,a,"-"); print a[1],a[2],a[3]}')
		if test -z "$day"
		then
			echo $f no date
			continue
		fi
	fi

	test -e $dst_dir/$year/$year-$month || mkdir -p $dst_dir/$year/$year-$month
	dst=$dst_dir/$year/$year-$month/$(basename "$f")
	/bin/mv -n "$f" "$dst"
	if test ! -e "$f"
	then
		echo "$f -> $dst"
	else
		src_size=$(stat -c %s "$f")
		dst_size=$(stat -c %s "$dst")
		if test $src_size == $dst_size
		then
			trash_dir=$trash/$(dirname "$f")
			test -e "$trash_dir" || mkdir -p "$trash_dir"
			/bin/mv "$f" "$trash/$f"
			echo "$f -> $trash/$f"
		else
			echo "Conflict: $f $dst" >&2
		fi
	fi
done