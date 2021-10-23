# Gaze Auth

This project is a docker-compose for the gazedev/keycloak docker image which in
turn is a slight modification of jboss/keycloak to bump the jdbc postgres version.

# Local Usage

`cp variables-local.env.example variables-local.env`

All the variables in this file should be set by default

`docker-compose --file=docker-compose-local.yml up dev`

# Production Usage

connect it to the postgres credentials.

start the server with docker-compose up -d

add the user with the docker(/docker-compose) script. make sure to quote the password

restart the docker container with `docker-compose restart`

install nginx

# Updating Keycloak

```
docker-compose stop && git pull && docker-compose run -d keycloak --admin-only && docker ps
docker exec -it gaze_auth_keycloak_run_1 bash
cd ~/keycloak
bin/jboss-cli.sh --file=bin/migrate-standalone.cli
exit
docker-compose down
docker-compose up -d
docker-compose ps
docker-compose logs --follow
```
