# before you can do this, you will need git to easily get this repo
# run:
# sudo apt install git

# Clone the repo
# git clone https://github.com/GazePgh/gaze_auth.git

# digital ocean has a droplet with docker and docker-compose installed
# if you aren't using that, you will need to install them as well
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04

# cd gaze_auth

# cp variables.env.example variables.env

# Fill out variables.env with the values of your database, replacing anything for accounts.gazepgh.org

docker-compose build

docker-compose up -d

# We are going to be installing things. Update software repositories
sudo apt-get update

# This is to remove password access to the droplet, only allowing ssh key access
sed -i 's/^PermitRootLogin yes/PermitRootLogin without-password/' /etc/ssh/sshd_config

sudo apt install nginx-full -y

# Allow access to ports 80 and 443
sudo ufw allow 'Nginx Full'

# Copy our config to the nginx sites-available directory, with a more specific name
sudo cp nginx.conf /etc/nginx/sites-available/keycloak

# Symlink keycloak nginx config to sites-enabled to enable it
sudo ln -sf /etc/nginx/sites-available/keycloak /etc/nginx/sites-enabled

# To check for typos in your file:
sudo nginx -t

# If you get no errors, you can restart nginx:
sudo service nginx restart

# Let's Encrypt
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get update
sudo apt install python-certbot-nginx -y

sudo certbot --nginx -d accounts.gazepgh.org
# Enter email address...:
# (A)gree to Terms
# (N)o sharing of email address
# 2 - Redirect all requests to https

# Accessing keycloak

## Start kecloak. The first time this is run it will also build, which may take a while
docker-compose up -d

## Allow access to the security admin console from our domain
docker-compose exec keycloak bash

# cd keycloak/bin

# ./kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user admin
# Enter password:

# ./kcadm.sh update clients/04ffa8d9-7398-4671-9a8e-3fad5e6adb06 -r master -s 'redirectUris=["https://auth.gazepgh.org/auth/*"]'
# ./kcadm.sh update clients/04ffa8d9-7398-4671-9a8e-3fad5e6adb06 -r master -s 'redirectUris=["/auth/admin/master/console/*"]'
