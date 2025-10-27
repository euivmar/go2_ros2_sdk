#!/usr/bin/env bash
set -e

# Fuente de ROS 2 y del workspace (el Dockerfile ya inyecta el overlay en /ros_entrypoint.sh)
if [ -f "/opt/ros/${ROS_DISTRO}/setup.bash" ]; then
  source "/opt/ros/${ROS_DISTRO}/setup.bash"
fi
if [ -f "/ros2_ws/install/setup.bash" ]; then
  source "/ros2_ws/install/setup.bash"
fi

exec "$@"
