docker exec -it \
  -e HOME=/work \
  -e ROS_HOME=/work/.ros \
  -e ROS_LOG_DIR=/work/.ros/log \
  ros1_noetic_dev \
  bash -lc 'source /opt/ros/noetic/setup.bash; bash'

