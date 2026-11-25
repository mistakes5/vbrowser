# Isolated GUI browser for agents: Brave on a virtual X display (Xvfb).
# Agent input (xdotool) and windows live only on this display, never on the Mac's.
FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg xvfb openbox x11vnc novnc websockify \
      xdotool scrot socat fonts-noto-core fonts-noto-cjk fonts-noto-color-emoji \
 && curl -fsSLo /usr/share/keyrings/brave.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/brave.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" > /etc/apt/sources.list.d/brave.list \
 && apt-get update && apt-get install -y --no-install-recommends brave-browser \
 && rm -rf /var/lib/apt/lists/* \
 && useradd -m -s /bin/bash agent && install -d -o agent -g agent /home/agent/profile
COPY entrypoint.sh /entrypoint.sh
USER agent
ENV DISPLAY=:99
EXPOSE 9222 6080
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
