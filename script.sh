#!/bin/bash

export KEY=$(cat key.txt)
export VIDEOS=$(cat input.txt)
export PAID_URL="http://media.railscasts.com/assets/subscriptions"
export FREE_URL="http://media.railscasts.com/assets/episodes/videos"

# green echo
function green {
  echo -e "\033[0;32m${@}\033[0m"
}

# red echo
function red {
  echo -e "\033[0;31m${@}\033[0m"
}

function bold {
  echo -e "\033[1;30m${@}\033[0m"
}

# Custom wget command, with continue and quiet options, as well path specification
function _wget {
  wget -c ${1} -P videos --quiet
}

# function which is responsible to download free eps
function download_free_ep {
  _wget "${PAID_URL}/${KEY}/videos/${1}.mp4"
}

# function which is responsible to download paid/pro/etc eps
function download_paid_ep {
  _wget "${FREE_URL}/${1}.mp4"
}

# treat erros, logging files which doesn't download to an errors.txt file
function error_treatment {
  if (( $? == 0 )); then
    green "---> 🍺  Successfully downloaded ${1}!"
  else
    red "---> 😭  Fail to download ${1} =("
    echo ${0} >> errors.txt
  fi
}

# try to download an Ep
function download_ep {
  download_free_ep ${1} || download_paid_ep ${1}
  error_treatment ${1}
}

# Main function
function main {
  bold "Downloading $(cat input.txt | wc -l) videos...\n\n"

  for video in $VIDEOS; do
    bold "\nDownloading ${video}..."
    download_ep $video
  done

  green "All done!"
}

# RUN FORREST RUN!
main