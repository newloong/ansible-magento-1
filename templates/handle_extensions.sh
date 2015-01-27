#!/bin/bash

new_extensions="{%  for item in magento_modman_extensions_git  %} {{item.dest}}/{{item.subdir|default('')}} {% endfor %} {%  for item in magento_modman_extensions_other  %} {{item.dest}}/{{item.subdir|default('')}} {% endfor %}"

for file in $(ls -l {{ magento_root }}/.modman/ | awk ' {print $11}'); do
  in_file=0;
  for nfile in $new_extensions; do
    if [ "$file" = "$nfile/" ]; then
      in_file=1;
    fi
  done
  if [ $in_file -eq 0 ]; then
    rm -f {{ magento_root }}/.modman/$(basename $file);
  fi
done


for nfile in $new_extensions; do
  if [ ! -h {{ magento_root }}/.modman/$(basename $nfile) ]; then
    cd {{ magento_root }}
    {{ magento_modman_bin_dir }}/modman link $nfile
  fi
done
