#!/bin/bash
LAYER_NAME=cognito_nodejs_layer

set -eo pipefail
if [ ! -f package.json ]; then
  echo "Initializin project..."
  npm init -y
fi

echo "Installing libraries..."
npm install axios


echo "Moving layer parts into a separe directory..."
if [ ! -d $LAYER_NAME ]; then
  mkdir $LAYER_NAME
fi
cp *.json $LAYER_NAME/
cp -r node_modules $LAYER_NAME/

