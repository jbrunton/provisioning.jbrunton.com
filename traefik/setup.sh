#!/bin/bash
set -e

docker network create --driver=overlay traefik-public
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
echo "NODE_ID=$NODE_ID"

docker node update --label-add traefik-public.traefik-public-certificates=true $NODE_ID
export EMAIL=admin@jbrunton.com
export DOMAIN=traefik.bechdel-lists.jbrunton.com
export USERNAME=admin
export HASHED_PASSWORD=$(openssl passwd -apr1)

docker stack deploy -c traefik.yml traefik
