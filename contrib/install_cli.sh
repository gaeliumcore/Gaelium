 #!/usr/bin/env bash

 # Execute this file to install the gaelium cli tools into your path on OS X

 CURRENT_LOC="$( cd "$(dirname "$0")" ; pwd -P )"
 LOCATION=${CURRENT_LOC%Gaelium-Qt.app*}

 # Ensure that the directory to symlink to exists
 sudo mkdir -p /usr/local/bin

 # Create symlinks to the cli tools
 sudo ln -s ${LOCATION}/Gaelium-Qt.app/Contents/MacOS/gaeliumd /usr/local/bin/gaeliumd
 sudo ln -s ${LOCATION}/Gaelium-Qt.app/Contents/MacOS/gaelium-cli /usr/local/bin/gaelium-cli
