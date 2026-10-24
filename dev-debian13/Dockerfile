# 使用 Debian 13 精简版作为基础，保持系统最小化
FROM debian:trixie-slim

# 避免 apt 安装过程中交互式提示
ENV DEBIAN_FRONTEND=noninteractive

# ⭐ 0. 替换 apt 源为阿里云镜像（Debian 13 使用 deb822 格式）
#    先删除默认源文件，再写入阿里云源，保持官方签名 keyring 不变
RUN rm -f /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list && \
    cat > /etc/apt/sources.list.d/debian.sources <<'EOF'
Types: deb
URIs: http://mirrors.aliyun.com/debian
Suites: trixie trixie-updates
Components: main
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: http://mirrors.aliyun.com/debian-security
Suites: trixie-security
Components: main
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF

# 1. 基础工具与 SSH 服务（SSH 用于登录，git 等用于开发）
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    git \
    curl \
    wget \
    vim \
    nano \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. i3wm 桌面环境与 X11 相关组件（最小化安装）
RUN apt-get update && apt-get install -y --no-install-recommends \
    i3-wm \
    i3status \
    i3lock \
    suckless-tools \
    # --- 精简的 X11 核心与工具 ---
    xserver-xorg-core \
    xinit \
    x11-xserver-utils \
    xserver-xorg-video-dummy \
    # --- 终端 ---
    xterm \
    dbus \
    xrdp \
    && rm -rf /var/lib/apt/lists/*

# 3. 配置 SSH：允许 root 登录（仅开发环境），开启 X11 转发
RUN mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#X11Forwarding no/X11Forwarding yes/' /etc/ssh/sshd_config \
    && sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config \
    && echo "root:123456" | chpasswd   # ⚠️ 示例密码，请在构建后立即修改

# 4. 为 root 用户创建最小化的 i3 配置（启动后自动加载）
RUN mkdir -p /root/.config/i3 && \
    cat > /root/.config/i3/config <<'EOF'
# i3 最小配置
font pango:monospace 8
# 启动终端（Mod+Enter）
bindsym $mod+Return exec xterm
# 关闭窗口（Mod+Shift+q）
bindsym $mod+Shift+q kill
# 重启 i3（Mod+Shift+r）
bindsym $mod+Shift+r restart
# 退出 i3（Mod+Shift+e）
bindsym $mod+Shift+e exit
EOF

# 5. 可选：为 xrdp 设置默认会话为 i3（如果使用 xrdp）
RUN echo "exec i3" > /root/.xsession && chmod +x /root/.xsession

# 6. 启动 sshd 并保持容器运行
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
