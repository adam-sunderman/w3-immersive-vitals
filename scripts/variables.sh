#!/bin/bash

# Game variables
GAME_PATH="G:/GOG/The Witcher 3 Wild Hunt GOTY"
BIN_FOLDER_NAME="x64"
W3_USER_SETTINGS_PATH="C:/Users/amsun/Documents/The Witcher 3"

# mod vars
NEXUS_MOD_ID=7609
MOD_NAME=modImmersiveVitals
RELEASE_NAME=ImmersiveVitals

# ensure prehooks are set up :)
git config --local core.hooksPath .githooks

# do not update anything below this line
pushd ..
MOD_PATH=`pwd`
popd