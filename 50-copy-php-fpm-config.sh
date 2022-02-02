config_path=/config
php_base_path=/etc
fpm_conf_dir=php-fpm.d
php_conf_dir=php.d
zts_conf_dir=php-zts.d
php_inst_conf_file=php-fpm.conf

[ -d $config_path ] || return

for f in $config_path/*; do
    [ -f "$f" ] || continue
    filename=$(basename $f)

    case "$filename" in
        php.ini)
            cp -v $f $php_base_path/
            ;;
        php-zts.d-*.ini)
            [ -d "$zts_conf_dir" ] || continue
            fn=$(echo $filename | sed "s/php-zts\.d-//")
            cp -v $f $php_base_path/$zts_conf_dir/$fn
            ;;
        php.d-*|*.ini)
            fn=$(echo $filename | sed "s/php\.d-//")
            cp -v $f $php_base_path/$php_conf_dir/$fn
            ;;
        $php_inst_conf_file)
            cp -v $f $php_base_path/
            ;;
        php-fpm.d-*.conf|*.conf)
            fn=$(echo $filename | sed "s/php-fpm\.d-//")
            cp -v $f $php_base_path/$fpm_conf_dir/$fn
            ;;
    esac
done
