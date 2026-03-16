FROM node:22-bookworm-slim

# System dependencies for Chromium
RUN apt-get update && apt-get install -y --no-install-recommends \
    libasound2 \
    libatk-bridge2.0-0 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    libxss1 \
    fonts-liberation \
    fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/*

# Install @playwright/cli globally
RUN npm install -g @playwright/cli@latest

# Install Chromium browser binary
RUN npx playwright install chromium

# playwright-cli defaults to "chrome" channel at /opt/google/chrome/chrome;
# symlink the bundled Chromium there so it works out of the box
RUN mkdir -p /opt/google/chrome \
    && CHROMIUM_DIR=$(find /root/.cache/ms-playwright/chromium-* -name 'chrome-linux' -type d | head -1) \
    && ln -s "$CHROMIUM_DIR/chrome" /opt/google/chrome/chrome

# Default config: use chrome channel with sandbox disabled (required in Docker)
RUN printf '{\n  "browser": {\n    "browserName": "chromium",\n    "launchOptions": {\n      "channel": "chrome",\n      "chromiumSandbox": false,\n      "args": ["--ignore-certificate-errors"]\n    },\n    "contextOptions": {\n      "ignoreHTTPSErrors": true,\n      "viewport": { "width": 1920, "height": 1080 }\n    }\n  }\n}\n' > /etc/playwright-cli.config.json

WORKDIR /work

ENTRYPOINT ["playwright-cli", "--config", "/etc/playwright-cli.config.json"]
