FROM node:18-bullseye-slim

# Install prerequisites (wget, gnupg) and libraries Chrome needs
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      wget gnupg2 ca-certificates apt-transport-https \
      fonts-liberation libappindicator3-1 libxss1 lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Import Google's signing key and add the Chrome repo (use signed-by)
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub \
  | gpg --dearmor -o /usr/share/keyrings/google-archive-keyring.gpg && \
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-archive-keyring.gpg] \
    http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google.list

# Install Chrome
RUN apt-get update && \
    apt-get install -y --no-install-recommends google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Install the node tool
RUN npm i -g chrome-headless-render-pdf

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD []
