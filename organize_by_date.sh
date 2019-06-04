#!/bin/bash

src_dir=$1
base_dir=$2
opt=$3

which exiv2 >/dev/null || (echo "exiv2 not found" && exit 1)
which exiftool >/dev/null || (echo "exiftool not found" && exit 1)

if test -z "$src_dir" -o -z "$base_dir"; then
    echo "usage:"
    echo "$0 <source dir> <photo base dir>     # dry run"
    echo "$0 <source dir> <photo base dir> -y  # run"
    exit 1
fi

find $src_dir -maxdepth 1 -type f | while read f
do
    filename=$(basename "$f")
    test "$filename" == Thumbs.db && continue

    ext=$(echo "$filename" | awk -F . '{print toupper($NF)}')
    test -z "$ext" && continue

    basename=$(basename "$filename" .$ext)
    
    day=""
    if test "$ext" = "JPG" -o "$ext" = "JPEG" -o "$ext" = "jpg" -o "$ext" = "jpeg"
    then
        read year month day <<<$(exiv2 pr "$f" 2>/dev/null | awk '/timestamp/{split($4,a,":"); print a[1],a[2],a[3]}')
        if test -n "$day"; then
            date_from='metadata'
        fi
    elif test "$ext" = mov -o "$ext" = MOV -o "$ext" = 3gp -o "$ext" = 3GP; then
        read year month day <<<$(exiftool "$f" | grep '^Create Date' | head -n1 | awk '{split($4,a,":"); print a[1],a[2],a[3]}')
        if test -n "$day"; then
            date_from='metadata'
        fi
    fi
    if test -z "$day"; then
        if [[ "$filename" =~ ^[12][0-9][0-9][0-9]\-[0-9][0-9]\-[0-9][0-9] ]]; then
            read year month day <<<$(sed 's/^\([0-9]*\)\-\([0-9]*\)\-\([0-9]*\).*$/\1 \2 \3/' <<<"$filename")
            if test -n "$day"; then
                date_from='by name'
            fi
        elif [[ "$filename" =~ ^[0-9][0-9]\-[0-9][0-9]\-[0-9][0-9] ]]; then   
            read year month day <<<$(sed 's/^\([0-9]*\)\-\([0-9]*\)\-\([0-9]*\).*$/\1 \2 \3/' <<<"$filename")
            year=$[$year+2000]
            if test -n "$day"; then
                date_from='by name'
            fi
        fi
    fi
    if test -z "$day"; then
        continue
    fi

    #dst_dir="$base_dir/$year/$year-$month"
    dst_dir="$base_dir/$year/$month"

    if test "$opt" = -y; then
        test -e "$dst_dir" | mkdir -p "$dst_dir"
    fi

    dst="$dst_dir/$filename"

    echo
    echo "src: $f"
    echo "date: $year-$month-$day ($date_from)"

    # no move
    if test "$(realpath "$f")" = "$(realpath -m "$dst")"; then
        echo "action: none"
        continue
    fi

    # simple move
    if test ! -e "$dst"; then
        echo "action: move to $dst"
        test "$opt" = -y && /bin/mv -n "$f" "$dst"
        continue
    fi

    # remove duplicate
    if diff -q "$f" "$dst" >/dev/null; then
        echo "action: delete, duplicate of $dst"
        test "$opt" = -y && /bin/rm "$f"
        continue
    fi
    
    # move and rename
    for i in {0..9}; do
        dst="$dst_dir/${basename}_$i.$ext"
        test ! -e "$dst" && break
    done
    if test -e "$dst"; then
        dst=$(mktemp -u "$dst_dir/${basename}_XXX.$ext")
    fi
    echo "action: rename to $dst"
    test "$opt" = -y && /bin/mv -n "$f" "$dst"
done

