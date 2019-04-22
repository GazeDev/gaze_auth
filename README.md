get the pieces from keycloak repo. compile server with updated dbc postgres (42.2.5)

connect it to the postgres credentials.

start the server with docker-compose up -d

add the user with the docker(/docker-compose) script. make sure to quote the password

restart the docker container with `docker-compose restart`

install nginx
