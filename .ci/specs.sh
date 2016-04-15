#!/bin/bash -e

export COMPOSE_PROJECT_NAME=letsintegrateapi
export COMPOSE_FILE=./.ci/docker-compose.yml

# Set up environment
docker-compose build
docker-compose run web rake db:create
docker-compose run web rake db:migrate

# Run tests
docker-compose run web rspec --format documentation --color .

# Clean up
docker-compose stop
docker-compose rm -f
