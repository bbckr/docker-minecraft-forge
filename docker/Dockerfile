FROM openjdk:8-jre-alpine
LABEL maintainer="Brianna Becker <bri@bckr.io>"

ENV MINECRAFT_VERS=1.12.2 \
    FORGE_VERS=14.23.4.2758

WORKDIR /server

# Install dependencies
RUN apk update \
    && apk add --no-cache \
    curl

# Download Minecraft Forge installer
RUN curl -O https://files.minecraftforge.net/maven/net/minecraftforge/forge/${MINECRAFT_VERS}-${FORGE_VERS}/forge-${MINECRAFT_VERS}-${FORGE_VERS}-installer.jar

# Install Minecraft Forge server and do post-installation clean-up
RUN java -jar forge-${MINECRAFT_VERS}-${FORGE_VERS}-installer.jar --installServer \
    && rm *installer.jar* \
    && mv forge-${MINECRAFT_VERS}-${FORGE_VERS}-universal.jar forge-universal.jar

FROM openjdk:8-jre-alpine

WORKDIR /server

RUN apk update \
    && apk add --no-cache \
    zip

# Copy installed minecraft server files from previous layer.
COPY --from=0 /server .

# Copy over accepted EULA and server properties. By running the container you
# automatically agree to the EULA
COPY ./server .

# Expose default Minecraft, RCON, and SSH port
# Note: RCON is not enabled and the RCON password is not set in the server
# properties at this point.
EXPOSE 25565 25575

# Start minecraft forge server
CMD java -jar forge-universal.jar
