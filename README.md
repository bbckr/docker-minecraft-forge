# minecraft-forge-docker
A base Minecraft Forge Server docker container managed in Terraform.

## Running the Container Locally
``` bash
docker-compose up -d
```

## Deploying the Infrastructure
``` bash
# Deploys to DigitalOcean default project
# https://www.digitalocean.com/docs/api/create-personal-access-token/
export DIGITALOCEAN_TOKEN=TOKEN

# Set docker login credentials to pull image from a private DockerHub repository
export TF_VAR_DOCKERHUB_USERNAME=USERNAME
export TF_VAR_DOCKERHUB_PASSWORD=PASSWORD

# Run in ~/.ssh
ssh-keygen -b 4096 -t rsa -f digitalocean_key

# For first time set-up
terraform init 

# Apply
terraform apply --auto-approve
```

## Git Tags
When tag `X.Y.Z` is pushed, a CircleCi workflow will start the job that builds and pushes the image `bckr/minecraft-forge:${CIRCLE_TAG}` to the remote docker repository.

## Disclaimer
To automate the process, the [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula) is set to true when the docker image is built. By running the container you automatically agree to the EULA.
