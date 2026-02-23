#!/bin/bash
# 获取输入参数
NEW_RES=$1

if [ -z "$NEW_RES" ]; then
    echo "使用方法: vnc-resize 1680x1050"
    exit 1
fi

echo ">>> 正在调整 VNC 分辨率为: $NEW_RES ..."

vncserver -kill :1
/usr/bin/vncserver :1 -geometry "$NEW_RES" -depth 24 -localhost no -SecurityTypes VncAuth --I-KNOW-THIS-IS-INSECURE

# 3. 等待 X Server 初始化完成
sleep 3.5

# 4. 关键步骤：强制重新加载 .Xresources 并校正字符间距
# 这里我们直接将间距参数注入内存
export DISPLAY=:1
if [ -f "$HOME/.Xresources" ]; then
    xrdb -remove && xrdb -load "$HOME/.Xresources"
else
    echo "=========================================="
fi

# 5. 通知 i3wm 重启以适配新屏幕尺寸
i3-msg restart > /dev/null 2>&1

echo ">>> 调整完成！请重新连接 VNC 客户端。"

