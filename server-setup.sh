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

# Fill out variables.env with the values of your database, replacing anything for accounts.gazepgh.org:

# nano variables.env


docker-compose build

docker-compose up -d

# We are going to be installing things. Update software repositories
sudo apt-get update

# This is to remove password access to the droplet, only allowing ssh key access
sed -i 's/^PermitRootLogin yes/PermitRootLogin without-password/' /etc/ssh/sshd_config

sudo apt install nginx-full -y

# Allow access to ports 80 and 443
sudo ufw allow 'Nginx Full'

# Modify nginx.conf to listen for the right server_name if you need to

# Copy our config to the nginx sites-available directory, with a more specific name
sudo cp nginx.conf /etc/nginx/sites-available/keycloak

# Symlink keycloak nginx config to sites-enabled to enable it
sudo ln -sf /etc/nginx/sites-available/keycloak /etc/nginx/sites-enabled

# Remove the default site
rm /etc/nginx/sites-enabled/default

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

# To check for typos in your file:
sudo nginx -t

# If you get no errors, you can restart nginx to apply the changes:
sudo service nginx restart

# Accessing keycloak

# Generate a kecloak admin user
docker-compose exec keycloak keycloak/bin/add-user-keycloak.sh -u <USERNAME> -p '<PASSWORD>'

docker-compose restart

# Enter the username and password you just used above

docker-compose exec keycloak keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user <USERNAME>
# Enter password:

# This will print out the clients, find clientId security-admin-console and take note of its id.
docker-compose exec keycloak keycloak/bin/kcadm.sh get clients

# Replace the <security-admin-console-id-value> and domain in the next command:
docker-compose exec keycloak keycloak/bin/kcadm.sh update clients/<security-admin-console-id-value> -r master -s 'redirectUris=["https://accounts.gazepgh.org/auth/*"]'
