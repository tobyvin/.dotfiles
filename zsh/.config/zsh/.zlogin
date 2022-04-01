export DISPLAY=':0'
export WAYLAND_DISPLAY=0
export XDG_SESSION_TYPE=wayland

systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_SESSION_TYPE

if command -v dbus-update-activation-environment >/dev/null 2>&1; then
  dbus-update-activation-environment DISPLAY WAYLAND_DISPLAY XDG_SESSION_TYPE
fi