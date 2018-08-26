# Docker Minecraft Forge Server

``` bash
docker-compose up -d
```

## Git Tags
When tag `X.Y.Z` is pushed, it pushes the image `bckr/minecraft-forge:${CIRCLE_TAG}` to the remote docker repository.

## Disclaimer
To automate the process, the [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula) is set to true. By running the container you automatically agree to the EULA.