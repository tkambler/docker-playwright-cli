# docker-playwright-cli

A Docker image that packages the [`@playwright/cli`](https://www.npmjs.com/package/@playwright/cli) npm tool with Chromium pre-installed. Provides a `playwright-cli` wrapper script that makes it feel like a native command on your host machine.

Use it to visit web pages, capture screenshots, generate PDFs, record videos, and more — all from the command line via a headless Chromium instance running inside Docker.

## Prerequisites

- Docker
- `~/bin` or `~/.local/bin` must exist and be in your `$PATH`

## Setup

Build the image and install the wrapper script:

```bash
./install
```

This builds the `tkambler/playwright-cli` Docker image (if not already built) and installs a `playwright-cli` wrapper to your PATH.

## Usage

The CLI is session-based. Open a browser first, then run commands against it:

```bash
# Open a page
playwright-cli open https://example.com

# Take a screenshot
playwright-cli screenshot

# Navigate to another page
playwright-cli goto https://google.com

# Generate a PDF
playwright-cli pdf

# Close the browser and clean up the container
playwright-cli close-all
```

Screenshots, PDFs, and other output files are saved to a `.playwright-cli/` directory in your current working directory.

Run `playwright-cli --help` to see all available commands.

## How it works

The wrapper script manages a long-lived Docker container (`playwright-cli-session`) behind the scenes. The first command starts the container; subsequent commands are sent to it via `docker exec`. Running `close-all` or `kill-all` stops the container.
