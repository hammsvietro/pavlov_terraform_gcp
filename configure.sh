#!/bin/bash

curl -fsSL https://get.docker.com | sh
sudo docker run --name pavlov -d \
  -p 7777:7777/udp \
  -p 8177:8177/udp \
  -p 9100:9100/tcp \
  -v $HOME/pavlov/Game.ini:/home/steam/pavlovserver/Pavlov/Saved/Config/LinuxServer/Game.ini \
  -v $HOME/pavlov/mods.txt:/home/steam/pavlovserver/Pavlov/Saved/Config/mods.txt \
  -v $HOME/pavlov/RconSettings.txt:/home/steam/pavlovserver/Pavlov/Saved/Config/RconSettings.txt \
  -v $HOME/pavlov/blacklist.txt:/home/steam/pavlovserver/Pavlov/Saved/Config/blacklist.txt \
  -v $HOME/pavlov/whitelist.txt:/home/steam/pavlovserver/Pavlov/Saved/Config/whitelist.txt \
  -e PORT=7777 \
  --restart unless-stopped \
  gregology/pavlov-server:latest
