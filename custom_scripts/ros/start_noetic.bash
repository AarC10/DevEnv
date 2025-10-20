#!/usr/bin/env bash
set -Eeuo pipefail

# Defaults (override by exporting env vars before running)
ROOT_DIR="${ROOT_DIR:-$HOME/Development/RIT/EEEE685}"   # host path mounted into container
WS_REL="${WS_REL:-ros1_ws}"                              # subfolder under ROOT_DIR
IMAGE="${ROS1_IMAGE:-osrf/ros:noetic-desktop-full}"      # change to -desktop if you prefer
NAME="${NAME:-ros1_noetic_dev}"

# Allow overrides via CLI: run_noetic.sh [ROOT_DIR] [WS_REL]
[[ $# -ge 1 ]] && ROOT_DIR="$1"
[[ $# -ge 2 ]] && WS_REL="$2"

HOST_UID="$(id -u)"
HOST_GID="$(id -g)"

# Ensure workspace exists (and has a src dir for catkin)
mkdir -p "${ROOT_DIR}/${WS_REL}/src"

echo "Launching ROS1 Noetic in Docker"
echo "  Image:      ${IMAGE}"
echo "  Host root:  ${ROOT_DIR}"
echo "  Workspace:  ${WS_REL}  (=> /work/${WS_REL} in container)"
echo

exec docker run -it --rm \
  --name "${NAME}" \
  --net=host --ipc=host \
  --user "${HOST_UID}:${HOST_GID}" \
  -e "DISPLAY=${DISPLAY:-}" \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v /etc/passwd:/etc/passwd:ro \
  -v /etc/group:/etc/group:ro \
  -v "${ROOT_DIR}:/work" \
  -w "/work/${WS_REL}" \
  -e HOME=/work \
  -e ROS_HOME=/work/.ros \
  -e ROS_LOG_DIR=/work/.ros/log \
  --device=/dev/ttyUSB0:/dev/ttyUSB0 \
  "${IMAGE}" \
  bash -lc 'source /opt/ros/noetic/setup.bash; echo "ROS1 Noetic ready in /work/'"${WS_REL}"'"; exec bash'

