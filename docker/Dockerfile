# Imagen base ROS 2 Humble
FROM ros:humble-ros-base

SHELL ["/bin/bash", "-lc"]

# ---- Dependencias del sistema ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg2 lsb-release python3-pip \
    portaudio19-dev mesa-utils libgl1-mesa-glx libgl1-mesa-dri \
    ros-humble-rviz2 ros-humble-rmw-cyclonedds-cpp \
    software-properties-common ffmpeg \
 && rm -rf /var/lib/apt/lists/*

# ---- Evitar conflicto con numpy ----
RUN pip install --no-cache-dir 'numpy<2.0.0'

# ---- Usuario normal (rootless-friendly) ----
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid ${USER_GID} ${USERNAME} \
 && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
 && mkdir -p /ros2_ws && chown -R ${USERNAME}:${USERNAME} /ros2_ws

USER ${USERNAME}
WORKDIR /ros2_ws

# ---- Código del workspace ----
COPY --chown=${USERNAME}:${USERNAME} . /ros2_ws/src

# ---- Reqs Python del proyecto ----
RUN cd src && if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# ---- Dependencias ROS ----
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
 && rosdep update \
 && rosdep install --from-paths src --ignore-src -r -y

# ---- Compilación ----
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
 && colcon build --symlink-install

# ---- Añadir overlay al entrypoint base de ROS ----
USER root
RUN sed --in-place --expression '$isource "/ros2_ws/install/setup.bash"' /ros_entrypoint.sh
USER ${USERNAME}

# ---- Entorno por defecto ----
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
ENV ROBOT_IP=""
ENV CONN_TYPE="webrtc"
ENV WEBRTC_SERVER_HOST="0.0.0.0"
ENV WEBRTC_SERVER_PORT="9991"

# ---- Entrypoint + comando ----
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["ros2", "launch", "go2_robot_sdk", "robot.launch.py"]