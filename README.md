# minecraft-server-docker
A base Minecraft Forge Server docker container managed in Terraform.

## Running the Container Locally
``` bash
docker-compose up -d
```

## Deploying the Infrastructure
The exported environment variables below will be configured to the terraform DigitalOcean provider when you apply. There is no need to specify it in the provider.
``` bash
# Required steps before deploying to the DigitalOcean default project
# https://www.digitalocean.com/docs/api/create-personal-access-token/
export DIGITALOCEAN_TOKEN=TOKEN

# Set docker login credentials to pull image from a private DockerHub repository
export TF_VAR_DOCKERHUB_USERNAME=USERNAME
export TF_VAR_DOCKERHUB_PASSWORD=PASSWORD

# Run in ~/.ssh
ssh-keygen -b 4096 -t rsa -f digitalocean_key

# For first time set-up
terraform init terraform/

# Apply
terraform apply --auto-approve terraform/ # optional -var="IMAGE_TAG=X.X.X" to deploy specific image tag, defaults to 'latest'
```

## Git Tags
When tag `X.Y.Z` is pushed, a CircleCi workflow will start the job that builds and pushes the image `bckr/minecraft-forge:${CIRCLE_TAG}` to the remote docker repository.

## Disclaimer
To automate the process, the [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula) is set to true when the docker image is built. By running the container you automatically agree to the EULA.
