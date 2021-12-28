#!/bin/bash

# Build artefacts required by http://download.xcsoar.org/.

# Halt on errors:
set -e

# Check for arguments
if [ $# -eq 0 ]; then
    echo "No arguments provided:"
    echo "USAGE:"
    echo "$0 OUTPUT_DIR"
    echo -n "" 
    exit 1
fi

## Output directory:
OUT="${1}"

# Create DIR structure
mkdir -p "${OUT}"
mkdir -p "${OUT}"/airspace/{0_META,country,region,global}
mkdir -p "${OUT}"/waypoint/{0_META,country,region,global}
mkdir -p "${OUT}"/map/{0_META,country,region,global}

# Rsync static content
rsync -apt data/content/ ${OUT}/

# Web site artefacts: waypoints
./script/build/waypoints_js.py  data/content/waypoint/country/ "${OUT}/waypoint/0_META/"

# Concatenate all waypoints to xcsoar-waypoints.cup
for each in $(find data/content/waypoint/ -name "*.cup")
  do
    cat "${each}" | sort -b > "${OUT}/waypoint/global/xcsoar_waypoints.cup"
done

# Web site artefacts: maps
./script/build/maps_config_js.py "${OUT}/map/0_META/"

# XCSoar App's manifest file (https://download.xcsoar.org/repository)
./script/build/repository.py "${OUT}"