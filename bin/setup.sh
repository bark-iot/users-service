#!/bin/bash
docker-compose run users-service bundle
docker-compose run users-service ./cli db_migrate
cd ../users-service/docs && mkdocs build # build api doc