#!/bin/bash

sysOpt=(all finish) # system options
unbuildableImages=(influxdb)
imgFolders=( "2smart-emqx:services/emqx" "2smart-ui:apps/ui" "dummy-device:bridges/dummy-device" "client-dashboard-be:apps/be" "influxdb:services/influx" "time-series-service:apps/time-series" "scenario-runner:apps/scenario-runner" "2smart-mysql:services/mysql" "ssl-certs:apps/ssl-service" "2smart-nginx:services/nginx" "2smart-heartbeat:apps/heartbeat" "2smart-core:apps/core" "perfect-device:bridges/perfect-device" "backup-service:apps/backup" "2smart-filebeat:services/filebeat" "2smart-updater:apps/updater" "2smart-updater-manager:apps/updater-manager" "2smart-acl:apps/acl" )

imgArr=(all 2smart-emqx 2smart-ui dummy-device client-dashboard-be influxdb time-series-service scenario-runner 2smart-mysql ssl-certs 2smart-nginx 2smart-heartbeat 2smart-core perfect-device backup-service 2smart-filebeat 2smart-updater 2smart-updater-manager 2smart-acl finish) # list of all images
choices=()

## Function to remove unbuildable images from list
removeUnbuildableImages() {
  local _arg=$@
  for el in ${unbuildableImages[@]}; do
    _arg=( "${_arg[@]/$el}" )
  done

  echo "$_arg"
}

## Function to remove system options from list of images
removeSysOpt() {
  local _arg=$@

  for el in ${sysOpt[@]}; do
    _arg=( "${_arg[@]/$el}" )
  done

  echo "$_arg"
}

createEmptyDirs() {
  for el in "${imgFolders[@]}" ; do
    VALUE="${el##*:}"
    mkdir -p ../$VALUE
  done
}

selectImgList() {
  local _arg=($@)

  select choice in "${_arg[@]}"
  do
    # Stop choosing on this option
    [[ $choice = 'finish' ]] && break
    [[ $choice = 'all' ]] && break
    # Append the choice to the array
    choices+=( "$choice" )
    printf "You selected the following: " >&2 # print to stdout
    for choice in "${choices[@]}"
    do
      printf "%s " "$choice" >&2 # print to stdout
    done
    printf '\n' >&2 # print to stdout
  done

  if [ $choice = 'all' ]
  then
    shifted=$(removeSysOpt "${_arg[@]}")
    shifted=$(echo "${shifted[@]}")

    echo "$shifted"
  else
    echo "${choices[@]}"
  fi
}

createEmptyDirs

if [ ! -e .env ]
then
  while true; do
    read -p ".env file does not exists. Would you like to create default dev version?[Y/n]" yn
    case $yn in
      [Yy]* )
        cp .env.sample .env
        echo ".end file has been created"
        break
      ;;
      [Nn]* ) echo "Ok, skip" ; break;;
      * ) echo "Please answer yes or no.";;
    esac
  done
fi


# Function call for build/up stages
if [[ $1 = 'build' ]]
then
  buildOnlyImages=$(removeUnbuildableImages "${imgArr[@]}")
  imgList=$(selectImgList "${buildOnlyImages[@]}")
  docker-compose -f docker-compose.yml -f docker-compose.develop.yml build $imgList
elif [[ $1 = 'down' ]]
then
  ## Stop old containers
  docker-compose -f docker-compose.yml -f docker-compose.develop.yml down
elif [[ $1 = 'pull' ]]
then
  imgList=$(selectImgList "${imgArr[@]}")
  docker-compose -f docker-compose.yml -f docker-compose.develop.yml pull $imgList
elif [[ $1 = 'up' ]]
then
  imgList=$(selectImgList "${imgArr[@]}")
  docker-compose -f docker-compose.yml -f docker-compose.develop.yml up -d --force-recreate --remove-orphans $imgList
elif [[ $1 = 'up-prod' ]]
then
  imgList=$(selectImgList "${imgArr[@]}")
  docker-compose -f docker-compose.yml up -d --force-recreate --remove-orphans $imgList
else
  echo "Wrong option! Valid options: build, pull, down, up"
fi

exit 0
