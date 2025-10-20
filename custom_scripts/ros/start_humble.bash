#!/usr/bin/env bash
set -Eeuo pipefail

# Defaults (override by exporting env vars before running)
ROOT_DIR="${ROOT_DIR:-$HOME/Development/RIT/EEEE685}"   # host path mounted into container
WS_REL="${WS_REL:-ros2_ws}"                              # subfolder under ROOT_DIR
IMAGE="${ROS2_IMAGE:-osrf/ros:humble-desktop}"           # or osrf/ros:humble-desktop-full
NAME="${NAME:-ros2_humble_dev}"

# Allow overrides via CLI: run_humble.sh [ROOT_DIR] [WS_REL]
[[ $# -ge 1 ]] && ROOT_DIR="$1"
[[ $# -ge 2 ]] && WS_REL="$2"

HOST_UID="$(id -u)"
HOST_GID="$(id -g)"

# Ensure workspace exists (and has a src dir for colcon)
mkdir -p "${ROOT_DIR}/${WS_REL}/src"

# (Fix a possible trailing brace typo if copy/paste fails)
if [[ "${ROOT_DIR}/${WS_REL}" == *"}" ]]; then
  WS_REL="${WS_REL%\}}"
  mkdir -p "${ROOT_DIR}/${WS_REL}/src"
fi

echo "Launching ROS2 Humble in Docker"
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
  "${IMAGE}" \
  bash -lc 'source /opt/ros/humble/setup.bash; echo "ROS2 Humble ready in /work/'"${WS_REL}"'"; exec bash'

