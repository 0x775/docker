docker run -d \
  -p 2222:22 \
  -p 5901:5901 \
  -e VNC_MODE=1 \
  -e VNC_PASS=123456 \
  --name my-container i3wm-dev
