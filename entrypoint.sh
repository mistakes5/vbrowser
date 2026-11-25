set -u
W=${VB_WIDTH:-1440} H=${VB_HEIGHT:-900}
Xvfb :99 -screen 0 ${W}x${H}x24 -nolisten tcp &
sleep 1
openbox &
# Watch/take-over view for a human: http://127.0.0.1:6080/vnc.html
x11vnc -display :99 -forever -shared -nopw -localhost -quiet &
websockify --web /usr/share/novnc 6080 localhost:5900 &
# Chromium only binds CDP to loopback; expose it to the published port.
socat TCP-LISTEN:9222,fork,reuseaddr TCP:127.0.0.1:9223 &
while true; do   # restart Brave if it exits or crashes
  brave-browser --user-data-dir=/home/agent/profile --remote-debugging-port=9223 \
    --no-sandbox --test-type --no-first-run --no-default-browser-check --disable-dev-shm-usage \
    --window-position=0,0 --window-size=${W},${H} --start-maximized about:blank
  sleep 2
done
