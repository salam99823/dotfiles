# General wayland environment variables
export XDG_SESSION_TYPE=wayland

# OpenGL Variables
export GBM_BACKEND=nvidia-drm
export __GL_GSYNC_ALLOWED=0
export __GL_VRR_ALLOWED=0
export __GLX_VENDOR_LIBRARY_NAME=nvidia

# Xwayland compatibility
export XWAYLAND_NO_GLAMOR=1

# Most pure GTK3 apps use wayland by default, but some,
# such as Firefox, require the backend to be explicitly selected.
export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1
export GTK_CSD=0

# qt wayland
export QT_QPA_PLATFORM=xcb
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

#Java XWayland blank screens fix
export _JAVA_AWT_WM_NONREPARENTING=1

# set ozone platform to wayland
export ELECTRON_OZONE_PLATFORM_HINT=wayland
