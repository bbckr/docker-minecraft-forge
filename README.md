# Docker Minecraft Forge Server

``` ps
# Configure your shell
docker-machine env $env:DOCKER_MACHINE_ENV | Invoke-expression

# Build
docker build --no-cache -t $env:IMAGE_NAME .

# Run
docker run -p 25565:22565 $env:IMAGE_NAME

# Get connect IP (docker-machine env ip)
docker-machine ip $env:DOCKER_MACHINE_ENV
```