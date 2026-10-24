#!/bin/bash
set -e

# 启动 SSH 服务
/usr/sbin/sshd -D &

# 如果安装了 xrdp，也启动 xrdp（可选）
if command -v xrdp >/dev/null 2>&1; then
    /usr/sbin/xrdp &
fi

# 保持容器在前台运行
tail -f /dev/null
