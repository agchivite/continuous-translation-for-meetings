# Continuous Translation for Meetings

## Project Overview

This project is designed to facilitate events like TED Talks, conferences, meetings, and similar gatherings where a host (speaker) creates a room and others join as guests. The host speaks in one language, and guests can choose to receive translations in their preferred language. The system currently supports a 32-bit ARMv7 architecture, with plans to expand to a 64-bit architecture in the future.

## Server Deployment (Raspberry Pi OS - Legacy 32-bit)

### Overview

The server component is responsible for managing rooms created by the host. Once a room is created, guests can join and select their preferred translation.

![Gif](./docs/host_gif.gif)

<video src="./docs/full_host.mp4" controls width="600"></video>

### Deployment Steps

1. **Navigate to the Server Directory:**

    - Move to the `back` directory in your project.

2. **Launch the Server:**

    - Use Docker Compose to start the server with the `docker-compose.yml` file.

    ```bash
    docker-compose up -d
    ```
