FROM openjdk:8-jre-alpine

ENV MINECRAFT_VERS=1.12.2 \
    FORGE_VERS=14.23.4.2758

WORKDIR /server

# Install dependencies
RUN apk add --no-cache \
    curl

# Download Minecraft Forge installer
RUN curl -O https://files.minecraftforge.net/maven/net/minecraftforge/forge/${MINECRAFT_VERS}-${FORGE_VERS}/forge-${MINECRAFT_VERS}-${FORGE_VERS}-installer.jar

# Install Minecraft Forge server and do post-installation clean-up
RUN java -jar forge-${MINECRAFT_VERS}-${FORGE_VERS}-installer.jar --installServer \
    && rm *installer.jar* \
    && mv forge-${MINECRAFT_VERS}-${FORGE_VERS}-universal.jar forge-universal.jar

FROM openjdk:8-jre-alpine

WORKDIR /server

COPY ./server/eula.txt .
COPY --from=0 /server .

# Expose default Minecraft port and start server
EXPOSE 25565
CMD java -jar forge-universal.jar
