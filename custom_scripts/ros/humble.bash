docker exec -it \
  -e HOME=/work \
  -e ROS_HOME=/work/.ros \
  -e ROS_LOG_DIR=/work/.ros/log \
  ros2_humble_dev \
  bash -lc 'source /opt/ros/humble/setup.bash; bash'

