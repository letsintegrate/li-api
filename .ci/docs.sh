#!/bin/bash -e

export COMPOSE_PROJECT_NAME=letsintegrateapi
export COMPOSE_FILE=./.ci/docker-compose.yml

# Set up environment
docker-compose build
docker-compose run web rake db:create
docker-compose run web rake db:migrate

# Generate documentation
docker-compose  run -e APIARY=true \
                web rspec --format documentation --color spec/requests

# Publish documentation
docker-compose  run -e APIARY_API_KEY=$APIARY_API_KEY \
                web apiary publish --api-name=$COMPOSE_PROJECT_NAME

# Clean up
docker-compose stop
docker-compose rm -f
