#!/bin/sh
ext_ini_dir=/etc/php.d

[ -z "$DISABLE_EXTENSIONS" ] && [ -z "$ENABLE_EXTENSIONS" ] && return

disable_extension() {
    file=$(basename $1)
    mv -v $ext_ini_dir/$file $ext_ini_dir/$file.disabled
}

enable_extension() {
    file=$(basename $1 .disabled)
    mv -v $ext_ini_dir/$file.disabled $ext_ini_dir/$file
}

for ext in $DISABLE_EXTENSIONS; do
    [ -f $ext_ini_dir/???$ext.ini ] && disable_extension $(find $ext_ini_dir -name ???$ext.ini)
    [ -f $ext_ini_dir/$ext.ini ] && disable_extension $(find $ext_ini_dir -name $ext.ini)
done

for ext in $ENABLE_EXTENSIONS; do
    [ -f $ext_ini_dir/???$ext.ini.disabled ] && enable_extension $(find $ext_ini_dir -name ???$ext.ini.disabled)
    [ -f $ext_ini_dir/$ext.ini.disabled ] && enable_extension $(find $ext_ini_dir -name $ext.ini.disabled)
done
