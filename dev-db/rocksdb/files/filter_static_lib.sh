#!/bin/sh

# This file removes all occurences of target RocksDB::rocksdb (static library) from
# installed CMake files

# name of static target
STT_NAME="RocksDB::rocksdb"

sed -f "$(dirname "$0")/filter_static_lib.sed" -i "$1" || exit 1

perl -pi -e 'BEGIN{undef $/;} s/set_target_properties\('"$STT_NAME"' [^)]+\)//mg; s/\n\n\n+/\n\n/mg' \
     "$1" || exit 1
