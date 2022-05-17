#!/bin/bash

# Make sure we are on MacOS
if [[ $OSTYPE != 'darwin'* ]]; then
    echo "This script only works on MacOS"
    exit 1
fi

WATERFOX_URL="https://cdn.waterfox.net/releases/osx64/installer/Waterfox%20G3.2.6%20Setup.dmg"
CLEAN_FLASH_URL="https://github.com/darktohka/clean-flash-builds/releases/download/v1.25/ChineseFlash-NPAPI-FlashPlayer-10.6.zip"

# Create a temporary directory
temp_dir=$(mktemp -d)

# https://stackoverflow.com/a/185900
cleanup() {
  sudo rm -rf $temp_dir
}

trap cleanup 0

error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}

trap 'error ${LINENO}' ERR

get_version() {
    echo $(plutil -extract CFBundleShortVersionString xml1 -o - "$1/Contents/Info.plist" | sed -n "s/.*<string>\(.*\)<\/string>.*/\1/p")
}

download_waterfox() {
    echo "=> Downloading Waterfox G3.2.6..."
    curl -# -L $WATERFOX_URL > $temp_dir/waterfox.dmg

    echo "- Mounting installer"
    volume_list=$(sudo hdiutil attach $temp_dir/waterfox.dmg | grep Volumes)
    volume=$(echo "$volume_list" | cut -f 3)
    
    echo "- Installing Waterfox"
    sudo cp -rf "$volume"/*.app /Applications
    
    echo "- Removing installer"
    sudo hdiutil unmount "$volume"/*.app

    echo "- Disabling automatic updates for Waterfox"
    sudo defaults write /Library/Preferences/net.waterfox.waterfox EnterprisePoliciesEnabled -bool TRUE
    sudo defaults write /Library/Preferences/net.waterfox.waterfox DisableAppUpdate -bool TRUE
}

# Check if Waterfox is already installed or not
if [ $(mdfind -name 'Waterfox.app') ]; then
    waterfox_version=$(get_version /Applications/Waterfox.app)
    
    if [ "$waterfox_version" == "78.14.0" ]; then
        echo "Waterfox already installed. Skipping download."
    else
        echo "Waterfox already installed but the verion is different."
        download_waterfox
    fi
else
    download_waterfox
fi

echo "=> Downloading Clean Flash 34.0.0.242"
curl -# -L $CLEAN_FLASH_URL > $temp_dir/cleanflash.zip

echo "- Extracting and copying plugins"
sudo unzip -q "$temp_dir"/cleanflash.zip -d "$temp_dir"/plugins/

sudo cp -R "$temp_dir"/plugins/. "$HOME/Library/Internet Plug-Ins/"
sudo cp -R "$temp_dir"/plugins/. "/Library/Internet Plug-Ins/"

# Delete temporary directory
sudo rm -rf $temp_dir

echo "Done. Enjoy!"