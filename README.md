# Inception 

## Overview

Inception is a project designed to help you understand the fundamentals of containerization, orchestration, and deployment using modern DevOps tools.  
It is typically the first infrastructure project in the 42 curriculum, focusing on Docker, Docker Compose, and basic service setup.

## Features

- Multi-service architecture using Docker Compose
- Containerized web services (e.g., NGINX, WordPress, MariaDB)
- Persistent data management with volumes
- Network isolation and communication between containers
- Automation of builds and service restarts

## Technologies Used

- **Docker**  
- **Docker Compose**
- **NGINX**
- **WordPress**
- **MariaDB**
- **Linux Shell**

## Getting Started

### Prerequisites

- Docker installed on your system
- Docker Compose installed

### Setup & Usage

1. Clone this repository:
    ```sh
    git clone https://github.com/LuirR91/Inception.git
    cd Inception
    ```
2. Build and start the services:
    ```sh
    make up
    ```

### Shutting Down & Cleaning Up

To stop and remove containers, networks, and volumes:
```sh
make down
make fclean
```

## Project Structure

- `srcs/` — Source files for Docker images and configuration
- `docker-compose.yml` — Service orchestration file
- Other configuration and environment files as needed
