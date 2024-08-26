# Continuous Translation for Meetings

## Project Overview

This project is designed to facilitate events like TED Talks, conferences, meetings, and similar gatherings where a host (speaker) creates a room and others join as guests. The host speaks in one language, and guests can choose to receive translations in their preferred language. The system currently supports a 32-bit ARMv7 architecture, with plans to expand to a 64-bit architecture in the future.

---

## Host and Guest Responsibilities (Frontend)

**Note:** The GIF visual demonstrations provide a bad quality of the video, please see YouTube links for better quality and audio translation.

### Host Responsibilities

1. **Deploy the Web Application:**

    - The host interface is a web application that should be deployed on an Web server, I used Nginx.

2. **Deployment Steps (Nginx):**

    - Copy the contents of `front/host_translator/deploy_web/web` to the Linux Nginx server directory `/var/www/html`.

[![Watch on YouTube](https://img.youtube.com/vi/ODbYDyy6c2k/maxresdefault.jpg)](https://youtu.be/RgRMhfmq0Ew)
_Video: Demonstrates how a host creates a room._

![Host Creating a Room](./docs/host_gif.gif)
_GIF: Demonstrates how a host creates a room._

### Guest Responsibilities

1. **Use the Mobile Application:**

    - Guests will use a mobile application available for Android/iOS devices. The APK for the mobile application is currently not provided and will be updated in the future.

[![Watch on YouTube](https://img.youtube.com/vi/ODbYDyy6c2k/maxresdefault.jpg)](https://youtu.be/ODbYDyy6c2k)
_Video: Demonstrates how a guest joins a room and gets the text translation to speech._

![Guest Joining a Room](./docs/guest_gif.gif)
_GIF: Demonstrates how a guest joins a room and gets the text translation to speech._

---

## Server Deployment (Raspberry Pi OS - Legacy 32-bit)

### Server Responsibility (Backend)

The server component is responsible for managing rooms created by the host. Once a room is created, guests can join and select their preferred translation.

### Deployment Steps

1. **Navigate to the Server Directory:**

    - Move to the `back` directory in your project.

2. **Launch the Server:**

    - Use Docker Compose to start the server with the `docker-compose.yml` file.

    ```bash
    docker-compose up -d
    ```

---
