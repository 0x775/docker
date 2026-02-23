#!/bin/bash
#动态调整VNC分辨率
vncserver -kill :1
sudo -u debian /usr/bin/vncserver :1 -geometry $1 -depth 24 -localhost no


#TODO...  ./vnc-resize 1680x1050
