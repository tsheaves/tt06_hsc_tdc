#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export OPENLANE_ROOT=${SCRIPT_DIR}/tt/openlane
export PDK_ROOT=${SCRIPT_DIR}/tt/pdk
export PDK=sky130A
export OPENLANE_TAG=2023.11.23
export OPENLANE_IMAGE_NAME=efabless/openlane:2023.11.23

